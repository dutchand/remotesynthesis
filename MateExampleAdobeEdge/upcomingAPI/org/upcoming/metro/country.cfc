<cfcomponent output="false">
	<cfproperty name="id" type="numeric" required="true" />
	<cfproperty name="countryName" type="string" required="true" />
	<cfproperty name="countryCode" type="string" required="true" />
	
	<cfset variables.instance = {} />
	<cfset init() />
	
	<cffunction name="init" access="public" output="false" returntype="org.upcoming.metro.country">
		<cfargument name="id" type="numeric" required="false" default="0" />
		<cfargument name="countryName" type="string" required="false" default="" />
		<cfargument name="countryCode" type="string" required="false" default="" />
		
		<cfset setid(arguments.id) />
		<cfset setcountryName(arguments.countryName) />
		<cfset setcountryCode(arguments.countryCode) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setid" access="public" output="false" returntype="void">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset variables.instance.id = arguments.id />
	</cffunction>
	<cffunction name="getid" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.id />
	</cffunction>
	
	<cffunction name="setcountryName" access="public" output="false" returntype="void">
		<cfargument name="countryName" type="string" required="true" />
		
		<cfset variables.instance.countryName = arguments.countryName />
	</cffunction>
	<cffunction name="getcountryName" access="public" output="false" returntype="string">
		<cfreturn variables.instance.countryName />
	</cffunction>
	
	<cffunction name="setcountryCode" access="public" output="false" returntype="void">
		<cfargument name="countryCode" type="string" required="true" />
		
		<cfset variables.instance.countryCode = arguments.countryCode />
	</cffunction>
	<cffunction name="getcountryCode" access="public" output="false" returntype="string">
		<cfreturn variables.instance.countryCode />
	</cffunction>
	
	<!---
	DUMP
	--->
	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="false" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>
</cfcomponent>