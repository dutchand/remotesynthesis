<!--- Document Information -----------------------------------------------------

Title:      DatasourceDAO.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    DAO for datasource

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		27/06/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="DatasourceDAO" hint="DAO for the datasource Bean">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="DatasourceDAO" output="false">
	<cfargument name="xmlFileReader" hint="The file path to the config file" type="transfer.com.io.XMLFileReader" required="Yes">
	<cfscript>
		setXMLReader(arguments.xmlFileReader);
		
		return this;
	</cfscript>
</cffunction>

<cffunction name="getDataSource" hint="Gets a datasource bean" access="public" returntype="Datasource" output="false">
	<cfargument name="Datasource" hint="Datasource bean" type="Datasource" required="Yes">
	<cfscript>
		var xDataSource = getXMLReader().search("/datasource/");

		var memento = Structnew();

		//convenience
		xDatasource = xDatasource[1];
		
		memento.name = xDatasource.name.xmlText;
		memento.username = xDatasource.username.xmlText;
		memento.password = xDatasource.password.xmlText;
		
		arguments.datasource.setMemento(memento);
		
		return arguments.datasource;			
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getXMLReader" access="private" returntype="transfer.com.io.XMLFileReader" output="false">
	<cfreturn instance.XMLReader />
</cffunction>

<cffunction name="setXMLReader" access="private" returntype="void" output="false">
	<cfargument name="XMLReader" type="transfer.com.io.XMLFileReader" required="true">
	<cfset instance.XMLReader = arguments.XMLReader />
</cffunction>

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>

</cfcomponent>