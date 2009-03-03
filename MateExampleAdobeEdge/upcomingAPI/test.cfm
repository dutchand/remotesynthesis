<cfset upcomingCFC = createObject("component","org.upcoming.upcoming").init(application.apiKey) />

<cfset countries = upcomingCFC.getCountryList() />

<!--- id 1 is USA --->
<cfset states = upcomingCFC.getStateList(1) />

<!--- id 22 is MA --->
<cfset metros = upcomingCFC.getMetroList(22) />

<!--- id 10 is Boston --->
<cfset events = upcomingCFC.search(metroId=10) />

<cfoutput>
<cfloop from="1" to="#arrayLen(events)#" index="i">
	#events[i].getEventName()#<br />
</cfloop>
</cfoutput>