package com.commands {

	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.business.DnsServicesDelegate;
	import com.model.ModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.IResponder;

	public class GetTypesCommand implements ICommand, IResponder {

		private var model : ModelLocator = ModelLocator.getInstance();
		
		public function execute( cgEvent:CairngormEvent ) : void {
			var delegate : DnsServicesDelegate = new DnsServicesDelegate( this );
			delegate.getQueryTypes();
		}
		
		public function result( event : Object ) : void {
			model.types.source = event.result;
		}
		
		public function fault( event : Object ) : void {
			// store an error message in the model locator
			// labels, alerts, etc can bind to this to notify the user of errors
			Alert.show("Fault occurred in GetTypesCommand.");
			Alert.show(event.fault.faultCode);
			Alert.show(event.fault.faultString);
		}
	}
}