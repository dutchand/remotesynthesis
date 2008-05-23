<!--- Document Information -----------------------------------------------------

Title:      TransferDecorator.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Base class for decorating a TransferObject

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		30/07/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="TransferDecorator" hint="Base class for decorating a TransferObject" extends="transfer.com.TransferObject">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Do not overwrite: Constructor" access="public" returntype="TransferDecorator" output="false">
	<cfargument name="transfer" hint="The Transfer lib" type="Transfer" required="Yes">
	<cfargument name="transferObject" hint="The transferObject to decorate" type="TransferObject" required="Yes">
	<cfargument name="utility" type="transfer.com.util.Utility" hint="Utility class" required="true" default="">
	<cfargument name="nullable" type="transfer.com.sql.Nullable" hint="nullable class" required="true" default="">
	<cfscript>
		setTransfer(arguments.transfer);

		//set it
		setTransferObject(arguments.transferObject);

		//then initialise
		arguments.transferObject.init(getTransfer(), arguments.utility, arguments.nullable, this);

		configure();

		return this;
	</cfscript>
</cffunction>

<cffunction name="getTransferObject" hint="Do not overwrite: Retrieves the decorated Transfreobject." access="public" returntype="TransferObject" output="false">
	<cfreturn instance.transferObject />
</cffunction>

<cffunction name="getClassName" hint="Do not overwrite: The class name of the TransferObject" access="public" returntype="string" output="false">
	<cfreturn getTransferObject().getClassName() />
</cffunction>

<cffunction name="getIsPersisted" hint="Do not overwrite: If the TransferObject is stored in the database or note." access="public" returntype="boolean" output="false">
	<cfreturn getTransferObject().getIsPersisted() />
</cffunction>

<cffunction name="getIsDirty" hint="Do not overwrite: Whether or not the data has been modified, but not persisted in the database" access="public" returntype="boolean" output="false">
	<cfreturn getTransferObject().getIsDirty() />
</cffunction>

<cffunction name="getOriginalTransferObject" hint="Do not overwrite: Returns the getTransferObject" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfreturn getTransferObject()>
</cffunction>

<cffunction name="getIsClone" hint="Do not overwrite: Whether or not the object is a clone" access="public" returntype="boolean" output="false">
	<cfreturn getTransferObject().getIsClone() />
</cffunction>

<cffunction name="clone" hint="Do not overwrite: Get a deep clone of this object" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfreturn getTransferObject().clone()>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="configure" hint="Overwrite to initialise the object when first created" access="private" returntype="void" output="false">
</cffunction>

<cffunction name="setTransferObject" hint="Do not overwrite: sets the internal TransferObject" access="private" returntype="void" output="false">
	<cfargument name="TransferObject" type="TransferObject" required="true">
	<cfset instance.transferObject = arguments.TransferObject />
</cffunction>

<cffunction name="getTransfer" hint="Do not overwrite: Transfer for creation of composite objects" access="private" returntype="Transfer" output="false">
	<cfreturn instance.Transfer />
</cffunction>

<cffunction name="setTransfer" hint="Do not overwrite: sets the Transfer lib" access="private" returntype="void" output="false">
	<cfargument name="Transfer" hint="Transfer for creation of composites" type="Transfer" required="true">
	<cfset instance.Transfer = arguments.Transfer />
</cffunction>

</cfcomponent>