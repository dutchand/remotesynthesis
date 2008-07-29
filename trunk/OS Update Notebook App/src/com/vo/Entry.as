package com.vo
{
	import com.vo.Category;
	
	[Bindable]
	public class Entry
	{

		public var title:String = "";
		public var url:String = "";
		public var content:String = "";
		public var category:Category = new Category;
		public var project:String = "";
		public var isNew:Boolean = false;

		public function Entry()
		{
		}

	}
}