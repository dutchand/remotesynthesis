<!--- Document Information -----------------------------------------------------

Title:      ObjectPool.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Object Pool

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		14/03/2005		Created

------------------------------------------------------------------------------->

<cfcomponent name="ObjectPool" displayname="Object Pool" hint="A Object pool">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ObjectPool" output="false">
	<cfscript>
		instance.pool = StructNew();
		
		return this;
	</cfscript>
</cffunction>

<cffunction name="add" hint="adds a Object" access="public" returntype="void" output="false">
	<cfargument name="Object" hint="The Object to add" type="web-inf.cftags.component" required="Yes">
	<cfargument name="key" hint="Unique key to store the Object under" type="string" required="Yes">
		
	<cfscript>
		StructInsert(instance.pool, arguments.key, arguments.Object);
	</cfscript>
</cffunction>

<cffunction name="has" hint="Checks to see if a Object is resident in the system" access="public" returntype="boolean" output="false">
	<cfargument name="key" hint="The unique key of the Object" type="string" required="Yes">
	
	<cfreturn StructKeyExists(instance.pool, arguments.key)>
</cffunction>

<cffunction name="get" hint="Retrives a Object from the pool" access="public" returntype="web-inf.cftags.component" output="false">
	<cfargument name="key" hint="The uniuqe key the Object is under" type="string" required="Yes">
	<cfreturn instance.pool[arguments.key]>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>