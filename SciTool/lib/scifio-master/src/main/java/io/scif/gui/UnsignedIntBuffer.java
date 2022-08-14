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

package io.scif.gui;

import java.awt.image.DataBuffer;

/**
 * DataBuffer that stores unsigned ints.
 *
 * @author Melissa Linkert
 */
public class UnsignedIntBuffer extends DataBuffer {

	private final int[][] bankData;

	/** Construct a new buffer of unsigned ints using the given int array. */
	public UnsignedIntBuffer(final int[] dataArray, final int size) {
		super(DataBuffer.TYPE_INT, size);
		bankData = new int[1][];
		bankData[0] = dataArray;
	}

	/** Construct a new buffer of unsigned ints using the given 2D int array. */
	public UnsignedIntBuffer(final int[][] dataArray, final int size) {
		super(DataBuffer.TYPE_INT, size);
		bankData = dataArray;
	}

	public int[] getData() {
		return bankData[0];
	}

	public int[] getData(final int bank) {
		return bankData[bank];
	}

	@Override
	public int getElem(final int i) {
		return getElem(0, i);
	}

	@Override
	public int getElem(final int bank, final int i) {
		final int value = bankData[bank][i + getOffsets()[bank]];
		return (int) (value & 0xffffffffL);
	}

	@Override
	public float getElemFloat(final int i) {
		return getElemFloat(0, i);
	}

	@Override
	public float getElemFloat(final int bank, final int i) {
		return (getElem(bank, i) & 0xffffffffL);
	}

	@Override
	public double getElemDouble(final int i) {
		return getElemDouble(0, i);
	}

	@Override
	public double getElemDouble(final int bank, final int i) {
		return (getElem(bank, i) & 0xffffffffL);
	}

	@Override
	public void setElem(final int i, final int val) {
		setElem(0, i, val);
	}

	@Override
	public void setElem(final int bank, final int i, final int val) {
		bankData[bank][i + getOffsets()[bank]] = val;
	}

	@Override
	public void setElemFloat(final int i, final float val) {
		setElemFloat(0, i, val);
	}

	@Override
	public void setElemFloat(final int bank, final int i, final float val) {
		bankData[bank][i + getOffsets()[bank]] = (int) val;
	}

	@Override
	public void setElemDouble(final int i, final double val) {
		setElemDouble(0, i, val);
	}

	@Override
	public void setElemDouble(final int bank, final int i, final double val) {
		bankData[bank][i + getOffsets()[bank]] = (int) val;
	}

}
