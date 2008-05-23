<!--- Document Information -----------------------------------------------------

Title:      QueryManager.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Manages generated SQL queries

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		04/08/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="QueryManager" hint="Manages generated SQL queries">
	
<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="QueryManager" output="false">
	<cfargument name="datasource" hint="The datasource BO" type="Datasource" required="Yes">	
	<cfargument name="objectManager" hint="The object manager to query" type="transfer.com.object.ObjectManager" required="Yes">
	<cfargument name="tqlConverter" hint="Converter for {property} statements" type="transfer.com.sql.TQLConverter" required="Yes">
	<cfscript>
		setDataSource(arguments.datasource);
		//go looking for the builder for the correct Database
		setQueryBuilder(createObject("component", "#arguments.datasource.getDatabaseType()#.QueryBuilder").init(arguments.objectManager, arguments.tqlConverter));
		setSQLPool(createObject("component", "collections.SQLPool").init());
		
		return this;
	</cfscript>	
</cffunction>

<cffunction name="getObjectQuery" hint="Creates and runs the query for the TransferObject" access="public" returntype="query" output="false">
	<cfargument name="object" hint="The Object BO" type="transfer.com.object.Object" required="Yes">
	<cfargument name="key" hint="The id key for the data" type="string" required="Yes">
		
	<cfscript>
		var sql = 0;
	</cfscript>
	
	<!--- double check lock --->
	<cfif NOT getSQLPool().hasSQL(arguments.object)>
		<cflock name="transfer.querymanager.getSelectQuery.#arguments.object.getClassName()#" timeout="60" throwontimeout="true">
			<cfscript>
				if(NOT getSQLPool().hasSQL(arguments.object))
				{
					sql = createObject("component", "transfer.com.sql.SelectQuery").init(getQueryBuilder().getObjectSQL(arguments.object));
					getSQLPool().addSQL(sql, arguments.object);
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfscript>
		sql = getSQLPool().getSQL(arguments.object);
		
		return runSelect(arguments.object, arguments.key, sql);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="runSelect" hint="Runs the SQL object" access="public" returntype="query" output="false">
	<cfargument name="object" hint="The Object BO" type="transfer.com.object.Object" required="Yes">
	<cfargument name="key" hint="The if key for the data" type="string" required="Yes">
	<cfargument name="selectQuery" hint="The cached select object" type="SelectQuery" required="Yes">
		
	<cfscript>
		var iterator = arguments.selectQuery.getSQLPartIterator();
		var len = arguments.selectQuery.getSQLPartLength();
		var qSelectTransfer = 0;

		var primaryKey = arguments.object.getPrimaryKey();
		var isNull = (Len(arguments.key) eq 0);		
		var counter = 0;
	</cfscript>
	
	<cfquery name="qSelectTransfer" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		<cfloop condition="#iterator.hasNext()#">
			<cfset counter = counter + 1>
			#iterator.next()#
			<!--- 
			the last part is always an order by 
			statement, so no putting value there
			 --->
			<cfif counter neq len>
			<cfswitch expression="#primaryKey.getType()#">
				<cfcase value="numeric">
					<cfqueryparam value="#arguments.key#" cfsqltype="cf_sql_float" null="#isNull#">
				</cfcase>
				<cfcase value="date">
					<cfqueryparam value="#arguments.key#" cfsqltype="cf_sql_timestamp" null="#isNull#">
				</cfcase>
				<cfcase value="boolean">
					<cfqueryparam value="#arguments.key#" cfsqltype="cf_sql_bit" null="#isNull#">
				</cfcase>
				<cfdefaultcase>
					<cfqueryparam value="#arguments.key#" cfsqltype="cf_sql_varchar" null="#isNull#">
				</cfdefaultcase>
			</cfswitch>		
			</cfif>	
		</cfloop>
	</cfquery>
	
	<cfreturn qSelectTransfer>
</cffunction>

<cffunction name="getDatasource" access="private" returntype="Datasource" output="false">
	<cfreturn instance.Datasource />
</cffunction>

<cffunction name="setDatasource" access="private" returntype="void" output="false">
	<cfargument name="Datasource" type="Datasource" required="true">
	<cfset instance.Datasource = arguments.Datasource />
</cffunction>

<cffunction name="getQueryBuilder" access="private" returntype="QueryBuilder" output="false">
	<cfreturn instance.QueryBuilder />
</cffunction>

<cffunction name="setQueryBuilder" access="private" returntype="void" output="false">
	<cfargument name="QueryBuilder" type="QueryBuilder" required="true">
	<cfset instance.QueryBuilder = arguments.QueryBuilder />
</cffunction>

<cffunction name="getSQLPool" access="private" returntype="transfer.com.sql.collections.SQLPool" output="false">
	<cfreturn instance.SQLPool />
</cffunction>

<cffunction name="setSQLPool" access="private" returntype="void" output="false">
	<cfargument name="SQLPool" type="transfer.com.sql.collections.SQLPool" required="true">
	<cfset instance.SQLPool = arguments.SQLPool />
</cffunction>

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>

</cfcomponent>