<!--- Document Information -----------------------------------------------------

Title:      TransferDeleter.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Deletes a transfer from the DB

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		17/08/2005		Created

------------------------------------------------------------------------------->

<cfcomponent name="TransferDeleter" hint="Deletes a transfer from the DB">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="TransferDeleter" output="false">
	<cfargument name="datasource" hint="The datasource BO" type="Datasource" required="Yes">
	<cfargument name="objectManager" hint="Need to object manager for making queries" type="transfer.com.object.ObjectManager" required="Yes">
	<cfargument name="transaction" hint="handles transactions" type="transfer.com.sql.Transaction" required="Yes">

	<cfscript>
		setDataSource(arguments.datasource);
		setObjectManager(arguments.objectManager);
		setTransaction(arguments.transaction);
		setMethodInvoker(createObject("component", "transfer.com.dynamic.MethodInvoker").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="delete" hint="Deletes a transfer object" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer object to insert" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="useTransaction" hint="Whether or not to use an internal transaction block" type="boolean" required="true">

	<cftry>
		<cfscript>
			getTransaction().begin(arguments.useTransaction);

			deleteManyToMany(arguments.transfer);
			deleteExternalManyToMany(arguments.transfer);
			deleteBasic(arguments.transfer);

			getTransaction().commit(arguments.useTransaction);
		</cfscript>

		<cfcatch type="any">
			<cfset getTransaction().rollback(arguments.useTransaction)>
			<cfrethrow>
		</cfcatch>
	</cftry>

</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="deleteBasic" hint="Delets the single table part of the object" access="private" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer object to insert" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var object = getObjectManager().getObject(arguments.transfer.getClassName());
		var qDeleteTransfer = 0;
		var primaryKey = object.getPrimaryKey();
		var value = getMethodInvoker().invokeMethod(arguments.transfer, "get" & primaryKey.getName());
	</cfscript>

	<cfquery name="qDeleteTransfer" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		DELETE FROM
		#object.getTable()#
		WHERE
		#primaryKey.getColumn()# =
		<cfswitch expression="#primaryKey.getType()#">
			<cfcase value="numeric">
				<cfqueryparam value="#value#" cfsqltype="cf_sql_float">
			</cfcase>
			<cfcase value="date">
				<cfqueryparam value="#value#" cfsqltype="cf_sql_timestamp">
			</cfcase>
			<cfcase value="boolean">
				<cfqueryparam value="#value#" cfsqltype="cf_sql_bit">
			</cfcase>
			<cfdefaultcase>
				<cfqueryparam value="#value#" cfsqltype="cf_sql_varchar">
			</cfdefaultcase>
		</cfswitch>
	</cfquery>
</cffunction>

<cffunction name="deleteManyToMany" hint="Delets the single table part of the object" access="private" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer object to insert" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var object = getObjectManager().getObject(arguments.transfer.getClassName());
		var qDeleteTransfer = 0;
		var primaryKey = object.getPrimaryKey();
		var value = getMethodInvoker().invokeMethod(arguments.transfer, "get" & primaryKey.getName());
		var iterator = object.getManyToManyIterator();
		var manytomany = 0;
	</cfscript>

	<cfloop condition="#iterator.hasNext()#">
		<cfset manyToMany = iterator.next()>

		<cfquery name="qDeleteTransfer" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
			DELETE FROM
				#manytomany.getTable()#
			WHERE
				#manytomany.getLinkFrom().getColumn()# =
			<cfswitch expression="#primaryKey.getType()#">
				<cfcase value="numeric">
					<cfqueryparam value="#value#" cfsqltype="cf_sql_float">
				</cfcase>
				<cfcase value="date">
					<cfqueryparam value="#value#" cfsqltype="cf_sql_timestamp">
				</cfcase>
				<cfcase value="boolean">
					<cfqueryparam value="#value#" cfsqltype="cf_sql_bit">
				</cfcase>
				<cfdefaultcase>
					<cfqueryparam value="#value#" cfsqltype="cf_sql_varchar">
				</cfdefaultcase>
			</cfswitch>
		</cfquery>
	</cfloop>
</cffunction>

<cffunction name="deleteExternalManyToMany" hint="Deletes any links that currently exist from this object out to a many to many link" access="private" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer object to insert" type="transfer.com.TransferObject" required="Yes">

	<cfscript>
		var qManyToMany = getObjectManager().getManyToManyLinksByClassLinkTo(arguments.transfer.getClassName());
		var qDeleteExternalManyToMany = 0;
		var object = getObjectManager().getObject(arguments.transfer.getClassName());
		var primaryKeyValue = getMethodInvoker().invokeMethod(arguments.transfer, "get" & object.getPrimarykey().getName());
	</cfscript>

	<cfloop query="qManyToMany">
		<cfquery name="qDeleteExternalManyToMany" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
			DELETE FROM
				#table#
			WHERE
				#columnTo# =
			<cfswitch expression="#object.getPrimaryKey().getType()#">
				<cfcase value="numeric">
					<cfqueryparam value="#primaryKeyValue#" cfsqltype="cf_sql_float">
				</cfcase>
				<cfcase value="date">
					<cfqueryparam value="#primaryKeyValue#" cfsqltype="cf_sql_timestamp">
				</cfcase>
				<cfcase value="boolean">
					<cfqueryparam value="#primaryKeyValue#" cfsqltype="cf_sql_bit">
				</cfcase>
				<cfdefaultcase>
					<cfqueryparam value="#primaryKeyValue#" cfsqltype="cf_sql_varchar">
				</cfdefaultcase>
			</cfswitch>
		</cfquery>
	</cfloop>
</cffunction>

<cffunction name="getDatasource" access="private" returntype="Datasource" output="false">
	<cfreturn instance.Datasource />
</cffunction>

<cffunction name="setDatasource" access="private" returntype="void" output="false">
	<cfargument name="Datasource" type="Datasource" required="true">
	<cfset instance.Datasource = arguments.Datasource />
</cffunction>

<cffunction name="getObjectManager" access="private" returntype="transfer.com.object.ObjectManager" output="false">
	<cfreturn instance.ObjectManager />
</cffunction>

<cffunction name="setObjectManager" access="private" returntype="void" output="false">
	<cfargument name="ObjectManager" type="transfer.com.object.ObjectManager" required="true">
	<cfset instance.ObjectManager = arguments.ObjectManager />
</cffunction>

<cffunction name="getMethodInvoker" access="private" returntype="transfer.com.dynamic.MethodInvoker" output="false">
	<cfreturn instance.MethodInvoker />
</cffunction>

<cffunction name="setMethodInvoker" access="private" returntype="void" output="false">
	<cfargument name="MethodInvoker" type="transfer.com.dynamic.MethodInvoker" required="true">
	<cfset instance.MethodInvoker = arguments.MethodInvoker />
</cffunction>

<cffunction name="getTransaction" access="private" returntype="transfer.com.sql.Transaction" output="false">
	<cfreturn instance.Transaction />
</cffunction>

<cffunction name="setTransaction" access="private" returntype="void" output="false">
	<cfargument name="Transaction" type="transfer.com.sql.Transaction" required="true">
	<cfset instance.Transaction = arguments.Transaction />
</cffunction>

</cfcomponent>