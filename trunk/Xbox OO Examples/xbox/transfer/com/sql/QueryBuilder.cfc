<!--- Document Information -----------------------------------------------------

Title:      QueryBuilder.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Builds a query out of BO Data

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		19/07/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="QueryBuilder" hint="Builds a Query out of BO data">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="QueryBuilder" output="false">
	<cfargument name="objectManager" hint="The object manager to query" type="transfer.com.object.ObjectManager" required="Yes">
	<cfargument name="tQLConverter" hint="Converter for {property} statements" type="transfer.com.sql.TQLConverter" required="Yes">
	<cfscript>
		setObjectManager(arguments.objectManager);
		setTQLConverter(arguments.tQLConverter);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getObjectSQL" hint="Creates the SQL for the Object BO" access="public" returntype="string" output="false">
	<cfargument name="Object" hint="The Object BO" type="transfer.com.object.Object" required="Yes">

	<cfscript>
		var columnStruct = buildColumnStruct(arguments.object); //meta data for the tables and columns

		var fromSQL = buildInitialFromSQL(arguments.object); //create the from sql
		var whereSQL = buildWhere(arguments.object); //where clause

		//put it all together
		return buildSQL(arguments.object, columnStruct, fromSQL ,whereSQL).toString();
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->
<cffunction name="buildColumnStruct" hint="Builds an struct with a key on table, with an array inside of each column, with type and column" access="private" returntype="struct" output="false">
	<cfargument name="object" hint="The BO of the object to build the list to" type="transfer.com.object.Object" required="Yes">
	<cfargument name="columnStruct" hint="Struct of Arrays defining tables and their columns" type="struct" required="No" default="#StructNew()#">
	<cfargument name="visitedClasses" hint="Array of class names that have been visited" type="array" required="No" default="#arrayNew(1)#">
	<cfargument name="compositionName" hint="The name of the composition" type="string" required="no" default="">

	<cfscript>
		var iterator = arguments.object.getPropertyIterator();
		var property = 0;
		var manytomany = 0;
		var manytoone = 0;
		var onetomany = 0;
		//var qExternalObjects = getObjectManager().getClassName ByOneToManyLinkTo(arguments.object.getClassName());
		var parentOneToMany = 0;
		var parentObject = 0;

		//if we have visited here before, return the columnArray
		if(arguments.visitedClasses.contains(arguments.object.getClassName() & ":" & arguments.compositionName))
		{
			/*
				Throw an exception at this point to
				show that lazy loading should be used,
				so as tables don't refer back to themselves
			*/
			throw("RecursiveCompositionException",
				"The structure of your configuration file causes an infinite loop",
				"The object '#arguments.object.getClassName()#' has a recursive link back to itself through composition '#arguments.compositionName#'.
				You will need to set one of the elements in this chain to lazy='true' for it to work.");
		}

		//add in this object as visited
		arrayAppend(arguments.visitedClasses, arguments.object.getClassName() & ":" & arguments.compositionName);

		//list properties
		if(NOT StructKeyExists(arguments.columnStruct, arguments.object.getTable()))
		{
			arguments.columnStruct[arguments.object.getTable()] = ArrayNew(1);
		}

		//a structure with the type, and the column

		//add in the primary key
		ArrayAppend(arguments.columnStruct[arguments.object.getTable()], createColumnMeta(arguments.object.getPrimaryKey()));

		while(iterator.hasNext())
		{
			property = iterator.next();
			ArrayAppend(arguments.columnStruct[arguments.object.getTable()], createColumnMeta(property));
		}

		//do external one to many links
		iterator = arguments.object.getParentOneToManyIterator();
		while(iterator.hasNext())
		{
			parentOneToMany = iterator.next();

			parentObject = getObjectManager().getObject(parentOneToMany.getLink().getTo());

			ArrayAppend(arguments.columnStruct[arguments.object.getTable()], createColumnMeta(parentObject.getPrimaryKey(), parentOneToMany.getLink().getColumn()));
		}

		//now follow out many to one
		iterator = arguments.object.getManyToOneIterator();
		while(iterator.hasNext())
		{
			manytoone = iterator.next();

			if(NOT manytoone.getIsLazy())
			{
				//punch it out to the next object
				buildColumnStruct(getObjectManager().getObject(manytoone.getLink().getTo()), arguments.columnStruct, arguments.visitedClasses, manytoone.getName());
			}
		}

		//now follow out many to many's
		iterator = arguments.object.getManyToManyIterator();
		while(iterator.hasNext())
		{
			manytomany = iterator.next();

			if(NOT manytomany.getIsLazy())
			{
				//punch it out to the next object
				buildColumnStruct(getObjectManager().getObject(manytomany.getLinkTo().getTo()), arguments.columnStruct, arguments.visitedClasses, manytomany.getName());
			}
		}

		//now follow out to one to many's
		iterator = arguments.object.getOneToManyIterator();
		while(iterator.hasNext())
		{
			onetomany = iterator.next();

			if(NOT onetomany.getIsLazy())
			{
				//punch it out to the next object
				buildColumnStruct(getObjectManager().getObject(onetomany.getLink().getTo()), arguments.columnStruct, arguments.visitedClasses, onetomany.getName());
			}
		}

		return arguments.columnStruct;
	</cfscript>
</cffunction>

<cffunction name="createColumnMeta" hint="Builds the Column meta data. Struct returned with column name (column), and type (type)" access="private" returntype="struct" output="false">
	<cfargument name="property" hint="The property to get the type from" type="transfer.com.object.Property" required="Yes">
	<cfargument name="column" hint="The column to set" type="string" required="No" default="#arguments.property.getColumn()#">
	<cfscript>
		var part = StructNew();
		part.column = arguments.column;
		part.type = arguments.property.getType();

		return part;
	</cfscript>
</cffunction>

<cffunction name="buildSQL" hint="Builds the SQL via a stringBuffer" access="private" returntype="any" output="false">
	<cfargument name="object" hint="The BO of the object to build the list to" type="transfer.com.object.Object" required="Yes">
	<cfargument name="columnStruct" hint="Struct of Arrays that defines tables and columns" type="struct" required="Yes">
	<cfargument name="fromSQL" hint="String that contains the from statement" type="string" required="Yes">
	<cfargument name="whereSQL" hint="The WHERE clause of the SQL" type="string" required="Yes">
	<cfargument name="parentCompositeName" hint="The paren't composite name" type="string" required="no" default="">
	<cfargument name="parentObject" hint="The parent object to set the item to" type="transfer.com.object.Object" required="No" default="#arguments.object#">
	<cfargument name="parentParentClass" hint="parent class 2 levels up" type="string" required="no" default="">
	<cfargument name="buffer" hint="java.lang.StringBuffer class for the sql" type="any" required="No" default="#createObject('Java', 'java.lang.StringBuffer')#">
	<cfargument name="visitedClasses" hint="Array of class names that have been visited" type="array" required="No" default="#arrayNew(1)#">
	<cfargument name="orderIndex" hint="The order index of this select" type="numeric" required="No" default="1">
	<cfargument name="compositeName" hint="The name of the composite structure" type="string" required="No" default="">
	<cfargument name="isArray" hint="is this memento part of an array?" type="boolean" required="No" default="false">
	<cfargument name="orderBuffer" hint="java.land.StringBuffer that tracks order by statement" type="any" required="no" default="#createObject('Java', 'java.lang.StringBuffer').init('ORDER BY transfer_orderIndex ASC')#">

	<cfscript>
		var iterator = arguments.object.getPropertyIterator();
		var property = 0;
		var manytomany = 0;
		var manytoone = 0;
		var onetomany = 0;
		var composite = 0;
		var parentClassName = "";
		var nextOrderIndex = arguments.orderIndex + 1;
		var where = 0;

		//if we have visited here before, return the columnArray
		if(arguments.visitedClasses.contains(arguments.compositeName & ":" & arguments.object.getClassName()))
		{
			return arguments.buffer;
		}

		//add in this object as visited
		arrayAppend(arguments.visitedClasses, arguments.compositeName & ":" & arguments.object.getClassName());

		//set up some values
		//if(arguments.parentObject.getClassName() neq arguments.object.getClassName())
		if(arguments.orderIndex neq 1)
		{
			parentClassName = arguments.parentObject.getClassName();
		}

		//start with SELECT
		arguments.buffer.append("SELECT ");

		buildSelect(arguments.buffer, arguments.object, arguments.parentObject, arguments.columnStruct, arguments.orderIndex);

		arguments.buffer.append(arguments.orderIndex & " as transfer_orderIndex,");
		arguments.buffer.append("'" & arguments.object.getClassName() & "' as transfer_className,");

		arguments.buffer.append("'" & parentClassName & "' as transfer_parentClassName,");

		arguments.buffer.append("'" & arguments.parentParentClass & "' as transfer_parentParentClassName,");

		arguments.buffer.append("'" & arguments.parentCompositeName & "' as transfer_parentCompositeName,");

		arguments.buffer.append("'" & arguments.isArray & "' as transfer_isArray,");

		arguments.buffer.append("'" & arguments.compositeName & "' as transfer_compositeName");

		//add from
		arguments.buffer.append(" FROM ");

		arguments.buffer.append(arguments.fromSQL);

		//WHERE
		arguments.buffer.append(" WHERE ");
		arguments.buffer.append(createTableName(arguments.object.getTable(), arguments.orderIndex) & "." & arguments.object.getPrimaryKey().getColumn() & " IS NOT NULL");

		arguments.buffer.append(" AND ");
		arguments.buffer.append(arguments.whereSQL);

		//end with UNION ALL
		arguments.buffer.append(" UNION ALL ");

		//follow out out to many to ones
		iterator = arguments.object.getManyToOneIterator();
		while(iterator.hasNext())
		{
			manytoone = iterator.next();

			composite = getObjectManager().getObject(manytoone.getLink().getTo());

			if(NOT manytoone.getIsLazy())
			{

				//punch it out to the next object
				buildSQL(composite,
							arguments.columnStruct,
							buildManyToOneFromSQL(arguments.object, composite, manytoone,arguments.fromSQL, nextOrderIndex), //build from sql
							arguments.whereSQL,
							arguments.compositeName,
							arguments.object,
							parentClassName,
							arguments.buffer,
							arguments.visitedClasses,
							nextOrderIndex,
							manytoone.getName(),
							false,
							arguments.orderBuffer
							);
			}
		}

		//follow out the one to many
		iterator = arguments.object.getOneToManyIterator();
		while(iterator.hasNext())
		{
			onetomany = iterator.next();

			if(NOT onetomany.getIsLazy())
			{
				composite = getObjectManager().getObject(onetomany.getLink().getTo());

				buildOrder(arguments.orderBuffer, onetoMany.getCollection(), composite);

				where = arguments.whereSQL;
				if(onetomany.getCollection().hasCondition())
				{
					where = buildConditionSQL(composite, onetomany.getCollection().getCondition(), nextOrderIndex) & " AND " & arguments.whereSQL;
				}

				//punch it out to the next object
				buildSQL(composite,
							arguments.columnStruct,
							buildOneToManyFromSQL(arguments.object, composite, onetomany, arguments.fromSQL, nextOrderIndex), //build from sql
							where,
							arguments.compositeName,
							arguments.object,
							parentClassName,
							arguments.buffer,
							arguments.visitedClasses,
							nextOrderIndex,
							onetomany.getName(),
							true,
							arguments.orderBuffer
							);
			}

		}

		//now follow out many to many's
		iterator = arguments.object.getManyToManyIterator();
		while(iterator.hasNext())
		{
			manytomany = iterator.next();

			if(NOT manytomany.getIsLazy())
			{
				composite = getObjectManager().getObject(manytomany.getLinkTo().getTo());

				buildOrder(arguments.orderBuffer, manyToMany.getCollection(), composite);

				where = arguments.whereSQL;
				if(manytomany.getCollection().hasCondition())
				{
					where = buildConditionSQL(composite, manytomany.getCollection().getCondition(), nextOrderIndex) & " AND " & arguments.whereSQL;
				}

				//punch it out to the next object
				buildSQL(composite,
							arguments.columnStruct,
							buildManyToManyFromSQL(arguments.object, composite, manyToMany, arguments.fromSQL, nextOrderIndex), //build from sql
							where,
							arguments.compositeName,
							arguments.object,
							parentClassName,
							arguments.buffer,
							arguments.visitedClasses,
							nextOrderIndex,
							manytomany.getName(),
							true,
							arguments.orderBuffer
							);
			}
		}

		if(arguments.orderIndex eq 1) //is first, so will be added last
		{
			//drop off the last UNION ALL (9 chars)
			arguments.buffer.delete(javaCast("int", arguments.buffer.length() - 10), arguments.buffer.length());

			//add the order by
			arguments.buffer.append(arguments.orderBuffer);
		}

		return arguments.buffer;
	</cfscript>
</cffunction>

<cffunction name="buildInitialFromSQL" hint="Builds the initial from SQL" access="private" returntype="string" output="false">
	<cfargument name="object" hint="The BO of the object to build FROM from" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		//we know it's 1
		return arguments.object.getTable() & " " & createTableName(arguments.object.getTable(), 1);
	</cfscript>
</cffunction>

<cffunction name="buildOneToManyFromSQL" hint="Builds the from SQL for a One to Many SQL" access="private" returntype="string" output="false">
	<cfargument name="object" hint="The original object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="composite" hint="The composite object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="oneToMany" hint="The one to many connector" type="transfer.com.object.OneToMany" required="Yes">
	<cfargument name="fromSQL" hint="The from SQL already written" type="string" required="Yes">
	<cfargument name="orderIndex" hint="The order index of this select" type="numeric" required="Yes">

	<cfscript>
		var buffer = createObject("Java", "java.lang.StringBuffer").init(arguments.fromSQL);
		var compositeTable = createTableName(arguments.composite.getTable(), arguments.orderIndex);
		var objectTable = createTableName(arguments.object.getTable(), arguments.orderIndex - 1);

		buffer.append(" LEFT JOIN " & arguments.composite.getTable() & " " & compositeTable);
		buffer.append(" ON " & objectTable & "." & arguments.object.getPrimaryKey().getColumn());
		buffer.append(" = " & compositeTable & "." & arguments.onetomany.getLink().getColumn());

		return buffer.toString();
	</cfscript>
</cffunction>

<cffunction name="buildManyToOneFromSQL" hint="Builds the from SQL for many to one composition" access="private" returntype="string" output="false">
	<cfargument name="object" hint="The original object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="composite" hint="The composite object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="manyToOne" hint="The many to many connector" type="transfer.com.object.ManyToOne" required="Yes">
	<cfargument name="fromSQL" hint="The from SQL already written" type="string" required="Yes">
	<cfargument name="orderIndex" hint="The order index of this select" type="numeric" required="Yes">

	<cfscript>
		var buffer = createObject("Java", "java.lang.StringBuffer").init(arguments.fromSQL);
		var compositeTable = createTableName(arguments.composite.getTable(), arguments.orderIndex);
		var objectTable = createTableName(arguments.object.getTable(), arguments.orderIndex - 1);

		buffer.append(" LEFT JOIN " & arguments.composite.getTable() & " " & compositeTable);
		buffer.append(" ON " & objectTable & "." & arguments.manyToOne.getLink().getColumn());
		buffer.append(" = " & compositeTable & "." & arguments.composite.getPrimaryKey().getColumn());

		return buffer.toString();
	</cfscript>
</cffunction>

<cffunction name="buildManyToManyFromSQL" hint="Builds the from SQL from a many to many composition" access="private" returntype="string" output="false">
	<cfargument name="object" hint="The original object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="composite" hint="The composite object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="manyToMany" hint="The many to many connector" type="transfer.com.object.ManyToMany" required="Yes">
	<cfargument name="fromSQL" hint="The from SQL already written" type="string" required="Yes">
	<cfargument name="orderIndex" hint="The order index of this select" type="numeric" required="Yes">

	<cfscript>
		var buffer = createObject("Java", "java.lang.StringBuffer").init(arguments.fromSQL);
		var compositeTable = createTableName(arguments.composite.getTable(), arguments.orderIndex);
		var objectTable = createTableName(arguments.object.getTable(), arguments.orderIndex - 1);
		var manytomanyTable = createTableName(arguments.manytomany.getTable(), arguments.orderIndex);

		//first part
		buffer.append(" LEFT JOIN " & arguments.manytomany.getTable() & " " & manytomanyTable);
		buffer.append(" ON " & objectTable & "." & arguments.object.getPrimaryKey().getColumn());
		buffer.append(" = " & manytomanyTable & "." & arguments.manyToMany.getLinkFrom().getColumn());

		//second part
		buffer.append(" LEFT JOIN ");
		buffer.append(arguments.composite.getTable() & " " & compositeTable);
		buffer.append(" ON " & manytomanyTable & "." & manyToMany.getLinkTo().getColumn());
		buffer.append(" = " & compositeTable & "." & arguments.composite.getPrimaryKey().getColumn());

		return buffer.toString();
	</cfscript>
</cffunction>

<cffunction name="buildWhere" hint="Builds a WHERE statement" access="private" returntype="string" output="false">
	<cfargument name="object" hint="The BO of the object to build the list to" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		var buffer = createObject("Java", "java.lang.StringBuffer").init();

		//we know it's 1
		buffer.append(createTableName(object.getTable(), 1));
		buffer.append(".");
		buffer.append(object.getPrimaryKey().getColumn());
		buffer.append(" = ?");

		return buffer.toString();
	</cfscript>
</cffunction>

<cffunction name="buildSelect" hint="Builds the column list part of the SELECT for a given object" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="java.lang.StringBuffer class for the sql" type="any" required="Yes">
	<cfargument name="object" hint="The BO of the object to build the list to" type="transfer.com.object.Object" required="Yes">
	<cfargument name="parentObject" hint="The parent object to set the item to" type="transfer.com.object.Object" required="Yes">
	<cfargument name="columnStruct" hint="Struct of Arrays defining the columns" type="struct" required="yes">
	<cfargument name="orderIndex" hint="The order index of this select" type="numeric" required="Yes">
	<cfscript>
		//lets loop around the column Struct
		var keyArray = StructKeyArray(arguments.columnStruct);
		var table = 0;
		var iterator = keyArray.iterator();
		var columnIterator = 0;
		var column = 0;
		var isNull = true;
		var columnArray = ArrayNew(1);
		var duplicateArray = buildDuplicateArray(arguments.columnStruct);
		var currentTableColumns = arguments.columnStruct[arguments.object.getTable()];
		var currentTableName = createTableName(arguments.object.getTable(), arguments.orderIndex);

		while(iterator.hasNext())
		{
			table = iterator.next();

			//are we in the same table?
			isNull = table neq arguments.object.getTable();

			columnIterator = arguments.columnStruct[table].iterator();

			while(columnIterator.hasNext())
			{
				column = columnIterator.next();

				//if the column is duplicate
				if(duplicateArray.contains(column.column))
				{
					//add column to list
					//if you are a duplicate and you have yet to be set - 'table.column'
					if(NOT columnArray.contains(column.column))
					{
						//if the active table has the column, display it
						if(currentTableColumns.contains(column))
						{
							arguments.buffer.append(currentTableName & ".");
						}
						else
						{
							arguments.buffer.append(writeNULL(column.column, column.type) & " as ");
						}
						arguments.buffer.append(column.column & ", ");

						ArrayAppend(columnArray, column.column);
					}
					//if you are a duplicate and you have been set - do nothing
				}
				else
				{
					//if you are not a duplicate, and isNull, 'Null as ...'
					if(isNull)
					{
						arguments.buffer.append(writeNULL(column.column, column.type) & " as ");
					}
					else //if you are not a duplicate and NOT is Null, 'table.column'
					{
						arguments.buffer.append(currentTableName & ".");
					}
					arguments.buffer.append(column.column & ", ");
				}
			}
		}

		//if(arguments.object.getClassName() neq arguments.parentObject.getClassName())
		if(arguments.orderIndex neq 1)
		{
			arguments.buffer.append(cast(createTableName(arguments.parentObject.getTable(), arguments.orderIndex -1) & "." & arguments.parentObject.getPrimaryKey().getColumn(), "varchar"));
			arguments.buffer.append(" as transfer_parentKey");
		}
		else
		{
			arguments.buffer.append(writeNULL(arguments.parentObject.getPrimaryKey().getColumn(), "string"));
			arguments.buffer.append(" as transfer_parentKey");
		}
		arguments.buffer.append(", ");
	</cfscript>
</cffunction>

<cffunction name="cast" hint="Cast the value of this to another value" access="public" returntype="string" output="false">
	<cfargument name="column" hint="The column to write the 'NULL' for" type="string" required="Yes">
	<cfargument name="type" hint="Type to cast it to" type="string" required="Yes">
	<cfset throw("VirtualMethodException", "This method is virtual and should be overwritten", "Overwrite this method dumbass.") />
</cffunction>

<cffunction name="writeNULL" hint="Overwrite to implement database specific NULL string text." access="private" returntype="string" output="false">
	<cfargument name="column" hint="The column to write the 'NULL' for" type="string" required="Yes">
	<cfargument name="type" hint="The type to write the 'NULL' for" type="string" required="Yes">
	<cfreturn "NULL">
</cffunction>

<cffunction name="buildDuplicateArray" hint="builds the array of values that have duplicate columns" access="private" returntype="array" output="false">
	<cfargument name="columnStruct" hint="Struct of Arrays defining the columns" type="struct" required="yes">
	<cfscript>
		//create an array of all the column names
		var duplicateArray = arrayNew(1);
		var columnArray = ArrayNew(1);
		var keyArray = StructKeyArray(arguments.columnStruct);
		var iterator = keyArray.iterator();
		var columnIterator = 0;
		var Collections = createObject("Java", "java.util.Collections");
		var len = 0;
		var counter = 1;

		while(iterator.hasNext())
		{
			columnIterator = arguments.columnStruct[iterator.next()].iterator();
			while(columnIterator.hasNext())
			{
				column = columnIterator.next();

				ArrayAppend(columnArray, column.column);
			}
		}
		//sort them
		Collections.sort(columnArray);

		//find all the duplicates and push them into a new array
		len = ArrayLen(columnArray) - 1;
		for(; counter lte len; counter = counter + 1)
		{
			if(columnArray[counter] eq columnArray[counter + 1])
			{
				ArrayAppend(duplicateArray, columnArray[counter]);
				counter = counter + 1;
			}
		}

		return duplicateArray;
	</cfscript>
</cffunction>

<cffunction name="buildOrder" hint="Builds the ORDER BY part of the sql" access="private" returntype="string" output="false">
	<cfargument name="orderBuffer" hint="The java.util.StringBuffer for order bys" type="any" required="Yes">
	<cfargument name="collection" hint="The collection that is being created" type="transfer.com.object.Collection" required="Yes">
	<cfargument name="object" hint="The Object that is being created in the collection" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		var property = 0;
		if(arguments.collection.hasOrder())
		{
			property = arguments.object.getPropertyByName(arguments.collection.getOrder().getProperty());

			//make sure we're not already ordering by it
			if(NOT FindNoCase(" " & property.getColumn() & " ", arguments.orderBuffer.toString()))
			{
				arguments.orderBuffer.append(", " & property.getColumn() & " " & arguments.collection.getOrder().getOrder());
			}
		}
	</cfscript>
</cffunction>

<cffunction name="createTableName" hint="Creates a table name from the table and hte orderindex" access="private" returntype="string" output="false">
	<cfargument name="table" hint="The name of the table" type="string" required="Yes">
	<cfargument name="orderIndex" hint="The order Index" type="numeric" required="Yes">
	<cfreturn arguments.table & "_" & arguments.orderIndex>
</cffunction>

<cffunction name="buildConditionSQL" hint="Builds the where statement for a condition" access="private" returntype="string" output="false">
	<cfargument name="object" hint="The Object that is being created in the collection" type="transfer.com.object.Object" required="Yes">
	<cfargument name="condition" hint="The condition" type="transfer.com.object.Condition" required="Yes">
	<cfargument name="orderIndex" hint="The order index" type="numeric" required="Yes">
	<cfscript>
		var table = createTableName(arguments.object.getTable(), arguments.orderIndex);

		if(arguments.condition.hasProperty())
		{
			return table & "." & object.getPropertyByName(arguments.condition.getProperty()).getColumn() & " = '" & arguments.condition.getValue() & "'";
		}

		return getTQLConverter().replaceProperties(arguments.object, arguments.condition.getWhere(), table);
	</cfscript>
</cffunction>

<cffunction name="getObjectManager" access="private" returntype="transfer.com.object.ObjectManager" output="false">
	<cfreturn instance.ObjectManager />
</cffunction>

<cffunction name="setObjectManager" access="private" returntype="void" output="false">
	<cfargument name="ObjectManager" type="transfer.com.object.ObjectManager" required="true">
	<cfset instance.ObjectManager = arguments.ObjectManager />
</cffunction>

<cffunction name="getTQLConverter" access="private" returntype="transfer.com.sql.TQLConverter" output="false">
	<cfreturn instance.TQLConverter />
</cffunction>

<cffunction name="setTQLConverter" access="private" returntype="void" output="false">
	<cfargument name="TQLConverter" type="transfer.com.sql.TQLConverter" required="true">
	<cfset instance.TQLConverter = arguments.TQLConverter />
</cffunction>

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>

</cfcomponent>