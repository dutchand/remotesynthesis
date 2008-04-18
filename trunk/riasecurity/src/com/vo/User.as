package com.vo
{
	[RemoteClass(alias="com.cf.user")]

	[Bindable]
	public class User
	{

		public var fullName:String = "";
		public var email:String = "";
		public var password:String = "";
		public var ssn:String = "";

		public function User(fullName:String="",email:String="",password:String="",ssn:String="") {
			this.fullName = fullName;
			this.email = email;
			this.password = password;
			this.ssn = ssn;
		}
	}
}