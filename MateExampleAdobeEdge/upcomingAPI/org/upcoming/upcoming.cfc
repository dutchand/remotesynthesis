<cfcomponent output="false">
	<cffunction name="init" access="public" output="false" returntype="org.upcoming.upcoming">
		<cfargument name="apiKey" required="true" type="string" />
		
		<cfset variables.apiKey = arguments.apiKey />
		<cfset variables.upcomingAPIurl = "http://upcoming.yahooapis.com/services/rest/" />
		<cfset variables.qs = variables.apiKey />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="callMethod" access="private" output="false" returntype="xml">
		<cfargument name="methodName" type="string" required="true" />
		<cfargument name="methodType" type="string" required="true" />
		
		<cfset var argument = "" />
		<cfset var result = "" />

		<cfhttp url="#variables.upcomingAPIurl#" charset="utf-8" result="result" method="#arguments.methodType#">
			<cfhttpparam type="url" name="api_key" value="#variables.apiKey#" />
			<cfhttpparam type="url" name="method" value="#arguments.methodName#" />
			<cfloop collection="#arguments#" item="argument">
				<cfif argument neq "methodName" and argument neq "methodType">
					<cfhttpparam type="url" name="#argument#" value="#arguments[argument]#" />
				</cfif>
			</cfloop>
		</cfhttp>
		
		<cfreturn xmlParse(result.fileContent) />
	</cffunction>
	
	<cffunction name="getCountryList" access="public" output="false" returntype="array">
		<cfset var args = {methodName="metro.getCountryList",methodType="GET"} />
		<cfset var result = callMethod(argumentCollection=args) />
		<cfset var arr = arrayNew(1) />
		<cfset var country = "" />
		<cfset var countryXML =  "" />

		<cfloop array="#result.rsp.xmlChildren#" index="countryXML">
			<cfset country = createObject("component","org.upcoming.metro.country").init(countryXML.xmlAttributes.id,countryXML.xmlAttributes.name,countryXML.xmlAttributes.code) />
			<cfset arrayAppend(arr,country) />
		</cfloop>
		
		<cfreturn arr />
	</cffunction>
	
	<cffunction name="getStateList" access="public" output="false" returntype="array">
		<cfargument name="countryID" type="numeric" required="true" />
		
		<cfset var args = {methodName="metro.getStateList",methodType="GET"} />
		<cfset var result = "" />
		<cfset var arr = arrayNew(1) />
		<cfset var state = "" />
		<cfset var stateXML =  "" />
		
		<!--- declare additional arguments. must do this here to maintain case --->
		<cfset args["country_id"]=arguments.countryID />
		
		<cfset result = callMethod(argumentCollection=args) />

		<cfloop array="#result.rsp.xmlChildren#" index="stateXML">
			<cfset state = createObject("component","org.upcoming.metro.state").init(stateXML.xmlAttributes.id,stateXML.xmlAttributes.name,stateXML.xmlAttributes.code) />
			<cfset arrayAppend(arr,state) />
		</cfloop>
		
		<cfreturn arr />
	</cffunction>
	
	<cffunction name="getMetroList" access="public" output="false" returntype="array">
		<cfargument name="stateID" type="numeric" required="true" />
		
		<cfset var args = {methodName="metro.getList",methodType="GET"} />
		<cfset var result = "" />
		<cfset var arr = arrayNew(1) />
		<cfset var metro = "" />
		<cfset var metroXML =  "" />
		<cfset var m = "" />
		
		<!--- declare additional arguments. must do this here to maintain case --->
		<cfset args["state_id"]=arguments.stateID />
		
		<cfset result = callMethod(argumentCollection=args) />

		<cfloop array="#result.rsp.xmlChildren#" index="metroXML">
			<cfset m = metroXML.xmlAttributes />
			<cfset metro = createObject("component","org.upcoming.metro.metro").init(m.id,m.name,m.code,m.state_id,m.state_name,m.state_code,m.country_id,m.country_name,m.country_code) />
			<cfset arrayAppend(arr,metro) />
		</cfloop>
		
		<cfreturn arr />
	</cffunction>
	
	<cffunction name="search" access="public" output="false" returntype="array">
		<cfargument name="searchText" type="string" required="false" />
		<cfargument name="countryId" type="numeric" required="false" />
		<cfargument name="stateId" type="numeric" required="false" />
		<cfargument name="metroId" type="numeric" required="false" />
		
		<cfset var args = {methodName="event.search",methodType="GET"} />
		<cfset var result = "" />
		<cfset var arr = arrayNew(1) />
		<cfset var event = "" />
		<cfset var eventXML =  "" />
		<cfset var e = "" />
		
		<!--- declare additional arguments. must do this here to maintain case --->
		<cfif structKeyExists(arguments,"searchText")>
			<cfset args["search_text"]=arguments.searchText />
		</cfif>
		<cfif structKeyExists(arguments,"countryId")>
			<cfset args["country_id"]=arguments.countryId />
		</cfif>
		<cfif structKeyExists(arguments,"stateId")>
			<cfset args["state_id"]=arguments.stateId />
		</cfif>
		<cfif structKeyExists(arguments,"metroId")>
			<cfset args["metro_id"]=arguments.metroId />
		</cfif>
		
		<cfset result = callMethod(argumentCollection=args) />

		<cfloop array="#result.rsp.xmlChildren#" index="eventXML">
			<cfset e = eventXML.xmlAttributes />
			<cfset event = createObject("component","org.upcoming.event.event").init(
				id=e.id,
				eventName=e.name,
				startDate=e.start_date,
				endDate=e.end_date,
				startTime=e.start_time,
				endTime=e.end_time,
				personal=e.personal,
				selfPromotion=e.selfpromotion,
				metroId=e.metro_id,
				venueId=e.venue_id,
				userId=e.user_id,
				categoryId=e.category_id,
				datePosted=e.date_posted,
				watchListCount=e.watchlist_count,
				url=e.url,
				latitude=e.latitude,
				longitude=e.longitude,
				geocodingPrecision=e.geocoding_precision,
				geocodingAmbiguous=e.geocoding_ambiguous,
				venueName=e.venue_name,
				venueAddress=e.venue_address,
				venueCity=e.venue_city,
				venueState=e.venue_state_name,
				venueStateCode=e.venue_state_code,
				venueStateId=e.venue_state_id,
				venueCountryName=e.venue_country_name,
				venueCountryCode=e.venue_country_code,
				venueCountryId=e.venue_country_id,
				venueZip=e.venue_zip,
				ticketUrl=e.ticket_url,
				ticketPrice=e.ticket_price,
				ticketFree=e.ticket_free,
				photoUrl=e.photo_url,
				numFutureEvent=e.num_future_events,
				startDateLastRendition=e.start_date_last_rendition
			) />
			<cfset arrayAppend(arr,event) />
		</cfloop>
		
		<cfreturn arr />
	</cffunction>
</cfcomponent>