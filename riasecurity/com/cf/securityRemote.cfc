<cfcomponent output="false">
	<cffunction name="getPublicKey" access="remote" output="false" returntype="string">
		<cfreturn application.publicKey />
	</cffunction>
	<cffunction name="saveUser" access="remote" output="false" returntype="com.cf.user">
		<cfargument name="user" type="com.cf.user" required="true" />
		
		<cfreturn arguments.user />
	</cffunction>
</cfcomponent>