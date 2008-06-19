<cfcomponent output="false">
	<cffunction name="login" access="remote" output="false" returntype="boolean">
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
		<cfargument name="userRole" type="string" required="true" />
		
		<cfset var success = true />
		
		<cftry>
			<cfset logoutUser() />
			<cflogin>
				<cfloginuser name="#arguments.username#" password="#arguments.password#" roles="#arguments.userRole#">
			</cflogin>
			<cfcatch type="any">
				<cfset success = false />
			</cfcatch>
		</cftry>
		<cfreturn success />
	</cffunction>
	
	<cffunction name="logoutUser" access="remote" output="false" returntype="boolean">
		<cflogout />
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="saveUser" access="remote" output="false" returntype="com.cf.user" roles="admin">
		<cfargument name="user" type="com.cf.user" required="true" />
		
		<cfreturn arguments.user />
	</cffunction>
</cfcomponent>