package com.vo.metro
{
	[RemoteClass(alias="org.upcoming.metro.state")]

	[Bindable]
	public class UpcomingState
	{

		public var id:Number = 0;
		public var stateName:String = "";
		public var stateCode:String = "";


		public function UpcomingState()
		{
		}

	}
}