
module rdx.utilities;

import std.exception;

package auto nop_type ( TType ) ( ) { return delegate void ( TType t ) { return; }; }
package auto nop_void ( ){ return delegate void ( ) { return; }; }

package auto thrower ( ){ return delegate void ( Throwable e ) { throw e; }; }
package auto k ( TInOut ) ( ) { return delegate TInOut ( TInOut inOut ) { return inOut; }; }

class InvalidOperationException : Exception { 

	@safe pure nothrow this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
		super(msg, file, line, next);
	}
	
	@safe pure nothrow this(string msg, Throwable next, string file = __FILE__, size_t line = __LINE__) {
		super(msg, file, line, next);
	}

}
