<!--- Document Information -----------------------------------------------------

Title:      NullableDAO.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    DAO for accessing the Nullable interface

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		17/07/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="NullableDAO" hint="DAO for the Nullable Bean">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="NullableDAO" output="false">
	<cfargument name="xmlFileReader" hint="The file path to the config file" type="transfer.com.io.XMLFileReader" required="Yes">
	<cfscript>
		setXMLReader(arguments.xmlFileReader);
		
		return this;
	</cfscript>
</cffunction>

<cffunction name="getNullable" hint="Gets a Nullable bean" access="public" returntype="nullable" output="false">
	<cfargument name="nullable" hint="nullable bean" type="nullable" required="Yes">
	<cfscript>
		var xNullValues = getXMLReader().search("/transfer/nullValues/");
		
		var memento = Structnew();
		
		if(ArrayLen(xNullValues))
		{
			//convenience
			xNullValues = xNullValues[1];
			if(StructKeyExists(xNullValues, "string"))
			{
				memento.string = xNullValues.string.xmlattributes.value;
			}
			if(StructKeyExists(xNullValues, "numeric"))
			{
				memento.numeric = xNullValues.numeric.xmlattributes.value;
			}
			if(StructKeyExists(xNullValues, "date"))
			{
				memento.date = xNullValues.date.xmlattributes.value;
			}
			if(StructKeyExists(xNullValues, "boolean"))
			{
				memento.boolean = xNullValues.boolean.xmlattributes.value;
			}
			if(StructKeyExists(xNullValues, "uuid"))
			{
				memento.uuid = xNullValues.uuid.xmlattributes.value;
			}
			if(StructKeyExists(xNullValues, "guid"))
			{
				memento.guid = xNullValues.guid.xmlattributes.value;
			}			
		}
		
		arguments.nullable.setMemento(memento);
		
		return arguments.nullable;
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