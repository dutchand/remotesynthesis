<cfcomponent output="false">
	<cfproperty name="fullName" type="string" required="true" />
	<cfproperty name="email" type="string" required="true" />
	<cfproperty name="password" type="string" required="true" />
	<cfproperty name="ssn" type="binary" required="true" />
		
	<cffunction name="init" access="public" output="false" returntype="com.cf.user">
		<cfargument name="fullName" type="string" required="true" />
		<cfargument name="email" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
		<cfargument name="ssn" type="binary" required="true" />
		
		<cfset setFullName(arguments.fullName) />
		<cfset setEmail(arguments.email) />
		<cfset setPassword(arguments.password) />
		<cfset setSSN(arguments.ssn) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getFullName" access="public" output="false" returntype="string">
		<cfreturn variables.fullName />
	</cffunction>	
	<cffunction name="setFullName" access="public" output="false" returntype="void">
		<cfargument name="fullName" type="string" required="true" />
		
		<cfset variables.fullName = arguments.fullName />
	</cffunction>
	
	<cffunction name="getEmail" access="public" output="false" returntype="string">
		<cfreturn variables.email />
	</cffunction>	
	<cffunction name="setEmail" access="public" output="false" returntype="void">
		<cfargument name="email" type="string" required="true" />
		
		<cfset variables.email = arguments.email />
	</cffunction>
	
	<cffunction name="getPassword" access="public" output="false" returntype="string">
		<cfreturn variables.password />
	</cffunction>	
	<cffunction name="setPassword" access="public" output="false" returntype="void">
		<cfargument name="password" type="string" required="true" />
		
		<cfset variables.password = arguments.password />
	</cffunction>
	
	<cffunction name="getSSN" access="public" output="false" returntype="binary">
		<cfreturn variables.ssn />
	</cffunction>	
	<cffunction name="setSSN" access="public" output="false" returntype="void">
		<cfargument name="ssn" type="binary" required="true" />
		
		<cfset variables.ssn = arguments.ssn />
	</cffunction>
</cfcomponent>