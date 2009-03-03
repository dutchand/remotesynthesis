package com.events 
{
	import flash.events.Event;

	public class StatesEvent extends Event
	{
		public static const GET_STATES: String = "getStates";
		
		public var countryId : Number;
		
		public function StatesEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}	
}