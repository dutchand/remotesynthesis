<cfapplication name="riasecurity" />

<cfparam name="url.reload" default="false" />
<cfif not structKeyExists(application,"keys") or url.reload>
	<cfset application.keys = {privateKey="44ede15274ab3a9bbd510455b746d65d",publicKey="653ea3210c6654b15da55e71811cb378"} />
</cfif>