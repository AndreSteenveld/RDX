module observer;

version( unittest ){

	import std.stdio;	
	import std.exception;

	import core.exception;

	import rdx.Observer;
	import rdx.Notification;
	import rdx.NotificationKind;
	
	//
	// Observer!* . toObserver tests
	//
	unittest {

		std.exception.assertThrown!AssertError( Observer!int.toObserver( null ) );

	}

	unittest { 
		
		int i = 0;

		void next( Notification!int n ){
			assert( i++ == 0 );
			assert( n.kind == NotificationKind.ON_NEXT );
			assert( n.value == 42 );
			assert( n.error is null );
			assert( n.hasValue );
		}

		auto observer = Observer!int.toObserver( &next );

		observer.onNext( 42 );
		
	}

	unittest {

		Throwable throwable = new Throwable( "Test exception" );

		int i = 0;

		void next ( Notification!int n ) {
			assert( i++ == 0 );
			assert( n.kind == NotificationKind.ON_ERROR );
			assert( n.error.opEquals( throwable ) );
			assert( !n.hasValue );
		}

		auto observer = Observer!int.toObserver( &next );

		observer.onError( throwable );

	}

	//
	// Observer!* . ToNotifier tests
	//

	class TestObserver : Observer!int {
	
		public int hasOnNext;
		public Throwable hasOnError;
		public bool hasOnComplete;

		override  void next( int value ) { this.hasOnNext = value; }
	
		override  void error( Throwable error ) { this.hasOnError = error; }
		
		override  void complete( ) { this.hasOnComplete = true; }
		
	}

	unittest {

		std.exception.assertThrown!AssertError( Observer!int.toNotifier( null ) );
	
	}
	
	unittest {

		auto o = new TestObserver( );
		o.toNotifier( )( Notification!int.createOnNext( 42 ) );

		assert( o.hasOnNext == 42 );

	}

	unittest {
		
		Throwable throwable = new Throwable( "Our test throwable" );

		auto o = new TestObserver( );
		o.toNotifier( )( Notification!int.createOnError( throwable ) );

		assert( throwable.opEquals( o.hasOnError ) );

	}
	
	unittest {

		auto o = new TestObserver( );
		o.toNotifier( )( Notification!int.createOnCompleted( ) );

		assert( o.hasOnComplete );

	}

}

