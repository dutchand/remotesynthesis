package com.model 
{
 	import com.adobe.cairngorm.model.ModelLocator;
 	
 	import mx.collections.ArrayCollection;

 	[Bindable]
	public class ModelLocator implements com.adobe.cairngorm.model.ModelLocator
	{
		private static var modelLocator : com.model.ModelLocator;
		
		public static function getInstance() : com.model.ModelLocator 
		{
			if ( modelLocator == null )
				modelLocator = new com.model.ModelLocator();
				
			return modelLocator;
	   }
	   
   	public function ModelLocator() 
   	{
   		if ( com.model.ModelLocator.modelLocator != null )
				throw new Error( "Only one ModelLocator instance should be instantiated" );	
   	}
		public var records:ArrayCollection = new ArrayCollection();
		public var classes:ArrayCollection = new ArrayCollection();
		public var types:ArrayCollection = new ArrayCollection();
	}
}