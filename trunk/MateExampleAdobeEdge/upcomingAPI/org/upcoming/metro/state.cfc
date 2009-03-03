<cfcomponent output="false">
	<cfproperty name="id" type="numeric" required="true" />
	<cfproperty name="stateName" type="string" required="true" />
	<cfproperty name="stateCode" type="string" required="true" />
	
	<cfset variables.instance = {} />
	<cfset init() />
	
	<cffunction name="init" access="public" output="false" returntype="org.upcoming.metro.state">
		<cfargument name="id" type="numeric" required="false" default="0" />
		<cfargument name="stateName" type="string" required="false" default="" />
		<cfargument name="stateCode" type="string" required="false" default="" />
		
		<cfset setid(arguments.id) />
		<cfset setstateName(arguments.stateName) />
		<cfset setstateCode(arguments.stateCode) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setid" access="public" output="false" returntype="void">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset variables.instance.id = arguments.id />
	</cffunction>
	<cffunction name="getid" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.id />
	</cffunction>
	
	<cffunction name="setstateName" access="public" output="false" returntype="void">
		<cfargument name="stateName" type="string" required="true" />
		
		<cfset variables.instance.stateName = arguments.stateName />
	</cffunction>
	<cffunction name="getstateName" access="public" output="false" returntype="string">
		<cfreturn variables.instance.stateName />
	</cffunction>
	
	<cffunction name="setstateCode" access="public" output="false" returntype="void">
		<cfargument name="stateCode" type="string" required="true" />
		
		<cfset variables.instance.stateCode = arguments.stateCode />
	</cffunction>
	<cffunction name="getstateCode" access="public" output="false" returntype="string">
		<cfreturn variables.instance.stateCode />
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