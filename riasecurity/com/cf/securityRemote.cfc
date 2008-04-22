<cfcomponent output="false">
	<cffunction name="getPublicKey" access="remote" output="false" returntype="string">
		<cfreturn application.keys.publicKey />
	</cffunction>
	<cffunction name="saveUser" access="remote" output="false" returntype="com.cf.user">
		<cfargument name="user" type="com.cf.user" required="true" />
		
		<cfset var ssn = decrypt(ToBase64(arguments.user.getSSNBinary()),getPublicKey(),"AES","Hex") />
		<cfset arguments.user.setSSN(ssn) />
		
		<cfreturn arguments.user />
	</cffunction>
</cfcomponent>