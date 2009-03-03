package com.events 
{
	import flash.events.Event;

	public class SearchEvent extends Event
	{
		public static const SEARCH: String = "search";
		
		public var searchText : String;
		public var countryId : Number;
		public var stateId : Number;
		public var metroId : Number;
		
		public function SearchEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}	
}