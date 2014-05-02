module observer;

version( unittest ){

	import std.stdio;	
	import std.exception;

	import rdx.Observer;
	import rdx.Notification;
	import rdx.NotificationKind;
	
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

	
}

