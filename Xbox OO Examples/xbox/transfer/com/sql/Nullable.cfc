<!--- Document Information -----------------------------------------------------

Title:      DefaultNullable.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Handles DefaultNull values

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		17/07/2006		Created

------------------------------------------------------------------------------->

<cfcomponent name="DefaultNullable" hint="Handles DefaultNull values">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Nullable" output="false">
	<cfargument name="objectManager" hint="The object manager to query" type="transfer.com.object.ObjectManager" required="Yes">
	<cfscript>
		setObjectManager(arguments.objectManager);

		//setup system wide default
		setDefaultNullBoolean(false);
		setDefaultNullDate(createDate(100, 1, 1));
		setDefaultNullString("");
		setDefaultNullNumeric(0);
		setDefaultNullUUID("00000000-0000-0000-0000000000000000");
		setDefaultNullGUID("00000000-0000-0000-0000-000000000000");

		return this;
	</cfscript>
</cffunction>

<cffunction name="setMemento" hint="Sets the state of the object" access="public" returntype="void" output="false">
	<cfargument name="memento" hint="the state to be set" type="struct" required="Yes">
	<cfscript>
		if(StructKeyExists(arguments.memento, "string"))
		{
			setDefaultNullString(arguments.memento.string);
		}
		if(StructKeyExists(arguments.memento, "numeric"))
		{
			setDefaultNullNumeric(arguments.memento.numeric);
		}
		if(StructKeyExists(arguments.memento, "date"))
		{
			setDefaultNullDate(ParseDateTime(arguments.memento.date));
		}
		if(StructKeyExists(arguments.memento, "boolean"))
		{
			setDefaultNullBoolean(arguments.memento.boolean);
		}
		if(StructKeyExists(arguments.memento, "uuid"))
		{
			setDefaultNullUUID(arguments.memento.uuid);
		}
		if(StructKeyExists(arguments.memento, "guid"))
		{
			setDefaultNullGUID(arguments.memento.guid);
		}
	</cfscript>
</cffunction>

<cffunction name="getNullValue" hint="returns the null value, depending on what type the property is" access="public" returntype="any" output="false">
	<cfargument name="className" hint="The className of the object to get the null value for" type="string" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to get the null value for" type="string" required="Yes">
	<cfscript>
		var object = getObjectManager().getObject(arguments.className);
		var property = object.getPropertyByName(arguments.propertyName);

		switch(property.getType())
		{
			case "numeric":
				return getNullNumeric(arguments.className, property.getName());
			break;
			case "uuid":
				return getNullUUID(arguments.className, property.getName());
			break;
			case "guid":
				return getNullGUID(arguments.className, property.getName());
			break;
			case "date":
				return getNullDate(arguments.className, property.getName());
			break;
			case "boolean":
				return getNullBoolean(arguments.className, property.getName());
			break;
			default:
				return getNullString(arguments.className, property.getName());
		}
	</cfscript>
</cffunction>

<cffunction name="getNullString" hint="Returns the null string value for this object and property" access="public" returntype="string" output="false">
	<cfargument name="className" hint="The className of the object to get the null value for" type="string" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfscript>
		if(hasNullValue(arguments.className, arguments.propertyName))
		{
			return getNullPropertyValue(arguments.className, arguments.propertyName);
		}

		return getDefaultNullString();
	</cfscript>
</cffunction>

<cffunction name="getNullNumeric" hint="Returns the null numeric value for this object and property" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="The className of the object to get the null value for" type="string" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfscript>
		if(hasNullValue(arguments.className, arguments.propertyName))
		{
			return getNullPropertyValue(arguments.className, arguments.propertyName);
		}

		return getDefaultNullNumeric();
	</cfscript>
</cffunction>

<cffunction name="getNullDate" hint="Returns the null date value for this object and property" access="public" returntype="date" output="false">
	<cfargument name="className" hint="The className of the object to get the null value for" type="string" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfscript>
		if(hasNullValue(arguments.className, arguments.propertyName))
		{
			return ParseDateTime(getNullPropertyValue(arguments.className, arguments.propertyName));
		}

		return getDefaultNullDate();
	</cfscript>
</cffunction>

<cffunction name="getNullBoolean" hint="Returns the null date value for this object and property" access="public" returntype="boolean" output="false">
	<cfargument name="className" hint="The className of the object to get the null value for" type="string" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfscript>
		if(hasNullValue(arguments.className, arguments.propertyName))
		{
			return getNullPropertyValue(arguments.className, arguments.propertyName);
		}

		return getDefaultNullBoolean();
	</cfscript>
</cffunction>

<cffunction name="getNullUUID" hint="Returns the null date value for this object and property" access="public" returntype="uuid" output="false">
	<cfargument name="className" hint="The className of the object to get the null value for" type="string" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfscript>
		if(hasNullValue(arguments.className, arguments.propertyName))
		{
			return getNullPropertyValue(arguments.className, arguments.propertyName);
		}

		return getDefaultNullUUID();
	</cfscript>
