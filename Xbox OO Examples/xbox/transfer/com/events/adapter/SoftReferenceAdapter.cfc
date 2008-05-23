<!--- Document Information -----------------------------------------------------

Title:      SoftReferenceAdapter.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    a soft reference event adapter

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		20/02/2007		Created

------------------------------------------------------------------------------->
<cfcomponent hint="An adapter that uses a soft reference, and if the reference has been cleared, it ignores it" extends="transfer.com.events.adapter.AbstractBaseEventActionAdapter" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="SoftReferenceAdapter" output="false">
	<cfscript>
		super.init();

		return this;
	</cfscript>
</cffunction>

<cffunction name="configure" hint="configure the adapter" access="public" returntype="void" output="false">
	<cfargument name="softRef" hint="java.lang.ref.SoftReference: The soft reference to hold" type="any" required="Yes">
	<cfargument name="transfer" hint="the original transfer object. No reference to it is held" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		setSoftReference(arguments.softRef);
		setHashCode(getSystem().identityHashCode(arguments.transfer));
	</cfscript>
</cffunction>

<cffunction name="getHashcode" access="public" returntype="string" output="false">
	<cfreturn instance.Hashcode />
</cffunction>

<cffunction name="getAdapted" hint="returns the object that is adapted from the soft reference. Could be null." access="public" returntype="any" output="false">
	<cfreturn getSoftReference().get()/>
</cffunction>

<cffunction name="actionBeforeCreateTransferEvent" hint="Actions a event before a create happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfscript>
		var object = getSoftReference().get();
		if(isDefined("object"))
		{
			object.actionBeforeCreateTransferEvent(arguments.event);
		}
	</cfscript>
</cffunction>

<cffunction name="actionAfterCreateTransferEvent" hint="Actions a event After a create happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfscript>
		var object = getSoftReference().get();
		if(isDefined("object"))
		{
			object.actionAfterCreateTransferEvent(arguments.event);
		}
	</cfscript>
</cffunction>

<cffunction name="actionBeforeUpdateTransferEvent" hint="Actions a event Before a create happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfscript>
		var object = getSoftReference().get();
		if(isDefined("object"))
		{
			object.actionBeforeUpdateTransferEvent(arguments.event);
		}
	</cfscript>
</cffunction>

<cffunction name="actionAfterUpdateTransferEvent" hint="Actions a event After a create happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfscript>
		var object = getSoftReference().get();
		if(isDefined("object"))
		{
			object.actionAfterUpdateTransferEvent(arguments.event);
		}
	</cfscript>
</cffunction>

<cffunction name="actionBeforeDeleteTransferEvent" hint="Actions a event Before a create happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfscript>
		var object = getSoftReference().get();
		if(isDefined("object"))
		{
			object.actionBeforeDeleteTransferEvent(arguments.event);
		}
	</cfscript>
</cffunction>

<cffunction name="actionAfterDeleteTransferEvent" hint="Actions a event After a create happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfscript>
		var object = getSoftReference().get();
		if(isDefined("object"))
		{
			object.actionAfterDeleteTransferEvent(arguments.event);
		}
	</cfscript>
</cffunction>

<cffunction name="actionBeforeDiscardTransferEvent" hint="Actions a event After a create happens" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event object" type="transfer.com.events.TransferEvent" required="Yes">
	<cfscript>
		var object = getSoftReference().get();
		if(isDefined("object"))
		{
			object.actionBeforeDiscardTransferEvent(arguments.event);
		}
	</cfscript>
</cffunction>

<cffunction name="clean" hint="Clean the adapter" access="public" returntype="void" output="false">
	<cfscript>
		StructDelete(instance, "softReference");
		StructDelete(instance, "hashCode");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getSoftReference" access="private" returntype="any" output="false">
	<cfreturn instance.SoftReference />
</cffunction>

<cffunction name="setSoftReference" access="private" returntype="void" output="false">
	<cfargument name="SoftReference" type="any" required="true">
	<cfset instance.SoftReference = arguments.SoftReference />
</cffunction>

<cffunction name="setHashcode" access="private" returntype="void" output="false">
	<cfargument name="Hashcode" type="string" required="true">
	<cfset instance.Hashcode = arguments.Hashcode />
</cffunction>

</cfcomponent>