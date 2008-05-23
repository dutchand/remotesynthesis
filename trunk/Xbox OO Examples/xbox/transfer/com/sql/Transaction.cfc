<!--- Document Information -----------------------------------------------------

Title:      Transaction.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Easy handle for Transactions

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		01/09/2006		Created

------------------------------------------------------------------------------->

<cfcomponent name="Transaction" hint="Easy handle for Transactions">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="Transaction" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="begin" hint="Starts a transaction" access="public" returntype="void" output="false">
	<cfargument name="use" hint="Actually use a transaction" type="boolean" required="no" default="true">
	<cfif arguments.use>
		<cftransaction action="begin" />
	</cfif>
</cffunction>

<cffunction name="commit" hint="commits a transaction" access="public" returntype="void" output="false">
	<cfargument name="use" hint="Actually use a transaction" type="boolean" required="no" default="true">
	<cfif arguments.use>
		<cftransaction action="commit" />
	</cfif>
</cffunction>

<cffunction name="rollback" hint="rolls back a transaction" access="public" returntype="void" output="false">
	<cfargument name="use" hint="Actually use a transaction" type="boolean" required="no" default="true">
	<cfif arguments.use>
		<cftransaction action="rollback" />
	</cfif>
</cffunction>


<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>