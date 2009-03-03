package com.vo.metro
{
	[RemoteClass(alias="org.upcoming.metro.metro")]

	[Bindable]
	public class Metro
	{

		public var id:Number = 0;
		public var metroName:String = "";
		public var metroCode:String = "";
		public var stateId:Number = 0;
		public var stateName:String = "";
		public var stateCode:String = "";
		public var countryId:Number = 0;
		public var countryName:String = "";
		public var countryCode:String = "";


		public function Metro()
		{
		}

	}
}