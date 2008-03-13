package com.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class GetClassesEvent extends CairngormEvent 
	{
		
		public function GetClassesEvent() 
		{
			super(DnsControl.EVENT_GET_CLASSES);
		}
	}	
}