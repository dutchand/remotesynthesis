package com.control 
{
	import com.adobe.cairngorm.control.FrontController;
	// import command classes
	import com.commands.*
	// import events
	import com.events.*
	
	public class DnsControl extends FrontController
	{
		
		public function DnsControl():void
		{
			addCommand(DoQueryEvent.EVENT_DO_QUERY, DoQueryCommand);
			addCommand(GetClassesEvent.EVENT_GET_CLASSES, GetClassesCommand);
			addCommand(GetTypesEvent.EVENT_GET_TYPES, GetTypesCommand);
		}
		
	}
}