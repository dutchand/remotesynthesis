package com.events 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;

	public class DoQueryEvent extends CairngormEvent
	{
		public static const EVENT_DO_QUERY:String = "EVENT_DO_QUERY";
		
		public var name : String;
		public var queryType : String;
		public var className : String;
		
		public function DoQueryEvent(name:String=null,queryType:String=null,className:String=null) 
		{
			super(EVENT_DO_QUERY);
			this.name = name;
			this.queryType = queryType;
			this.className = className;
		}
		override public function clone():Event {
            return new DoQueryEvent(name,queryType,className);
        }

	}	
}