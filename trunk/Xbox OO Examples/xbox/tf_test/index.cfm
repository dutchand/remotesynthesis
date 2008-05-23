<!--- 
	this would be in onApplictionStart() in application.cfc
 --->
<cfif not structKeyExists(application,"inited") or structKeyExists(url,"reload")>
	<cfset application.factory = createObject("component","coldspring.beans.DefaultXmlBeanFactory").init() />
	<cfset application.factory.loadBeansFromXmlFile(expandPath("/tf_test/config/services.xml"),true)/>
	
	<cfset application.consoleService = application.factory.getBean("consoleService") />
	<cfset application.inited = true />
</cfif>
<cfset variables.consoleService = application.consoleService />

<!--- create my accessory --->
<cfset myAccessory = consoleService.createAccessory(createUUID(),"HD-DVD") />
<cfset consoleService.saveAccessory(myAccessory) />

<!--- create two controls --->
<cfset myControl1 = consoleService.createControl(createUUID(),true,true) />
<cfset consoleService.saveControl(myControl1) />
<cfset myControl2 = consoleService.createControl(createUUID(),false,false) />
<cfset consoleService.saveControl(myControl2) />

<!--- create three games --->
<cfset myGame1 = consoleService.createGame(createUUID(),"Gears of War",false) />
<cfset consoleService.saveGame(myGame1) />
<cfset myGame2 = consoleService.createGame(createUUID(),"Ghost Recon Advanced Warfighter 2",false) />
<cfset consoleService.saveGame(myGame2) />
<cfset myGame3 = consoleService.createGame(createUUID(),"Halo 3",true) />
<cfset consoleService.saveGame(myGame3) />

<!--- create a new console --->
<cfset myConsole = consoleService.createConsole(createUUID(),"XBOX 360",20) />
<!--- add our accessory --->
<cfset myConsole.addAccessories(myAccessory) />
<!--- add our controllers --->
<cfset myConsole.addControls(myControl1) />
<cfset myConsole.addControls(myControl2) />
<!--- add our games --->
<cfset myConsole.addGames(myGame1) />
<cfset myConsole.addGames(myGame2) />
<cfset myConsole.addGames(myGame3) />
<cfset myConsole.save() />

<!--- output the console info --->
<cfoutput>
<h3>Console Created in Memory</h3>
<table>
	<tr>
		<td>Console ID</td>
		<td>#myConsole.getConsoleID()#</td>
	</tr>
	<tr>
		<td>Type</td>
		<td>#myConsole.getType()#</td>
	</tr>
	<tr>
		<td>Storage</td>
		<td>#myConsole.getStorage()#</td>
	</tr>
	<tr>
		<td colspan="2"><strong>Accessories</strong></td>
	</tr>
	<cfset accessories = myConsole.getAccessoriesArray() />
	<cfloop from="1" to="#arrayLen(accessories)#" index="i">
		<tr>
			<td>Name</td>
			<td>#accessories[i].getAccessoryName()#</td>
		</tr>
	</cfloop>
	<cfset controls = myConsole.getControlsArray() />
	<cfloop from="1" to="#arrayLen(controls)#" index="i">
		<tr>
			<td colspan="2"><strong>Control #i#</strong></td>
		</tr>
		<tr>
			<td>Wireless?</td>
			<td>#yesNoFormat(controls[i].getWireless())#</td>
		</tr>
		<tr>
			<td>Headset?</td>
			<td>#yesNoFormat(controls[i].getHeadset())#</td>
		</tr>
	</cfloop>
	<tr>
		<td colspan="2"><strong>Games</strong></td>
	</tr>
	<cfset games = myConsole.getGamesArray() />
	<cfloop from="1" to="#arrayLen(games)#" index="i">
		<tr>
			<td colspan="2"><em>#games[i].getGameName()#</em></td>
		</tr>
		<tr>
			<td>Special Edition?</td>
			<td>#yesNoFormat(games[i].getSpecialEdition())#</td>
		</tr>
	</cfloop>
</table>
</cfoutput>

<cfset myLoadedConsole = consoleService.getConsole(myConsole.getConsoleID()) />

<!--- output the console info --->
<cfoutput>
<h3>Console Loaded from Database</h3>
<table>
	<tr>
		<td>Console ID</td>
		<td>#myLoadedConsole.getConsoleID()#</td>
	</tr>
	<tr>
		<td>Type</td>
		<td>#myLoadedConsole.getType()#</td>
	</tr>
	<tr>
		<td>Storage</td>
		<td>#myLoadedConsole.getStorage()#</td>
	</tr>
	<tr>
		<td colspan="2"><strong>Accessories</strong></td>
	</tr>
	<cfset accessories = myLoadedConsole.getAccessoriesArray() />
	<cfloop from="1" to="#arrayLen(accessories)#" index="i">
		<tr>
			<td>Name</td>
			<td>#accessories[i].getAccessoryName()#</td>
		</tr>
	</cfloop>
	<cfset controls = myLoadedConsole.getControlsArray() />
	<cfloop from="1" to="#arrayLen(controls)#" index="i">
		<tr>
			<td colspan="2"><strong>Control #i#</strong></td>
		</tr>
		<tr>
			<td>Wireless?</td>
			<td>#yesNoFormat(controls[i].getWireless())#</td>
		</tr>
		<tr>
			<td>Headset?</td>
			<td>#yesNoFormat(controls[i].getHeadset())#</td>
		</tr>
	</cfloop>
	<tr>
		<td colspan="2"><strong>Games</strong></td>
	</tr>
	<cfset games = myLoadedConsole.getGamesArray() />
	<cfloop from="1" to="#arrayLen(games)#" index="i">
		<tr>
			<td colspan="2"><em>#games[i].getGameName()#</em></td>
		</tr>
		<tr>
			<td>Special Edition?</td>
			<td>#yesNoFormat(games[i].getSpecialEdition())#</td>
		</tr>
	</cfloop>
</table>
</cfoutput>

<!--- load a game into our xbox --->
<cfset myLoadedConsole.loadGame(games[1].getGameName()) />
<!--- use the headset for XBOX Live campaign --->
<cfset controls[1].useHeadset() />
<cfoutput>
<h3>You are now playing #myLoadedConsole.getLoadedGame().getGameName()#. Your headset is <cfif controls[1].isHeadsetInUse()>on<cfelse>off</cfif>.</h3>
</cfoutput>