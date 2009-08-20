<cfcomponent displayname="artistDAO">

	<cffunction name="init" access="public" output="false" returntype="com.withcs.artists.artistDAO">
		<cfargument name="dsn" type="string" required="true">
		<cfset variables.dsn = arguments.dsn>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="create" access="public" output="false" returntype="boolean">
		<cfargument name="artist" type="com.withcs.artists.artist" required="true" />

		<cfset var qCreate = "" />
		<cftry>
			<cfquery name="qCreate" datasource="#variables.dsn#">
				INSERT INTO ARTISTS
					(
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
					)
				VALUES
					(
					<cfqueryparam value="#arguments.artist.getARTISTID()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getARTISTID())#" />,
					<cfqueryparam value="#arguments.artist.getFIRSTNAME()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getFIRSTNAME())#" />,
					<cfqueryparam value="#arguments.artist.getLASTNAME()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getLASTNAME())#" />,
					<cfqueryparam value="#arguments.artist.getADDRESS()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getADDRESS())#" />,
					<cfqueryparam value="#arguments.artist.getCITY()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getCITY())#" />,
					<cfqueryparam value="#arguments.artist.getSTATE()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getSTATE())#" />,
					<cfqueryparam value="#arguments.artist.getPOSTALCODE()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getPOSTALCODE())#" />,
					<cfqueryparam value="#arguments.artist.getEMAIL()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getEMAIL())#" />,
					<cfqueryparam value="#arguments.artist.getPHONE()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getPHONE())#" />,
					<cfqueryparam value="#arguments.artist.getFAX()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getFAX())#" />,
					<cfqueryparam value="#arguments.artist.getTHEPASSWORD()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getTHEPASSWORD())#" />
					)
			</cfquery>
			<cfcatch type="database">
				<cfreturn false />
			</cfcatch>
		</cftry>
		<cfreturn true />
	</cffunction>

	<cffunction name="read" access="public" output="false" returntype="void">
		<cfargument name="artist" type="com.withcs.artists.artist" required="true" />

		<cfset var qRead = "" />
		<cfset var strReturn = structNew() />
		<cftry>
			<cfquery name="qRead" datasource="#variables.dsn#">
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
				WHERE	ARTISTID = <cfqueryparam value="#arguments.artist.getARTISTID()#" CFSQLType="cf_sql_varchar" />
			</cfquery>
			<cfcatch type="database">
				<cfrethrow />
				<!--- leave the bean as is and set an empty query for the conditional logic below --->
				<cfset qRead = queryNew("id") />
			</cfcatch>
		</cftry>
		<cfif qRead.recordCount>
			<cfset strReturn = queryRowToStruct(qRead)>
			<cfset arguments.artist.init(argumentCollection=strReturn)>
		</cfif>
	</cffunction>

	<cffunction name="update" access="public" output="false" returntype="boolean">
		<cfargument name="artist" type="com.withcs.artists.artist" required="true" />

		<cfset var qUpdate = "" />
		<cftry>
			<cfquery name="qUpdate" datasource="#variables.dsn#">
				UPDATE	ARTISTS
				SET
					ARTISTID = <cfqueryparam value="#arguments.artist.getARTISTID()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getARTISTID())#" />,
					FIRSTNAME = <cfqueryparam value="#arguments.artist.getFIRSTNAME()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getFIRSTNAME())#" />,
					LASTNAME = <cfqueryparam value="#arguments.artist.getLASTNAME()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getLASTNAME())#" />,
					ADDRESS = <cfqueryparam value="#arguments.artist.getADDRESS()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getADDRESS())#" />,
					CITY = <cfqueryparam value="#arguments.artist.getCITY()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getCITY())#" />,
					STATE = <cfqueryparam value="#arguments.artist.getSTATE()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getSTATE())#" />,
					POSTALCODE = <cfqueryparam value="#arguments.artist.getPOSTALCODE()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getPOSTALCODE())#" />,
					EMAIL = <cfqueryparam value="#arguments.artist.getEMAIL()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getEMAIL())#" />,
					PHONE = <cfqueryparam value="#arguments.artist.getPHONE()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getPHONE())#" />,
					FAX = <cfqueryparam value="#arguments.artist.getFAX()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getFAX())#" />,
					THEPASSWORD = <cfqueryparam value="#arguments.artist.getTHEPASSWORD()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.artist.getTHEPASSWORD())#" />
				WHERE	
			</cfquery>
			<cfcatch type="database">
				<cfreturn false />
			</cfcatch>
		</cftry>
		<cfreturn true />
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="boolean">
		<cfargument name="artist" type="com.withcs.artists.artist" required="true" />

		<cfset var qDelete = "">
		<cftry>
			<cfquery name="qDelete" datasource="#variables.dsn#">
				DELETE FROM	ARTISTS 
				WHERE	
			</cfquery>
			<cfcatch type="database">
				<cfreturn false />
			</cfcatch>
		</cftry>
		<cfreturn true />
	</cffunction>

	<cffunction name="exists" access="public" output="false" returntype="boolean">
		<cfargument name="artist" type="com.withcs.artists.artist" required="true" />

		<cfset var qExists = "">
		<cfquery name="qExists" datasource="#variables.dsn#" maxrows="1">
			SELECT count(1) as idexists
			FROM	ARTISTS
			WHERE	
		</cfquery>

		<cfif qExists.idexists>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="boolean">
		<cfargument name="artist" type="com.withcs.artists.artist" required="true" />
		
		<cfset var success = false />
		<cfif exists(arguments.artist)>
			<cfset success = update(arguments.artist) />
		<cfelse>
			<cfset success = create(arguments.artist) />
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
