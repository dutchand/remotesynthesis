<!--- Document Information -----------------------------------------------------

Title:      TransferCleaner.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Removes all but the basic TransferObject methods from a TransferObject

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		18/10/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="TransferCleaner" displayname="Removes all but the basic TransferObject methods from a TransferObject">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="TransferCleaner" output="false">
	<cfscript>
		var coreMethods = ArrayNew(1);

		setMethodInjector(createObject("component", "MethodInjector").init());

		//setup mixin functions
		instance.mixin = StructNew();
		instance.mixin.cleanTransferObject = variables.cleanTransferObject;

		//remove it
		getMethodInjector().removeMethod(this, "cleanTransferObject");

		return this;
	</cfscript>
</cffunction>

<cffunction name="cleanTransfer" hint="Takes a transfer, and prepares it for repopulation (resistance in futile)" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="transfer" hint="The transferObject to be cleaned" type="transfer.com.TransferObject" required="Yes">

	<cfscript>
		//insert cleaner mixin
		getMethodInjector().injectMethod(arguments.transfer, instance.mixin.cleanTransferObject);

		//run it
		//arguments.transfer.cleanTransferObject(getCoreMethods());
		arguments.transfer.cleanTransferObject(getMethodInjector());

		getMethodInjector().removeMethod(arguments.transfer, "cleanTransferObject");

		//return it
		return arguments.transfer;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getMethodInjector" access="private" returntype="MethodInjector" output="false">
	<cfreturn instance.MethodInjector />
</cffunction>

<cffunction name="setMethodInjector" access="private" returntype="void" output="false">
	<cfargument name="MethodInjector" type="MethodInjector" required="true">
	<cfset instance.MethodInjector = arguments.MethodInjector />
</cffunction>

<!--- mixin functions --->
<cffunction name="cleanTransferObject" hint="Mixin for cleaning a transfer for reuse" access="public" returntype="void" output="false">
	<cfargument name="methodInjector" hint="The method injector" type="methodInjector" required="Yes">
	<cfscript>
		var coreMethods = ArrayNew(1);
		var iterator = 0;

		//first let's save what we need
		ArrayAppend(coreMethods, this.getClassName);
		ArrayAppend(coreMethods, variables.setClassName);
		ArrayAppend(coreMethods, variables.getTransfer);
		ArrayAppend(coreMethods, variables.setTransfer);
		ArrayAppend(coreMethods, variables.getComposite);
		ArrayAppend(coreMethods, variables.throw);
		ArrayAppend(coreMethods, variables.getUtility);
		ArrayAppend(coreMethods, variables.setUtility);
		ArrayAppend(coreMethods, this.getIsPersisted);
		ArrayAppend(coreMethods, this.setIsPersisted);
		ArrayAppend(coreMethods, this.getIsDirty);
		ArrayAppend(coreMethods, this.setIsDirty);
		ArrayAppend(coreMethods, variables.getLoaded);
		ArrayAppend(coreMethods, variables.setLoaded);
		ArrayAppend(coreMethods, variables.getNullable);
		ArrayAppend(coreMethods, variables.setNullable);
		ArrayAppend(coreMethods, this.getOriginalTransferObject);
		ArrayAppend(coreMethods, variables.getThisObject);
		ArrayAppend(coreMethods, variables.setThisObject);
		ArrayAppend(coreMethods, variables.getIsClone);
		ArrayAppend(coreMethods, variables.setIsClone);
		ArrayAppend(coreMethods, this.clone);
		ArrayAppend(coreMethods, this.sameTransfer);

		//clear variables
		StructClear(variables);

		//clear this
		StructClear(this);

		//push back 'this'
		variables.this = this;

		//give it a new instance scope
		variables.instance = StructNew();

		//reappaly the methods
		iterator = coreMethods.iterator();
		while(iterator.hasNext())
		{
			arguments.methodInjector.injectMethod(this, iterator.next());
		}
	</cfscript>
</cffunction>

</cfcomponent>