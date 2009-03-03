package com.vo.metro
{
	[RemoteClass(alias="org.upcoming.metro.country")]

	[Bindable]
	public class Country
	{

		public var id:Number = 0;
		public var countryName:String = "";
		public var countryCode:String = "";


		public function Country()
		{
		}

	}
}