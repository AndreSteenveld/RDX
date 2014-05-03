
module rdx.Observer;

import rdx.AnonymousObserver;
import rdx.Notification;
import rdx.concurrency.Schedular;

class Observer( TValue ) {

	static Observer!TValue toObserver ( void delegate( Notification!TValue ) handler )
		in { assert( handler !is null ); }
		body { 

			return new AnonymousObserver!TValue(
				( TValue v ) => handler( Notification!TValue.createOnNext( v ) ),
				( Throwable e ) => handler( Notification!TValue.createOnError( e ) ),
				(  ) => handler( Notification!TValue.createOnCompleted( ) )
			);
			
		}

	static void delegate ( Notification!TValue ) toNotifier ( Observer!TValue observer )
		in { assert( observer !is null ); }
		body { 

			return ( notifier ) => notifier.accept( observer );
		
		}	

	static Observer!TValue create ( TValue ) ( void delegate( TValue ) onNext )
		in { assert( onNext != null ); }
		body { 

			return new AnonymousObserver!TValue( onNext );

		}	
	
	static Observer!TValue create ( TValue ) ( void delegate( TValue ) onNext, void delegate( ) onComplete )
		in {
			assert( onNext != null );
			assert( onComplete != null );
		}
		body { 

			return new AnonymousObserver!TValue( onNext, onComplete );		

		}
	
	static Observer!TValue create ( TValue ) ( void delegate( TValue ) onNext, void delegate( Throwable ) onError )
		in {
			assert( onNext != null );
			assert( onError != null );
		} 
		body { 

			return new AnonymousObserver!TValue( onNext, onError );

		}
	
	static Observer!TValue create ( TValue ) ( void delegate( TValue ) onNext, void delegate( Throwable ) onError, void delegate( ) onComplete )
		in {
			assert( onNext != null );
			assert( onError != null );
			assert( onComplete != null );
		}
		body { 

			return new AnonymousObserver!TValue( onNext, onError, onComplete );
		
		}

	private bool _isStopped = false;
	@property public bool isStopped( ){ return this._isStopped; }
		
	Observer!TValue synchronise ( ){ return null; }
	Observer!TValue synchronise ( Object gate ){ return null; }
	Observer!TValue synchronise ( bool preventReenterence ){ return null; }
	//Observer!TValue synchronise ( Observer!TValue observer, AsyncLock lock ){  }

	void delegate( Notification!TValue ) toNotifier ( )
		body { 
		
			return Observer!TValue.toNotifier( this );

		}
	
	Observer!TValue asObserver ( )
		body { 
		
			return new AnonymousObserver!TValue( &this.onNext, &this.onError, &this.onComplete );

		}

	Observer!TValue checked ( )
		body { return null; }

	Observer!TValue notifyOn ( Schedular schedular )
		in { assert( schedular !is null ); }
		body { return null; }

	abstract protected void complete( );
	void onComplete( ){ 
		
		if( !this.isStopped ){
			
			this._isStopped = true;
			this.complete( );

		}

	}
	
	abstract protected void next( TValue value );
	void onNext( TValue value ){ 
		
		if( !this.isStopped ) 
			this.next( value );

	}	

	abstract protected void error( Throwable error );
	void onError( Throwable error ) 
		in { assert( error !is null ); }
		body { 
		
			if( !this.isStopped ){
				
				this._isStopped = true;
				this.error( error );
				
			}
			
		}

	package bool fail( Throwable error ){

		if( !this.isStopped ){
			
			this._isStopped = true;
			this.error( error );
			return true;

		}

		return false;

	}

}




