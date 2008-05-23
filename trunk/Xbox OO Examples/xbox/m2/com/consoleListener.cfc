<cfcomponent output="false" extends="MachII.framework.Listener" displayname="consoleListener" hint="I am a console listener.">

	<cffunction name="configure" access="public" returntype="void" output="false">	
		<cfset var dsn = getProperty('dsn') />
		
		<cfset var consoleDAO = createObject("component","m2.com.xbox.consoleDAO").init(dsn) />
		<cfset var consoleGateway = createObject("component","m2.com.xbox.consoleGateway").init(dsn) />
		<cfset var controlDAO = createObject("component","m2.com.xbox.controls.controlDAO").init(dsn) />
		<cfset var controlGateway = createObject("component","m2.com.xbox.controls.controlGateway").init(dsn) />
		<cfset var accessoryDAO = createObject("component","m2.com.xbox.accessories.accessoryDAO").init(dsn) />
		<cfset var accessoryGateway = createObject("component","m2.com.xbox.accessories.accessoryGateway").init(dsn) />
		<cfset var gameDAO = createObject("component","m2.com.xbox.games.gameDAO").init(dsn) />
		<cfset var gameGateway = createObject("component","m2.com.xbox.games.gameGateway").init(dsn) />

		<cfset variables.consoleService = createObject("component","m2.com.xbox.consoleService").init(consoleDAO,consoleGateway,controlDAO,controlGateway,accessoryDAO,accessoryGateway,gameDAO,gameGateway) />
	</cffunction>
	
	<cffunction name="getConsole" access="public" returntype="any" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var consoleID = event.getArg("consoleID") />
		<!--- if no id is defined, just get at empty console with a new id --->
		<cfif not len(consoleID)>
			<cfset consoleID = createUUID() />
		</cfif>
		<cfreturn variables.consoleService.getConsole(consoleID) />
	</cffunction>
	
	<cffunction name="createConsole" access="public" returntype="any" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var args = structNew() />
		<cfset args.consoleID = event.getArg("consoleID") />
		<cfif not len(args.consoleID)>
			<cfset args.consoleID = createUUID() />
		</cfif>
		<cfset args.type = event.getArg("type") />
		<cfset args.storage = event.getArg("storage") />
		<cfreturn variables.consoleService.createConsole(argumentCollection=args) />
	</cffunction>
	
	<cffunction name="updateConsole" access="public" returntype="void" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var console = event.getArg("console") />
		<cfset var type = event.getArg("type") />
		<cfset var storage = event.getArg("storage") />
		<cfif len(type)>
			<cfset console.setType(type) />
		</cfif>
		<cfif len(storage)>
			<cfset console.setStorage(storage) />
		</cfif>
	</cffunction>
	
	<cffunction name="saveConsole" access="public" returntype="void" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var success =  variables.consoleService.saveConsole(event.getArg("console")) />
		<cfif success>
			<cfset announceEvent("success",event.getArgs()) />
		<cfelse>
			<cfset event.setArg("message","The save failed") />
			<cfset announceEvent("failed",event.getArgs()) />
		</cfif>
	</cffunction>
	
	<cffunction name="getGame" access="public" returntype="any" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var gameID = event.getArg("gameID") />
		<!--- if no id is defined, just get at empty console --->
		<cfif not len(gameID)>
			<cfset gameID = createUUID() />
		</cfif>
		<cfreturn variables.consoleService.getGame(gameID) />
	</cffunction>
	
	<cffunction name="createGame" access="public" returntype="any" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var args = structNew() />
		<cfset args.gameID = event.getArg("gameID") />
		<cfif not len(args.gameID)>
			<cfset args.gameID = createUUID() />
		</cfif>
		<cfset args.gameName = event.getArg("gameName") />
		<cfset args.specialEdition = event.getArg("specialEdition") />
		<cfreturn variables.consoleService.createGame(argumentCollection=args) />
	</cffunction>
	
	<cffunction name="saveGame" access="public" returntype="void" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var success =  variables.consoleService.saveGame(event.getArg("game")) />
		<cfif success>
			<cfset announceEvent("success",event.getArgs()) />
		<cfelse>
			<cfset event.setArg("message","The save failed") />
			<cfset announceEvent("failed",event.getArgs()) />
		</cfif>
	</cffunction>

<!--- accessories --->
	<cffunction name="getAccessory" access="public" returntype="any" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var accessoryID = event.getArg("accessoryID") />
		<!--- if no id is defined, just get at empty console --->
		<cfif not len(accessoryID)>
			<cfset accessoryID = createUUID() />
		</cfif>
		<cfreturn variables.consoleService.getAccessory(accessoryID) />
	</cffunction>
	
	<cffunction name="saveAccessory" access="public" returntype="void" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var success =  variables.consoleService.saveAccessory(event.getArg("accessory")) />
		<cfif success>
			<cfset announceEvent("success",event.getArgs()) />
		<cfelse>
			<cfset event.setArg("message","The save failed") />
			<cfset announceEvent("failed",event.getArgs()) />
		</cfif>
	</cffunction>
</cfcomponent>