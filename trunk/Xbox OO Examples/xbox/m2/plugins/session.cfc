<cfcomponent extends="MachII.framework.Plugin">
	<cffunction name="configure" access="public" returntype="void" output="false">
	</cffunction>
	
	<cffunction name="preEvent" access="public" returntype="void" output="false">
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="true" />
		<cfset var event = arguments.eventContext.getCurrentEvent() />
		
		<cfif structKeyExists(session,"console") and not event.isArgDefined('consoleID')>
			<cfset event.setArg('consoleID',session.console.getConsoleID()) />
		</cfif>
		<cfif structKeyExists(session,"console") and not event.isArgDefined('console')>
			<cfset event.setArg('console',session.console) />
		</cfif>
	</cffunction>
	
	<cffunction name="preView" access="public" returntype="void" output="false">
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="true" />
		<cfset var event = arguments.eventContext.getCurrentEvent() />
		
		<cfif event.isArgDefined('console') and (not structKeyExists(session,"console") or event.isArgDefined('clearConsole'))>
			<cfset session.console = event.getArg('console') />
		</cfif>
	</cffunction>
</cfcomponent>