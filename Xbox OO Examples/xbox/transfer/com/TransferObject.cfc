<!--- Document Information -----------------------------------------------------

Title:      TransferObject.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Basic transfer Object

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		11/07/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="TransferObject" hint="The basic CFC for creating TransferObjects">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<!---
No init, as it is dynamically created and injected
 --->
<cffunction name="getClassName" hint="The class name of the TransferObject" access="public" returntype="string" output="false">
	<cfreturn instance.ClassName />
</cffunction>

<cffunction name="sameTransfer" hint="Checks to see if 2 transfer objects are the same" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The transfer object to check if we are equal" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var system = createObject("java", "java.lang.System");

		//i'm not sure why I can't use getThisObject() from here, or why I can't use 'this', but it works.
		return (system.identityHashCode(getOriginalTransferObject()) eq system.identityHashCode(arguments.transfer.getOriginalTransferObject()));
	</cfscript>
</cffunction>

<cffunction name="getIsPersisted" access="public" returntype="boolean" output="false">
	<cfreturn instance.IsPersisted />
</cffunction>

<cffunction name="getIsDirty" access="public" returntype="boolean" output="false">
	<cfreturn instance.IsDirty />
</cffunction>

<cffunction name="getOriginalTransferObject" hint="Returns this object" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfreturn this>
</cffunction>

<cffunction name="clone" hint="Get a deep clone of this object" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfscript>
		var clone = getTransfer().new(getClassName());

		if(getIsPersisted())
		{
			clone.getOriginalTransferObject().setIsClone(true);
		}

		copyValuesTo(clone);

		clone.getOriginalTransferObject().setIsDirty(getIsDirty());
		clone.getOriginalTransferObject().setIsPersisted(getIsPersisted());

		return clone;
	</cfscript>
</cffunction>

<cffunction name="getIsClone" access="public" returntype="boolean" output="false">
	<cfreturn instance.IsClone />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<cffunction name="setIsClone" access="package" returntype="void" output="false">
	<cfargument name="IsClone" type="boolean" required="true">
	<cfset instance.IsClone = arguments.IsClone />
</cffunction>

<cffunction name="setIsPersisted" access="package" returntype="void" output="false">
	<cfargument name="IsPersisted" type="boolean" required="true">
	<cfset instance.IsPersisted = arguments.IsPersisted />
</cffunction>

<cffunction name="setIsDirty" access="package" returntype="void" output="false">
	<cfargument name="IsDirty" type="boolean" required="true">
	<cfset instance.IsDirty = arguments.IsDirty />
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getNullable" access="private" returntype="transfer.com.sql.Nullable" output="false">
	<cfreturn instance.Nullable />
</cffunction>

<cffunction name="setNullable" access="private" returntype="void" output="false">
	<cfargument name="Nullable" type="transfer.com.sql.Nullable" required="true">
	<cfset instance.Nullable = arguments.Nullable />
</cffunction>

<cffunction name="setClassName" access="private" returntype="void" output="false">
	<cfargument name="ClassName" type="string" required="true">
	<cfset instance.ClassName = arguments.ClassName />
</cffunction>

<cffunction name="getTransfer" hint="Transfer for creation of composite objects" access="private" returntype="Transfer" output="false">
	<cfreturn instance.Transfer />
</cffunction>

<cffunction name="setTransfer" access="private" returntype="void" output="false">
	<cfargument name="Transfer" hint="Transfer for creation of composites" type="Transfer" required="true">
	<cfset instance.Transfer = arguments.Transfer />
</cffunction>

<cffunction name="getComposite" hint="retrieves of builds the requisite composite for the memento" access="private" returntype="TransferObject" output="false">
	<cfargument name="className" hint="The classname of the object" type="string" required="Yes">
	<cfargument name="memento" hint="The memento for the composite object" type="struct" required="Yes">
	<cfargument name="primarykey" hint="The name of the primary Key" type="string" required="Yes">
	<cfscript>
		var transfer = 0;
		var key = arguments.memento[arguments.primaryKey];

		//handle cloning
		if(getIsClone())
		{
			transfer = getTransfer().new(arguments.className);

			transfer.getOriginalTransferObject().setIsClone(true);

			transfer.setMemento(arguments.memento);

			//it's not dirty, and it is persisited
			transfer.getOriginalTransferObject().setIsDirty(arguments.memento.transfer_isDirty);
			transfer.getOriginalTransferObject().setIsPersisted(arguments.memento.transfer_isPersisted);

			return transfer;
		}
	</cfscript>

	<!---
	double check lock it so that we only ever get one version of an object in the
	persistance scope
	 --->
	<cfif NOT getTransfer().isCached(arguments.className, key)>
		<cflock name="transfer.get.#arguments.className#.#key#" throwontimeout="true" timeout="60">
			<cfscript>
				if(NOT getTransfer().isCached(arguments.className, key))
				{
					transfer = getTransfer().new(arguments.className);
					transfer.setMemento(arguments.memento);

					//turn on the event handlers (done in cache now)
					//transfer.getOriginalTransferObject().initEventObservers();

					//it's not dirty, and it is persisited
					transfer.getOriginalTransferObject().setIsDirty(arguments.memento.transfer_isDirty);
					transfer.getOriginalTransferObject().setIsPersisted(arguments.memento.transfer_isPersisted);

					getTransfer().cache(transfer);

					//push out in case persisted in 'none' scope
					return transfer;
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfscript>
		return getTransfer().get(arguments.className, arguments.memento[arguments.primaryKey]);
	</cfscript>
</cffunction>

<cffunction name="getUtility" access="private" returntype="transfer.com.util.Utility" output="false">
	<cfreturn instance.Utility />
</cffunction>

<cffunction name="setUtility" access="private" returntype="void" output="false">
	<cfargument name="Utility" type="transfer.com.util.Utility" required="true">
	<cfset instance.Utility = arguments.Utility />
</cffunction>

<cffunction name="getLoaded" access="private" returntype="struct" output="false">
	<cfreturn instance.loaded />
</cffunction>

<cffunction name="setLoaded" access="private" returntype="void" output="false">
	<cfargument name="loaded" type="struct" required="true">
	<cfset instance.loaded = arguments.loaded />
</cffunction>

<cffunction name="getThisObject" access="private" returntype="transfer.com.TransferObject" output="false">
	<cfreturn instance.thisObject />
</cffunction>

<cffunction name="setThisObject" access="private" returntype="void" output="false">
	<cfargument name="thisObject" type="transfer.com.TransferObject" required="true">
	<cfset instance.thisObject = arguments.thisObject />
</cffunction>

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>

</cfcomponent>