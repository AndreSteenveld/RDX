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

		override void next( int value ) { this.hasOnNext = value; }
	
		override void error( Throwable error ) { this.hasOnError = error; }
		
		override void complete( ) { this.hasOnComplete = true; }
		
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

	//
	// Observer!* . create methods
	//
	unittest {
		
		bool next = false;

		auto observer = Observer!int.create( delegate void ( int v ) {			
			assert( v == 42 );
			next = true;
		});

		observer.onNext( 42 );

		assert( next );

		observer.onComplete( );

	}

	unittest {

		Throwable 
			throwable  = new Throwable( "Our going to be thrown throwable" ),
			comparable = Throwable.init;

		bool next = false;

		auto observer = Observer!int.create( delegate void ( int v ){ 
			assert( v == 42 );
			next = true;
		});
		
		try {

			observer.onError( throwable );

			assert( false );
	
		} catch( Throwable thrown ){

			comparable = thrown;

		}

		assert( throwable.opEquals( comparable ) );

	}

	unittest {

		bool 
			next     = false,
			complete = false;

		auto observer = Observer!int.create(
			delegate void ( int v ){ assert( v == 42 ); next = true; },
			delegate void ( ){ complete = true; }
		);

		observer.onNext( 42 );

		assert( next && !complete );

		observer.onComplete( );

		assert( next && complete );		

	}

	unittest {

		Throwable
			throwable = new Throwable( "The thing we are going to throw around!" ),
			comparable = Throwable.init;

		bool
			next     = false,
			complete = false;

		auto observer = Observer!int.create(
			delegate void ( int v ){ assert( v == 42 ); next = true; },
			delegate void ( ){ complete = true; }
		);
	
		observer.onNext( 42 );

		assert( next && !complete );

		try {
			
			observer.onError( throwable );
			assert( false );

		} catch( Throwable thrown ){

			comparable = thrown;

		}

		assert( throwable.opEquals( comparable ) );
		assert( next && !complete );

	}
	
	unittest {

		Throwable throwable = new Throwable( "Throwy thingy!" );

		bool
			next  = false,
			error = false;
		
		auto observer = Observer!int.create(
			delegate void ( int v ){ assert( v == 42 ); next = true; },
			delegate void ( Throwable t ){ assert( throwable.opEquals( t ) ); error = true; }
		);
		
		observer.onNext( 42 );

		assert( next && !error );

		observer.onError( throwable );

		assert( next && error );

	}

	unittest {

		Throwable throwable = new Throwable( "Unlike the others this one will never see action" );

		bool
			next  = false,
			error = false;
	
		auto observer = Observer!int.create(
			delegate void ( int v ){ assert( v == 42 ); next = true; },
			delegate void ( Throwable t ){ assert( throwable.opEquals( t ) ); error = true; }
		);
				
		observer.onNext( 42 );
		
		assert( next && !error );
		
		observer.onComplete( );
		
		assert( next && !error );

	}

	unittest {

		Throwable throwable = new Throwable( "This one won't see any action either" );

		bool
			next     = false,
			error    = false,
			complete = false;

		auto observer = Observer!int.create(
			delegate void ( int v ){ assert( v == 42 ); next = true; },
			delegate void ( Throwable t ){ assert( throwable.opEquals( t ) ); error = true; },
			delegate void ( ){ complete = true; }
		);

		observer.onNext( 42 );

		assert( next && !error && !complete );

		observer.onComplete( );

		assert( next && !error && complete );

	}

	unittest {

		Throwable throwable = new Throwable( "This one won't see any action either" );
		
		bool
			next     = false,
			error    = false,
			complete = false;
		
		auto observer = Observer!int.create(
			delegate void ( int v ){ assert( v == 42 ); next = true; },
			delegate void ( Throwable t ){ assert( throwable.opEquals( t ) ); error = true; },
			delegate void ( ){ complete = true; }
		);

		observer.onNext( 42 );

		assert( next && !error && !complete );

		observer.onError( throwable );

		assert( next && error && !complete );

	}

	//
	// Create and observer from another observer
	// 
	unittest {

		auto observer = new TestObserver( );
		observer.asObserver( ).onNext( 42 );

		assert( observer.hasOnNext == 42 );

	}

	unittest {

		Throwable throwable = new Throwable( "Throw me!!" );

		auto observer = new TestObserver( );
		observer.asObserver( ).onError( throwable );

		assert( throwable.opEquals( observer.hasOnError ) );

	}

	unittest {

		auto observer = new TestObserver( );
		observer.asObserver( ).onComplete( );

		assert( observer.hasOnComplete );	

	}

}

