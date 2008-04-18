<cfapplication name="riasecurity" />

<cfparam name="url.reload" default="false" />
<cfif not structKeyExists(application,"publicKey") or url.reload>
	<cfset application.publicKey = toBase64(generateSecretKey("AES")) />
</cfif>