<cfcomponent output="false">
	
	<cfset variables.upcoming = createObject("component","org.upcoming.upcoming").init(application.apiKey) />
	
	<cffunction name="getCountryList" access="remote" output="false" returntype="array">
		<cfreturn variables.upcoming.getCountryList() />
	</cffunction>
	
	<cffunction name="getStateList" access="remote" output="false" returntype="array">
		<cfargument name="countryID" type="numeric" required="true" />
		
		<cfreturn variables.upcoming.getStateList(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="getMetroList" access="remote" output="false" returntype="array">
		<cfargument name="stateID" type="numeric" required="true" />
		
		<cfreturn variables.upcoming.getMetroList(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="search" access="remote" output="false" returntype="array">
		<cfargument name="searchText" type="string" required="false" />
		<cfargument name="countryId" type="numeric" required="false" />
		<cfargument name="stateId" type="numeric" required="false" />
		<cfargument name="metroId" type="numeric" required="false" />
		
		<cfreturn variables.upcoming.search(argumentCollection=arguments) />
	</cffunction>
</cfcomponent>