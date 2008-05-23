<!--- 
	this service should be a singleton and in application scope
	in your application. this would be in onApplictionStart() in application.cfc
 --->
<cfset props = structNew() />
<cfset props.dsn = "xbox" />
<cfset factory = createObject("component","coldspring.beans.DefaultXmlBeanFactory").init(defaultProperties=props)/>
<cfset factory.loadBeansFromXmlFile(expandPath("/cs/config/services.xml"),true)/>

<cfset consoleService = factory.getBean("consoleService") />
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
<cfset myConsole.addAccessory(myAccessory) />
<!--- add our controllers --->
<cfset myConsole.addControl(myControl1) />
<cfset myConsole.addControl(myControl2) />
<!--- add our games --->
<cfset myConsole.addGame(myGame1) />
<cfset myConsole.addGame(myGame2) />
<cfset myConsole.addGame(myGame3) />
<cfset consoleService.saveConsole(myConsole) />

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
	<cfset accessories = myConsole.getAccessories() />
	<cfloop from="1" to="#arrayLen(accessories)#" index="i">
		<tr>
			<td>Name</td>
			<td>#accessories[i].getAccessoryName()#</td>
		</tr>
	</cfloop>
	<cfset controls = myConsole.getControls() />
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
	<cfset games = myConsole.getGames() />
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
	<cfset accessories = myLoadedConsole.getAccessories() />
	<cfloop from="1" to="#arrayLen(accessories)#" index="i">
		<tr>
			<td>Name</td>
			<td>#accessories[i].getAccessoryName()#</td>
		</tr>
	</cfloop>
	<cfset controls = myLoadedConsole.getControls() />
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
	<cfset games = myLoadedConsole.getGames() />
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