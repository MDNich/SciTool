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

package io.scif.codec;

/**
 * A growable array of bytes.
 *
 * @author Wayne Rasband
 */
public class ByteVector {

	private byte[] data;

	private int size;

	public ByteVector() {
		data = new byte[10];
		size = 0;
	}

	public ByteVector(final int initialSize) {
		data = new byte[initialSize];
		size = 0;
	}

	public ByteVector(final byte[] byteBuffer) {
		data = byteBuffer;
		size = 0;
	}

	public void add(final byte x) {
		while (size >= data.length)
			doubleCapacity();
		data[size++] = x;
	}

	public int size() {
		return size;
	}

	public byte get(final int index) {
		return data[index];
	}

	public void add(final byte[] array) {
		add(array, 0, array.length);
	}

	public void add(final byte[] array, final int off, final int len) {
		while (data.length < size + len)
			doubleCapacity();
		if (len == 1) data[size] = array[off];
		else if (len < 35) {
			// for loop is faster for small number of elements
			for (int i = 0; i < len; i++)
				data[size + i] = array[off + i];
		}
		else System.arraycopy(array, off, data, size, len);
		size += len;
	}

	void doubleCapacity() {
		final byte[] tmp = new byte[data.length * 2 + 1];
		System.arraycopy(data, 0, tmp, 0, data.length);
		data = tmp;
	}

	public void clear() {
		size = 0;
	}

	public byte[] toByteArray() {
		final byte[] bytes = new byte[size];
		System.arraycopy(data, 0, bytes, 0, size);
		return bytes;
	}

}
