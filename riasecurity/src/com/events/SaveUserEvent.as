package com.events 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;

	public class SaveUserEvent extends CairngormEvent
	{
		public static const EVENT_SAVE_USER:String = "EVENT_SAVE_USER";
		
		public var fullName : String;
		public var email : String;
		public var password : String;
		
		public function SaveUserEvent(fullName:String=null,email:String=null,password:String=null) 
		{
			super(EVENT_SAVE_USER);
			this.fullName = fullName;
			this.email = email;
			this.password = password;
		}
		override public function clone():Event {
            return new SaveUserEvent(fullName,email,password);
        }

	}	
}