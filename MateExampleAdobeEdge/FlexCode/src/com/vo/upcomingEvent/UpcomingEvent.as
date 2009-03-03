package com.vo.upcomingEvent
{
	[RemoteClass(alias="org.upcoming.event.event")]

	[Bindable]
	public class UpcomingEvent
	{

		public var id:Number = 0;
		public var eventName:String = "";
		public var startDate:Date = null;
		public var endDate:Date = null;
		public var startTime:String = "";
		public var endTime:String = "";
		public var personal:Boolean = false;
		public var selfPromotion:Boolean = false;
		public var metroId:String = "";
		public var venueId:Number = 0;
		public var userId:Number = 0;
		public var categoryId:Number = 0;
		public var datePosted:Date = null;
		public var watchListCount:Number = 0;
		public var eventUrl:String = "";
		public var latitude:Number = 0;
		public var longitude:Number = 0;
		public var geocodingPrecision:String = "";
		public var geocodingAmbiguous:String = "";
		public var venueName:String = "";
		public var venueAddress:String = "";
		public var venueCity:String = "";
		public var venueState:String = "";
		public var venueStateCode:String = "";
		public var venueStateId:Number = 0;
		public var venueCountryName:String = "";
		public var venueCountryCode:String = "";
		public var venueCountryId:Number = 0;
		public var venueZip:String = "";
		public var ticketUrl:String = "";
		public var ticketPrice:String = "";
		public var ticketFree:Boolean = false;
		public var photoUrl:String = "";
		public var numFutureEvents:Number = 0;
		public var startDateLastRendition:String = "";


		public function UpcomingEvent()
		{
		}

	}
}