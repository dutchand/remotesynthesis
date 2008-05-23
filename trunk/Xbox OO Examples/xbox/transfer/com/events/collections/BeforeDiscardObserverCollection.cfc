<!--- Document Information -----------------------------------------------------

Title:      BeforeDiscardObserverCollection.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Collection of Observers for before a Update

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		18/06/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="BeforeDiscardObserverCollection" hint="Collection of Observers for before a Discard" extends="AbstractBaseObserverCollection">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="BeforeDiscardObserverCollection" output="false">
	<cfscript>
		super.init("actionBeforeDiscardTransferEvent");

		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>