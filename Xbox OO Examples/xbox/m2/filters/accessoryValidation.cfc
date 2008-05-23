<cfcomponent displayname="accessoryValidation" extends="MachII.framework.EventFilter" output="false">

	<!---
	PROPERTIES
	--->

	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="configure" access="public" output="false" returntype="void"
		hint="Configures the event-filter.">
		<!--- Does nothing. --->
	</cffunction>
	
	<!---
	PUBLIC FUNCTIONS
	--->
	<cffunction name="filterEvent" access="public" output="false" returntype="boolean">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="true" />
		
		<cfset var proceed = true />
		<cfset var errors = arrayNew(1) />
		<cfif not len(trim(event.getArg("accessoryName")))>
			<cfset arrayAppend(errors,"You must enter a accessory name") />
		</cfif>
		<cfif arrayLen(errors)>
			<cfset proceed = false />
			<cfset event.setArg("errors",errors) />
			<cfset announceEvent("failed", arguments.event.getArgs()) />
		</cfif>
		
		<cfreturn proceed />
	</cffunction>

</cfcomponent>