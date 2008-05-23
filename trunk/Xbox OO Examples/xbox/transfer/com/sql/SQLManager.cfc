<!--- Document Information -----------------------------------------------------

Title:      SQLManager.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Top level configuration manager for SQL objects

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		19/07/2006		Created

------------------------------------------------------------------------------->

<cfcomponent name="SQLManager" hint="Top level configuration manager for SQL objects">

<cfscript>
	instance = StructNew();
</cfscript>

<cffunction name="init" hint="Constructor" access="public" returntype="SQLManager" output="false">
	<cfargument name="datasource" hint="The datasource bean" type="Datasource" required="Yes">
	<cfargument name="configReader" hint="XML reader for the config file" type="transfer.com.io.XMLFileReader" required="Yes">
	<cfargument name="objectManager" hint="The object manager to query" type="transfer.com.object.ObjectManager" required="Yes">
	<cfargument name="utility" hint="The utility object" type="transfer.com.util.Utility" required="Yes">

	<cfscript>
		var TQLConverter = createObject("component", "TQLConverter").init();
		var transaction = createObject("component", "Transaction").init();

		//nullable - yeah I know, I did it on one line = bad, but it was fun.
		setNullable(createObject("component", "NullableDAO").init(arguments.configReader).getNullable(createObject("component", "Nullable").init(arguments.objectManager)));

		setTransferInserter(createObject("component", "#arguments.datasource.getDatabaseType()#.TransferInserter").init(arguments.datasource, arguments.objectManager, arguments.utility, getNullable(), transaction));
		setTransferUpdater(createObject("component", "TransferUpdater").init(arguments.datasource, arguments.objectManager, getNullable(), transaction, TQLConverter));
		setTransferDeleter(createObject("component", "TransferDeleter").init(arguments.datasource, arguments.objectManager, transaction));
		setTransferGateway(createObject("component", "TransferGateway").init(arguments.datasource, arguments.objectManager, TQLConverter));
		setQueryManager(createObject("component", "QueryManager").init(arguments.datasource, arguments.objectManager, TQLConverter));
		setRefreshSelecter(createObject("component", "RefreshSelecter").init(arguments.datasource, objectManager));

		return this;
	</cfscript>
</cffunction>

<cffunction name="getNullable" access="public" returntype="transfer.com.sql.Nullable" output="false">
	<cfreturn instance.Nullable />
</cffunction>

<cffunction name="create" hint="Inserts the transfer into the DB" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer object to insert" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="useTransaction" hint="Whether or not to use an internal transaction block" type="boolean" required="true">
	<cfscript>
		getTransferInserter().create(arguments.transfer, arguments.useTransaction);
	</cfscript>
</cffunction>

<cffunction name="update" hint="Updates the Transfer in the DB" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transferObject to update" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="useTransaction" hint="Whether or not to use an internal transaction block" type="boolean" required="true">
	<cfscript>
		getTransferUpdater().update(arguments.transfer, arguments.useTransaction);
	</cfscript>
</cffunction>

<cffunction name="delete" hint="Deletes a transfer object" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer object to insert" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="useTransaction" hint="Whether or not to use an internal transaction block" type="boolean" required="true">
	<cfscript>
		return getTransferDeleter().delete(arguments.transfer, arguments.useTransaction);
	</cfscript>
</cffunction>

<cffunction name="getObjectQuery" hint="Creates and runs the query for the TransferObject" access="public" returntype="query" output="false">
	<cfargument name="object" hint="The Object BO" type="transfer.com.object.Object" required="Yes">
	<cfargument name="key" hint="The id key for the data" type="string" required="Yes">
	<cfscript>
		return getQueryManager().getObjectQuery(arguments.object, arguments.key);
	</cfscript>
</cffunction>

