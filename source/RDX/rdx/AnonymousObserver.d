
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

