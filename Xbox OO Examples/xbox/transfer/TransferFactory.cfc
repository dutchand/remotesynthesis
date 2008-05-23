<!--- Document Information -----------------------------------------------------

Title:      TransferFactory.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Factory for Transfer

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		27/06/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="TransferFactory" hint="The Factory for Transfer, should be a scope singleton">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="TransferFactory" output="false">
	<cfargument name="datasourcePath" hint="The path to datasource xml file. Should be a relative path, i.e. /myapp/configs/datasource.xml" type="string" required="No">
	<cfargument name="configPath" hint="The path to the config xml file, Should be a relative path, i.e. /myapp/configs/transfer.xml" type="string" required="No">
	<cfargument name="definitionPath" hint="directory to write the defition files. Should be from root, i.e. /myapp/definitions/, as it is used for cfinclude" default="/transfer/resources/definitions/" type="string" required="No">
	<cfargument name="configuration" hint="A configuration bean.  If you supply one, you don't need to provide any other arguments" type="transfer.com.config.Configuration" required="No">

	<cfscript>
		var datasourceDAO = 0;
		var datasource = 0;

		var datasourceReader = 0;
		var configReader = 0;

		//push data from config object
		if(StructKeyExists(arguments, "configuration"))
		{
			arguments.datasourcePath = arguments.configuration.getDataSourcePath();
			arguments.configPath = arguments.configuration.getConfigPath();
			arguments.definitionPath = arguments.configuration.getDefinitionPath();
		}

		datasourceReader = createObject("component", "com.io.XMLFileReader").init(expandPath(arguments.datasourcePath));
		configReader = createObject("component", "com.io.XMLFileReader").init(expandPath(arguments.configPath));

		datasourceDAO = createObject("component", "com.sql.DatasourceDAO").init(datasourceReader);
		datasource = createObject("component", "com.sql.Datasource").init();

		setDatasource(dataSourceDAO.getDataSource(datasource));

		//clean up definition Path
		if(NOT arguments.definitionPath.endsWith("/"))
		{
			arguments.definitionPath = arguments.definitionPath & "/";
		}

		setTransfer(createObject("component", "com.Transfer").init(getDatasource(),
																	configReader,
																	arguments.definitionPath,
																	getVersion()
																	));

		return this;
	</cfscript>
</cffunction>

<cffunction name="getDatasource" access="public" hint="Returns the datasource bean that provides connectivity details to the database" returntype="transfer.com.sql.Datasource" output="false">
	<cfreturn instance.Datasource />
</cffunction>

<cffunction name="getTransfer" access="public" hint="Returns the main library class, that is used in all processing" returntype="transfer.com.Transfer" output="false">
	<cfreturn instance.Transfer />
</cffunction>

<cffunction name="getVersion" access="public" hint="Returns the version number" returntype="string" output="false">
	<cfreturn "0.6.3"/>
</cffunction>


<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setTransfer" access="private" returntype="void" output="false">
	<cfargument name="Transfer" type="transfer.com.Transfer" required="true">
	<cfset instance.Transfer = arguments.Transfer />
</cffunction>

<cffunction name="setDatasource" access="private" returntype="void" output="false">
	<cfargument name="Datasource" type="transfer.com.sql.Datasource" required="true">
	<cfset instance.Datasource = arguments.Datasource />
</cffunction>


</cfcomponent>