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
		public var ssn:String = "";
		public var ssnBinary:ByteArray;

		public function User(fullName:String="",email:String="",password:String="",ssn:String="",ssnBinary:ByteArray=null) {
			this.fullName = fullName;
			this.email = email;
			this.password = password;
			this.ssn = ssn;
			this.ssnBinary = ssnBinary;
		}
	}
}