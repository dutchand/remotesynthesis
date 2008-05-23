<!--- Document Information -----------------------------------------------------

Title:      TransferPopulator.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Populates a Transfer Object with Query Information

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		19/07/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="TransferPopulator" hint="Populates a Transfer Objects with Query information">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="TransferPopulator" output="false">
	<cfargument name="sqlManager" hint="The SQL Manager" type="transfer.com.sql.SQLManager" required="Yes">
	<cfargument name="objectManager" hint="Need to object manager for making queries" type="transfer.com.object.ObjectManager" required="Yes">
	<cfscript>
		setSQLManager(arguments.sqlManager);
		setObjectManager(arguments.objectManager);
		setMethodInvoker(createObject("component", "transfer.com.dynamic.MethodInvoker").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="populate" hint="Populates a Transfer object with query data" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer object to populate" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="key" hint="Key for the BO" type="string" required="Yes">

	<cfscript>
		var object = getObjectManager().getObject(arguments.transfer.getClassName());

		//pass the object over to the query maker, and get back the result
		var qObject = getSQLManager().getObjectQuery(object, arguments.key);

		//create memento from the result
		var memento = buildMemento(qObject);

		//if key not found, it will return an empty object
		if(not StructIsEmpty(memento))
		{
			//setMemento on the transfer object
			arguments.transfer.setMemento(memento);
		}

		//pass transferObject back out
		//return arguments.transfer;
	</cfscript>
</cffunction>

<cffunction name="populateManyToOne" hint="populates many to one data into the object for lazy load" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer to load into" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="name" hint="The name of the manytoone to load" type="string" required="Yes">
	<cfscript>
		var lazyObject = getObjectManager().getObjectLazyManyToOne(arguments.transfer.getClassName(), arguments.name);

		//get primary key
		var key = getMethodInvoker().invokeMethod(arguments.transfer, "get" & lazyObject.getPrimaryKey().getName());

		//pass the object over to the query maker, and get back the result
		var qObject = getSQLManager().getObjectQuery(lazyObject, key);
		var memento = buildMemento(qObject);
		var args = structNew();

		//build memento arguments
		args.memento = StructNew();

		if(StructKeyExists(memento, arguments.name))
		{
			args.memento = memento[arguments.name];
		}

		getMethodInvoker().invokeMethod(arguments.transfer, "set" & arguments.name & "Memento", args);
	</cfscript>
</cffunction>

<cffunction name="populateOneToMany" hint="populates onetomany data into the object for lazy load" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer to load into" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="name" hint="The name of the manytoone to load" type="string" required="Yes">
	<cfscript>
		var lazyObject = getObjectManager().getObjectLazyOneToMany(arguments.transfer.getClassName(), arguments.name);

		//get primary key
		var key = getMethodInvoker().invokeMethod(arguments.transfer, "get" & lazyObject.getPrimaryKey().getName());

		//pass the object over to the query maker, and get back the result
		var qObject = getSQLManager().getObjectQuery(lazyObject, key);

		var memento = buildMemento(qObject);
		var args = structNew();

		//build memento arguments
		args.memento = ArrayNew(1);

		if(StructKeyExists(memento, arguments.name))
		{
			args.memento = memento[arguments.name];
		}

		getMethodInvoker().invokeMethod(arguments.transfer, "set" & arguments.name & "Memento", args);
	</cfscript>
</cffunction>

<cffunction name="populateManyToMany" hint="populates manytomany data into the object for lazy load" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer to load into" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="name" hint="The name of the manytoone to load" type="string" required="Yes">
	<cfscript>
		var lazyObject = getObjectManager().getObjectLazyManyToMany(arguments.transfer.getClassName(), arguments.name);

		//get primary key
		var key = getMethodInvoker().invokeMethod(arguments.transfer, "get" & lazyObject.getPrimaryKey().getName());

		//pass the object over to the query maker, and get back the result
		var qObject = getSQLManager().getObjectQuery(lazyObject, key);

		var memento = buildMemento(qObject);
		var args = structNew();

		//build memento arguments
		args.memento = ArrayNew(1);

		if(StructKeyExists(memento, arguments.name))
		{
			args.memento = memento[arguments.name];
		}

		getMethodInvoker().invokeMethod(arguments.transfer, "set" & arguments.name & "Memento", args);
	</cfscript>
</cffunction>

<cffunction name="populateParentOneToMany" hint="populates parent onetomany data into the object for lazy load" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer to load into" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="name" hint="The name of the external onetomany to load" type="string" required="Yes">
	<cfscript>
		var lazyObject = getObjectManager().getObjectLazyParentOneToMany(arguments.transfer.getClassName());

		//get primary key
		var key = getMethodInvoker().invokeMethod(arguments.transfer, "get" & lazyObject.getPrimaryKey().getName());

		//pass the object over to the query maker, and get back the result
		var qObject = getSQLManager().getObjectQuery(lazyObject, key);

		var args = structNew();

		//build memento arguments
		args.memento = buildMemento(qObject);

		getMethodInvoker().invokeMethod(arguments.transfer, "set" & arguments.name & "Memento", args);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="buildMemento" hint="Builds a memento from a object and query" access="private" returntype="struct" output="false">
	<cfargument name="qObject" hint="The query that has the data" type="query" required="Yes">
	<cfscript>
		var object = 0;
		var parentClassName = 0;
		var parentCompositeName = 0;
		var compositeName = 0;
		var isArray = 0;
		var parentKey = 0;
		//var qExternalObjects = 0;
		var parentOneToMany = 0;
		var mementoPart = 0;
		var key = 0;
		var parentObject = 0;
		var iterator = 0;
		var property = 0;
		var mementoBuilder = createObject("component", "transfer.com.dynamic.MementoBuilder").init(getObjectManager(), arguments.qObject);

		//throw exception if empty
		if(NOT arguments.qObject.recordCount)
		{
			throw("EmptyQueryException", "The query provided to populate this transfer is empty", "It is likely the ID that has been selected for this query no longer exists");
		}
	</cfscript>

	<cfloop query="arguments.qObject">
		<cfscript>
			object = getObjectManager().getObject(transfer_className);
			parentClassName = transfer_parentClassName;
			isArray = transfer_isArray;
			compositeName = transfer_compositeName;
			parentParentClassName = transfer_parentParentClassName;

			if(Len(parentClassName))
			{
				parentKey = transfer_parentKey;
				parentCompositeName = transfer_parentCompositeName;
			}

			mementoPart = StructNew();

			//do id, set it aside
			//key = arguments.qObject[object.getPrimaryKey().getColumn()][arguments.qObject.currentRow];
			key = getPropertyColumnValue(arguments.qObject, object, object.getPrimaryKey());

			mementoPart[object.getPrimaryKey().getName()] = key;

			//tell it that it is not dirty, and is persisted
			mementoPart.transfer_isDirty = false;
			mementoPart.transfer_isPersisted = true;

			//loop throough properties
			iterator = object.getPropertyIterator();

			while(iterator.hasNext())
			{
				property = iterator.next();
				//mementoPart[property.getName()] = arguments.qObject[property.getColumn()][arguments.qObject.currentRow];
				mementoPart[property.getName()] = getPropertyColumnValue(arguments.qObject, object, property);
			}

			//loop through qExternalObjects
			iterator = object.getParentOneToManyIterator();
			while(iterator.hasNext())
			{
				parentOneToMany = iterator.next();

				parentObject = getObjectManager().getObject(parentOneToMany.getLink().getTo());

				mementoPart["parent"& parentObject.getObjectName() & "_" & parentObject.getPrimaryKey().getName()] = arguments.qObject[parentOneToMany.getLink().getColumn()][arguments.qObject.currentRow];
			}

			//add the details to the memento objects
			mementoBuilder.add(compositeName, key, object.getClassName(), isArray, mementoPart, parentClassName, parentKey, parentCompositeName, parentParentClassName);
		</cfscript>
	</cfloop>

	<cfreturn mementoBuilder.getMementoStruct()>
</cffunction>

<cffunction name="getPropertyColumnValue" hint="Returns the column value, but returns the default null value for the item if it is NULL" access="private" returntype="any" output="false">
	<cfargument name="query" hint="The query we are looking at" type="query" required="Yes">
	<cfargument name="object" hint="The property to get the value for" type="transfer.com.object.Object" required="Yes">
	<cfargument name="property" hint="The property to get the value for" type="transfer.com.object.Property" required="Yes">
	<cfscript>
		var value = 0;

		switch(property.getType())
		{
			//only do this for booleans, for postgres
			case "boolean":
				value =	arguments.query.getBoolean(arguments.property.getColumn());
			break;
			case "uuid":
			case "guid":
				value = UCase(arguments.query.getString(arguments.property.getColumn()));
			break;
			default:
				value =	arguments.query.getString(arguments.property.getColumn());
			break;
		}

		if(arguments.query.wasNull())
		{
			return getSQLManager().getNullable().getNullValue(arguments.object.getClassName(), arguments.property.getName());
		}

		return value;
	</cfscript>
</cffunction>

<cffunction name="getSQLManager" access="private" returntype="transfer.com.sql.SQLManager" output="false">
	<cfreturn instance.SQLManager />
</cffunction>

<cffunction name="setSQLManager" access="private" returntype="void" output="false">
	<cfargument name="SQLManager" type="transfer.com.sql.SQLManager" required="true">
	<cfset instance.SQLManager = arguments.SQLManager />
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

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>

</cfcomponent>