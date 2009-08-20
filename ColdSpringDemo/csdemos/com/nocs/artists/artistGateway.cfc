
<cfcomponent displayname="artistGateway" output="false">
	<cffunction name="init" access="public" output="false" returntype="com.nocs.artists.artistGateway">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getByAttributesQuery" access="public" output="false" returntype="query">
		<cfargument name="ARTISTID" type="string" required="false" />
		<cfargument name="FIRSTNAME" type="string" required="false" />
		<cfargument name="LASTNAME" type="string" required="false" />
		<cfargument name="ADDRESS" type="string" required="false" />
		<cfargument name="CITY" type="string" required="false" />
		<cfargument name="STATE" type="string" required="false" />
		<cfargument name="POSTALCODE" type="string" required="false" />
		<cfargument name="EMAIL" type="string" required="false" />
		<cfargument name="PHONE" type="string" required="false" />
		<cfargument name="FAX" type="string" required="false" />
		<cfargument name="THEPASSWORD" type="string" required="false" />
		<cfargument name="orderby" type="string" required="false" />
		
		<cfset var qList = "" />		
		<cfquery name="qList" datasource="#variables.dsn#">
			SELECT
				ARTISTID,
				FIRSTNAME,
				LASTNAME,
				ADDRESS,
				CITY,
				STATE,
				POSTALCODE,
				EMAIL,
				PHONE,
				FAX,
				THEPASSWORD
			FROM	ARTISTS
			WHERE	0=0
		
		<cfif structKeyExists(arguments,"ARTISTID") and len(arguments.ARTISTID)>
			AND	ARTISTID = <cfqueryparam value="#arguments.ARTISTID#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"FIRSTNAME") and len(arguments.FIRSTNAME)>
			AND	FIRSTNAME = <cfqueryparam value="#arguments.FIRSTNAME#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"LASTNAME") and len(arguments.LASTNAME)>
			AND	LASTNAME = <cfqueryparam value="#arguments.LASTNAME#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"ADDRESS") and len(arguments.ADDRESS)>
			AND	ADDRESS = <cfqueryparam value="#arguments.ADDRESS#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"CITY") and len(arguments.CITY)>
			AND	CITY = <cfqueryparam value="#arguments.CITY#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"STATE") and len(arguments.STATE)>
			AND	STATE = <cfqueryparam value="#arguments.STATE#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"POSTALCODE") and len(arguments.POSTALCODE)>
			AND	POSTALCODE = <cfqueryparam value="#arguments.POSTALCODE#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"EMAIL") and len(arguments.EMAIL)>
			AND	EMAIL = <cfqueryparam value="#arguments.EMAIL#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"PHONE") and len(arguments.PHONE)>
			AND	PHONE = <cfqueryparam value="#arguments.PHONE#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"FAX") and len(arguments.FAX)>
			AND	FAX = <cfqueryparam value="#arguments.FAX#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"THEPASSWORD") and len(arguments.THEPASSWORD)>
			AND	THEPASSWORD = <cfqueryparam value="#arguments.THEPASSWORD#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments, "orderby") and len(arguments.orderBy)>
			ORDER BY #arguments.orderby#
		</cfif>
		</cfquery>
		
		<cfreturn qList />
	</cffunction>

	<cffunction name="getByAttributes" access="public" output="false" returntype="array">
		<cfargument name="ARTISTID" type="string" required="false" />
		<cfargument name="FIRSTNAME" type="string" required="false" />
		<cfargument name="LASTNAME" type="string" required="false" />
		<cfargument name="ADDRESS" type="string" required="false" />
		<cfargument name="CITY" type="string" required="false" />
		<cfargument name="STATE" type="string" required="false" />
		<cfargument name="POSTALCODE" type="string" required="false" />
		<cfargument name="EMAIL" type="string" required="false" />
		<cfargument name="PHONE" type="string" required="false" />
		<cfargument name="FAX" type="string" required="false" />
		<cfargument name="THEPASSWORD" type="string" required="false" />
		<cfargument name="orderby" type="string" required="false" />
		
		<cfset var qList = getByAttributesQuery(argumentCollection=arguments) />		
		<cfset var arrObjects = arrayNew(1) />
		<cfset var tmpObj = "" />
		<cfset var i = 0 />
		<cfloop from="1" to="#qList.recordCount#" index="i">
			<cfset tmpObj = createObject("component","com.nocs.artists.artist").init(argumentCollection=queryRowToStruct(qList,i)) />
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
