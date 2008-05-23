<!--- Document Information -----------------------------------------------------

Title:      AfterNewObserverCollection.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Collection of observers for after new event

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		22/02/2007		Newd

------------------------------------------------------------------------------->
<cfcomponent name="AfterNewObserverCollection" hint="Collection of Observers for after a New" extends="AbstractBaseObserverCollection">

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="AfterNewObserverCollection" output="false">
	<cfscript>
		variables.instance = StructNew();

		super.init("actionAfterNewTransferEvent");

		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>