</cffunction>

<cffunction name="getNullGUID" hint="Returns the null date value for this object and property" access="public" returntype="guid" output="false">
	<cfargument name="className" hint="The className of the object to get the null value for" type="string" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfscript>
		if(hasNullValue(arguments.className, arguments.propertyName))
		{
			return getNullPropertyValue(arguments.className, arguments.propertyName);
		}

		return getDefaultNullGUID();
	</cfscript>
</cffunction>
<!---
<cffunction name="parseNumeric" hint="Parses numeric values, taking into account null values" access="public" returntype="numeric" output="false">
	<cfargument name="transfer" hint="The transfer object to get the null value for" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfargument name="value" hint="The value to parse" type="string" required="Yes">

	<cfscript>
		if(NOT Len(arguments.value))
		{
			return getNullNumeric(arguments.transfer.getClassName(), arguments.propertyName);
		}
		return arguments.value;
	</cfscript>
</cffunction>

<cffunction name="parseUUID" hint="Parses UUID values, taking into account null values" access="public" returntype="UUID" output="false">
	<cfargument name="transfer" hint="The transfer object to get the null value for" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfargument name="value" hint="The value to parse" type="string" required="Yes">
	<cfscript>
		if(NOT Len(arguments.value))
		{
			return getNullUUID(arguments.transfer.getClassName(), arguments.propertyName);
		}
		return Ucase(arguments.value);
	</cfscript>
</cffunction>

<cffunction name="parseGUID" hint="Parses GUID values, taking into account null values" access="public" returntype="GUID" output="false">
	<cfargument name="transfer" hint="The transfer object to get the null value for" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfargument name="value" hint="The value to parse" type="string" required="Yes">
	<cfscript>
		if(NOT Len(arguments.value))
		{
			return getNullGUID(arguments.transfer.getClassName(), arguments.propertyName);
		}
		return UCase(arguments.value);
	</cfscript>
</cffunction>

<cffunction name="parseBoolean" hint="Parses boolean values, taking into account null values, and postgres 't' and 'f' values" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The transfer object to get the null value for" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfargument name="value" hint="The value to parse" type="string" required="Yes">
	<cfscript>
		switch(arguments.value)
		{
			case "":
				return getNullBoolean(arguments.transfer.getClassName(), arguments.propertyName);
			break;
			case "t":
				return true;
			break;
			case "f":
				return false;
			break;

			default:
				return arguments.value;
		}
	</cfscript>
</cffunction>

<cffunction name="parseDate" hint="Parses Date time values, taking into account null values" access="public" returntype="Date" output="false">
	<cfargument name="transfer" hint="The transfer object to get the null value for" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfargument name="value" hint="The value to parse" type="string" required="Yes">
	<cfscript>
		if(NOT Len(arguments.value))
		{
			return getNullDate(arguments.transfer.getClassName(), arguments.propertyName);
		}
		return parseDateTime(arguments.value);
	</cfscript>
</cffunction>

<cffunction name="parseString" hint="Parses GUID values, taking into account null values" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="The transfer object to get the null value for" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfargument name="value" hint="The value to parse" type="string" required="Yes">
	<cfscript>
		if(NOT Len(arguments.value))
		{
			return getNullString(arguments.transfer.getClassName(), arguments.propertyName);
		}
		return arguments.value;
	</cfscript>
</cffunction> --->

<cffunction name="checkNullValue" hint="Generically checks a null value for a given property" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" type="transfer.com.TransferObject" required="true" hint="The transferObject to get the null primary key value for">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfargument name="value" hint="The value to test" type="any" required="Yes">
	<cfscript>
		var object = getObjectManager().getObject(arguments.transfer.getClassName());
		var property = object.getPropertyByName(arguments.propertyName);

		switch(property.getType())
		{
			case "numeric":
				return checkNullNumeric(arguments.transfer, property.getName(), arguments.value);
			break;
			case "uuid":
				return checkNullUUID(arguments.transfer, property.getName(), arguments.value);
			break;
			case "guid":
				return checkNullGUID(arguments.transfer, property.getName(), arguments.value);
			break;
			case "date":
				return checkNullDate(arguments.transfer, property.getName(), arguments.value);
			break;
			case "boolean":
				return checkNullBoolean(arguments.transfer, property.getName(), arguments.value);
			break;
			default:
				return checkNullString(arguments.transfer, property.getName(), arguments.value);
		}
	</cfscript>
</cffunction>

<cffunction name="checkNullUUID" hint="whether the UUID is a null value or not" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The transfer object to get the null value for" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfargument name="uuid" hint="the uuid to test" type="uuid" required="Yes">
	<cfreturn arguments.uuid eq getNullUUID(arguments.transfer.getClassName(), arguments.propertyName)>
</cffunction>

<cffunction name="checkNullGUID" hint="whether the GUID is a null value or not" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The transfer object to get the null value for" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfargument name="guid" hint="the guid to test" type="guid" required="Yes">
	<cfreturn arguments.guid eq getNullGUID(arguments.transfer.getClassName(), arguments.propertyName)>
