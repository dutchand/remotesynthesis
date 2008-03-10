package com.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class DoQueryEvent extends CairngormEvent 
	{
		public var name : String;
		public var queryType : String;
		public var className : String;
		
		public function DoQueryEvent(name:String=null,queryType:String=null,className:String=null) 
		{
			super(DnsControl.EVENT_DO_QUERY);
			this.name = name;
			this.queryType = queryType;
			this.className = className;
		}
	}	
}