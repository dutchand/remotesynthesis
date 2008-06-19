<cfapplication name="riasecurity" sessionmanagement="true" />

<cfif not structKeyExists(application,"tokens") or structKeyExists(url,"reload")>
	<cfset application.tokens = structNew() />
	<cflogout />
</cfif>