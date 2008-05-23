<!--- Document Information -----------------------------------------------------

Title:      AbstractBaseFacade.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    The abstract base for all facades

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		16/05/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="AbstractBaseFacade" hint="The abstract base to all the scope facades">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="AbstractBaseFacade" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="configure" hint="configuration, due to di loops" access="public" returntype="void" output="false">
	<cfargument name="key" hint="The key to store values under" type="string" required="Yes">
	<cfscript>
		setKey(arguments.key);
	</cfscript>
</cffunction>

<!--- CacheManager --->

<cffunction name="getCacheManager" access="public" returntype="any" hint="return com.compoundtheory.objectcache.CacheManager" output="false">
	<cfreturn getScopePlace().CacheManager />
</cffunction>

<cffunction name="setCacheManager" access="public" returntype="void" output="false">
	<cfargument name="CacheManager" type="any" required="true">
	<cfscript>
		getScopePlace().CacheManager = arguments.CacheManager;
	</cfscript>
</cffunction>

<cffunction name="hasCacheManager" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
		<cfreturn scopePlaceKeyExists("CacheManager")>
</cffunction>

<!--- AfterCreateObserverCollection --->

<cffunction name="getAfterCreateObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfreturn getScopePlace().AfterCreateObserverCollection />
</cffunction>

<cffunction name="setAfterCreateObserverCollection" access="public" returntype="void" output="false">
	<cfargument name="AfterCreateObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().AfterCreateObserverCollection = arguments.AfterCreateObserverCollection />
</cffunction>

<cffunction name="hasAfterCreateObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("AfterCreateObserverCollection")>
</cffunction>

<!--- AfterDeleteObserverCollection --->

<cffunction name="getAfterDeleteObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfreturn getScopePlace().AfterDeleteObserverCollection />
</cffunction>

<cffunction name="setAfterDeleteObserverCollection" access="public" returntype="void" output="false">
	<cfargument name="AfterDeleteObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().AfterDeleteObserverCollection = arguments.AfterDeleteObserverCollection />
</cffunction>

<cffunction name="hasAfterDeleteObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("AfterDeleteObserverCollection")>
</cffunction>

 <!---AfterUpdateObserverCollection --->

<cffunction name="getAfterUpdateObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfreturn getScopePlace().AfterUpdateObserverCollection />
</cffunction>

<cffunction name="setAfterUpdateObserverCollection" access="public" returntype="void" output="false">
	<cfargument name="AfterUpdateObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().AfterUpdateObserverCollection = arguments.AfterUpdateObserverCollection />
</cffunction>

<cffunction name="hasAfterUpdateObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("AfterUpdateObserverCollection")>
</cffunction>

 <!--- BeforeCreateObserverCollection --->

<cffunction name="getBeforeCreateObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfreturn getScopePlace().BeforeCreateObserverCollection />
</cffunction>

<cffunction name="setBeforeCreateObserverCollection" access="public" returntype="void" output="false">
	<cfargument name="BeforeCreateObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().BeforeCreateObserverCollection = arguments.BeforeCreateObserverCollection />
</cffunction>

<cffunction name="hasBeforeCreateObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("BeforeCreateObserverCollection")>
</cffunction>

<!--- BeforeUpdateObserverCollection --->

<cffunction name="getBeforeUpdateObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfreturn getScopePlace().BeforeUpdateObserverCollection />
</cffunction>

<cffunction name="setBeforeUpdateObserverCollection" access="public" returntype="void" output="false">
	<cfargument name="BeforeUpdateObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().BeforeUpdateObserverCollection = arguments.BeforeUpdateObserverCollection />
</cffunction>

<cffunction name="hasBeforeUpdateObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("BeforeUpdateObserverCollection")>
</cffunction>

<!--- BeforeDeleteObserverCollection --->

<cffunction name="getBeforeDeleteObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfreturn getScopePlace().BeforeDeleteObserverCollection />
</cffunction>

<cffunction name="setBeforeDeleteObserverCollection" access="public" returntype="void" output="false">
	<cfargument name="BeforeDeleteObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().BeforeDeleteObserverCollection = arguments.BeforeDeleteObserverCollection />
</cffunction>

<cffunction name="hasBeforeDeleteObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("BeforeDeleteObserverCollection")>
</cffunction>

<!--- BeforeDiscardObserverCollection --->

<cffunction name="getBeforeDiscardObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfreturn getScopePlace().BeforeDiscardObserverCollection />
</cffunction>

<cffunction name="setBeforeDiscardObserverCollection" access="public" returntype="void" output="false">
	<cfargument name="BeforeDiscardObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().BeforeDiscardObserverCollection = arguments.BeforeDiscardObserverCollection />
</cffunction>

<cffunction name="hasBeforeDiscardObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("BeforeDiscardObserverCollection")>
</cffunction>

<!--- AfterNewObserverCollection --->

<cffunction name="getAfterNewObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfreturn getScopePlace().AfterNewObserverCollection />
</cffunction>

<cffunction name="setAfterNewObserverCollection" access="public" returntype="void" output="false">
	<cfargument name="AfterNewObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().AfterNewObserverCollection = arguments.AfterNewObserverCollection />
</cffunction>

<cffunction name="hasAfterNewObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("AfterNewObserverCollection")>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="scopePlaceKeyExists" hint="Returns true if the scope place key exists" access="private" returntype="boolean" output="false">
	<cfargument name="key" hint="the key to look for" type="string" required="Yes">
	<cfscript>
		if(NOT hasScopePlace())
		{
			return false;
		}

		return StructKeyExists(getScopePlace(), key);
	</cfscript>
</cffunction>

<cffunction name="hasScopePlace" hint="checks to see if the scope has been accessed at all" access="private" returntype="boolean" output="false">
	<cfscript>
		var scope = 0;

		return structKeyExists(getScope(), getKey());
	</cfscript>
</cffunction>

<cffunction name="getScopePlace" hint="Returns the place in which the Transfer parts are stored" access="private" returntype="struct" output="false">
	<cfscript>
		var scope = getScope();
	</cfscript>

	<cfif NOT hasScopePlace()>
		<cflock name="transfer.ScopeFacade.#getIdentityHashCode(getScope())#" timeout="60">
			<cfscript>
				if(NOT hasScopePlace())
				{
					scope[getKey()] = StructNew();
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfreturn scope[getKey()]>
</cffunction>

<cffunction name="getKey" access="private" returntype="string" output="false">
	<cfreturn instance.Key />
</cffunction>

<cffunction name="setKey" access="private" returntype="void" output="false">
	<cfargument name="Key" type="string" required="true">
	<cfset instance.Key = arguments.Key />
</cffunction>

<cffunction name="getScope" hint="Overwrite to return the scope this facade refers to" access="private" returntype="struct" output="false">
	<cfset throw("VirtualMethodException", "This method must be overwritten to be used", "This method is virtual and should be overwritten")>
</cffunction>

<cffunction name="getIdentityHashCode" hint="Gets the object hash code" access="private" returntype="string" output="false">
	<cfargument name="object" hint="The Object the query is associated with" type="any" required="Yes">
	<cfscript>
		var system = createObject("java", "java.lang.System");
		return system.identityHashCode(arguments.object);
	</cfscript>
</cffunction>

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>


</cfcomponent>