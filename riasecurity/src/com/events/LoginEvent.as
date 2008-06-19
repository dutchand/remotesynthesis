package com.events 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;

	public class LoginEvent extends CairngormEvent
	{
		public static const EVENT_LOGIN:String = "EVENT_LOGIN";
		
		public var username : String;
		public var password : String;
		public var roleName : String;
		
		public function LoginEvent(username:String=null,password:String=null,roleName:String=null) 
		{
			super(EVENT_LOGIN);
			
			this.username = username;
			this.password = password;
			this.roleName = roleName;
		}
		override public function clone():Event {
            return new LoginEvent();
        }

	}	
}