<!--- Document Information -----------------------------------------------------

Title:      CacheConfigManager.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Manages caching configuration

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		15/05/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="CacheConfigManager" hint="Manages the caching configuration">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="CacheConfigManager" output="false">
	<cfargument name="javaLoader" hint="The Java loader for loading Java classes" type="transfer.com.util.JavaLoader" required="Yes">
	<cfargument name="configReader" hint="The XML Reader for the config file" type="transfer.com.io.XMLFileReader" required="Yes">

	<cfscript>
		//we don't need this after initial loading
		var cacheConfigDAO = createObject("component", "CacheConfigDAO").init(arguments.javaLoader, arguments.configReader);
		setScopeDao(createObject("component", "ScopeDAO").init(arguments.configReader));
		setScopePool(createObject("component", "transfer.com.collections.ObjectPool").init());
		setCacheConfig(cacheConfigDAO.getCacheConfig());

		return this;
	</cfscript>
</cffunction>

<cffunction name="getScope" hint="Retrieves the scope caching meta data" access="public" returntype="Scope" output="false">
	<cfargument name="type" hint="the scope to retrieve" type="string" required="Yes">
	<cfscript>
		var scope = 0;

		//get the defintion
		if(NOT getScopePool().has(arguments.type))
		{
			scope = getScopeDAO().getScope(createEmptyScope(), arguments.type);
			getScopePool().add(scope, arguments.type);
		}
		scope = getScopePool().get(arguments.type);

		return scope;
	</cfscript>
</cffunction>

<cffunction name="getCacheConfig" hint="returns Java com.compoundtheory.objectcache.CacheConfig for configuring the ObjectCache" access="public" returntype="any" output="false">
	<cfreturn instance.CacheConfig />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="createEmptyScope" hint="Creates an empty Scope object" access="public" returntype="transfer.com.cache.Scope" output="false">
	<cfreturn createObject("component", "transfer.com.cache.Scope").init()>
</cffunction>

<cffunction name="setCacheConfig" access="private" returntype="void" output="false">
	<cfargument name="CacheConfig" type="any" required="true">
	<cfset instance.CacheConfig = arguments.CacheConfig />
</cffunction>

<cffunction name="getScopeDao" access="private" returntype="ScopeDao" output="false">
	<cfreturn instance.ScopeDao />
</cffunction>

<cffunction name="setScopeDao" access="private" returntype="void" output="false">
	<cfargument name="ScopeDao" type="ScopeDao" required="true">
	<cfset instance.ScopeDao = arguments.ScopeDao />
</cffunction>

<cffunction name="getScopePool" access="private" returntype="transfer.com.collections.ObjectPool" output="false">
	<cfreturn instance.ObjectPool />
</cffunction>

<cffunction name="setScopePool" access="private" returntype="void" output="false">
	<cfargument name="ObjectPool" type="transfer.com.collections.ObjectPool" required="true">
	<cfset instance.ObjectPool = arguments.ObjectPool />
</cffunction>

</cfcomponent>