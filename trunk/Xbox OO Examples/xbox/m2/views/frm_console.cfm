<cfset message = event.getArg("message") />
<cfset errors = event.getArg("errors") />
<cfset console = session.console />
<!--- if a game was added we can get it and add it to our console --->
<cfset game = event.getArg("game") />
<cfif not isSimpleValue(game)>
	<cfset console.addGame(game) />
</cfif>

<!--- default the form values --->
<cfparam name="form.consoleID" default="#console.getConsoleID()#" />
<cfparam name="form.type" default="#console.getType()#" />
<cfparam name="form.storage" default="#console.getStorage()#" />

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
<form action="index.cfm?event=console.process" method="post">
	<input type="hidden" name="consoleID" value="#form.consoleID#" />
	<label for="type">Console Type:</label><br />
	<input type="text" name="type" value="#form.type#" /><br />
	<label for="type">Storage:</label><br />
	<input type="text" name="storage" value="#form.storage#" /><br />
	<input type="submit" name="submitted" value="Save Console" />
	<input type="button" name="clearConsole" value="Clear Console" onClick="document.location.href='index.cfm?event=console.clear'" />
</form>

<cfif arrayLen(console.getGames())>
	<cfset games = console.getGames() />
	<a href="index.cfm?event=games.add">New Game</a>
	<table>
		<th>Name</th>
		<th>Special Edition</th>
	<cfloop from="1" to="#arrayLen(games)#" index="i">
		<tr>
			<td>#games[i].getGameName()#</td>
			<td>#yesNoFormat(games[i].getSpecialEdition())#</td>
		</tr>
	</cfloop>
	</table>
<cfelse>
<p>No games have been added to this console. <a href="index.cfm?event=games.add">Add one now</a>.</p>
</cfif>
</cfoutput>