<cfset message = event.getArg("message") />
<cfset errors = event.getArg("errors") />
<cfset accessory = event.getArg("accessory") />

<!--- default the form values --->
<cfparam name="form.accessoryID" default="#accessory.getAccessoryID()#" />
<cfparam name="form.accessoryName" default="#accessory.getAccessoryName()#" />

<cfoutput>
<cfif len(message)>
	<div style="color:red">#message#</div>
</cfif>
<cfif isArray(errors) and arrayLen(errors)>
	<div style="color:red">
		Please correct the following issues:
		<ul>
			<cfloop from="1" to="#arrayLen(errors)#" index="i">
				<li>#errors[i]#</li>
			</cfloop>
		</ul>
	</div>
</cfif>
<form action="index.cfm?event=accessories.process" method="post">
	<input type="hidden" name="accessoryID" value="#form.accessoryID#" />
	<label for="type">Accessory Name:</label><br />
	<input type="text" name="accessoryName" value="#form.accessoryName#" /><br />
	<input type="submit" name="submitted" value="Add Accessory" />
</form>
</cfoutput>