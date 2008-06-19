package com.business {
	
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.vo.User;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class SecurityServicesDelegate {

		private var responder : IResponder;
		private var securityService : Object;

		public function SecurityServicesDelegate( command : IResponder ) {
			// constructor will store a reference to the service we're going to call
			this.securityService = ServiceLocator.getInstance().getRemoteObject( 'securityServices' );
			// and store a reference to the command that created this delegate
			this.responder = command;
		}
		
		public function saveUser(user:User) : void {
			// call the service
			var token:AsyncToken = securityService.saveUser.send(user);
			// notify this command when the service call completes
			token.addResponder( responder );
		}
		
		public function login(username:String,password:String,userRole:String) : void {
			// call the service
			var token:AsyncToken = securityService.login.send(username,password,userRole);
			// notify this command when the service call completes
			token.addResponder( responder );
		}
		
		public function logoutUser() : void {
			// call the service
			var token:AsyncToken = securityService.logoutUser.send();
			// notify this command when the service call completes
			token.addResponder( responder );
		}
	}
}