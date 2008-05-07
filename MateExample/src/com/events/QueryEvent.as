package com.events 
{
	import flash.events.Event;

	public class QueryEvent extends Event
	{
		public static const DO: String = "doQueryEvent";
		public static const RECEIVED: String = "receivedQueryEvent";
		
		public var name : String;
		public var queryType : String;
		public var className : String;
		
		public function QueryEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}	
}