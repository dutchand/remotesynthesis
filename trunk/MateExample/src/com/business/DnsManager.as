package com.business
{
	import mx.collections.ArrayCollection;
	
	public class DnsManager
	{
		[Bindable]
		public var types:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var classes:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var records:ArrayCollection = new ArrayCollection();
		
		public function setTypes(typesResult:Array):void {
			types.source = typesResult;
		}
		public function setClasses(classesResult:Array):void {
			classes.source = classesResult;
		}
		public function setDnsQuery(dnsResult:Array):void {
			records.source = dnsResult;
		}
	}
}