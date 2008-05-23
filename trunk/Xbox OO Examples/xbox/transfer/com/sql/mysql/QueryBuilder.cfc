<!--- Document Information -----------------------------------------------------

Title:      QueryBuilder.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Builds a query out of BO Data, for MYSQL

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		25/05/2006		Created

------------------------------------------------------------------------------->

<cfcomponent name="QueryBuilder" hint="Builds a Query out of BO data, for MYSQL" extends="transfer.com.sql.QueryBuilder">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="QueryBuilder" output="false">
	<cfargument name="objectManager" hint="The object manager to query" type="transfer.com.object.ObjectManager" required="Yes">
	<cfargument name="tqlConverter" hint="Converter for {property} statements" type="transfer.com.sql.TQLConverter" required="Yes">
	<cfscript>
		super.init(arguments.objectManager, arguments.tqlConverter);

		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="cast" hint="Cast the value of this to another value" access="public" returntype="string" output="false">
	<cfargument name="column" hint="The column to write the 'NULL' for" type="string" required="Yes">
	<cfargument name="type" hint="Type to cast it to" type="string" required="Yes">
	<cfscript>
		var sql = "CONVERT(" & arguments.column & ", ";
		
		switch(arguments.type)
		{
			case "varchar":
				sql = sql & "char";
			break;
		}
		
		sql = sql & ")";
		
		return sql;
	</cfscript>
</cffunction>

</cfcomponent>