
module rdx.Notification;

import rdx.NotificationKind;
import rdx.Observer;
import rdx.Observable;

import rdx.concurrency.Schedular;

class Notification ( TValue ) {
	
	static Notification!TValue createOnNext( TValue value ){ 

		return new OnNextNotification!TValue( value );

	}

	static Notification!TValue createOnError( Throwable error )
		in { assert( error !is null ); }
		body { 

			return new OnErrorNotification!TValue( error );
		
		}

	static Notification!TValue createOnCompleted( ){ 

		return new OnCompletedNotification!TValue( );
		
	}

	private Throwable _error;
	private NotificationKind _kind;
	private bool _hasValue = false;
	private TValue _value;
	
	@property Throwable error( ) { return this._error; } 
	
	@property bool hasValue( ) { return this._hasValue; }
	
	@property NotificationKind kind( ) { return this._kind; }
	
	@property {

		TValue value( ) { return this._value; }
		protected TValue value( TValue value ){

			try     
				{ this._value = value; }
			catch( Error e )
				{ this._error = error; }
			finally 
				{ this._hasValue = true; }

			return this._value;

		}

	}
	
	//
	// TODO: overwrite the equality operator!
	//

	abstract void accept( Observer!TValue observer );
	
	abstract void accept( void delegate( TValue ) onNext, void delegate( Throwable ) onError, void delegate( ) onComplete );
	
	Observable!TValue toObservable( ){ return null; }
	
	Observable!TValue toObservable( Schedular schedular )
		in { assert( schedular !is null ); }
		body { return null; }
	
}

package final class OnNextNotification ( TValue ) : Notification!TValue { 
	
	this( TValue value ){ 
		
		this.value = value; 
		this._kind = NotificationKind.ON_NEXT;
		
	}
	
	override void accept( Observer!TValue observer )
		in { assert( observer !is null ); }
		body { observer.onNext( this.value ); }
	
	override void accept( void delegate( TValue ) onNext, void delegate( Throwable ) onError, void delegate( ) onComplete )
		in {
			assert( onNext != null );
			assert( onError != null );
			assert( onComplete != null );
		}
		body { onNext( this.value ); }
	
}

package final class OnErrorNotification ( TValue )  : Notification!TValue { 
	
	this( Throwable error ) {
		
		this._error = error;
		this._kind = NotificationKind.ON_ERROR;
		
	}
	
	override @property TValue value( ) {
		throw this._error;	
		return super.value;
	}
	
	override void accept( Observer!TValue observer )
		in { assert( observer !is null ); }
		body { observer.onError( this.error ); }
	
	override void accept( void delegate( TValue ) onNext, void delegate( Throwable ) onError, void delegate( ) onComplete )
		in {
			assert( onNext != null );
			assert( onError != null );
			assert( onComplete != null );
		}
		body { onError( this.error ); }
		
}

package final class OnCompletedNotification ( TValue ) : Notification!TValue { 
	
	this( ){
		
		this._error = null;
		this._kind = NotificationKind.ON_COMPLETE;
		
	}
	
	override @property TValue value( ) {
		throw new Exception( "Invalid operation: completed without a value" );
	}
	
	override void accept( Observer!TValue observer )
		in { assert( observer !is null ); }
		body { observer.onComplete( ); }
	
	override void accept( void delegate( TValue ) onNext, void delegate( Throwable ) onError, void delegate( ) onComplete )
		in {
			assert( onNext != null );
			assert( onError != null );
			assert( onComplete != null );
		}
		body { onComplete( ); }
	
}

