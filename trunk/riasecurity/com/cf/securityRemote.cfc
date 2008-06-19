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
		
		<cfset session.user = {email=user.getEmail(),password=user.getPassword()} />
		<cfreturn arguments.user />
	</cffunction>
	
	<cffunction name="verifyPassword" access="remote" output="false" returntype="string">
		<cfargument name="email" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
		
		<cfset var success = false />
		<cfset var token = "" />
		<cfif arguments.email eq session.user.email and arguments.password eq session.user.password>
			<cfset success = true />
			<cfset token = createUUID() />
			<cfset application.tokens[token] = "whatever I want to store" />
		</cfif>
		<cfreturn token />
	</cffunction>
	
	<cffunction name="verifyToken" access="remote" output="false" returntype="boolean">
		<cfargument name="token" type="string" required="true" />
		<cfset var success = false />
		
		<cfif structKeyExists(application.tokens,arguments.token)>
			<cfset success = true />
		</cfif>
		<cfreturn success />
	</cffunction>
</cfcomponent>