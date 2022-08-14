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

package io.scif;

import org.scijava.service.Service;

/**
 * Exception thrown when there is an object instantiation error or error
 * processing dependencies.
 *
 * @author Chris Allan
 */
public class DependencyException extends Exception {

	/** Serial for this version. */
	public static final long serialVersionUID = -7836244849086491562L;

	/** The class that was used in a failed instantiation. */
	private Class<? extends Service> failureClass;

	/**
	 * Default constructor.
	 *
	 * @param message Error message.
	 */
	public DependencyException(final String message) {
		super(message);
	}

	/**
	 * Default constructor.
	 *
	 * @param message Error message.
	 * @param klass Failed instantiation class.
	 */
	public DependencyException(final String message,
		final Class<? extends Service> klass)
	{
		super(message);
		this.failureClass = klass;
	}

	/**
	 * Default constructor.
	 *
	 * @param message Error message.
	 * @param klass Failed instantiation class.
	 * @param cause Upstream exception.
	 */
	public DependencyException(final String message,
		final Class<? extends Service> klass, final Throwable cause)
	{
		super(message, cause);
		this.failureClass = klass;
	}

	/**
	 * Default constructor.
	 *
	 * @param cause Upstream exception.
	 */
	public DependencyException(final Throwable cause) {
		super(cause);
	}

	/**
	 * Returns the class that was used during a failed instantiation.
	 *
	 * @return See above.
	 */
	public Class<? extends Service> getFailureClass() {
		return failureClass;
	}

	@Override
	public String toString() {
		if (failureClass == null) {
			return getMessage();
		}
		return getMessage() + " for " + failureClass;
	}
}
