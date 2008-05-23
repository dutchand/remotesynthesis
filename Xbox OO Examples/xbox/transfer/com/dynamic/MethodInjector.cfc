<!--- Document Information -----------------------------------------------------

Title:      MethodInjector.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Method injector

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		29/06/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="MethodInjector" hint="Injects methods into CFCs">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="MethodInjector" output="false">
	<cfscript>
		instance.mixin = StructNew();

		instance.mixin["removeMethodMixin"] = variables.removeMethodMixin;
		removeMethod(this, "removeMethodMixin");

		instance.mixin["injectMethodMixin"] = variables.injectMethodMixin;
		removeMethod(this, "injectMethodMixin");

		return this;
	</cfscript>
</cffunction>

<cffunction name="injectMethod" hint="Injects a method into a CFC" access="public" returntype="web-inf.cftags.component" output="false">
	<cfargument name="CFC" hint="The cfc to inject the method into" type="web-inf.cftags.component" required="Yes">
	<cfargument name="UDF" hint="UDF to be checked" type="any" required="Yes">

	<cfscript>
		var metaData = 0;
		checkValidUDF(arguments.UDF);

		try
		{
			//do this by hand to avoid recursion issues
			arguments.CFC["injectMethodMixin"] = instance.mixin.injectMethodMixin;
			arguments.CFC.injectMethodMixin(arguments.UDF);

			//avoid recursion
			StructDelete(arguments.CFC, "injectMethodMixin");
		}
		catch(Any exc)
		{
			throw("MethodInjectException", "Error inserting method '#metaData.name#'", exc.message);
		}

		return arguments.CFC;
	</cfscript>
</cffunction>

<cffunction name="removeMethod" hint="Take a public Method off a CFC" access="public" returntype="void" output="false">
	<cfargument name="CFC" hint="The cfc to inject the method into" type="web-inf.cftags.component" required="Yes">
	<cfargument name="UDFName" hint="Name of the UDF to be removed" type="string" required="Yes">

	<cfscript>
		arguments.CFC["removeMethodMixin"] = instance.mixin.removeMethodMixin;
		arguments.CFC.removeMethodMixin(arguments.UDFName);

		StructDelete(arguments.CFC, "removeMethodMixin");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="checkValidUDF" hint="Checks to see if the this is a valid UDF, otherwise throws a coldfusion.runtime.UDFMethod$InvalidArgumentTypeException" access="private" returntype="void" output="false">
	<cfargument name="UDF" hint="UDF to be checked" type="any" required="Yes">

	<cfscript>
		//if(arguments.UDF.getClass().getSuperclass().getName() neq "coldfusion.runtime.UDFMethod")
		if(NOT isCustomFunction(arguments.UDF))
		{
			throw("coldfusion.runtime.UDFMethod$InvalidArgumentTypeException", "The argument UDF passed to this function is not of type coldfusion.runtime.UDF.");
		}
	</cfscript>
</cffunction>

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>

<!--- mixin --->
<cffunction name="injectMethodMixin" hint="[mixin, removed at init] - injects a method into the CFC scope" access="public" returntype="void" output="false">
	<cfargument name="UDF" hint="UDF to be checked" type="any" required="Yes">
	<cfscript>
		var metadata = getMetaData(arguments.UDF);
		variables[metadata.name] = arguments.UDF;

		if(NOT structKeyExists(metadata, "access"))
		{
			metadata.access = "public";
		}

		if(metadata.access neq "private")
		{
			this[metaData.name] = arguments.UDF;
		}
	</cfscript>
</cffunction>

<cffunction name="removeMethodMixin" hint="[mixin, removed at init] - injects a method into the CFC scope" access="public" returntype="void" output="false">
	<cfargument name="UDFName" hint="Name of the UDF to be removed" type="string" required="Yes">
	<cfscript>
		StructDelete(this, arguments.udfName);
		StructDelete(variables, arguments.udfName);
	</cfscript>
</cffunction>

</cfcomponent>