<cfset message = event.getArg("message") />
<cfset errors = event.getArg("errors") />
<cfset game = event.getArg("game") />

<!--- default the form values --->
<cfparam name="form.gameID" default="#game.getGameID()#" />
<cfparam name="form.gameName" default="#game.getGameName()#" />
<cfparam name="form.specialEdition" default="#game.getSpecialEdition()#" />

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
<form action="index.cfm?event=games.process" method="post">
	<input type="hidden" name="gameID" value="#form.gameID#" />
	<label for="type">Game Name:</label><br />
	<input type="text" name="gameName" value="#form.gameName#" /><br />
	<label for="type">Is this a special edition?</label><br />
	<input type="checkbox" name="specialEdition" value="1" <cfif form.specialEdition eq 1>checked</cfif> /><br />
	<input type="submit" name="submitted" value="Add Game" />
</form>
</cfoutput>