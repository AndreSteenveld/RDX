
module rdx.Observable;

import rdx.Observer;

interface Observable ( TValue ) {
	
	Observer!TValue subscribe( );	
	Observer!TValue subscribe( Observer!TValue observer );		
	
	Observer!TValue subscribe( void delegate( TValue ) onNext );	
	
	Observer!TValue subscribe( void delegate( TValue ) onNext, void delegate( ) onComplete );	
	
	Observer!TValue subscribe( void delegate( TValue ) onNext, void delegate( Throwable ) onError );	
	
	Observer!TValue subscribe( void delegate( TValue ) onNext, void delegate( Throwable ) onError, void delegate( ) onComplete );
	
}
