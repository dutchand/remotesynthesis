<!--- Document Information -----------------------------------------------------

Title:      SoftReferenceAdapterPool.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    a pool for soft reference adapters

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		20/02/2007		Created

------------------------------------------------------------------------------->

<cfcomponent hint="Keeps a pool of Soft References" extends="transfer.com.collections.AbstractBaseSemiSoftRefObjectPool" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="SoftReferenceAdapterPool" output="false">
	<cfscript>
		//10 hard referenced items
		super.init(10);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getSoftReferenceAdapter" hint="Gives you a Soft Reference Adapter" access="public" returntype="transfer.com.events.adapter.SoftReferenceAdapter" output="false">
	<cfargument name="softRef" hint="java.lang.SoftRef: The soft reference to push into the adapter" type="any" required="Yes">
	<cfargument name="transfer" hint="the transfer object to adapt" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var adapter = 0;

		adapter = pop();

		adapter.configure(arguments.softRef, arguments.transfer);

		return adapter;
	</cfscript>
</cffunction>

<cffunction name="recycle" hint="recycles the event back in" access="public" returntype="void" output="false">
	<cfargument name="adapter" hint="The soft reference to recycle" type="transfer.com.events.adapter.SoftReferenceAdapter" required="Yes">
	<cfscript>
		arguments.adapter.clean();
		push(arguments.adapter);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getNewObject" hint="Returns a SoftReferenceAdapter" access="private" returntype="web-inf.cftags.component" output="false">
	<cfreturn createObject("component", "transfer.com.events.adapter.SoftReferenceAdapter").init() />
</cffunction>

</cfcomponent>