</cffunction>

<cffunction name="checkNullDate" hint="whether the Date is a null value or not" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The transfer object to get the null value for" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfargument name="date" hint="the date to test" type="date" required="Yes">
	<cfreturn arguments.date eq getNullDate(arguments.transfer.getClassName(), arguments.propertyName)>
</cffunction>

<cffunction name="checkNullNumeric" hint="whether the numeric is a null value or not" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The transfer object to get the null value for" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfargument name="number" hint="the number to test" type="numeric" required="Yes">
	<cfreturn arguments.number eq getNullNumeric(arguments.transfer.getClassName(), arguments.propertyName)>
</cffunction>

<cffunction name="checkNullBoolean" hint="whether the boolean is a null value or not" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The transfer object to get the null value for" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfargument name="boolean" hint="the boolean to test" type="boolean" required="Yes">
	<cfreturn arguments.boolean eq getNullBoolean(arguments.transfer.getClassName(), arguments.propertyName)>
</cffunction>

<cffunction name="checkNullString" hint="whether the string is a null value or not" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The transfer object to get the null value for" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfargument name="string" hint="the string to test" type="string" required="Yes">
	<cfreturn arguments.string eq getNullString(arguments.transfer.getClassName(), arguments.propertyName)>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="hasNullValue" hint="Checks to see if a property of an object has a null value" access="private" returntype="boolean" output="false">
	<cfargument name="className" hint="The className of the object to get the null value for" type="string" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfscript>
		var object = getObjectManager().getObject(arguments.className);
		var property = object.getPropertyByName(arguments.propertyName);

		return property.hasNullValue();
	</cfscript>
</cffunction>

<cffunction name="getNullPropertyValue" hint="gets the null value of a property" access="private" returntype="any" output="false">
	<cfargument name="className" hint="The class to get the null value for" type="string" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to check against" type="string" required="Yes">
	<cfscript>
		var object = getObjectManager().getObject(arguments.className);
		var property = object.getPropertyByName(arguments.propertyName);

		return property.getNullValue();
	</cfscript>
</cffunction>

<cffunction name="getDefaultNullNumeric" access="private" returntype="numeric" output="false">
	<cfreturn instance.DefaultNullNumeric />
</cffunction>

<cffunction name="getDefaultNullString" access="private" returntype="string" output="false">
	<cfreturn instance.DefaultNullString />
</cffunction>

<cffunction name="getDefaultNullDate" access="private" returntype="date" output="false">
	<cfreturn instance.DefaultNullDate />
</cffunction>

<cffunction name="getDefaultNullBoolean" access="private" returntype="string" output="false">
	<cfreturn instance.DefaultNullBoolean />
</cffunction>

<cffunction name="getDefaultNullUUID" access="private" returntype="uuid" output="false">
	<cfreturn instance.DefaultNullUUID />
</cffunction>

<cffunction name="getDefaultNullGUID" access="private" returntype="guid" output="false">
	<cfreturn instance.DefaultNullGUID />
</cffunction>

<cffunction name="setDefaultNullGUID" access="private" returntype="void" output="false">
	<cfargument name="DefaultNullGUID" type="guid" required="true">
	<cfset instance.DefaultNullGUID = arguments.DefaultNullGUID />
</cffunction>

<cffunction name="setDefaultNullUUID" access="private" returntype="void" output="false">
	<cfargument name="DefaultNullUUID" type="uuid" required="true">
	<cfset instance.DefaultNullUUID = arguments.DefaultNullUUID />
</cffunction>

<cffunction name="setDefaultNullBoolean" access="private" returntype="void" output="false">
	<cfargument name="DefaultNullBoolean" type="string" required="true">
	<cfset instance.DefaultNullBoolean = arguments.DefaultNullBoolean />
</cffunction>

<cffunction name="setDefaultNullDate" access="private" returntype="void" output="false">
	<cfargument name="DefaultNullDate" type="date" required="true">
	<cfset instance.DefaultNullDate = arguments.DefaultNullDate />
</cffunction>

<cffunction name="setDefaultNullString" access="private" returntype="void" output="false">
	<cfargument name="DefaultNullString" type="string" required="true">
	<cfset instance.DefaultNullString = arguments.DefaultNullString />
</cffunction>

<cffunction name="setDefaultNullNumeric" access="private" returntype="void" output="false">
	<cfargument name="DefaultNullNumeric" type="numeric" required="true">
	<cfset instance.DefaultNullNumeric = arguments.DefaultNullNumeric />
</cffunction>

<cffunction name="getObjectManager" access="private" returntype="transfer.com.object.ObjectManager" output="false">
	<cfreturn instance.ObjectManager />
</cffunction>

<cffunction name="setObjectManager" access="private" returntype="void" output="false">
	<cfargument name="ObjectManager" type="transfer.com.object.ObjectManager" required="true">
	<cfset instance.ObjectManager = arguments.ObjectManager />
</cffunction>

</cfcomponent>