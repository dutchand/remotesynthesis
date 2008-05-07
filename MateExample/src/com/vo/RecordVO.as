package com.vo
{
	[RemoteClass(alias="com.cf.record")]

	[Bindable]
	public class RecordVO
	{

		public var sectionID:String = "";
		public var sectionName:String = "";
		public var className:String = "";
		public var recordName:String = "";
		public var type:String = "";
		public var additionalName:String = "";
		public var target:String = "";
		public var ttl:String = "";


		public function RecordVO()
		{
		}

	}
}