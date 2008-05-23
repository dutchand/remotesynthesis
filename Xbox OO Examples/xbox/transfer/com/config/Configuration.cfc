<!--- Document Information -----------------------------------------------------

Title:      Configuration.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Configuration bean

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		14/09/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="Configuration" hint="Configuration bean">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Configuration" output="false">
	<cfargument name="datasourcePath" hint="The path to datasource xml file. Should be a relative path, i.e. /myapp/configs/datasource.xml" type="string" required="no" default="">
	<cfargument name="configPath" hint="The path to the config xml file, Should be a relative path, i.e. /myapp/configs/transfer.xml" type="string" required="no" default="">
	<cfargument name="definitionPath" hint="directory to write the defition files. Should be from root, i.e. /myapp/definitions/, as it is used for cfinclude" default="/transfer/resources/definitions/" type="string" required="No">
	<cfscript>
		setConfigPathCollection(ArrayNew(1));

		setDataSourcePath(arguments.datasourcePath);
		setConfigPath(arguments.configPath);
		setDefinitionPath(arguments.definitionPath);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getDataSourcePath" access="public" returntype="string" output="false">
	<cfreturn variables.dataSourcePath />
</cffunction>

<cffunction name="setDataSourcePath" access="public" returntype="void" output="false">
	<cfargument name="dataSourcePath" type="string" required="true">
	<cfset variables.dataSourcePath = arguments.dataSourcePath />
</cffunction>

<cffunction name="getConfigPath" access="public" returntype="string" output="false">
	<cfscript>
		var configPathCollection = getConfigPathCollection();

		return configPathCollection[1];
	</cfscript>
</cffunction>

<cffunction name="setConfigPath" access="public" returntype="void" output="false">
	<cfargument name="configPath" type="string" required="true">
	<cfscript>
		var configPathCollection = getConfigPathCollection();
		configPathCollection[1] = arguments.configPath;

		setConfigPathCollection(configPathCollection);
	</cfscript>
</cffunction>

<cffunction name="getDefinitionPath" access="public" returntype="string" output="false">
	<cfreturn variables.definitionPath />
</cffunction>

<cffunction name="setDefinitionPath" access="public" returntype="void" output="false">
	<cfargument name="definitionPath" type="string" required="true">
	<cfset variables.definitionPath = arguments.definitionPath />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getConfigPathCollection" access="private" returntype="array" output="false">
	<cfreturn variables.ConfigPathCollection />
</cffunction>

<cffunction name="setConfigPathCollection" access="private" returntype="void" output="false">
	<cfargument name="ConfigPathCollection" type="array" required="true">
	<cfset variables.ConfigPathCollection = arguments.ConfigPathCollection />
</cffunction>

</cfcomponent>