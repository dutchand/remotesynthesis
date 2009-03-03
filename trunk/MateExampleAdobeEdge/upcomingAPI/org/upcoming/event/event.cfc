<cfcomponent output="false">
	<cfproperty name="id" type="numeric" required="true" default="0" />
	<cfproperty name="eventName" type="string" required="true" default="" />
	<cfproperty name="startDate" type="date" required="true" />
	<cfproperty name="endDate" type="date" required="false" />
	<cfproperty name="startTime" type="string" required="false" />
	<cfproperty name="endTime" type="string" required="false" />
	<cfproperty name="personal" type="boolean" required="false" />
	<cfproperty name="selfPromotion" type="boolean" required="false" />
	<cfproperty name="metroId" type="string" required="false" />
	<cfproperty name="venueId" type="numeric" required="false" />
	<cfproperty name="userId" type="numeric" required="false" />
	<cfproperty name="categoryId" type="numeric" required="false" />
	<cfproperty name="datePosted" type="date" required="false" />
	<cfproperty name="watchListCount" type="numeric" required="false" />
	<cfproperty name="eventUrl" type="string" required="false" />
	<cfproperty name="latitude" type="numeric" required="false" />
	<cfproperty name="longitude" type="numeric" required="false" />
	<cfproperty name="geocodingPrecision" type="string" required="false" />
	<cfproperty name="geocodingAmbiguous" type="string" required="false" />
	<cfproperty name="venueName" type="string" required="false" />
	<cfproperty name="venueAddress" type="string" required="false" />
	<cfproperty name="venueCity" type="string" required="false" />
	<cfproperty name="venueState" type="string" required="false" />
	<cfproperty name="venueStateCode" type="string" required="false" />
	<cfproperty name="venueStateId" type="numeric" required="false" />
	<cfproperty name="venueCountryName" type="string" required="false" />
	<cfproperty name="venueCountryCode" type="string" required="false" />
	<cfproperty name="venueCountryId" type="numeric" required="false" />
	<cfproperty name="venueZip" type="string" required="false" />
	<cfproperty name="ticketUrl" type="string" required="false" />
	<cfproperty name="ticketPrice" type="string" required="false" />
	<cfproperty name="ticketFree" type="boolean" required="false" />
	<cfproperty name="photoUrl" type="string" required="false" />
	<cfproperty name="numFutureEvents" type="numeric" required="false" />
	<cfproperty name="startDateLastRendition" type="string" required="false" />
	
	<cfset variables.instance = {} />
	<cfset init() />
	
	<cffunction name="init" access="public" output="false" returntype="org.upcoming.event.event">
		<cfargument name="id" type="numeric" required="true" default="0" />
		<cfargument name="eventName" type="string" required="false" default="" />
		<cfargument name="startDate" type="date" required="false" default="#now()#" />
		<cfargument name="endDate" type="string" required="false" default="" />
		<cfargument name="startTime" type="string" required="false" default="" />
		<cfargument name="endTime" type="string" required="false" default="" />
		<cfargument name="personal" type="boolean" required="false" default="false" />
		<cfargument name="selfPromotion" type="boolean" required="false" default="false" />
		<cfargument name="metroId" type="string" required="false" default="" />
		<cfargument name="venueId" type="numeric" required="false" default="0" />
		<cfargument name="userId" type="numeric" required="false" default="0" />
		<cfargument name="categoryId" type="numeric" required="false" default="0" />
		<cfargument name="datePosted" type="date" required="false" default="#now()#" />
		<cfargument name="watchListCount" type="numeric" required="false" default="0" />
		<cfargument name="eventUrl" type="string" required="false" default="" />
		<cfargument name="latitude" type="numeric" required="false" default="0" />
		<cfargument name="longitude" type="numeric" required="false" default="0" />
		<cfargument name="geocodingPrecision" type="string" required="false" default="" />
		<cfargument name="geocodingAmbiguous" type="string" required="false" default="" />
		<cfargument name="venueName" type="string" required="false" default="" />
		<cfargument name="venueAddress" type="string" required="false" default="" />
		<cfargument name="venueCity" type="string" required="false" default="" />
		<cfargument name="venueState" type="string" required="false" default="" />
		<cfargument name="venueStateCode" type="string" required="false" default="" />
		<cfargument name="venueStateId" type="numeric" required="false" default="0" />
		<cfargument name="venueCountryName" type="string" required="false" default="" />
		<cfargument name="venueCountryCode" type="string" required="false" default="" />
		<cfargument name="venueCountryId" type="numeric" required="false" default="0" />
		<cfargument name="venueZip" type="string" required="false" default="" />
		<cfargument name="ticketUrl" type="string" required="false" default="" />
		<cfargument name="ticketPrice" type="string" required="false" default="" />
		<cfargument name="ticketFree" type="boolean" required="false" default="false" />
		<cfargument name="photoUrl" type="string" required="false" default="" />
		<cfargument name="numFutureEvents" type="numeric" required="false" default="0" />
		<cfargument name="startDateLastRendition" type="string" required="false" default="" />
		
		<cfset setid(arguments.id) />
		<cfset seteventName(arguments.eventName) />
		<cfset setstartDate(arguments.startDate) />
		<cfset setendDate(arguments.endDate) />
		<cfset setpersonal(arguments.personal) />
		<cfset setselfPromotion(arguments.selfPromotion) />
		<cfset setmetroId(arguments.metroId) />
		<cfset setvenueId(arguments.venueId) />
		<cfset setuserId(arguments.userId) />
		<cfset setcategoryId(arguments.categoryId) />
		<cfset setdatePosted(arguments.datePosted) />
		<cfset setwatchListCount(arguments.watchListCount) />
		<cfset seteventUrl(arguments.eventUrl) />
		<cfset setlatitude(arguments.latitude) />
		<cfset setlongitude(arguments.longitude) />
		<cfset setgeocodingPrecision(arguments.geocodingPrecision) />
		<cfset setgeocodingAmbiguous(arguments.geocodingAmbiguous) />
		<cfset setvenueName(arguments.venueName) />
		<cfset setvenueAddress(arguments.venueAddress) />
		<cfset setvenueCity(arguments.venueCity) />
		<cfset setvenueState(arguments.venueState) />
		<cfset setvenueStateCode(arguments.venueStateCode) />
		<cfset setvenueStateId(arguments.venueStateId) />
		<cfset setvenueCountryName(arguments.venueCountryName) />
		<cfset setvenueCountryCode(arguments.venueCountryCode) />
		<cfset setvenueCountryId(arguments.venueCountryId) />
		<cfset setvenueZip(arguments.venueZip) />
		<cfset setticketUrl(arguments.ticketUrl) />
		<cfset setticketPrice(arguments.ticketPrice) />
		<cfset setticketFree(arguments.ticketFree) />
		<cfset setphotoUrl(arguments.photoUrl) />
		<cfset setnumFutureEvents(arguments.numFutureEvents) />
		<cfset setstartDateLastRendition(arguments.startDateLastRendition) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setid" access="public" output="false" returntype="void">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset variables.instance.id = arguments.id />
	</cffunction>
	<cffunction name="getid" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.id />
	</cffunction>
	
	<cffunction name="seteventName" access="public" output="false" returntype="void">
		<cfargument name="eventName" type="string" required="true" />
		
		<cfset variables.instance.eventName = arguments.eventName />
	</cffunction>
	<cffunction name="geteventName" access="public" output="false" returntype="string">
		<cfreturn variables.instance.eventName />
	</cffunction>
	
	<cffunction name="setstartDate" access="public" output="false" returntype="void">
		<cfargument name="startDate" type="date" required="true" />
		
		<cfset variables.instance.startDate = arguments.startDate />
	</cffunction>
	<cffunction name="getstartDate" access="public" output="false" returntype="date">
		<cfreturn variables.instance.startDate />
	</cffunction>
	
	<cffunction name="setendDate" access="public" output="false" returntype="void">
		<cfargument name="endDate" type="string" required="true" />
		
		<cfset variables.instance.endDate = arguments.endDate />
	</cffunction>
	<cffunction name="getendDate" access="public" output="false" returntype="string">
		<cfreturn variables.instance.endDate />
	</cffunction>
	
	<cffunction name="setpersonal" access="public" output="false" returntype="void">
		<cfargument name="personal" type="boolean" required="true" />
		
		<cfset variables.instance.personal = arguments.personal />
	</cffunction>
	<cffunction name="getpersonal" access="public" output="false" returntype="boolean">
		<cfreturn variables.instance.personal />
	</cffunction>
	
	<cffunction name="setselfPromotion" access="public" output="false" returntype="void">
		<cfargument name="selfPromotion" type="boolean" required="true" />
		
		<cfset variables.instance.selfPromotion = arguments.selfPromotion />
	</cffunction>
	<cffunction name="getselfPromotion" access="public" output="false" returntype="boolean">
		<cfreturn variables.instance.selfPromotion />
	</cffunction>
	
	<cffunction name="setmetroId" access="public" output="false" returntype="void">
		<cfargument name="metroId" type="string" required="true" />
		
		<cfset variables.instance.metroId = arguments.metroId />
	</cffunction>
	<cffunction name="getmetroId" access="public" output="false" returntype="string">
		<cfreturn variables.instance.metroId />
	</cffunction>
	
	<cffunction name="setvenueId" access="public" output="false" returntype="void">
		<cfargument name="venueId" type="numeric" required="true" />
		
		<cfset variables.instance.venueId = arguments.venueId />
	</cffunction>
	<cffunction name="getvenueId" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.venueId />
	</cffunction>
	
	<cffunction name="setuserId" access="public" output="false" returntype="void">
		<cfargument name="userId" type="numeric" required="true" />
		
		<cfset variables.instance.userId = arguments.userId />
	</cffunction>
	<cffunction name="getuserId" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.userId />
	</cffunction>
	
	<cffunction name="setcategoryId" access="public" output="false" returntype="void">
		<cfargument name="categoryId" type="numeric" required="true" />
		
		<cfset variables.instance.categoryId = arguments.categoryId />
	</cffunction>
	<cffunction name="getcategoryId" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.categoryId />
	</cffunction>
	
	<cffunction name="setdatePosted" access="public" output="false" returntype="void">
		<cfargument name="datePosted" type="date" required="true" />
		
		<cfset variables.instance.datePosted = arguments.datePosted />
	</cffunction>
	<cffunction name="getdatePosted" access="public" output="false" returntype="date">
		<cfreturn variables.instance.datePosted />
	</cffunction>
	
	<cffunction name="setwatchListCount" access="public" output="false" returntype="void">
		<cfargument name="watchListCount" type="numeric" required="true" />
		
		<cfset variables.instance.watchListCount = arguments.watchListCount />
	</cffunction>
	<cffunction name="getwatchListCount" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.watchListCount />
	</cffunction>
	
	<cffunction name="seteventUrl" access="public" output="false" returntype="void">
		<cfargument name="eventUrl" type="string" required="true" />
		
		<cfset variables.instance.eventUrl = arguments.eventUrl />
	</cffunction>
	<cffunction name="geteventUrl" access="public" output="false" returntype="string">
		<cfreturn variables.instance.eventUrl />
	</cffunction>
	
	<cffunction name="setlatitude" access="public" output="false" returntype="void">
		<cfargument name="latitude" type="numeric" required="true" />
		
		<cfset variables.instance.latitude = arguments.latitude />
	</cffunction>
	<cffunction name="getlatitude" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.latitude />
	</cffunction>
	
	<cffunction name="setlongitude" access="public" output="false" returntype="void">
		<cfargument name="longitude" type="numeric" required="true" />
		
		<cfset variables.instance.longitude = arguments.longitude />
	</cffunction>
	<cffunction name="getlongitude" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.longitude />
	</cffunction>
	
	<cffunction name="setgeocodingPrecision" access="public" output="false" returntype="void">
		<cfargument name="geocodingPrecision" type="string" required="true" />
		
		<cfset variables.instance.geocodingPrecision = arguments.geocodingPrecision />
	</cffunction>
	<cffunction name="getgeocodingPrecision" access="public" output="false" returntype="string">
		<cfreturn variables.instance.geocodingPrecision />
	</cffunction>
	
	<cffunction name="setgeocodingAmbiguous" access="public" output="false" returntype="void">
		<cfargument name="geocodingAmbiguous" type="string" required="true" />
		
		<cfset variables.instance.geocodingAmbiguous = arguments.geocodingAmbiguous />
	</cffunction>
	<cffunction name="getgeocodingAmbiguous" access="public" output="false" returntype="string">
		<cfreturn variables.instance.geocodingAmbiguous />
	</cffunction>
	
	<cffunction name="setvenueName" access="public" output="false" returntype="void">
		<cfargument name="venueName" type="string" required="true" />
		
		<cfset variables.instance.venueName = arguments.venueName />
	</cffunction>
	<cffunction name="getvenueName" access="public" output="false" returntype="string">
		<cfreturn variables.instance.venueName />
	</cffunction>
	
	<cffunction name="setvenueAddress" access="public" output="false" returntype="void">
		<cfargument name="venueAddress" type="string" required="true" />
		
		<cfset variables.instance.venueAddress = arguments.venueAddress />
	</cffunction>
	<cffunction name="getvenueAddress" access="public" output="false" returntype="string">
		<cfreturn variables.instance.venueAddress />
	</cffunction>
	
	<cffunction name="setvenueCity" access="public" output="false" returntype="void">
		<cfargument name="venueCity" type="string" required="true" />
		
		<cfset variables.instance.venueCity = arguments.venueCity />
	</cffunction>
	<cffunction name="getvenueCity" access="public" output="false" returntype="string">
		<cfreturn variables.instance.venueCity />
	</cffunction>
	
	<cffunction name="setvenueState" access="public" output="false" returntype="void">
		<cfargument name="venueState" type="string" required="true" />
		
		<cfset variables.instance.venueState = arguments.venueState />
	</cffunction>
	<cffunction name="getvenueState" access="public" output="false" returntype="string">
		<cfreturn variables.instance.venueState />
	</cffunction>
	
	<cffunction name="setvenueStateCode" access="public" output="false" returntype="void">
		<cfargument name="venueStateCode" type="string" required="true" />
		
		<cfset variables.instance.venueStateCode = arguments.venueStateCode />
	</cffunction>
	<cffunction name="getvenueStateCode" access="public" output="false" returntype="string">
		<cfreturn variables.instance.venueStateCode />
	</cffunction>
	
	<cffunction name="setvenueStateId" access="public" output="false" returntype="void">
		<cfargument name="venueStateId" type="string" required="true" />
		
		<cfset variables.instance.venueStateId = arguments.venueStateId />
	</cffunction>
	<cffunction name="getvenueStateId" access="public" output="false" returntype="string">
		<cfreturn variables.instance.venueStateId />
	</cffunction>
	
	<cffunction name="setvenueCountryName" access="public" output="false" returntype="void">
		<cfargument name="venueCountryName" type="string" required="true" />
		
		<cfset variables.instance.venueCountryName = arguments.venueCountryName />
	</cffunction>
	<cffunction name="getvenueCountryName" access="public" output="false" returntype="string">
		<cfreturn variables.instance.venueCountryName />
	</cffunction>
	
	<cffunction name="setvenueCountryCode" access="public" output="false" returntype="void">
		<cfargument name="venueCountryCode" type="string" required="true" />
		
		<cfset variables.instance.venueCountryCode = arguments.venueCountryCode />
	</cffunction>
	<cffunction name="getvenueCountryCode" access="public" output="false" returntype="string">
		<cfreturn variables.instance.venueCountryCode />
	</cffunction>
	
	<cffunction name="setvenueCountryId" access="public" output="false" returntype="void">
		<cfargument name="venueCountryId" type="string" required="true" />
		
		<cfset variables.instance.venueCountryId = arguments.venueCountryId />
	</cffunction>
	<cffunction name="getvenueCountryId" access="public" output="false" returntype="string">
		<cfreturn variables.instance.venueCountryId />
	</cffunction>
	
	<cffunction name="setvenueZip" access="public" output="false" returntype="void">
		<cfargument name="venueZip" type="string" required="true" />
		
		<cfset variables.instance.venueZip = arguments.venueZip />
	</cffunction>
	<cffunction name="getvenueZip" access="public" output="false" returntype="string">
		<cfreturn variables.instance.venueZip />
	</cffunction>
	
	<cffunction name="setticketUrl" access="public" output="false" returntype="void">
		<cfargument name="ticketUrl" type="string" required="true" />
		
		<cfset variables.instance.ticketUrl = arguments.ticketUrl />
	</cffunction>
	<cffunction name="getticketUrl" access="public" output="false" returntype="string">
		<cfreturn variables.instance.ticketUrl />
	</cffunction>
	
	<cffunction name="setticketPrice" access="public" output="false" returntype="void">
		<cfargument name="ticketPrice" type="string" required="true" />
		
		<cfset variables.instance.ticketPrice = arguments.ticketPrice />
	</cffunction>
	<cffunction name="getticketPrice" access="public" output="false" returntype="string">
		<cfreturn variables.instance.ticketPrice />
	</cffunction>
	
	<cffunction name="setticketFree" access="public" output="false" returntype="void">
		<cfargument name="ticketFree" type="boolean" required="true" />
		
		<cfset variables.instance.ticketFree = arguments.ticketFree />
	</cffunction>
	<cffunction name="getticketFree" access="public" output="false" returntype="boolean">
		<cfreturn variables.instance.ticketFree />
	</cffunction>
	
	<cffunction name="setphotoUrl" access="public" output="false" returntype="void">
		<cfargument name="photoUrl" type="string" required="true" />
		
		<cfset variables.instance.photoUrl = arguments.photoUrl />
	</cffunction>
	<cffunction name="getphotoUrl" access="public" output="false" returntype="string">
		<cfreturn variables.instance.photoUrl />
	</cffunction>
	
	<cffunction name="setnumFutureEvents" access="public" output="false" returntype="void">
		<cfargument name="numFutureEvents" type="numeric" required="true" />
		
		<cfset variables.instance.numFutureEvents = arguments.numFutureEvents />
	</cffunction>
	<cffunction name="getnumFutureEvents" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.numFutureEvents />
	</cffunction>
	
	<cffunction name="setstartDateLastRendition" access="public" output="false" returntype="void">
		<cfargument name="startDateLastRendition" type="string" required="true" />
		
		<cfset variables.instance.startDateLastRendition = arguments.startDateLastRendition />
	</cffunction>
	<cffunction name="getstartDateLastRendition" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.startDateLastRendition />
	</cffunction>
	
	<!---
	DUMP
	--->
	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="false" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>
</cfcomponent>