package com.control 
{
	import com.adobe.cairngorm.control.FrontController;
	// import command classes
	import com.commands.*
	// import events
	import com.events.*
	
	public class SecurityControl extends FrontController
	{
		
		public function SecurityControl():void
		{
			addCommand(LoginEvent.EVENT_LOGIN, LoginCommand);
			addCommand(LogoutEvent.EVENT_LOGOUT, LogoutCommand);
			addCommand(SaveUserEvent.EVENT_SAVE_USER, SaveUserCommand);
		}
		
	}
}