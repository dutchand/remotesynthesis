package com.commands {

	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.business.DnsServicesDelegate;
	import com.control.DoQueryEvent;
	import com.model.ModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.IResponder;

	public class DoQueryCommand implements ICommand, IResponder {

		private var model : ModelLocator = ModelLocator.getInstance();
		
		public function execute( cgEvent:CairngormEvent ) : void {
			var doQueryEvent:DoQueryEvent = DoQueryEvent(cgEvent);
			var delegate : DnsServicesDelegate = new DnsServicesDelegate( this );
			delegate.doQuery(doQueryEvent.name,doQueryEvent.queryType,doQueryEvent.className);
		}
		
		public function result( rpcEvent : Object ) : void {
			model.records.source = rpcEvent.result;
		}
		
		public function fault( rpcEvent : Object ) : void {
			// store an error message in the model locator
			// labels, alerts, etc can bind to this to notify the user of errors
			Alert.show("Fault occurred in DoQueryCommand.");
			Alert.show(rpcEvent.fault.faultCode);
			Alert.show(rpcEvent.fault.faultString);
		}
	}
}