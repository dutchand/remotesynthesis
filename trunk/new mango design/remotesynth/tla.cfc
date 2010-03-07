<cfcomponent output="false">
	<cffunction name="init" access="public" output="false" returntype="tla">
		<cfargument name="inventoryKey" type="string" required="true" />
		
		<cfset variables.inventoryKey = arguments.inventoryKey />
		<cfset variables.lastUpdated = now() />
		<cfset variables.xmlInventory = "">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getLastUpdated" access="public" output="false" returntype="date">
		<cfreturn variables.lastUpdated />
	</cffunction>
	
	<cffunction name="setInventory" access="public" output="false" returntype="void">
		<cfargument name="referrer" type="string" required="false" default="" />
		<cfargument name="userAgent" type="string" required="false" default="" />
		
		<cfset var tlaResponse = "" />
		<cfset var tlaURL = "http://www.text-link-ads.com/xml.php?inventory_key=" & variables.inventoryKey />
		<cfif len(arguments.referrer)>
			<cfset tlaURL = tlaURL & "referer=" & arguments.referrer />
		</cfif>
		<cfif len(arguments.userAgent)>
			<cfset tlaURL = tlaURL & "user_agent=" & arguments.userAgent />
		</cfif>
		<cftry>
			<cfhttp url="#tlaURL#" method="get" result="tlaResponse" timeout="30" />
			<cfset variables.xmlInventory = xmlParse(tlaResponse.fileContent) />
			<cfcatch type="any">
				<cfset variables.xmlInventory = xmlNew() />
			</cfcatch>
		</cftry>
	</cffunction>
	<cffunction name="getInventory" access="public" output="false" returntype="xml">
		<cfreturn variables.xmlInventory />
	</cffunction>
	
	<cffunction name="getInventoryAsQuery" access="public" output="false" returntype="query">
		<cfset var i = 1 />
		<cfset var tmpQuery = queryNew("url,text,beforetext,aftertext","VarChar,VarChar,VarChar,VarChar") />
		<cfif isDefined("variables.xmlInventory.links")>
			<cfloop from="1" to="#arrayLen(variables.xmlInventory.links.xmlChildren)#" index="i">
				<cfset queryAddRow(tmpQuery) />
				<cfset querySetCell(tmpQuery,"url",variables.xmlInventory.links.link[i].url.xmlText) />
				<cfset querySetCell(tmpQuery,"text", variables.xmlInventory.links.link[i].Text.xmlText) />
				<cfset querySetCell(tmpQuery,"beforetext",variables.xmlInventory.links.link[i].beforeText.xmlText) />
				<cfset querySetCell(tmpQuery,"aftertext",variables.xmlInventory.links.link[i].afterText.xmlText) />
			</cfloop>
		</cfif>
		
		<cfreturn tmpQuery />
	</cffunction>
</cfcomponent>