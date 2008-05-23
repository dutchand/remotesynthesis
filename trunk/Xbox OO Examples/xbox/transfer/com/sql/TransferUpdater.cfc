<!--- Document Information -----------------------------------------------------

Title:      TransferUpdater.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Does the update of a transfer object on the DB

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		10/08/2005		Created

------------------------------------------------------------------------------->

<cfcomponent name="TransferUpdater" hint="Does the update of a transfer object on the DB">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="TransferUpdater" output="false">
	<cfargument name="Datasource" hint="The datasource BO" type="Datasource" required="Yes">
	<cfargument name="objectManager" hint="Need to object manager for making queries" type="transfer.com.object.ObjectManager" required="Yes">
	<cfargument name="nullable" hint="The nullable class" type="transfer.com.sql.Nullable" required="Yes">
	<cfargument name="transaction" hint="handles transactions" type="transfer.com.sql.Transaction" required="Yes">
	<cfargument name="tQLConverter" hint="Converter for {property} statements" type="transfer.com.sql.TQLConverter" required="Yes">
	<cfscript>
		setDataSource(arguments.datasource);
		setObjectManager(arguments.objectManager);
		setNullable(arguments.nullable);
		setTransaction(arguments.transaction);
		setTQLConverter(arguments.tQLConverter);
		setMethodInvoker(createObject("component", "transfer.com.dynamic.MethodInvoker").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="update" hint="Updates the Transfer in the DB" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transferObject to update" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="useTransaction" hint="Whether or not to use an internal transaction block" type="boolean" required="true">

	<cftry>
		<cfscript>
			getTransaction().begin(arguments.useTransaction);

			updateBasic(arguments.transfer);

			updateManyToMany(arguments.transfer);

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

<cffunction name="updateBasic" hint="Updates the single table portion of the transfer element table" access="private" returntype="void" output="false">
	<cfargument name="transfer" hint="The transferObject to update" type="transfer.com.TransferObject" required="Yes">

	<cfscript>
		var qUpdateTransfer = 0;
		var object = getObjectManager().getObject(arguments.transfer.getClassName());
		var iterator = object.getPropertyIterator();
		var property = 0;
		var primaryKey = object.getPrimaryKey();
		var primaryKeyValue = getMethodInvoker().invokeMethod(arguments.transfer, "get" & primaryKey.getName());
		var isStarted = false;
		var manytoone = 0;
		var composite = 0;
		var hasComposite = 0;
		var compositeObject = 0;
		var parentOneToMany = 0;
		var parent = 0;
		var hasParent = 0;
		var parentObject = 0;
		var isNull = false;
		var value = 0;

		//if it has no properties, return it
		if(NOT iterator.hasNext())
		{
			return;
		}
	</cfscript>

	<cfquery name="qUpdateTransfer" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		UPDATE
		#object.getTable()#
		SET
		<cfloop condition="#iterator.hasNext()#">
			<cfset property = iterator.next()>

			<!--- ignore any property that has ignore-update='true' --->
			<cfif NOT property.getIgnoreUpdate()>

				<cfset value = getMethodInvoker().invokeMethod(arguments.transfer, "get" & property.getName())>
				<cfif isStarted>,<cfelse><cfset isStarted = true></cfif>
				#property.getColumn()# =
				<cfswitch expression="#property.getType()#">
					<cfcase value="numeric">
						<cfset isNull = property.getIsNullable() AND getNullable().checkNullNumeric(arguments.transfer, property.getName(), value)>
						<cfqueryparam value="#value#" cfsqltype="cf_sql_float" null="#isNull#">
					</cfcase>
					<cfcase value="date">
						<cfset isNull = property.getIsNullable() AND getNullable().checkNullDate(arguments.transfer, property.getName(), value)>
						<cfqueryparam value="#value#" cfsqltype="cf_sql_timestamp" null="#isNull#">
					</cfcase>
					<cfcase value="boolean">
						<cfset isNull = property.getIsNullable() AND getNullable().checkNullBoolean(arguments.transfer, property.getName(), value)>
						<cfqueryparam value="#value#" cfsqltype="cf_sql_bit" null="#isNull#">
					</cfcase>
					<cfcase value="uuid">
						<cfset isNull = property.getIsNullable() AND getNullable().checkNullUUID(arguments.transfer, property.getName(), value)>
						<cfqueryparam value="#value#" cfsqltype="cf_sql_varchar" null="#isNull#">
					</cfcase>
					<cfcase value="guid">
						<cfset isNull = property.getIsNullable() AND getNullable().checkNullGUID(arguments.transfer, property.getName(), value)>
						<cfqueryparam value="#value#" cfsqltype="cf_sql_varchar" null="#isNull#">
					</cfcase>
					<cfdefaultcase>
						<cfset isNull = property.getIsNullable() AND getNullable().checkNullString(arguments.transfer, property.getName(), value)>
						<cfqueryparam value="#value#" cfsqltype="cf_sql_varchar" null="#isNull#">
					</cfdefaultcase>
				</cfswitch>

			</cfif>
		</cfloop>
		<cfscript>
			iterator = object.getManyToOneIterator();
		</cfscript>
		<cfloop condition="#iterator.hasNext()#">
			<cfscript>
				manytoone = iterator.next();
				compositeObject = getObjectManager().getObject(manyToOne.getLink().getTo());

				//default values
				value = 0;
				isNull = false;

				//check for existence first
				hasComposite = getMethodInvoker().invokeMethod(arguments.transfer, "has" & manyToOne.getName());
				if(hasComposite)
				{
					//get the composite
					composite = getMethodInvoker().invokeMethod(arguments.transfer, "get" & manyToOne.getName());
					//get the defintion of the composite - could have done this through composite

					//if not created, throw an excpetion
					if(not composite.getIsPersisted())
					{
						throw("ManyToOneNotCreatedException",
							  "The ManyToOne TransferObject has not been created.",
							  "In TransferObject '"& object.getClassName() &"' manytoone '"& compositeObject.getClassName() &"' has not been created in the database.");
					}

					//get it's primary key value
					value = invokeGetPrimaryKey(composite);
				}
				else
				{
					isNull = true;
				}
			</cfscript>

			<cfif isStarted>,<cfelse><cfset isStarted = true></cfif>
			#manyToOne.getLink().getColumn()# =
			<cfswitch expression="#compositeObject.getPrimaryKey().getType()#">
				<cfcase value="numeric">
					<cfset isNull = isNull OR getNullable().checkNullNumeric(composite, compositeObject.getPrimaryKey().getName(), value)>
					<cfqueryparam value="#value#" cfsqltype="cf_sql_float" null="#isNull#">
				</cfcase>
				<cfcase value="date">
					<cfset isNull = isNull OR getNullable().checkNullDate(composite, compositeObject.getPrimaryKey().getName(), value)>
					<cfqueryparam value="#value#" cfsqltype="cf_sql_timestamp" null="#isNull#">
				</cfcase>
				<cfcase value="boolean">
					<cfset isNull = isNull OR getNullable().checkNullBoolean(composite, compositeObject.getPrimaryKey().getName(), value)>
					<cfqueryparam value="#value#" cfsqltype="cf_sql_bit" null="#isNull#">
				</cfcase>
				<cfcase value="uuid">
					<cfset isNull = isNull OR getNullable().checkNullUUID(composite, compositeObject.getPrimaryKey().getName(), value)>
					<cfqueryparam value="#value#" cfsqltype="cf_sql_varchar" null="#isNull#">
				</cfcase>
				<cfcase value="guid">
					<cfset isNull = isNull OR getNullable().checkNullGUID(composite, compositeObject.getPrimaryKey().getName(), value)>
					<cfqueryparam value="#value#" cfsqltype="cf_sql_varchar" null="#isNull#">
				</cfcase>
				<cfdefaultcase>
					<cfset isNull = isNull OR getNullable().checkNullString(composite, compositeObject.getPrimaryKey().getName(), value)>
					<cfqueryparam value="#value#" cfsqltype="cf_sql_varchar" null="#isNull#">
				</cfdefaultcase>
			</cfswitch>
		</cfloop>
		<!--- external one to many's' --->

		<cfset iterator = object.getParentOneToManyIterator()>

		<cfloop condition="#iterator.hasNext()#">
			<cfscript>
				parentOneToMany = iterator.next();

				parentObject = getObjectManager().getObject(parentOneToMany.getLink().getTo());

				//check parent first
				hasParent = getMethodInvoker().invokeMethod(arguments.transfer, "hasParent" & parentObject.getObjectName());

				//default values
				value = 0;
				isNull = false;

				if(hasParent)
				{
					//get the parent
					parent = getMethodInvoker().invokeMethod(arguments.transfer, "getParent" & parentObject.getObjectName());

					//make sure it's in the DB
					if(not parent.getIsPersisted())
					{
						throw("OneToManyNotCreatedException",
							  "The OneToMany TransferObject is not persisted.",
							  "In TransferObject '"& object.getClassName() &"' onetomany '"& parentObject.getClassName() &"' has not been created in the database.");
					}

					//method invoke the IDValue
					value = invokeGetPrimaryKey(parent);
				}
				else
				{
					isNull = true;
				}
			</cfscript>

			<!--- set it --->
			<cfif isStarted>,<cfelse><cfset isStarted = true></cfif>
			#parentOneToMany.getLink().getColumn()# =

			<cfswitch expression="#parentObject.getPrimaryKey().getType()#">
				<cfcase value="numeric">
					<cfset isNull = isNull OR getNullable().checkNullNumeric(parent, parentObject.getPrimaryKey().getName(), value)>
					<cfqueryparam value="#value#" cfsqltype="cf_sql_float" null="#isNull#">
				</cfcase>
				<cfcase value="date">
					<cfset isNull = isNull OR getNullable().checkNullDate(parent, parentObjectt.getPrimaryKey().getName(), value)>
					<cfqueryparam value="#value#" cfsqltype="cf_sql_timestamp" null="#isNull#">
				</cfcase>
				<cfcase value="boolean">
					<cfset isNull = isNull OR getNullable().checkNullBoolean(parent, parentObject.getPrimaryKey().getName(), value)>
					<cfqueryparam value="#value#" cfsqltype="cf_sql_bit" null="#isNull#">
				</cfcase>
				<cfcase value="uuid">
					<cfset isNull = isNull OR getNullable().checkNullUUID(parent, parentObject.getPrimaryKey().getName(), value)>
					<cfqueryparam value="#value#" cfsqltype="cf_sql_varchar" null="#isNull#">
				</cfcase>
				<cfcase value="guid">
					<cfset isNull = isNull OR getNullable().checkNullGUID(parent, parentObject.getPrimaryKey().getName(), value)>
					<cfqueryparam value="#value#" cfsqltype="cf_sql_varchar" null="#isNull#">
				</cfcase>
				<cfdefaultcase>
					<cfset isNull = isNull OR getNullable().checkNullString(parent, parentObject.getPrimaryKey().getName(), value)>
					<cfqueryparam value="#value#" cfsqltype="cf_sql_varchar" null="#isNull#">
				</cfdefaultcase>
			</cfswitch>
		</cfloop>
		WHERE
		#object.getPrimaryKey().getColumn()# =
			<cfswitch expression="#primaryKey.getType()#">
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
</cffunction>

<cffunction name="updateManyToMany" hint="Updates the many to many portion of the transfer" access="private" returntype="void" output="false">
	<cfargument name="transfer" hint="The transferObject to update" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var qUpdateTransfer = 0;
		var object = getObjectManager().getObject(arguments.transfer.getClassName());
		var primaryKey = object.getPrimaryKey();
		var primaryKeyValue = getMethodInvoker().invokeMethod(arguments.transfer, "get" & primaryKey.getName());
		var composite = 0;
		var compositeObject = 0;
		var iterator = object.getManyToManyIterator();
		var manytomany = 0;
		var value = 0;
		var condition = 0;
		var property = 0;
	</cfscript>

	<cfloop condition="#iterator.hasNext()#">
		<cfset manytomany = iterator.next()>
		<cfset collectionIterator = getMethodInvoker().invokeMethod(arguments.transfer, "get" & manyToMany.getName() & "Iterator")>
		<cfset compositeObject = getObjectManager().getObject(manyToMany.getLinkTo().getTo()) />

		<!--- clear out links --->
		<cfquery name="qUpdateTransfer" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
			DELETE FROM
				#manytomany.getTable()#
			WHERE
				#manytomany.getLinkFrom().getColumn()# =
			<cfswitch expression="#primaryKey.getType()#">
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
			<cfif manytomany.getCollection().hasCondition()>
				<cfset condition = manytomany.getCollection().getCondition() />
				AND
				#manytomany.getLinkTo().getColumn()# IN
				(
					SELECT #compositeObject.getPrimaryKey().getColumn()#
					FROM
					#compositeObject.getTable()#
					WHERE
					<cfif condition.hasWhere()>
						#getTQLConverter().replaceProperties(compositeObject, condition.getWhere())#
					<cfelse>
						<cfset property = compositeObject.getPropertyByName(condition.getProperty()) />
						#property.getColumn()# =
						<cfswitch expression="#property.getType()#">
							<cfcase value="numeric">
								<cfqueryparam value="#condition.getValue()#" cfsqltype="cf_sql_float">
							</cfcase>
							<cfcase value="date">
								<cfqueryparam value="#condition.getValue()#" cfsqltype="cf_sql_timestamp">
							</cfcase>
							<cfcase value="boolean">
								<cfqueryparam value="#condition.getValue()#" cfsqltype="cf_sql_bit">
							</cfcase>
							<cfcase value="uuid">
								<cfqueryparam value="#condition.getValue()#" cfsqltype="cf_sql_varchar">
							</cfcase>
							<cfcase value="guid">
								<cfqueryparam value="#condition.getValue()#" cfsqltype="cf_sql_varchar">
							</cfcase>
							<cfdefaultcase>
								<cfqueryparam value="#condition.getValue()#" cfsqltype="cf_sql_varchar">
							</cfdefaultcase>
						</cfswitch>
					</cfif>
				)
			</cfif>
		</cfquery>


		<!--- now go back through and reinsert the values --->
		<cfloop condition="#collectionIterator.hasNext()#">
			<cfscript>
				composite = collectionIterator.next();

				if(NOT composite.getIsPersisted())
				{
					throw("ManyToManyNotCreatedException",
							  "A ManyToMany TransferObject child is not persisted.",
							  "In TransferObject '"& object.getClassName() &"' manytomany '"& composite.getClassName() &"' has not been created in the database.");
				}

				value = invokeGetPrimaryKey(composite);
			</cfscript>
			<cfquery name="qUpdateTransfer" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
				INSERT INTO
					#manytomany.getTable()#
				(
					#manyToMany.getLinkFrom().getColumn()#,
					#manyToMany.getLinkTo().getColumn()#
				)
				VALUES
				(
					<cfswitch expression="#primaryKey.getType()#">
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
					,
					<cfswitch expression="#compositeObject.getPrimaryKey().getType()#">
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
				)
			</cfquery>
		</cfloop>

	</cfloop>
</cffunction>

<cffunction name="invokeGetPrimaryKey" hint="Gets the primary key value from an object" access="private" returntype="any" output="false">
	<cfargument name="transfer" hint="The transfer object to insert" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var object = getObjectManager().getObject(arguments.transfer.getClassName());

		return getMethodInvoker().invokeMethod(arguments.transfer, "get" & object.getPrimaryKey().getName());
	</cfscript>
</cffunction>

<!--- <cffunction name="getNullValueByPrimaryKey" access="private" returntype="string" output="false">
	<cfargument name="transfer" type="transfer.com.TransferObject" required="true" hint="The transferObject to get the null primary key value for">
	<cfscript>
		var object = getObjectManager().getObject(arguments.transfer.getClassName());
		var primaryKey = arguments.object.getPrimaryKey();

		switch(primaryKey.getType())
		{
			case "numeric":
				return getNullable().getNullNumeric(arguments.transfer, primaryKey.getName());
			break;
			case "uuid":
				return getNullable().getNullUUID(arguments.transfer, primaryKey.getName());
			break;
			case "guid":
				return getNullable().getNullGUID(arguments.transfer, primaryKey.getName());
			break;
			case "date":
				return getNullable().getNullDate(arguments.transfer, primaryKey.getName());
			break;
			case "boolean":
				return getNullable().getNullBoolean(arguments.transfer, primaryKey.getName());
			break;
			default:
				return getNullable().getNullString(arguments.transfer, primaryKey.getName());
		}
	</cfscript>
</cffunction> --->

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
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


<cffunction name="getNullable" access="private" returntype="Nullable" output="false">
	<cfreturn instance.Nullable />
</cffunction>

<cffunction name="setNullable" access="private" returntype="void" output="false">
	<cfargument name="Nullable" type="Nullable" required="true">
	<cfset instance.Nullable = arguments.Nullable />
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

<cffunction name="getTQLConverter" access="private" returntype="transfer.com.sql.TQLConverter" output="false">
	<cfreturn instance.TQLConverter />
</cffunction>

<cffunction name="setTQLConverter" access="private" returntype="void" output="false">
	<cfargument name="TQLConverter" type="transfer.com.sql.TQLConverter" required="true">
	<cfset instance.TQLConverter = arguments.TQLConverter />
</cffunction>

</cfcomponent>
