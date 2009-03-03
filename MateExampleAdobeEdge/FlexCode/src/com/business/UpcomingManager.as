package com.business
{
	import com.vo.metro.*;
	import com.vo.upcomingEvent.UpcomingEvent;
	
	import mx.collections.ArrayCollection;
	
	public class UpcomingManager
	{
		
		[Bindable]
		public var countries:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var selectedCountry:Country; // this is mostly here for compile purposes to enable CF type translation
		
		[Bindable]
		public var upcomingStates:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var selectedState:UpcomingState; // this is mostly here for compile purposes to enable CF type translation
		
		[Bindable]
		public var metros:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var selectedMetro:Metro; // this is mostly here for compile purposes to enable CF type translation
		
		[Bindable]
		public var upcomingEvents:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var selectedEvent:UpcomingEvent; // this is mostly here for compile purposes to enable CF type translation
		
		public function setCountries(r:Array):void {
			countries.source = r;
		}
		
		public function setSelectedCountry(country:Country):void {
			selectedCountry = country;
		}
		
		public function setUpcomingStates(r:Array):void {
			upcomingStates.source = r;
		}
		
		public function setSelectedState(myState:UpcomingState):void {
			selectedState = myState;
		}
		
		public function setMetros(r:Array):void {
			metros.source = r;
		}
		
		public function setUpcomingEvents(r:Array):void {
			upcomingEvents.source = r;
		}
	}
}