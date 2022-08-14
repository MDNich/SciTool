/*
 * #%L
 * SCIFIO library for reading and converting scientific file formats.
 * %%
 * Copyright (C) 2011 - 2022 SCIFIO developers.
 * %%
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 * #L%
 */

package io.scif.formats;

import io.scif.AbstractFormat;
import io.scif.AbstractMetadata;
import io.scif.AbstractParser;
import io.scif.ByteArrayPlane;
import io.scif.ByteArrayReader;
import io.scif.Format;
import io.scif.FormatException;
import io.scif.ImageMetadata;
import io.scif.codec.JPEGTileDecoder;
import io.scif.config.SCIFIOConfig;
import io.scif.util.FormatTools;

import java.io.IOException;

import net.imagej.axis.Axes;
import net.imglib2.Interval;

import org.scijava.Priority;
import org.scijava.io.handle.DataHandle;
import org.scijava.io.location.Location;
import org.scijava.plugin.Plugin;

/**
 * Reader for decoding JPEG images using java.awt.Toolkit. This reader is useful
 * for reading very large JPEG images, as it supports tile-based access.
 *
 * @author Melissa Linkert
 * @author Mark Hiner
 */
@Plugin(type = Format.class, name = "Tile JPEG", priority = Priority.LOW)
public class JPEGTileFormat extends AbstractFormat {

	// -- AbstractFormat Methods --

	@Override
	protected String[] makeSuffixArray() {
		return new String[] { "jpg", "jpeg" };
	}

	// -- Nested Classes --

	public static class Metadata extends AbstractMetadata {

		// -- Fields --

		private JPEGTileDecoder decoder;

		// -- JPEGTileMetadata API getters and setters --

		public JPEGTileDecoder getDecoder() {
			return decoder;
		}

		public void setDecoder(final JPEGTileDecoder decoder) {
			this.decoder = decoder;
		}

		// -- Metadata API Methods --

		@Override
		public void populateImageMetadata() {
			createImageMetadata(1);
			final ImageMetadata iMeta = get(0);

			iMeta.setAxisTypes(Axes.CHANNEL, Axes.X, Axes.Y);
			iMeta.setPlanarAxisCount(3);
			iMeta.setLittleEndian(false);
			iMeta.setAxisLength(Axes.X, decoder.getWidth());
			iMeta.setAxisLength(Axes.Y, decoder.getHeight());
			iMeta.setAxisLength(Axes.CHANNEL, decoder.getScanline(0).length / iMeta
				.getAxisLength(Axes.X));
			iMeta.setPixelType(FormatTools.UINT8);
			iMeta.setMetadataComplete(true);
			iMeta.setIndexed(false);
		}

		@Override
		public void close(final boolean fileOnly) throws IOException {
			if (!fileOnly) {
				if (decoder != null) {
					decoder.close();
				}
				decoder = null;
			}

			super.close(fileOnly);
		}
	}

	public static class Parser extends AbstractParser<Metadata> {

		// -- Parser API Methods --

		@Override
		protected void typedParse(final DataHandle<Location> handle,
			final Metadata meta, final SCIFIOConfig config) throws IOException,
			FormatException
		{
			if (!handle.exists() || handle.length() == 0) {
				throw new FormatException("Trying to read from non-existing file!");
			}

			final JPEGTileDecoder decoder = new JPEGTileDecoder(getContext());
			meta.setDecoder(decoder);
			decoder.initialize(getSource(), 0, 1);
		}
	}

	public static class Reader extends ByteArrayReader<Metadata> {

		// -- AbstractReader API Methods --

		@Override
		protected String[] createDomainArray() {
			return new String[] { FormatTools.GRAPHICS_DOMAIN };
		}

		// -- Reader API methods --

		@Override
		public ByteArrayPlane openPlane(final int imageIndex, final long planeIndex,
			final ByteArrayPlane plane, final Interval bounds,
			final SCIFIOConfig config) throws FormatException, IOException
		{
			final Metadata meta = getMetadata();
			final byte[] buf = plane.getBytes();
			final int xIndex = meta.get(imageIndex).getAxisIndex(Axes.X);
			final int yIndex = meta.get(imageIndex).getAxisIndex(Axes.Y);
			final int x = (int) bounds.min(xIndex);
			final int y = (int) bounds.min(yIndex);
			final int w = (int) bounds.dimension(xIndex);
			final int h = (int) bounds.dimension(yIndex);
			FormatTools.checkPlaneForReading(meta, imageIndex, planeIndex, buf.length,
				bounds);

			final int c = (int) meta.get(imageIndex).getAxisLength(Axes.CHANNEL);

			for (int ty = y; ty < y + h; ty++) {
				byte[] scanline = meta.getDecoder().getScanline(ty);
				if (scanline == null) {
					meta.getDecoder().initialize(getHandle(), 0);
					scanline = meta.getDecoder().getScanline(ty);
				}
				System.arraycopy(scanline, c * x, buf, (ty - y) * c * w, c * w);
			}

			return plane;
		}

	}
}