<cffunction name="list" hint="Lists a series of object values" access="public" returntype="query" output="false">
	<cfargument name="className" hint="The class of the objects to list" type="string" required="Yes">
	<cfargument name="orderProperty" hint="The property to order by" type="string" required="No" default="">
	<cfargument name="orderASC" hint="Boolean whether to order by ASC, otherwise order by DESC" type="boolean" required="No" default="true">
	<cfargument name="useAliases" hint="Boolean as to whether or not to alias columns with the transfer property names" type="boolean" required="no" default="true">
	<cfscript>
		return getTransferGateway().list(arguments.className,
											arguments.orderProperty,
											arguments.orderASC,
											arguments.useAliases);
	</cfscript>
</cffunction>

<cffunction name="listByProperty" hint="Lists a series of values, filtered by a given value" access="public" returntype="query" output="false">
	<cfargument name="className" hint="The class of the objects to list" type="string" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to filter by" type="string" required="Yes">
	<cfargument name="propertyValue" hint="The value to filter by (only simple values)" type="any" required="Yes">
	<cfargument name="onlyRetrievePrimaryKey" hint="boolean to whether or not to only retrieve the primary key" type="boolean" required="Yes">
	<cfargument name="orderProperty" hint="The property to order by" type="string" required="No" default="">
	<cfargument name="orderASC" hint="Boolean whether to order by ASC, otherwise order by DESC" type="boolean" required="No" default="true">
	<cfargument name="useAliases" hint="Boolean as to whether or not to alias columns with the transfer property names" type="boolean" required="no" default="true">

	<cfscript>
		return getTransferGateway().listByProperty(arguments.className,
													arguments.propertyName,
													arguments.propertyValue,
													arguments.onlyRetrievePrimaryKey,
													arguments.orderProperty,
													arguments.orderASC,
													arguments.useAliases);
	</cfscript>
</cffunction>

<cffunction name="listByPropertyMap" hint="Lists values, filtered by a Struct of Property : Value properties" access="public" returntype="query" output="false">
	<cfargument name="className" hint="The class of the objects to list" type="string" required="Yes">
	<cfargument name="propertyMap" hint="Struct with keys that match to properties, and values to filter by" type="struct" required="Yes">
	<cfargument name="onlyRetrievePrimaryKey" hint="boolean to whether or not to only retrieve the primary key" type="boolean" required="Yes">
	<cfargument name="orderProperty" hint="The property to order by" type="string" required="No" default="">
	<cfargument name="orderASC" hint="Boolean whether to order by ASC, otherwise order by DESC" type="boolean" required="No" default="true">
	<cfargument name="useAliases" hint="Boolean as to whether or not to alias columns with the transfer property names" type="boolean" required="no" default="true">

	<cfscript>
		return getTransferGateway().listByPropertyMap(arguments.className,
															arguments.propertyMap,
															arguments.onlyRetrievePrimaryKey,
															arguments.orderProperty,
															arguments.orderASC,
															arguments.useAliases);
	</cfscript>
</cffunction>

<cffunction name="listByWhere" hint="Lists a series of values, filtered by a given value" access="public" returntype="query" output="false">
	<cfargument name="className" hint="The class of the objects to list" type="string" required="Yes">
	<cfargument name="whereSQL" hint="The where statement for the SQL Query (Do not include the 'where'). Properties can be defined as {propertyName}" type="any" required="Yes">
	<cfargument name="onlyRetrievePrimaryKey" hint="boolean to whether or not to only retrieve the primary key" type="boolean" required="Yes">
	<cfargument name="orderProperty" hint="The property to order by" type="string" required="No" default="">
	<cfargument name="orderASC" hint="Boolean whether to order by ASC, otherwise order by DESC" type="boolean" required="No" default="true">
	<cfargument name="useAliases" hint="Boolean as to whether or not to alias columns with the transfer property names" type="boolean" required="no" default="true">

	<cfscript>
		return getTransferGateway().listByWhere(arguments.className,
												arguments.whereSQL,
												arguments.onlyRetrievePrimaryKey,
												arguments.orderProperty,
												arguments.orderASC,
												arguments.useAliases);
	</cfscript>
