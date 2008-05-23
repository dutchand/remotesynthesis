<!--- Document Information -----------------------------------------------------

Title:      SelectQuery.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Encapsulates all the parts of a select query

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		22/05/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="SelectQuery" hint="Encapsulates all the parts of a select query">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="SelectQuery" output="false">
	<cfargument name="sql" hint="The sql statement with ? for id values" type="string" required="Yes">	
	<cfscript>
		setSQLParts(ListToArray(arguments.sql, "?"));
		
		return this;
	</cfscript>
</cffunction>

<cffunction name="getSQLPartIterator" hint="Return a java.util.Iterator for each of the SQL parts between the id values" access="public" returntype="any" output="false">
	<cfreturn getSQLParts().iterator()>
</cffunction>

<cffunction name="getSQLPartLength" hint="How many parts does it have?" access="public" returntype="numeric" output="false">
	<cfreturn ArrayLen(getSQLParts())>	
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getSQLParts" access="private" returntype="array" output="false">
	<cfreturn instance.SQLParts />
</cffunction>

<cffunction name="setSQLParts" access="private" returntype="void" output="false">
	<cfargument name="SQLParts" type="array" required="true">
	<cfset instance.SQLParts = arguments.SQLParts />
</cffunction>

</cfcomponent>