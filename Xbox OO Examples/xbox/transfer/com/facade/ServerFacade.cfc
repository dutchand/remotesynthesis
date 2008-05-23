<!--- Document Information -----------------------------------------------------

Title:      ServerFacade.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Facade to the Server Scope

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		16/05/2006		Created

------------------------------------------------------------------------------->

<cfcomponent name="ServerFacade" hint="Facade to the Server Scope" extends="AbstractBaseFacade">

<cfscript>
	instance.static.uuid = "AC603836-094D-3CAD-9BC441EF13B60E25";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="AbstractBaseFacade" output="false">
	<cfargument name="version" hint="the version of Transfer" type="string" required="Yes">
	<cfscript>
		setJavaLoaderKey(instance.static.uuid & "." & arguments.version);
		
		return this;
	</cfscript>
</cffunction>

<cffunction name="getJavaLoader" access="public" returntype="transfer.com.util.javaLoader.JavaLoader" output="false">
	<cfreturn StructFind(getScope(), getJavaLoaderKey()) />
</cffunction>

<cffunction name="setJavaLoader" access="public" returntype="void" output="false">
	<cfargument name="javaLoader" type="transfer.com.util.javaLoader.JavaLoader" required="true">
	<cfset StructInsert(getScope(), getJavaLoaderKey(), arguments.javaLoader) />
</cffunction>

<cffunction name="hasJavaLoader" hint="if the server scope has the JavaLoader in it" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(getScope(), getJavaLoaderkey())/>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getScope" hint="returns the Server scope" access="private" returntype="struct" output="false">
	<cfreturn server>
</cffunction>

<cffunction name="getJavaLoaderKey" access="private" returntype="string" output="false">
	<cfreturn instance.JavaLoaderKey />
</cffunction>

<cffunction name="setJavaLoaderKey" access="private" returntype="void" output="false">
	<cfargument name="JavaLoaderKey" type="string" required="true">
	<cfset instance.JavaLoaderKey = arguments.JavaLoaderKey />
</cffunction>

</cfcomponent>