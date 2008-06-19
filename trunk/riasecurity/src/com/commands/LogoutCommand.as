package com.commands {

	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.business.SecurityServicesDelegate;
	import com.model.ModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;

	public class LogoutCommand implements ICommand, IResponder {

		private var model : ModelLocator = ModelLocator.getInstance();
		
		public function execute( cgEvent:CairngormEvent ) : void {
			var delegate : SecurityServicesDelegate = new SecurityServicesDelegate( this );
			delegate.logoutUser();
		}
		
		public function result( event : Object ) : void {
			Alert.show("You are logged out.");
		}
		
		public function fault( event : Object ) : void {
			// store an error message in the model locator
			// labels, alerts, etc can bind to this to notify the user of errors
			var message:String = "Fault occurred in LogoutCommand.";
			message += "\n\n" + event.fault.faultCode;
			message += "\n\n" + event.fault.faultString;
			Alert.show(message);
		}
	}
}