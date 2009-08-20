
<cfcomponent displayname="artGateway" output="false">
	<cffunction name="init" access="public" output="false" returntype="com.nocs.art.artGateway">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getByAttributesQuery" access="public" output="false" returntype="query">
		<cfargument name="ARTID" type="string" required="false" />
		<cfargument name="ARTISTID" type="string" required="false" />
		<cfargument name="ARTNAME" type="string" required="false" />
		<cfargument name="DESCRIPTION" type="string" required="false" />
		<cfargument name="PRICE" type="numeric" required="false" />
		<cfargument name="LARGEIMAGE" type="string" required="false" />
		<cfargument name="MEDIAID" type="string" required="false" />
		<cfargument name="ISSOLD" type="numeric" required="false" />
		<cfargument name="orderby" type="string" required="false" />
		
		<cfset var qList = "" />		
		<cfquery name="qList" datasource="#variables.dsn#">
			SELECT
				ARTID,
				ARTISTID,
				ARTNAME,
				DESCRIPTION,
				PRICE,
				LARGEIMAGE,
				MEDIAID,
				ISSOLD
			FROM	ART
			WHERE	0=0
		
		<cfif structKeyExists(arguments,"ARTID") and len(arguments.ARTID)>
			AND	ARTID = <cfqueryparam value="#arguments.ARTID#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"ARTISTID") and len(arguments.ARTISTID)>
			AND	ARTISTID = <cfqueryparam value="#arguments.ARTISTID#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"ARTNAME") and len(arguments.ARTNAME)>
			AND	ARTNAME = <cfqueryparam value="#arguments.ARTNAME#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"DESCRIPTION") and len(arguments.DESCRIPTION)>
			AND	DESCRIPTION = <cfqueryparam value="#arguments.DESCRIPTION#" CFSQLType="cf_sql_clob" />
		</cfif>
		<cfif structKeyExists(arguments,"PRICE") and len(arguments.PRICE)>
			AND	PRICE = <cfqueryparam value="#arguments.PRICE#" CFSQLType="cf_sql_decimal" />
		</cfif>
		<cfif structKeyExists(arguments,"LARGEIMAGE") and len(arguments.LARGEIMAGE)>
			AND	LARGEIMAGE = <cfqueryparam value="#arguments.LARGEIMAGE#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"MEDIAID") and len(arguments.MEDIAID)>
			AND	MEDIAID = <cfqueryparam value="#arguments.MEDIAID#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"ISSOLD") and len(arguments.ISSOLD)>
			AND	ISSOLD = <cfqueryparam value="#arguments.ISSOLD#" CFSQLType="cf_sql_smallint" />
		</cfif>
		<cfif structKeyExists(arguments, "orderby") and len(arguments.orderBy)>
			ORDER BY #arguments.orderby#
		</cfif>
		</cfquery>
		
		<cfreturn qList />
	</cffunction>

	<cffunction name="getByAttributes" access="public" output="false" returntype="array">
		<cfargument name="ARTID" type="string" required="false" />
		<cfargument name="ARTISTID" type="string" required="false" />
		<cfargument name="ARTNAME" type="string" required="false" />
		<cfargument name="DESCRIPTION" type="string" required="false" />
		<cfargument name="PRICE" type="numeric" required="false" />
		<cfargument name="LARGEIMAGE" type="string" required="false" />
		<cfargument name="MEDIAID" type="string" required="false" />
		<cfargument name="ISSOLD" type="numeric" required="false" />
		<cfargument name="orderby" type="string" required="false" />
		
		<cfset var qList = getByAttributesQuery(argumentCollection=arguments) />		
		<cfset var arrObjects = arrayNew(1) />
		<cfset var tmpObj = "" />
		<cfset var i = 0 />
		<cfloop from="1" to="#qList.recordCount#" index="i">
			<cfset tmpObj = createObject("component","com.nocs.art.art").init(argumentCollection=queryRowToStruct(qList,i)) />
			<cfset arrayAppend(arrObjects,tmpObj) />
		</cfloop>
				
		<cfreturn arrObjects />
	</cffunction>

	<cffunction name="queryRowToStruct" access="private" output="false" returntype="struct">
		<cfargument name="qry" type="query" required="true">
		
		<cfscript>
			/**
			 * Makes a row of a query into a structure.
			 * 
			 * @param query 	 The query to work with. 
			 * @param row 	 Row number to check. Defaults to row 1. 
			 * @return Returns a structure. 
			 * @author Nathan Dintenfass (nathan@changemedia.com) 
			 * @version 1, December 11, 2001 
			 */
			//by default, do this to the first row of the query
			var row = 1;
			//a var for looping
			var ii = 1;
			//the cols to loop over
			var cols = listToArray(qry.columnList);
			//the struct to return
			var stReturn = structnew();
			//if there is a second argument, use that for the row number
			if(arrayLen(arguments) GT 1)
				row = arguments[2];
			//loop over the cols and build the struct from the query row
			for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
				stReturn[cols[ii]] = qry[cols[ii]][row];
			}		
			//return the struct
			return stReturn;
		</cfscript>
	</cffunction>

</cfcomponent>
