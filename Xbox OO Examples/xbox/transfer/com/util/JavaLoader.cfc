<!--- Document Information -----------------------------------------------------

Title:      JavaLoader.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Loads up the Java classes Transfer needs

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		08/05/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="JavaLoader" hint="Loads External Java Classes for Transfer">

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="JavaLoader" output="false">
	<cfargument name="serverFacade" hint="the server facade for the javaloader" type="transfer.com.facade.ServerFacade" required="Yes">
	<cfscript>
		variables.instance = StructNew();

		setServerFacade(arguments.serverFacade);
	</cfscript>
		
	<!--- double check lock for safety --->
	<cfif NOT getServerFacade().hasJavaLoader()>
		<cflock name="transfer.server.JavaLoader" throwontimeout="true" timeout="60">
			<cfscript>
				if(NOT getServerFacade().hasJavaLoader())
				{
					getServerFacade().setJavaLoader(createObject("component", "transfer.com.util.javaloader.JavaLoader").init(queryJars(), true));
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="create" hint="Retrieves a reference to the java class. To create a instance, you must run init() on this object" access="public" returntype="any" output="false">
	<cfargument name="className" hint="The name of the class to create" type="string" required="Yes">
	<cfscript>
		return getServerFacade().getJavaLoader().create(arguments.className);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="queryJars" hint="pulls a query of all the jars in the /resources/lib folder" access="private" returntype="array" output="false">
	<cfscript>
		var qJars = 0;
		//the path to my jar library
		var path = getDirectoryFromPath(getMetaData(this).path) & "../../resources/lib";
		var jarList = "";
		var aJars = ArrayNew(1);
		var libName = 0;
	</cfscript>

	<cfdirectory action="list" name="qJars" directory="#path#" filter="*.jar" sort="name desc"/>

	<cfloop query="qJars">
		<cfscript>
			libName = ListGetAt(name, 1, "-");
			//let's not use the lib's that have the same name, but a lower datestamp
			if(NOT ListFind(jarList, libName))
			{
				ArrayAppend(aJars, directory & "/" & name);
				jarList = ListAppend(jarList, libName);
			}
		</cfscript>
	</cfloop>

	<cfreturn aJars>
</cffunction>

<cffunction name="getServerFacade" access="private" returntype="transfer.com.facade.ServerFacade" output="false">
	<cfreturn instance.serverFacade />
</cffunction>

<cffunction name="setServerFacade" access="private" returntype="void" output="false">
	<cfargument name="serverFacade" type="transfer.com.facade.ServerFacade" required="true">
	<cfset instance.serverFacade = arguments.serverFacade />
</cffunction>

</cfcomponent>