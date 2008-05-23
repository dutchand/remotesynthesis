<!--- Document Information -----------------------------------------------------

Title:      RefreshSelecter.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Makes queries to refresh properties after an insert of update

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		25/07/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="RefreshSelecter" hint="Makes queries to refresh properties after an insert of update">

<cfscript>
	instance = StructNew();
</cfscript>
<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="RefreshSelecter" output="false">
	<cfargument name="datasource" hint="The datasource BO" type="Datasource" required="Yes">
	<cfargument name="objectManager" hint="The object manager to query" type="transfer.com.object.ObjectManager" required="Yes">

	<cfscript>
		setDataSource(arguments.datasource);
		setObjectManager(arguments.objectManager);

		setInsertRefreshCollection(StructNew());
		setUpdateRefreshCollection(StructNew());
		setMethodInvoker(createObject("component", "transfer.com.dynamic.MethodInvoker").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="hasInsertRefresh" hint="Check to see if it requires a run of the refresh query" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The object to refresh" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var object = getObjectManager().getObject(arguments.transfer.getClassName());

		return ArrayLen(getInsertRefreshProperties(object));
	</cfscript>
</cffunction>

<cffunction name="getInsertRefreshQuery" hint="Returns the refresh query for an insert" access="public" returntype="query" output="false">
	<cfargument name="transfer" hint="The object to refresh" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var object = getObjectManager().getObject(arguments.transfer.getClassName());

		return queryRefresh(arguments.transfer, object, getInsertRefreshProperties(object));
	</cfscript>
</cffunction>

<cffunction name="hasUpdateRefresh" hint="Check to see if it requires a run of the refresh query" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The object to refresh" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var object = getObjectManager().getObject(arguments.transfer.getClassName());

		return ArrayLen(getUpdateRefreshProperties(object));
	</cfscript>
</cffunction>

<cffunction name="getUpdateRefreshQuery" hint="Returns the refresh query for an insert" access="public" returntype="query" output="false">
	<cfargument name="transfer" hint="The object to refresh" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var object = getObjectManager().getObject(arguments.transfer.getClassName());

		return queryRefresh(arguments.transfer, object, getUpdateRefreshProperties(object));
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="queryRefresh" hint="Gets the refresh query" access="public" returntype="query" output="false">
	<cfargument name="transfer" hint="The object to refresh" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="object" hint="The object to refresh" type="transfer.com.object.Object" required="Yes">
	<cfargument name="propertyArray" hint="The array of properties that need to be refreshed" type="array" required="Yes">
	<cfscript>
		var qRefresh = 0;
		var iterator = arguments.propertyArray.iterator();
		var property = 0;
		var primaryKeyValue = getMethodInvoker().invokeMethod(arguments.transfer, "get" & arguments.object.getPrimaryKey().getName());
	</cfscript>

	<cfquery name="qRefresh" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		SELECT
		<cfloop condition="#iterator.hasNext()#">
			<cfset property = iterator.next()>
			#property.getColumn()#,
		</cfloop>
		#arguments.object.getPrimaryKey().getColumn()#
		FROM
		#arguments.object.getTable()#
		WHERE
		#arguments.object.getPrimaryKey().getColumn()# =
		<cfswitch expression="#arguments.object.getPrimaryKey().getType()#">
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

	<cfreturn qRefresh>
</cffunction>


<!--- cache the collections --->

<cffunction name="getInsertRefreshProperties" hint="Gets the array of insert refresh properties" access="public" returntype="array" output="false">
	<cfargument name="object" hint="The object to refresh" type="transfer.com.object.Object" required="Yes">
	<cfset var className = arguments.object.getClassName()>

	<cfif NOT StructKeyExists(getInsertRefreshCollection(), className)>
		<cflock name="transfer.refreshSelector.getInsertRefreshProperties.#className#" timeout="60">
			<cfscript>
				if(NOT StructKeyExists(getInsertRefreshCollection(), className))
				{
					StructInsert(getInsertRefreshCollection(), className, buildRefreshPropertyCollection(arguments.object, "insert"));
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfreturn StructFind(getInsertRefreshCollection(), className)>
</cffunction>


<cffunction name="getUpdateRefreshProperties" hint="Gets the array of update refresh properties" access="public" returntype="array" output="false">
	<cfargument name="object" hint="The object to refresh" type="transfer.com.object.Object" required="Yes">
	<cfset var className = arguments.object.getClassName()>

	<cfif NOT StructKeyExists(getUpdateRefreshCollection(), className)>
		<cflock name="transfer.refreshSelector.getUpdateRefreshProperties.#className#" timeout="60">
			<cfscript>
				if(NOT StructKeyExists(getUpdateRefreshCollection(), className))
				{
					StructInsert(getUpdateRefreshCollection(), className, buildRefreshPropertyCollection(arguments.object, "update"));
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfreturn StructFind(getUpdateRefreshCollection(), className)>
</cffunction>

<cffunction name="buildRefreshPropertyCollection" hint="Builds a property collection of refreshable properties" access="public" returntype="array" output="false">
	<cfargument name="object" hint="The object to refresh" type="transfer.com.object.Object" required="Yes">
	<cfargument name="refreshType" hint="The type of refresh, 'insert' or 'update'" type="string" required="Yes">
	<cfscript>
		var iterator = object.getPropertyIterator();
		var property = 0;
		var	propertyArray = ArrayNew(1);
		var add = false;

		while(iterator.hasNext())
		{
			property = iterator.next();
			add = false;

			switch(arguments.refreshType)
			{
				case "insert":
					if(property.getRefreshInsert())
					{
						add = true;
					}
				break;

				case "update":
					if(property.getRefreshUpdate())
					{
						add = true;
					}
				break;
			}

			if(add)
			{
				ArrayAppend(propertyArray, property);
			}
		}

		return propertyArray;
	</cfscript>
</cffunction>


<cffunction name="getInsertRefreshCollection" access="private" returntype="struct" output="false">
	<cfreturn instance.InsertRefreshCollection />
</cffunction>

<cffunction name="setInsertRefreshCollection" access="private" returntype="void" output="false">
	<cfargument name="InsertRefreshCollection" type="struct" required="true">
	<cfset instance.InsertRefreshCollection = arguments.InsertRefreshCollection />
</cffunction>

<cffunction name="getUpdateRefreshCollection" access="private" returntype="struct" output="false">
	<cfreturn instance.UpdateRefreshCollection />
</cffunction>

<cffunction name="setUpdateRefreshCollection" access="private" returntype="void" output="false">
	<cfargument name="UpdateRefreshCollection" type="struct" required="true">
	<cfset instance.UpdateRefreshCollection = arguments.UpdateRefreshCollection />
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

</cfcomponent>