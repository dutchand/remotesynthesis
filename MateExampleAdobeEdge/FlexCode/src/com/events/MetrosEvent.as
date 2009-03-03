package com.events 
{
	import flash.events.Event;

	public class MetrosEvent extends Event
	{
		public static const GETMETROS: String = "getMetros";
		
		public var stateId : Number;
		
		public function MetrosEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}	
}