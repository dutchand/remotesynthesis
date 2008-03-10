package com.control 
{
	import com.adobe.cairngorm.control.FrontController;
	// import command classes
	import com.commands.DoQueryCommand;
	
	public class DnsControl extends FrontController
	{
		public static const EVENT_DO_QUERY : String = "EVENT_DO_QUERY";
		
		public function DnsControl():void
		{
			addCommand(DnsControl.EVENT_DO_QUERY, DoQueryCommand);
		}
		
	}
}