package com.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class GetTypesEvent extends CairngormEvent 
	{
		
		public function GetTypesEvent() 
		{
			super(DnsControl.EVENT_GET_TYPES);
		}
	}	
}