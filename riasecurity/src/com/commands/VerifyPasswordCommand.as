package com.commands {

	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.crypto.SHA256;
	import com.business.SecurityServicesDelegate;
	import com.events.VerifyPasswordEvent;
	import com.model.ModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;

	public class VerifyPasswordCommand implements ICommand, IResponder {

		private var model : ModelLocator = ModelLocator.getInstance();
		
		public function execute( cgEvent:CairngormEvent ) : void {
			var verifyPasswordEvent:VerifyPasswordEvent = VerifyPasswordEvent(cgEvent);
			var delegate : SecurityServicesDelegate = new SecurityServicesDelegate( this );
			// hash the password (one way)
			var password:String = SHA256.hash(verifyPasswordEvent.password);
			delegate.verifyPassword(verifyPasswordEvent.email,password);
		}
		
		public function result( event : Object ) : void {
			var loggedIn:Boolean = false;
			if (event.result != '') {
				model.token = event.result;
				loggedIn = true;
			}
			Alert.show("Login verified? " + loggedIn.toString());
		}
		
		public function fault( event : Object ) : void {
			// store an error message in the model locator
			// labels, alerts, etc can bind to this to notify the user of errors
			var message:String = "Fault occurred in VerifyPasswordCommand.";
			message += "\n\n" + event.fault.faultCode;
			message += "\n\n" + event.fault.faultString;
			Alert.show(message);
		}
	}
}