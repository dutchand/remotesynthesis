package com.business {
	
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	import com.vo.RecordVO;

	public class DnsServicesDelegate {

		private var responder : IResponder;
		private var dnsService : Object;
		private var record : RecordVO;

		public function DnsServicesDelegate( command : IResponder ) {
			// constructor will store a reference to the service we're going to call
			this.dnsService = ServiceLocator.getInstance().getRemoteObject( 'dnsServices' );
			// and store a reference to the command that created this delegate
			this.responder = command;
		}
		
		public function doQuery(name:String,queryType:String,className:String) : void {
			// call the service
			var token:AsyncToken = dnsService.doQuery.send(name,queryType,className);
			// notify this command when the service call completes
			token.addResponder( responder );
		}
		
		public function getQueryTypes() : void {
			// call the service
			var token:AsyncToken = dnsService.getQueryTypes.send();
			// notify this command when the service call completes
			token.addResponder( responder );
		}
		
		public function getQueryClasses() : void {
			// call the service
			var token:AsyncToken = dnsService.getQueryClasses.send();
			// notify this command when the service call completes
			token.addResponder( responder );
		}
	}
}