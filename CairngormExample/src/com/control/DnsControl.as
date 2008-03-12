package com.control 
{
	import com.adobe.cairngorm.control.FrontController;
	// import command classes
	import com.commands.DoQueryCommand;
	import com.commands.GetClassesCommand;
	import com.commands.GetTypesCommand;
	
	public class DnsControl extends FrontController
	{
		public static const EVENT_DO_QUERY : String = "EVENT_DO_QUERY";
		public static const EVENT_GET_CLASSES : String = "EVENT_GET_CLASSES";
		public static const EVENT_GET_TYPES : String = "EVENT_GET_TYPES";
		
		public function DnsControl():void
		{
			addCommand(DnsControl.EVENT_DO_QUERY, DoQueryCommand);
			addCommand(DnsControl.EVENT_GET_CLASSES, GetClassesCommand);
			addCommand(DnsControl.EVENT_GET_TYPES, GetTypesCommand);
		}
		
	}
}