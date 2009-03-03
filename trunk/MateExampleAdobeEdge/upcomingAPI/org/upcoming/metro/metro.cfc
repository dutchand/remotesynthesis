<cfcomponent output="false">
	<cfproperty name="id" type="numeric" required="true" />
	<cfproperty name="metroName" type="string" required="true" />
	<cfproperty name="metroCode" type="string" required="true" />
	<cfproperty name="stateId" type="numeric" required="true" />
	<cfproperty name="stateName" type="string" required="true" />
	<cfproperty name="stateCode" type="string" required="true" />
	<cfproperty name="countryId" type="numeric" required="true" />
	<cfproperty name="countryName" type="string" required="true" />
	<cfproperty name="countryCode" type="string" required="true" />
	
	<cfset variables.instance = {} />
	<cfset init() />
	
	<cffunction name="init" access="public" output="false" returntype="org.upcoming.metro.metro">
		<cfargument name="id" type="numeric" required="false" default="0" />
		<cfargument name="metroName" type="string" required="false" default="" />
		<cfargument name="metroCode" type="string" required="false" default="" />
		<cfargument name="stateId" type="numeric" required="false" default="0" />
		<cfargument name="stateName" type="string" required="false" default="" />
		<cfargument name="stateCode" type="string" required="false" default="" />
		<cfargument name="countryId" type="numeric" required="false" default="0" />
		<cfargument name="countryName" type="string" required="false" default="" />
		<cfargument name="countryCode" type="string" required="false" default="" />
		
		<cfset setid(arguments.id) />
		<cfset setmetroName(arguments.metroName) />
		<cfset setmetroCode(arguments.metroCode) />
		<cfset setstateId(arguments.stateId) />
		<cfset setstateName(arguments.stateName) />
		<cfset setstateCode(arguments.stateCode) />
		<cfset setcountryId(arguments.countryId) />
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
	
	<cffunction name="setmetroName" access="public" output="false" returntype="void">
		<cfargument name="metroName" type="string" required="true" />
		
		<cfset variables.instance.metroName = arguments.metroName />
	</cffunction>
	<cffunction name="getmetroName" access="public" output="false" returntype="string">
		<cfreturn variables.instance.metroName />
	</cffunction>
	
	<cffunction name="setmetroCode" access="public" output="false" returntype="void">
		<cfargument name="metroCode" type="string" required="true" />
		
		<cfset variables.instance.metroCode = arguments.metroCode />
	</cffunction>
	<cffunction name="getmetroCode" access="public" output="false" returntype="string">
		<cfreturn variables.instance.metroCode />
	</cffunction>
	
	<cffunction name="setstateId" access="public" output="false" returntype="void">
		<cfargument name="stateId" type="numeric" required="true" />
		
		<cfset variables.instance.stateId = arguments.stateId />
	</cffunction>
	<cffunction name="getstateId" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.stateId />
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
	
	<cffunction name="setcountryId" access="public" output="false" returntype="void">
		<cfargument name="countryId" type="numeric" required="true" />
		
		<cfset variables.instance.countryId = arguments.countryId />
	</cffunction>
	<cffunction name="getcountryId" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.countryId />
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