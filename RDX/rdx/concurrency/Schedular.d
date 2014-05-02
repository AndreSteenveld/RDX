
module rdx.concurrency.Schedular;

import std.datetime;

class Schedular {
	
	@property DateTime now( ){ return DateTime.max; }
	
	Object schedule ( TState ) ( TState state, Object delegate( Schedular, TState ) action ){ return null; }
	
	Object schedule ( TState ) ( TState state, DateTime dueTime, Object delegate( Schedular, TState ) action ){ return null; }
	
}


