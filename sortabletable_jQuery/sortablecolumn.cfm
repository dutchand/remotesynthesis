<cfparam name="attributes.column" type="string" default="" />
<cfparam name="attributes.title" type="string" default="#attributes.column#" />
<cfparam name="attributes.format" type="string" default="" />
<cfparam name="attributes.sort" type="string" default="" />
<cfparam name="attributes.disable" type="string" default="false" />
<cfparam name="attributes.pre" type="string" default="" />
<cfparam name="attributes.post" type="string" default="" />

<cfif thisTag.ExecutionMode eq "start">
	<cfassociate baseTag = "cf_sortabletable" datacollection="columns" />
<cfelse>
</cfif>