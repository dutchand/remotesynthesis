<cfcomponent displayname="consoleDAO" hint="table ID column = consoleID">	<cffunction name="init" access="public" output="false" returntype="m2.com.xbox.consoleDAO">		<cfargument name="dsn" type="string" required="true">		<cfset variables.dsn = arguments.dsn>		<cfreturn this>	</cffunction>		<cffunction name="create" access="public" output="false" returntype="boolean">		<cfargument name="console" type="m2.com.xbox.console" required="true" />		<cfset var qCreate = "" />		<cftry>			<cfquery name="qCreate" datasource="#variables.dsn#">				INSERT INTO console					(					consoleID,					type,					storage					)				VALUES					(					<cfqueryparam value="#arguments.console.getconsoleID()#" CFSQLType="cf_sql_char" />,					<cfqueryparam value="#arguments.console.gettype()#" CFSQLType="cf_sql_varchar" />,					<cfqueryparam value="#arguments.console.getstorage()#" CFSQLType="cf_sql_integer" />					)			</cfquery>			<!--- save any controls, games, accessories associations --->			<cfset saveControls(arguments.console) />			<cfset saveGames(arguments.console) />			<cfset saveAccessories(arguments.console) />			<cfcatch type="database">				<cfreturn false />			</cfcatch>		</cftry>		<cfreturn true />	</cffunction>	<cffunction name="read" access="public" output="false" returntype="void">		<cfargument name="console" type="m2.com.xbox.console" required="true" />		<cfset var qRead = "" />		<cfset var strReturn = structNew() />		<cftry>			<cfquery name="qRead" datasource="#variables.dsn#">				SELECT					consoleID,					type,					storage				FROM	console				WHERE	consoleID = <cfqueryparam value="#arguments.console.getconsoleID()#" CFSQLType="cf_sql_char" />			</cfquery>			<cfcatch type="database">				<!--- leave the bean as is and set an empty query for the conditional logic below --->				<cfset qRead = queryNew("id") />			</cfcatch>		</cftry>		<cfif qRead.recordCount>			<cfset strReturn = queryRowToStruct(qRead)>			<cfset arguments.console.init(argumentCollection=strReturn)>		</cfif>	</cffunction>	<cffunction name="update" access="public" output="false" returntype="boolean">		<cfargument name="console" type="m2.com.xbox.console" required="true" />		<cfset var qUpdate = "" />		<cftry>			<cfquery name="qUpdate" datasource="#variables.dsn#">				UPDATE	console				SET					type = <cfqueryparam value="#arguments.console.gettype()#" CFSQLType="cf_sql_varchar" />,					storage = <cfqueryparam value="#arguments.console.getstorage()#" CFSQLType="cf_sql_integer" />				WHERE	consoleID = <cfqueryparam value="#arguments.console.getconsoleID()#" CFSQLType="cf_sql_char" />			</cfquery>			<!--- save any controls, games, accessories associations --->			<cfset saveControls(arguments.console) />			<cfset saveGames(arguments.console) />			<cfset saveAccessories(arguments.console) />			<cfcatch type="database">				<cfreturn false />			</cfcatch>		</cftry>		<cfreturn true />	</cffunction>	<cffunction name="delete" access="public" output="false" returntype="boolean">		<cfargument name="console" type="m2.com.xbox.console" required="true" />		<cfset var qDelete = "">		<cftry>			<cfquery name="qDelete" datasource="#variables.dsn#">				DELETE FROM	console 				WHERE	consoleID = <cfqueryparam value="#arguments.console.getconsoleID()#" CFSQLType="cf_sql_char" />			</cfquery>			<cfcatch type="database">				<cfreturn false />			</cfcatch>		</cftry>		<cfreturn true />	</cffunction>	<cffunction name="exists" access="public" output="false" returntype="boolean">		<cfargument name="console" type="m2.com.xbox.console" required="true" />		<cfset var qExists = "">		<cfquery name="qExists" datasource="#variables.dsn#" maxrows="1">			SELECT count(1) as idexists			FROM	console			WHERE	consoleID = <cfqueryparam value="#arguments.console.getconsoleID()#" CFSQLType="cf_sql_char" />		</cfquery>		<cfif qExists.idexists>			<cfreturn true />		<cfelse>			<cfreturn false />		</cfif>	</cffunction>	<cffunction name="save" access="public" output="false" returntype="boolean">		<cfargument name="console" type="m2.com.xbox.console" required="true" />				<cfset var success = false />		<cfif exists(arguments.console)>			<cfset success = update(arguments.console) />		<cfelse>			<cfset success = create(arguments.console) />		</cfif>				<cfreturn success />	</cffunction>		<cffunction name="saveControls" access="private" output="false" returntype="void">		<cfargument name="console" type="console" required="true" />				<cfset var i = 0 />		<cfset var clearControlRel = "" />		<cfset var saveControlRel = "" />		<cfset var controls = arguments.console.getControls() />		<!--- first clear existing relationships --->		<cfquery name="clearControlRel" datasource="#variables.dsn#">			DELETE FROM relconsolecontrols			WHERE		consoleID = <cfqueryparam value="#arguments.console.getconsoleID()#" CFSQLType="cf_sql_char" />		</cfquery>		<cfif arrayLen(controls)>			<cfloop from="1" to="#arrayLen(controls)#" index="i">				<cfquery name="saveControlRel" datasource="#variables.dsn#">					INSERT INTO relconsolecontrols(consoleid,controlid)					VALUES (<cfqueryparam value="#arguments.console.getconsoleID()#" CFSQLType="cf_sql_char" />,							<cfqueryparam value="#controls[i].getControlID()#" CFSQLType="cf_sql_char" />							)				</cfquery>			</cfloop>		</cfif>	</cffunction>		<cffunction name="saveGames" access="private" output="false" returntype="void">		<cfargument name="console" type="console" required="true" />				<cfset var i = 0 />		<cfset var clearGameRel = "" />		<cfset var saveGameRel = "" />		<cfset var games = arguments.console.getGames() />		<!--- first clear existing relationships --->		<cfquery name="clearGameRel" datasource="#variables.dsn#">			DELETE FROM relconsolegames			WHERE		consoleID = <cfqueryparam value="#arguments.console.getconsoleID()#" CFSQLType="cf_sql_char" />		</cfquery>		<cfif arrayLen(games)>			<cfloop from="1" to="#arrayLen(games)#" index="i">				<cfquery name="saveGameRel" datasource="#variables.dsn#">					INSERT INTO relconsolegames(consoleid,gameid)					VALUES (<cfqueryparam value="#arguments.console.getconsoleID()#" CFSQLType="cf_sql_char" />,							<cfqueryparam value="#games[i].getGameID()#" CFSQLType="cf_sql_char" />							)				</cfquery>			</cfloop>		</cfif>	</cffunction>		<cffunction name="saveAccessories" access="private" output="false" returntype="void">		<cfargument name="console" type="console" required="true" />				<cfset var i = 0 />		<cfset var clearAccessoryRel = "" />		<cfset var saveAccessoryRel = "" />		<cfset var accessories = arguments.console.getAccessories() />		<!--- first clear existing relationships --->		<cfquery name="clearAccessoryRel" datasource="#variables.dsn#">			DELETE FROM relconsoleaccessories			WHERE		consoleID = <cfqueryparam value="#arguments.console.getconsoleID()#" CFSQLType="cf_sql_char" />		</cfquery>		<cfif arrayLen(accessories)>			<cfloop from="1" to="#arrayLen(accessories)#" index="i">				<cfquery name="saveAccessoryRel" datasource="#variables.dsn#">					INSERT INTO relconsoleaccessories(consoleid,accessoryid)					VALUES (<cfqueryparam value="#arguments.console.getconsoleID()#" CFSQLType="cf_sql_char" />,							<cfqueryparam value="#accessories[i].getAccessoryID()#" CFSQLType="cf_sql_char" />							)				</cfquery>			</cfloop>		</cfif>	</cffunction>	<cffunction name="queryRowToStruct" access="private" output="false" returntype="struct">		<cfargument name="qry" type="query" required="true">				<cfscript>			/**			 * Makes a row of a query into a structure.			 * 			 * @param query 	 The query to work with. 			 * @param row 	 Row number to check. Defaults to row 1. 			 * @return Returns a structure. 			 * @author Nathan Dintenfass (nathan@changemedia.com) 			 * @version 1, December 11, 2001 			 */			//by default, do this to the first row of the query			var row = 1;			//a var for looping			var ii = 1;			//the cols to loop over			var cols = listToArray(qry.columnList);			//the struct to return			var stReturn = structnew();			//if there is a second argument, use that for the row number			if(arrayLen(arguments) GT 1)				row = arguments[2];			//loop over the cols and build the struct from the query row			for(ii = 1; ii lte arraylen(cols); ii = ii + 1){				stReturn[cols[ii]] = qry[cols[ii]][row];			}					//return the struct			return stReturn;		</cfscript>	</cffunction></cfcomponent>
