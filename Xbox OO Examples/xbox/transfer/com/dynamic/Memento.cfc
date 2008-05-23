<!--- Document Information -----------------------------------------------------

Title:      Memento.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Builds the tree structure for building mementos for TransferObject population

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		18/04/2006		Created

------------------------------------------------------------------------------->

<cfcomponent name="Memento" hint="Builds the tree structure for building mementos for TransferObject population">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Memento" output="false">
	<cfargument name="className" hint="The name of the class this represents" type="string" required="Yes">
	<cfargument name="valueStruct" hint="The struct of values for this memento part" type="struct" required="Yes">

	<cfscript>
		setClassName(arguments.className);
		setValueStruct(arguments.valueStruct);
		setChildren(StructNew());

		return this;
	</cfscript>
</cffunction>

<cffunction name="addChild" hint="Adds a child set of values to this memento" access="public" returntype="void" output="false">
	<cfargument name="compositeName" hint="The name of the composite structure" type="string" required="Yes">
	<cfargument name="isArray" hint="if it is an array or not" type="boolean" required="Yes">
	<cfargument name="child" hint="The chlid to add" type="transfer.com.dynamic.Memento" required="Yes">
	<cfscript>
		var position = 0;

		//ArrayAppend(getChildren(), arguments.child);
		if(NOT StructKeyExists(getChildren(), arguments.compositeName))
		{
			StructInsert(getChildren(), arguments.compositeName, StructNew());
			position = StructFind(getChildren(), arguments.compositeName);

			position.isArray = arguments.isArray;
			position.collection = ArrayNew(1);
		}

		position = StructFind(getChildren(), arguments.compositeName);

		ArrayAppend(position.collection, arguments.child);
	</cfscript>
</cffunction>

<cffunction name="getMemento" hint="Returns the struct value of this memento and its children" access="public" returntype="struct" output="false">
	<cfscript>
		var memento = StructNew();
		var keyIterator = StructKeyArray(getChildren()).iterator();
		var key = 0;
		var iterator = 0;
		var child = 0;
		var position = 0;

		StructAppend(memento, getValueStruct());

		while(keyIterator.hasNext())
		{
			key = keyIterator.next();
			position = StructFind(getChildren(), key);

			iterator = position.collection.iterator();

			while(iterator.hasNext())
			{
				child = iterator.next();

				if(position.isArray) //if an array, loop through and add the bits
				{
					if(NOT StructKeyExists(memento, key))
					{
						memento[key] = ArrayNew(1);
					}
					ArrayAppend(memento[key], child.getMemento());
				}
				else
				{
					memento[key] = child.getMemento();
				}
			}
		}

		return memento;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->


<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getClassName" access="private" returntype="string" output="false">
	<cfreturn instance.ClassName />
</cffunction>

<cffunction name="setClassName" access="private" returntype="void" output="false">
	<cfargument name="ClassName" type="string" required="true">
	<cfset instance.ClassName = arguments.ClassName />
</cffunction>

<cffunction name="getValueStruct" access="private" returntype="struct" output="false">
	<cfreturn instance.ValueStruct />
</cffunction>

<cffunction name="setValueStruct" access="private" returntype="void" output="false">
	<cfargument name="ValueStruct" type="struct" required="true">
	<cfset instance.ValueStruct = arguments.ValueStruct />
</cffunction>

<cffunction name="getChildren" access="private" returntype="struct" output="false">
	<cfreturn instance.Children />
</cffunction>

<cffunction name="setChildren" access="private" returntype="void" output="false">
	<cfargument name="Children" type="struct" required="true">
	<cfset instance.Children = arguments.Children />
</cffunction>

</cfcomponent>