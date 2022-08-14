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

package io.scif.img.cell.loaders;

import io.scif.ImageMetadata;
import io.scif.Reader;
import io.scif.img.ImageRegion;
import io.scif.util.FormatTools;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;

import net.imglib2.img.basictypeaccess.array.LongArray;
import net.imglib2.type.numeric.integer.LongType;

/**
 * {@link SCIFIOArrayLoader} implementation for {@link LongArray} types.
 *
 * @author Mark Hiner
 */
public class LongArrayLoader extends AbstractArrayLoader<LongArray> {

	public LongArrayLoader(final Reader reader, final ImageRegion subRegion) {
		super(reader, subRegion);
	}

	@Override
	public void convertBytes(final LongArray data, final byte[] bytes,
		final int planesRead)
	{
		final ImageMetadata iMeta = reader().getMetadata().get(0);

		if (isCompatible()) {
			final int bpp = getBitsPerElement() / 8;
			final int offset = planesRead * (bytes.length / bpp);
			final ByteBuffer bb = ByteBuffer.wrap(bytes);

			bb.order(iMeta.isLittleEndian() ? ByteOrder.LITTLE_ENDIAN
				: ByteOrder.BIG_ENDIAN);
			bb.asLongBuffer().get(data.getCurrentStorageArray(), offset,
				bytes.length / bpp);
		}
		else {
			final int pixelType = iMeta.getPixelType();
			final int bpp = FormatTools.getBytesPerPixel(pixelType);
			final int offset = planesRead * (bytes.length / bpp);

			for (int index = 0; index < bytes.length / bpp; index++) {
				final long value = (long) utils().decodeWord(bytes, index * bpp,
					pixelType, iMeta.isLittleEndian());
				data.setValue(offset + index, value);
			}
		}
	}

	@Override
	public LongArray emptyArray(final int entities) {
		return new LongArray(entities);
	}

	@Override
	public int getBitsPerElement() {
		return 64;
	}

	@Override
	public Class<?> outputClass() {
		return LongType.class;
	}
}
