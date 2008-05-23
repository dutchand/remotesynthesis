<cfcomponent displayname="consoleValidation" extends="MachII.framework.EventFilter" output="false">

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
	<cffunction name="filterEvent" access="public" output="false" returntype="boolean" 
		hint="Filters event and returns a boolean to Mach-II indicating whether or not the event queue 
		should proceed.  If not, the event queue is cleared and a new event is announced.">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="true" />
		
		<cfset var proceed = true />
		<cfset var errors = arrayNew(1) />
		<cfif not len(trim(event.getArg("type")))>
			<cfset arrayAppend(errors,"You must enter a type") />
		</cfif>
		<cfif not len(trim(event.getArg("storage")))>
			<cfset arrayAppend(errors,"You must enter a storage amount") />
		</cfif>
		<cfif not isNumeric(trim(event.getArg("storage")))>
			<cfset arrayAppend(errors,"Storage must be numeric") />
		</cfif>
		<cfif arrayLen(errors)>
			<cfset proceed = false />
			<cfset event.setArg("errors",errors) />
			<cfset announceEvent("failed", arguments.event.getArgs()) />
		</cfif>
		
		<cfreturn proceed />
	</cffunction>

</cfcomponent>