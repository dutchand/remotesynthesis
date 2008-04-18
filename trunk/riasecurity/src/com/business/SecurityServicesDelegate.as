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
		
		public function getPublicKey() : void {
			// call the service
			var token:AsyncToken = securityService.getPublicKey.send();
			// notify this command when the service call completes
			token.addResponder( responder );
		}
	}
}