</cffunction>

<cffunction name="hasInsertRefresh" hint="Check to see if it requires a run of the refresh query" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The object to refresh" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		return getRefreshSelecter().hasInsertRefresh(arguments.transfer);
	</cfscript>
</cffunction>

<cffunction name="getInsertRefreshQuery" hint="Returns the refresh query for an insert" access="public" returntype="query" output="false">
	<cfargument name="transfer" hint="The object to refresh" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		return getRefreshSelecter().getInsertRefreshQuery(arguments.transfer);
	</cfscript>
</cffunction>

<cffunction name="hasUpdateRefresh" hint="Check to see if it requires a run of the refresh query" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The object to refresh" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		return getRefreshSelecter().hasUpdateRefresh(arguments.transfer);
	</cfscript>
</cffunction>

<cffunction name="getUpdateRefreshQuery" hint="Returns the refresh query for an insert" access="public" returntype="query" output="false">
	<cfargument name="transfer" hint="The object to refresh" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		return getRefreshSelecter().getUpdateRefreshQuery(arguments.transfer);
	</cfscript>
</cffunction>


<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setNullable" access="private" returntype="void" output="false">
	<cfargument name="Nullable" type="transfer.com.sql.Nullable" required="true">
	<cfset instance.Nullable = arguments.Nullable />
</cffunction>

<cffunction name="getQueryManager" access="private" returntype="transfer.com.sql.QueryManager" output="false">
	<cfreturn instance.QueryManager />
</cffunction>

<cffunction name="setQueryManager" access="private" returntype="void" output="false">
	<cfargument name="QueryManager" type="transfer.com.sql.QueryManager" required="true">
	<cfset instance.QueryManager = arguments.QueryManager />
</cffunction>

<cffunction name="getTransferUpdater" access="private" returntype="transfer.com.sql.TransferUpdater" output="false">
	<cfreturn instance.TransferUpdater />
</cffunction>

<cffunction name="setTransferUpdater" access="private" returntype="void" output="false">
	<cfargument name="TransferUpdater" type="transfer.com.sql.TransferUpdater" required="true">
	<cfset instance.TransferUpdater = arguments.TransferUpdater />
</cffunction>

<cffunction name="getTransferInserter" access="private" returntype="transfer.com.sql.TransferInserter" output="false">
	<cfreturn instance.TransferInserter />
</cffunction>

<cffunction name="setTransferInserter" access="private" returntype="void" output="false">
	<cfargument name="TransferInserter" type="transfer.com.sql.TransferInserter" required="true">
	<cfset instance.TransferInserter = arguments.TransferInserter />
</cffunction>

<cffunction name="getTransferDeleter" access="private" returntype="transfer.com.sql.TransferDeleter" output="false">
	<cfreturn instance.TransferDeleter />
</cffunction>

<cffunction name="setTransferDeleter" access="private" returntype="void" output="false">
	<cfargument name="TransferDeleter" type="transfer.com.sql.TransferDeleter" required="true">
	<cfset instance.TransferDeleter = arguments.TransferDeleter />
</cffunction>

<cffunction name="getTransferGateway" access="private" returntype="transfer.com.sql.TransferGateway" output="false">
	<cfreturn instance.TransferGateway />
</cffunction>

<cffunction name="setTransferGateway" access="private" returntype="void" output="false">
	<cfargument name="TransferGateway" type="transfer.com.sql.TransferGateway" required="true">
	<cfset instance.TransferGateway = arguments.TransferGateway />
</cffunction>

<cffunction name="getRefreshSelecter" access="private" returntype="RefreshSelecter" output="false">
	<cfreturn instance.RefreshSelecter />
</cffunction>

<cffunction name="setRefreshSelecter" access="private" returntype="void" output="false">
	<cfargument name="RefreshSelecter" type="RefreshSelecter" required="true">
	<cfset instance.RefreshSelecter = arguments.RefreshSelecter />
</cffunction>

</cfcomponent>