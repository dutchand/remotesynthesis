package com.commands {

	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.business.SecurityServicesDelegate;
	import com.model.ModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;

	public class GetPublicKeyCommand implements ICommand, IResponder {

		private var model : ModelLocator = ModelLocator.getInstance();
		
		public function execute( cgEvent:CairngormEvent ) : void {
			var delegate : SecurityServicesDelegate = new SecurityServicesDelegate( this );
			delegate.getPublicKey();
		}
		
		public function result( event : Object ) : void {
			model.publicKey = event.result;
		}
		
		public function fault( event : Object ) : void {
			// store an error message in the model locator
			// labels, alerts, etc can bind to this to notify the user of errors
			var message:String = "Fault occurred in GetPublicKeyCommand.";
			message += "\n\n" + event.fault.faultCode;
			message += "\n\n" + event.fault.faultString;
			Alert.show(message);
		}
	}
}