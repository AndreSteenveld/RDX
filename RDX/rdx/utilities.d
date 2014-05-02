
module rdx.utilities;

 package auto nop_type ( TType ) ( ) { return delegate void ( TType t ) { return; }; }
 package auto nop_void ( ){ return delegate void ( ) { return; }; }

 package auto thrower ( ){ return delegate void ( Throwable e ) { throw e; }; }
 package auto k ( TInOut ) ( ) { return delegate TInOut ( TInOut inOut ) { return inOut; }; }
