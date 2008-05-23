<!--- Document Information -----------------------------------------------------

Title:      DecoratorWriter.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Writes decorators for TransferObjects

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		10/08/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="DecoratorWriter" hint="Object That writes out the decorators">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="DecoratorWriter" output="false">
	<cfargument name="definitionPath" hint="Path to where the definitions are kept" type="string" required="Yes">
	<cfargument name="objectManager" hint="Need to object manager for making queries" type="transfer.com.object.ObjectManager" required="Yes">

	<cfscript>
		setDefinitionPath(arguments.definitionPath);
		setObjectManager(arguments.objectManager);

		return this;
	</cfscript>
</cffunction>


<cffunction name="hasDefinition" hint="Checks to see if the defintion has been written" access="public" returntype="boolean" output="false">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">

	<cfreturn fileExists(getDefinitionPath() & getDefinitionFileName(arguments.object))>
</cffunction>

<cffunction name="getDefinitionFileName" hint="Creates the name that the file defition will be saved under" access="public" returntype="string" output="false">
	<cfargument name="object" hint="BO of the Object" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		//use the @ symbol to diffentiate between a transferObject and a Decorator.
		return arguments.object.getClassName() & "@" & arguments.object.getHash() & ".transfer";
	</cfscript>
</cffunction>

<cffunction name="writeDefinition" hint="Writes the defintion to the .transfer file" access="public" returntype="void" output="false">
	<cfargument name="object" hint="The object def, as the transfer won't know it's class yet" type="transfer.com.object.Object" required="Yes">
	<cfargument name="transfer" hint="The transfer Object to decorate" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var buffer = createObject("component", "transfer.com.dynamic.definition.DefinitionBuffer").init();
		var fileWriter = createObject("component", "transfer.com.io.FileWriter").init(getDefinitionPath()& "/" & getDefinitionFileName(arguments.object));

		//iterator for all keys on the transferObject
		var iterator = StructKeyArray(arguments.transfer).iterator();
		var	part = 0;

		while(iterator.hasNext())
		{
			part = arguments.transfer[iterator.next()];
			if(isCustomFunction(part) AND getMetaData(part).access eq "public")
			{
				writeFunctionWrapper(buffer, part);
			}
		}

		fileWriter.write(buffer.toDefintionString());
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="writeFunctionWrapper" hint="Writes the wrapper function for the transfer object" access="public" returntype="string" output="false">
	<cfargument name="buffer" hint="The buffer to write with" type="transfer.com.dynamic.definition.DefinitionBuffer" required="Yes">
	<cfargument name="function" hint="The function coming through" type="any" required="Yes">
	<cfscript>
		var metadata = getMetaData(arguments.function);
		var len = 0;
		var counter = 0;
		var metaArg = 0;
		var hasParams = StructKeyExists(metadata, "parameters");
		var argsList = "";

		if(NOT StructKeyExists(metadata, "hint"))
		{
			metadata.hint = "";
		}

		arguments.buffer.writeCFFunctionOpen(metadata.name, metadata.access, metadata.returntype, metadata.hint);

		if(hasParams)
		{
			len = ArrayLen(metadata.parameters);

			for(counter = 1; counter lte len; counter = counter + 1)
			{
				metaArg = metadata.parameters[counter];
				//TODO: argument hints
				if(NOT structKeyExists(metaArg, "default"))
				{
					metaArg.default = "";
				}
				arguments.buffer.writeCFArgument(metaArg.name, metaArg.type, metaArg.required, metaArg.default);
			}
		}

		arguments.buffer.cfscript(true);

		if(metadata.returntype neq "void")
		{
			arguments.buffer.append("return ");
		}

		arguments.buffer.append("getTransferObject()." & metadata.name & "(");

		if(hasParams)
		{

			for(counter = 1; counter lte len; counter = counter + 1)
			{
				metaArg =  metadata.parameters[counter];
				argsList = ListAppend(argsList, "arguments." & metaArg.name);
			}
		}
		arguments.buffer.append(argsList);
		arguments.buffer.writeLine(");");
		arguments.buffer.cfscript(false);
		arguments.buffer.writeCFFunctionClose();
	</cfscript>
</cffunction>

<cffunction name="getDefinitionPath" access="private" returntype="string" output="false">
	<cfreturn instance.DefinitionPath />
</cffunction>

<cffunction name="setDefinitionPath" access="private" returntype="void" output="false">
	<cfargument name="DefinitionPath" type="string" required="true">
	<cfset instance.DefinitionPath = arguments.DefinitionPath />
</cffunction>

<cffunction name="getObjectManager" access="private" returntype="transfer.com.object.ObjectManager" output="false">
	<cfreturn instance.ObjectManager />
</cffunction>

<cffunction name="setObjectManager" access="private" returntype="void" output="false">
	<cfargument name="ObjectManager" type="transfer.com.object.ObjectManager" required="true">
	<cfset instance.ObjectManager = arguments.ObjectManager />
</cffunction>

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>

</cfcomponent>