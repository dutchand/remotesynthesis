<!--- Document Information -----------------------------------------------------

Title:      FacadeFactory.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Factory for getting Scope Facades

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		16/05/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="FacadeFactory" hint="The Factory for getting facades">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="FacadeFactory" output="false">
	<cfargument name="version" hint="the version of Transfer" type="string" required="Yes">
	<cfscript>
		setApplicationFacade(createObject("component", "ApplicationFacade").init());
		setInstanceFacade(createObject("component", "InstanceFacade").init());
		setRequestFacade(createObject("component", "RequestFacade").init());
		setServerFacade(createObject("component", "ServerFacade").init(arguments.version));
		setSessionFacade(createObject("component", "SessionFacade").init());
		setNoneFacade(createObject("component", "NoneFacade").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="configure" hint="post init configure for di loops" access="public" returntype="void" output="false">
	<cfargument name="cacheConfigManager" hint="The Cache Manager" type="transfer.com.cache.cacheConfigManager" required="Yes">
	<cfscript>
		getApplicationFacade().configure(arguments.cacheConfigManager.getScope("application").getKey());
		getInstanceFacade().configure(arguments.cacheConfigManager.getScope("instance").getKey());
		getRequestFacade().configure(arguments.cacheConfigManager.getScope("request").getKey());
		getServerFacade().configure(arguments.cacheConfigManager.getScope("server").getKey());
		getSessionFacade().configure(arguments.cacheConfigManager.getScope("session").getKey());
		getNoneFacade().configure(arguments.cacheConfigManager.getScope("none").getKey());
	</cfscript>
</cffunction>

<cffunction name="getApplicationFacade" access="public" returntype="ApplicationFacade" output="false">
	<cfreturn instance.ApplicationFacade />
</cffunction>

<cffunction name="getInstanceFacade" access="public" returntype="InstanceFacade" output="false">
	<cfreturn instance.InstanceFacade />
</cffunction>

<cffunction name="getRequestFacade" access="public" returntype="RequestFacade" output="false">
	<cfreturn instance.RequestFacade />
</cffunction>

<cffunction name="getServerFacade" access="public" returntype="ServerFacade" output="false">
	<cfreturn instance.ServerFacade />
</cffunction>

<cffunction name="getSessionFacade" access="public" returntype="SessionFacade" output="false">
	<cfreturn instance.SessionFacade />
</cffunction>

<cffunction name="getNoneFacade" access="public" returntype="NoneFacade" output="false">
	<cfreturn instance.NoneFacade />
</cffunction>

<cffunction name="getFacadeByScope" hint="Returns the right facade depending on what scope you enter" access="public" returntype="AbstractBaseFacade" output="false">
	<cfargument name="scope" hint="The scope you need a facade for" type="string" required="Yes">
	<cfscript>
		switch(arguments.scope)
		{
			case "application":
				return getApplicationFacade();
			break;
			case "instance":
				return getInstanceFacade();
			break;
			case "transaction":
			case "session":
				return getSessionFacade();
			break;
			case "request":
				return getRequestFacade();
			break;
			case "none":
				return getNoneFacade();
			break;
			case "server":
				return getServerFacade();
			break;
		}
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setNoneFacade" access="private" returntype="void" output="false">
	<cfargument name="NoneFacade" type="NoneFacade" required="true">
	<cfset instance.NoneFacade = arguments.NoneFacade />
</cffunction>

<cffunction name="setSessionFacade" access="private" returntype="void" output="false">
	<cfargument name="SessionFacade" type="SessionFacade" required="true">
	<cfset instance.SessionFacade = arguments.SessionFacade />
</cffunction>

<cffunction name="setServerFacade" access="private" returntype="void" output="false">
	<cfargument name="ServerFacade" type="ServerFacade" required="true">
	<cfset instance.ServerFacade = arguments.ServerFacade />
</cffunction>

<cffunction name="setRequestFacade" access="private" returntype="void" output="false">
	<cfargument name="RequestFacade" type="RequestFacade" required="true">
	<cfset instance.RequestFacade = arguments.RequestFacade />
</cffunction>

<cffunction name="setApplicationFacade" access="private" returntype="void" output="false">
	<cfargument name="ApplicationFacade" type="ApplicationFacade" required="true">
	<cfset instance.ApplicationFacade = arguments.ApplicationFacade />
</cffunction>

<cffunction name="setInstanceFacade" access="private" returntype="void" output="false">
	<cfargument name="InstanceFacade" type="InstanceFacade" required="true">
	<cfset instance.InstanceFacade = arguments.InstanceFacade />
</cffunction>

</cfcomponent>