/**
 * 
 * Author:
 * Andre Steenveld <Andre.Steenveld@gmail.com>
 * 
 * Copyright (c) 2014 ZZP Andre
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
module rdx.AnonymousObserver;

import rdx.Observer;
import rdx.utilities : nop_void, thrower;

final class AnonymousObserver ( TValue ) : Observer!TValue {
	
	private void delegate( TValue ) _next;
	private void delegate( Throwable ) _error;
	private void delegate( ) _complete;

	this( void delegate( TValue ) onNext, void delegate( Throwable ) onError, void delegate( ) onComplete )
		in {
			assert( onNext != null );
			assert( onError != null );
			assert( onComplete != null );
		}
		body {
			this._next = onNext;
			this._error = onError;
			this._complete = onComplete;
		}

	this( void delegate( TValue ) onNext ) {

		this( onNext, rdx.utilities.thrower, rdx.utilities.nop_void );

	}

	this( void delegate( TValue ) onNext, void delegate( Throwable ) onError ){

		this( onNext, onError, rdx.utilities.nop_void );

	}

	this( void delegate( TValue ) onNext, void delegate( ) onComplete ){
		
		this( onNext, rdx.utilities.thrower, onComplete );

	}

	override protected void next( TValue value ){ this._next( value ); }
	override protected void error( Throwable error ){ this._error( error ); }
	override protected void complete( ){ this._complete( ); }

	package Observer!TValue safe( Object lock ){ return null; }

}

