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
			addCommand(GetPublicKeyEvent.EVENT_GET_KEY, GetPublicKeyCommand);
			addCommand(SaveUserEvent.EVENT_SAVE_USER, SaveUserCommand);
		}
		
	}
}