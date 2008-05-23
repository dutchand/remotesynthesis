<cfcomponent displayname="accessory" output="false">		<cfproperty name="accessoryID" type="uuid" default="" />		<cfproperty name="accessoryName" type="string" default="" />			<!---	PROPERTIES	--->	<cfset variables.instance = StructNew() />	<!---	INITIALIZATION / CONFIGURATION	--->	<cffunction name="init" access="public" returntype="blank.com.accessory" output="false">		<cfargument name="accessoryID" type="uuid" required="false" default="#createUUID()#" />		<cfargument name="accessoryName" type="string" required="false" default="" />				<!--- run setters --->		<cfset setaccessoryID(arguments.accessoryID) />		<cfset setaccessoryName(arguments.accessoryName) />				<cfreturn this /> 	</cffunction>	<!---	PUBLIC FUNCTIONS	--->	<cffunction name="setMemento" access="public" returntype="blank.com.accessory" output="false">		<cfargument name="memento" type="struct" required="yes"/>		<cfset variables.instance = arguments.memento />		<cfreturn this />	</cffunction>	<cffunction name="getMemento" access="public" returntype="struct" output="false" >		<cfreturn variables.instance />	</cffunction>	<cffunction name="validate" access="public" returntype="array" output="false">		<cfset var errors = arrayNew(1) />		<cfset var thisError = structNew() />				<!--- accessoryID --->		<cfif (NOT len(trim(getaccessoryID())))>			<cfset thisError.field = "accessoryID" />			<cfset thisError.type = "required" />			<cfset thisError.message = "accessoryID is required" />			<cfset arrayAppend(errors,duplicate(thisError)) />		</cfif>				<!--- accessoryName --->		<cfif (NOT len(trim(getaccessoryName())))>			<cfset thisError.field = "accessoryName" />			<cfset thisError.type = "required" />			<cfset thisError.message = "accessoryName is required" />			<cfset arrayAppend(errors,duplicate(thisError)) />		</cfif>		<cfif (len(trim(getaccessoryName())) AND NOT IsSimpleValue(trim(getaccessoryName())))>			<cfset thisError.field = "accessoryName" />			<cfset thisError.type = "invalidType" />			<cfset thisError.message = "accessoryName is not a string" />			<cfset arrayAppend(errors,duplicate(thisError)) />		</cfif>		<cfif (len(trim(getaccessoryName())) GT 45)>			<cfset thisError.field = "accessoryName" />			<cfset thisError.type = "tooLong" />			<cfset thisError.message = "accessoryName is too long" />			<cfset arrayAppend(errors,duplicate(thisError)) />		</cfif>				<cfreturn errors />	</cffunction>	<!---	ACCESSORS	--->	<cffunction name="setaccessoryID" access="public" returntype="void" output="false">		<cfargument name="accessoryID" type="uuid" required="true" />		<cfset variables.instance.accessoryID = arguments.accessoryID />	</cffunction>	<cffunction name="getaccessoryID" access="public" returntype="uuid" output="false">		<cfreturn variables.instance.accessoryID />	</cffunction>	<cffunction name="setaccessoryName" access="public" returntype="void" output="false">		<cfargument name="accessoryName" type="string" required="true" />		<cfset variables.instance.accessoryName = arguments.accessoryName />	</cffunction>	<cffunction name="getaccessoryName" access="public" returntype="string" output="false">		<cfreturn variables.instance.accessoryName />	</cffunction>	<!---	DUMP	--->	<cffunction name="dump" access="public" output="true" return="void">		<cfargument name="abort" type="boolean" default="false" />		<cfdump var="#variables.instance#" />		<cfif arguments.abort>			<cfabort />		</cfif>	</cffunction></cfcomponent>
