package com.commands {

	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.crypto.SHA256;
	import com.business.SecurityServicesDelegate;
	import com.events.SaveUserEvent;
	import com.model.ModelLocator;
	import com.vo.User;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;

	public class SaveUserCommand implements ICommand, IResponder {

		private var model : ModelLocator = ModelLocator.getInstance();
		
		public function execute( cgEvent:CairngormEvent ) : void {
			var saveUserEvent:SaveUserEvent = SaveUserEvent(cgEvent);
			var delegate : SecurityServicesDelegate = new SecurityServicesDelegate( this );
			// hash the password (one way)
			var password:String = SHA256.hash(saveUserEvent.password);
			// hash the ssn (two way)
			var encryptedSSN:String = "";
			var user:User = new User(saveUserEvent.fullName,saveUserEvent.email,password,encryptedSSN);
			delegate.saveUser(user);
		}
		
		public function result( event : Object ) : void {
			// just display the user object I sent as an alert
			var user:User = event.result;
			var message:String = "";
			message += "Full Name : " + user.fullName + "\n";
			message += "Email : " + user.email + "\n";
			message += "Password : " + user.password + "\n";
			message += "SSN : " + user.ssn;
			Alert.show(message);
		}
		
		public function fault( event : Object ) : void {
			// store an error message in the model locator
			// labels, alerts, etc can bind to this to notify the user of errors
			var message:String = "Fault occurred in SaveUserCommand.";
			message += "\n\n" + event.fault.faultCode;
			message += "\n\n" + event.fault.faultString;
			Alert.show(message);
		}
	}
}