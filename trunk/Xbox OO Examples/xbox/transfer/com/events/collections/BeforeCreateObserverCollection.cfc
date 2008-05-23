<!--- Document Information -----------------------------------------------------

Title:      BeforeCreateObserverCollection.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Collection of Observers for before a Creation

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		06/10/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="BeforeCreateObserverCollection" hint="Collection of Observers for before a Creation" extends="AbstractBaseObserverCollection">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="BeforeCreateObserverCollection" output="false">
	<cfscript>
		super.init("actionBeforeCreateTransferEvent");

		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>