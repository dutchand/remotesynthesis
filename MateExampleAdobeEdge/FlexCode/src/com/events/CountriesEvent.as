package com.events 
{
	import flash.events.Event;

	public class CountriesEvent extends Event
	{
		public static const GETCOUNTRIES: String = "getCountries";
		public static const COUNTRIESRECEIVED: String = "countriesReceived";
		
		public static const DEFAULT_COUNTRY: Number = 1;
		
		public function CountriesEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}	
}