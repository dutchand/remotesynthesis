<!--- Document Information -----------------------------------------------------

Title:      ObjectAdapter.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    an object event adapter

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		20/02/2007		Created

------------------------------------------------------------------------------->
<cfcomponent name="ObjectAdapter" hint="An adapter that just calles the action methods on the underlying object" extends="transfer.com.events.adapter.AbstractBaseEventActionAdapter" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ObjectAdapter" output="false">
	<cfargument name="object" hint="The object to adapt to" type="any" required="Yes">
	<cfscript>
		super.init();
		setObject(arguments.object);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getAdapted" hint="returns the object that is adapted" access="public" returntype="any" output="false">
	<cfreturn getObject()/>
</cffunction>

<cffunction name="getHashCode" hint="returns a hashcode unique for the object contained for this adapter. Used for observer storage" access="public" returntype="string" output="false">
	<cfreturn getSystem().identityHashCode(getAdapted()) />
</cffunction>

<cffunction name="actionBeforeCreateTransferEvent" hint="Actions a event before a create happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfset getObject().actionBeforeCreateTransferEvent(arguments.event) />
</cffunction>

<cffunction name="actionAfterCreateTransferEvent" hint="Actions a event After a create happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfset getObject().actionAfterCreateTransferEvent(arguments.event) />
</cffunction>

<cffunction name="actionBeforeUpdateTransferEvent" hint="Actions a event Before a create happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfset getObject().actionBeforeUpdateTransferEvent(arguments.event) />
</cffunction>

<cffunction name="actionAfterUpdateTransferEvent" hint="Actions a event After a create happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfset getObject().actionAfterUpdateTransferEvent(arguments.event) />
</cffunction>

<cffunction name="actionBeforeDeleteTransferEvent" hint="Actions a event Before a create happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfset getObject().actionBeforeDeleteTransferEvent(arguments.event) />
</cffunction>

<cffunction name="actionAfterDeleteTransferEvent" hint="Actions a event After a create happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfset getObject().actionAfterDeleteTransferEvent(arguments.event) />
</cffunction>

<cffunction name="actionBeforeDiscardTransferEvent" hint="Actions a event After a create happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfset getObject().actionBeforeDiscardTransferEvent(arguments.event) />
</cffunction>

<cffunction name="actionAfterNewTransferEvent" hint="Actions a event after a New() happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfset getObject().actionAfterNewTransferEvent(arguments.event) />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getObject" access="private" returntype="any" output="false">
	<cfreturn instance.Object />
</cffunction>

<cffunction name="setObject" access="private" returntype="void" output="false">
	<cfargument name="Object" type="any" required="true">
	<cfset instance.Object = arguments.Object />
</cffunction>

</cfcomponent>