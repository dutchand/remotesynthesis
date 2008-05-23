<cfcomponent displayname="control" output="false">		<cfproperty name="controlID" type="uuid" default="" />		<cfproperty name="wireless" type="Boolean" default="" />		<cfproperty name="headset" type="Boolean" default="" />			<!---	PROPERTIES	--->	<cfset variables.instance = StructNew() />	<!---	INITIALIZATION / CONFIGURATION	--->	<cffunction name="init" access="public" returntype="control" output="false">		<cfargument name="controlID" type="uuid" required="false" default="#createUUID()#" />		<cfargument name="wireless" type="string" required="false" default="" />		<cfargument name="headset" type="string" required="false" default="" />				<!--- run setters --->		<cfset setcontrolID(arguments.controlID) />		<cfset setwireless(arguments.wireless) />		<cfset setheadset(arguments.headset) />				<!--- you are not using the headset by default --->		<cfset removeHeadset() />				<cfreturn this /> 	</cffunction>	<!---	PUBLIC FUNCTIONS	--->	<cffunction name="setMemento" access="public" returntype="standard.com.xbox.controls.control" output="false">		<cfargument name="memento" type="struct" required="yes"/>		<cfset variables.instance = arguments.memento />		<cfreturn this />	</cffunction>	<cffunction name="getMemento" access="public" returntype="struct" output="false" >		<cfreturn variables.instance />	</cffunction>	<cffunction name="validate" access="public" returntype="array" output="false">		<cfset var errors = arrayNew(1) />		<cfset var thisError = structNew() />				<!--- controlID --->		<cfif (NOT len(trim(getcontrolID())))>			<cfset thisError.field = "controlID" />			<cfset thisError.type = "required" />			<cfset thisError.message = "controlID is required" />			<cfset arrayAppend(errors,duplicate(thisError)) />		</cfif>				<!--- wireless --->		<cfif (NOT len(trim(getwireless())))>			<cfset thisError.field = "wireless" />			<cfset thisError.type = "required" />			<cfset thisError.message = "wireless is required" />			<cfset arrayAppend(errors,duplicate(thisError)) />		</cfif>				<!--- headset --->		<cfif (NOT len(trim(getheadset())))>			<cfset thisError.field = "headset" />			<cfset thisError.type = "required" />			<cfset thisError.message = "headset is required" />			<cfset arrayAppend(errors,duplicate(thisError)) />		</cfif>				<cfreturn errors />	</cffunction>	<!---	ACCESSORS	--->	<cffunction name="setcontrolID" access="public" returntype="void" output="false">		<cfargument name="controlID" type="uuid" required="true" />		<cfset variables.instance.controlID = arguments.controlID />	</cffunction>	<cffunction name="getcontrolID" access="public" returntype="uuid" output="false">		<cfreturn variables.instance.controlID />	</cffunction>	<cffunction name="setwireless" access="public" returntype="void" output="false">		<cfargument name="wireless" type="string" required="true" />		<cfset variables.instance.wireless = arguments.wireless />	</cffunction>	<cffunction name="getwireless" access="public" returntype="string" output="false">		<cfreturn variables.instance.wireless />	</cffunction>	<cffunction name="setheadset" access="public" returntype="void" output="false">		<cfargument name="headset" type="string" required="true" />		<cfset variables.instance.headset = arguments.headset />	</cffunction>	<cffunction name="getheadset" access="public" returntype="string" output="false">		<cfreturn variables.instance.headset />	</cffunction>	<cffunction name="useHeadset" access="public" returntype="void" output="false">		<cfif getHeadset()>			<cfset variables.headsetInUse = true />		<cfelse>			<cfthrow errorcode="standard.com.xbox.controls.control.headsetNotSupported" />		</cfif>	</cffunction>	<cffunction name="removeHeadset" access="public" returntype="void" output="false">		<cfset variables.headsetInUse = false />	</cffunction>	<cffunction name="isHeadsetInUse" access="public" returntype="boolean" output="false">		<cfreturn variables.headsetInUse />	</cffunction>	<!---	DUMP	--->	<cffunction name="dump" access="public" output="true" return="void">		<cfargument name="abort" type="boolean" default="false" />		<cfdump var="#variables.instance#" />		<cfif arguments.abort>			<cfabort />		</cfif>	</cffunction></cfcomponent>
