<!--- Document Information -----------------------------------------------------

Title:      SQLPool.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Caches SQl strings for reuse later

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/08/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="SQLPool" hint="Caches SQL strings for reused later">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="SQLPool" output="false">
	<cfscript>
		setCache(StructNew());
		
		return this;
	</cfscript>
</cffunction>

<cffunction name="hasSQL" hint="Whether the SQL is in the cache" access="public" returntype="boolean" output="false">
	<cfargument name="object" hint="The Object the query is associated with" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		//return StructKeyExists(getCache(), arguments.object.getClassName());
		return StructKeyExists(getCache(), getIdentityHashCode(arguments.object));
	</cfscript>
</cffunction>

<cffunction name="addSQL" hint="Adds a SQL statement to the cache" access="public" returntype="void" output="false">
	<cfargument name="sql" hint="The SQL statement to cache" type="transfer.com.sql.SelectQuery" required="Yes">
	<cfargument name="object" hint="The Object the query is associated with" type="transfer.com.object.Object" required="Yes">
		
	<cfscript>
		StructInsert(getCache(), getIdentityHashCode(arguments.object), sql);
	</cfscript>
</cffunction>

<cffunction name="getSQL" hint="retrieve SQL for a given object" access="public" returntype="transfer.com.sql.SelectQuery" output="false">
	<cfargument name="object" hint="The Object the query is associated with" type="transfer.com.object.Object" required="Yes">
	<cfreturn StructFind(getCache(), getIdentityHashCode(arguments.object))>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getIdentityHashCode" hint="Gets the object hash code" access="private" returntype="string" output="false">
	<cfargument name="object" hint="The Object the query is associated with" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		var system = createObject("java", "java.lang.System");
		return system.identityHashCode(arguments.object);
	</cfscript>
</cffunction>

<cffunction name="getCache" access="private" returntype="struct" output="false">
	<cfreturn instance.Cache />
</cffunction>

<cffunction name="setCache" access="private" returntype="void" output="false">
	<cfargument name="Cache" type="struct" required="true">
	<cfset instance.Cache = arguments.Cache />
</cffunction>

</cfcomponent>