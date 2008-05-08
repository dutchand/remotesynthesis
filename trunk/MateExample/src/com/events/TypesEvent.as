package com.events 
{
	import flash.events.Event;

	public class TypesEvent extends Event
	{
		public static const RECEIVED: String = "receivedTypesEvent";
		
		public function TypesEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}	
}