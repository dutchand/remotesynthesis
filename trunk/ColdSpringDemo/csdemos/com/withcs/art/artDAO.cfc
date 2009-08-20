<cfcomponent displayname="artDAO">

	<cffunction name="init" access="public" output="false" returntype="com.withcs.art.artDAO">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="artistDAO" type="com.withcs.artists.artistDAO" required="true" />
		
		<cfset variables.dsn = arguments.dsn />
		<cfset variables.artistDAO = arguments.artistDAO />
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="create" access="public" output="false" returntype="boolean">
		<cfargument name="art" type="com.withcs.art.art" required="true" />

		<cfset var qCreate = "" />
		<cftry>
			<cfquery name="qCreate" datasource="#variables.dsn#">
				INSERT INTO ART
					(
					ARTID,
					ARTISTID,
					ARTNAME,
					DESCRIPTION,
					PRICE,
					LARGEIMAGE,
					MEDIAID,
					ISSOLD
					)
				VALUES
					(
					<cfqueryparam value="#arguments.art.getARTID()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.art.getARTID())#" />,
					<cfqueryparam value="#arguments.art.getARTIST().getARTISTID()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.art.getARTISTID().getARTISTID())#" />,
					<cfqueryparam value="#arguments.art.getARTNAME()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.art.getARTNAME())#" />,
					<cfqueryparam value="#arguments.art.getDESCRIPTION()#" CFSQLType="cf_sql_clob" null="#not len(arguments.art.getDESCRIPTION())#" />,
					<cfqueryparam value="#arguments.art.getPRICE()#" CFSQLType="cf_sql_decimal" null="#not len(arguments.art.getPRICE())#" />,
					<cfqueryparam value="#arguments.art.getLARGEIMAGE()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.art.getLARGEIMAGE())#" />,
					<cfqueryparam value="#arguments.art.getMEDIAID()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.art.getMEDIAID())#" />,
					<cfqueryparam value="#arguments.art.getISSOLD()#" CFSQLType="cf_sql_smallint" null="#not len(arguments.art.getISSOLD())#" />
					)
			</cfquery>
			<cfcatch type="database">
				<cfreturn false />
			</cfcatch>
		</cftry>
		<cfreturn true />
	</cffunction>

	<cffunction name="read" access="public" output="false" returntype="void">
		<cfargument name="art" type="com.withcs.art.art" required="true" />

		<cfset var qRead = "" />
		<cfset var strReturn = structNew() />
		<cftry>
			<cfquery name="qRead" datasource="#variables.dsn#">
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
				WHERE	ARTID = <cfqueryparam value="#arguments.art.getARTID()#" CFSQLType="cf_sql_varchar" />
			</cfquery>
			<cfcatch type="database">
			<cfrethrow />
				<!--- leave the bean as is and set an empty query for the conditional logic below --->
				<cfset qRead = queryNew("id") />
			</cfcatch>
		</cftry>
		<cfif qRead.recordCount>
			<cfset strReturn = queryRowToStruct(qRead) />
			<cfset arguments.art.init(argumentCollection=strReturn) />
			<cfif len(qRead.artistID)>
				<cfset artist = createObject("component","com.withcs.artists.artist").init(artistID=qRead.artistID) />
				<cfset artistDAO.read(artist) />
				<cfset art.setArtist(artist) />
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="update" access="public" output="false" returntype="boolean">
		<cfargument name="art" type="com.withcs.art.art" required="true" />

		<cfset var qUpdate = "" />
		<cftry>
			<cfquery name="qUpdate" datasource="#variables.dsn#">
				UPDATE	ART
				SET
					ARTID = <cfqueryparam value="#arguments.art.getARTID()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.art.getARTID())#" />,
					ARTISTID = <cfqueryparam value="#arguments.art.getARTISTID()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.art.getARTISTID())#" />,
					ARTNAME = <cfqueryparam value="#arguments.art.getARTNAME()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.art.getARTNAME())#" />,
					DESCRIPTION = <cfqueryparam value="#arguments.art.getDESCRIPTION()#" CFSQLType="cf_sql_clob" null="#not len(arguments.art.getDESCRIPTION())#" />,
					PRICE = <cfqueryparam value="#arguments.art.getPRICE()#" CFSQLType="cf_sql_decimal" null="#not len(arguments.art.getPRICE())#" />,
					LARGEIMAGE = <cfqueryparam value="#arguments.art.getLARGEIMAGE()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.art.getLARGEIMAGE())#" />,
					MEDIAID = <cfqueryparam value="#arguments.art.getMEDIAID()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.art.getMEDIAID())#" />,
					ISSOLD = <cfqueryparam value="#arguments.art.getISSOLD()#" CFSQLType="cf_sql_smallint" null="#not len(arguments.art.getISSOLD())#" />
				WHERE	
			</cfquery>
			<cfcatch type="database">
				<cfreturn false />
			</cfcatch>
		</cftry>
		<cfreturn true />
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="boolean">
		<cfargument name="art" type="com.withcs.art.art" required="true" />

		<cfset var qDelete = "">
		<cftry>
			<cfquery name="qDelete" datasource="#variables.dsn#">
				DELETE FROM	ART 
				WHERE	
			</cfquery>
			<cfcatch type="database">
				<cfreturn false />
			</cfcatch>
		</cftry>
		<cfreturn true />
	</cffunction>

	<cffunction name="exists" access="public" output="false" returntype="boolean">
		<cfargument name="art" type="com.withcs.art.art" required="true" />

		<cfset var qExists = "">
		<cfquery name="qExists" datasource="#variables.dsn#" maxrows="1">
			SELECT count(1) as idexists
			FROM	ART
			WHERE	
		</cfquery>

		<cfif qExists.idexists>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="boolean">
		<cfargument name="art" type="com.withcs.art.art" required="true" />
		
		<cfset var success = false />
		<cfif exists(arguments.art)>
			<cfset success = update(arguments.art) />
		<cfelse>
			<cfset success = create(arguments.art) />
		</cfif>
		
		<cfreturn success />
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
