<cfset connectAPI = createobject("component","com.connectAPI").init("http://breeze1.msi.umn.edu/api/xml","brinaldi@remotesynthesis.com","rinaldi-8") />

<!--- <cfset addUsers = breezeAPI.principalUpdate("brian","rinaldi","brian.rinaldi@gmail.com","rinaldi-8","brian.rinaldi@gmail.com") />

<cfdump var="#addUsers#">

<cfset users = breezeAPI.reportBulkUsers() />

<cfdump var="#users#"> --->

<cfset principals = connectAPI.principalList() />
<cfdump var="#principals#">

<cfset scoshortcuts = connectAPI.scoShortcuts() />
<cfdump var="#scoshortcuts#">