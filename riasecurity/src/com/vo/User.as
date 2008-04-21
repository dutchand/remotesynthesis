package com.vo
{
	[RemoteClass(alias="com.cf.user")]

	[Bindable]
	public class User
	{
		import flash.utils.ByteArray;

		public var fullName:String = "";
		public var email:String = "";
		public var password:String = "";
		public var ssn:ByteArray;

		public function User(fullName:String="",email:String="",password:String="",ssn:ByteArray=null) {
			this.fullName = fullName;
			this.email = email;
			this.password = password;
			this.ssn = ssn;
		}
	}
}