<cfcomponent displayname="controlGateway" output="false">	<cffunction name="init" access="public" output="false" returntype="csFlex.com.xbox.controls.controlGateway">		<cfargument name="dsn" type="string" required="true" />		<cfset variables.dsn = arguments.dsn />		<cfreturn this />	</cffunction>		<cffunction name="getByAttributesQuery" access="public" output="false" returntype="query">		<cfargument name="controlID" type="uuid" required="false" />		<cfargument name="consoleID" type="uuid" required="false" />		<cfargument name="wireless" type="Boolean" required="false" />		<cfargument name="headset" type="Boolean" required="false" />		<cfargument name="orderby" type="string" required="false" />				<cfset var qList = "" />				<cfquery name="qList" datasource="#variables.dsn#">			SELECT				c.controlID,				c.wireless,				c.headset			FROM	control c				INNER JOIN relconsolecontrols cc on c.controlID = cc.controlID			WHERE	0=0				<cfif structKeyExists(arguments,"controlID") and len(arguments.controlID)>			AND	controlID = <cfqueryparam value="#arguments.controlID#" CFSQLType="cf_sql_char" />		</cfif>		<cfif structKeyExists(arguments,"wireless") and len(arguments.wireless)>			AND	wireless = <cfqueryparam value="#arguments.wireless#" CFSQLType="cf_sql_tinyint" />		</cfif>		<cfif structKeyExists(arguments,"headset") and len(arguments.headset)>			AND	headset = <cfqueryparam value="#arguments.headset#" CFSQLType="cf_sql_tinyint" />		</cfif>		<cfif structKeyExists(arguments,"consoleID") and len(arguments.consoleID)>			AND	cc.consoleID = <cfqueryparam value="#arguments.consoleID#" CFSQLType="cf_sql_char" />		</cfif>		<cfif structKeyExists(arguments, "orderby") and len(arguments.orderBy)>			ORDER BY #arguments.orderby#		</cfif>		</cfquery>				<cfreturn qList />	</cffunction>	<cffunction name="getByAttributes" access="public" output="false" returntype="array">		<cfargument name="controlID" type="uuid" required="false" />		<cfargument name="consoleID" type="uuid" required="false" />		<cfargument name="wireless" type="Boolean" required="false" />		<cfargument name="headset" type="Boolean" required="false" />		<cfargument name="orderby" type="string" required="false" />				<cfset var qList = getByAttributesQuery(argumentCollection=arguments) />				<cfset var arrObjects = arrayNew(1) />		<cfset var tmpObj = "" />		<cfset var i = 0 />		<cfloop from="1" to="#qList.recordCount#" index="i">			<cfset tmpObj = createObject("component","csFlex.com.xbox.controls.control").init(argumentCollection=queryRowToStruct(qList,i)) />			<cfset arrayAppend(arrObjects,tmpObj) />		</cfloop>				<cfreturn arrObjects />	</cffunction>		<cffunction name="queryRowToStruct" access="private" output="false" returntype="struct">		<cfargument name="qry" type="query" required="true">				<cfscript>			/**			 * Makes a row of a query into a structure.			 * 			 * @param query 	 The query to work with. 			 * @param row 	 Row number to check. Defaults to row 1. 			 * @return Returns a structure. 			 * @author Nathan Dintenfass (nathan@changemedia.com) 			 * @version 1, December 11, 2001 			 */			//by default, do this to the first row of the query			var row = 1;			//a var for looping			var ii = 1;			//the cols to loop over			var cols = listToArray(qry.columnList);			//the struct to return			var stReturn = structnew();			//if there is a second argument, use that for the row number			if(arrayLen(arguments) GT 1)				row = arguments[2];			//loop over the cols and build the struct from the query row			for(ii = 1; ii lte arraylen(cols); ii = ii + 1){				stReturn[cols[ii]] = qry[cols[ii]][row];			}					//return the struct			return stReturn;		</cfscript>	</cffunction></cfcomponent>
