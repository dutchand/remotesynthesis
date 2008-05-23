<!--- Document Information -----------------------------------------------------

Title:      PropertyWriter.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Writes out the property definitions

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/04/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="PropertyWriter" hint="Writes out the property definitions" extends="AbstractBaseWriter">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="PropertyWriter" output="false">
	<cfargument name="objectManager" hint="The Object Manager" type="transfer.com.object.ObjectManager" required="Yes">
	<cfscript>
		super.init(objectManager);

		return this;
	</cfscript>
</cffunction>

<cffunction name="writePrimaryKey" hint="Writes the ID property getter and setters" access="public" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">

	<cfscript>
		writeGetter(arguments.buffer, arguments.object.getPrimaryKey());
		writeSetter(arguments.buffer, arguments.object.getPrimaryKey());
	</cfscript>
</cffunction>

<cffunction name="writeProperties" hint="Writes out the properties to the definition" access="public" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		var iterator = arguments.Object.getPropertyIterator();
		var property = 0;

		while(iterator.hasNext())
		{
			property = iterator.next();

			//write getter
			writeGetter(arguments.buffer, property);

			//write setter
			writeSetter(arguments.buffer, property);

			if(property.getIsNullable())
			{
				writeSetNull(arguments.buffer, property);
				writeGetIsNull(arguments.buffer, property);
			}
		}
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="writeGetter" hint="Writes the getter for a property" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="property" hint="The property to write the getter for" type="transfer.com.object.Property" required="Yes">
	<cfscript>
		arguments.buffer.writeCFFunctionOpen("get" & arguments.property.getName(), "public", arguments.property.getType());
		arguments.buffer.writeCFScriptBlock("return instance." & arguments.property.getName() & ";");
		arguments.buffer.writeCFFunctionClose();
	</cfscript>
</cffunction>


<cffunction name="writeSetter" hint="Writes the setter for a property" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="property" hint="The property to write the getter for" type="transfer.com.object.Property" required="Yes">
	<cfscript>
		var access = 0;

		if(property.getSet())
		{
			access = "public";
		}
		else
		{
			access = "private";
		}

		arguments.buffer.writeCFFunctionOpen("set" & arguments.property.getName(),access ,"void");
		arguments.buffer.writeCFArgument(property.getName(), arguments.property.getType(), true);
		arguments.buffer.cfScript(true);

		arguments.buffer.append("if(NOT StructKeyExists(instance, " & q() & arguments.property.getName() & q() & ") OR ");
		if(arguments.property.getType() neq "string")
		{
			arguments.buffer.append("get" & arguments.property.getName() & "() neq arguments." & arguments.property.getName());
		}
		else
		{
			arguments.buffer.append("Compare(get" & arguments.property.getName() & "(), arguments." & arguments.property.getName() & ") neq 0");
		}

		arguments.buffer.writeLine(")");

		arguments.buffer.writeline("{");
		arguments.buffer.writeLine("instance." & arguments.property.getName() & " = arguments." & arguments.property.getName() & ";");
		arguments.buffer.writeSetIsDirty(true);
		arguments.buffer.writeline("}");
		arguments.buffer.cfScript(false);
		arguments.buffer.writeCFFunctionClose();
	</cfscript>
</cffunction>

<cffunction name="writeSetNull" hint="Writes the set()Null on the object" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="property" hint="The property to write the null for for" type="transfer.com.object.Property" required="Yes">
	<cfscript>
		arguments.buffer.writeCFFunctionOpen("set" & arguments.property.getName() & "Null", "public" ,"void");
			arguments.buffer.cfscript(true);
				arguments.buffer.writeLine("var null = getNullable().getNull"& arguments.property.getType() & "(getClassName(), " & q() & arguments.property.getName() & q() & ");");
				arguments.buffer.writeLine("set" & arguments.property.getName() & "(null);");
			arguments.buffer.cfscript(false);
		arguments.buffer.writeCFFunctionClose();
	</cfscript>
</cffunction>

<cffunction name="writeGetIsNull" hint="Writes the get()IsNull on the object" access="private" returntype="void" output="false">
	<cfargument name="buffer" hint="The Buffer that the defintion file is being set in" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="property" hint="The property to write the getIsnull for for" type="transfer.com.object.Property" required="Yes">
	<cfscript>
		arguments.buffer.writeCFFunctionOpen("get" & arguments.property.getName() & "IsNull", "public" ,"boolean");
			arguments.buffer.cfscript(true);
				arguments.buffer.writeLine("return getNullable().checkNull"& arguments.property.getType() & "(getThisObject(), " & q() & arguments.property.getName() & q() & ", get" & arguments.property.getName() & "());");
			arguments.buffer.cfscript(false);
		arguments.buffer.writeCFFunctionClose();
	</cfscript>
</cffunction>

</cfcomponent>