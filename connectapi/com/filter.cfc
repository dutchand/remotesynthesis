<cfcomponent displayname="Breeze Filter Object">
	<cffunction name="init" access="public" output="false" returntype="filter">
		<cfargument name="allowedFilters" type="string" required="false" default="" />
		<cfset variables.arrFilter = arrayNew(1) />
		<cfset setallowedFilters(arguments.allowedFilters) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addItem" access="public" output="false" returntype="filter">
		<cfargument name="filter" type="string" required="true" />
		<cfargument name="filterValue" type="string" required="false" default="asc" />
		
		<cfset var filterStruct = structNew() />
		<cfset filterStruct['name'] = arguments.filter />
		<cfset filterStruct['value'] = arguments.filterValue />
		<cfset arrayAppend(variables.arrFilter,filterStruct) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getFilterArray" access="public" output="false" returntype="array">
		<cfargument name="allowedFilters" type="string" required="false" />
		
		<cfset var returnArray = arrayNew(1) />
		<cfset var i = 0 />
		<cfset var tmpStruct = "" />
		
		<cfif structKeyExists(arguments,"allowedFilters")>
			<cfset setallowedFilters(arguments.allowedFilters) />
		</cfif>
		<cfif not len(getallowedFilters())>
			<cfthrow type="breezeAPI.filter.allowedFilters" detail="You must set the allowed filters list before getting the filter array" />
		</cfif>
		<cfloop from="1" to="#arrayLen(variables.arrFilter)#" index="i">
			<cfif listFind(getallowedFilters(),variables.arrFilter[i].name)>
				<cfset tmpStruct = structNew() />
				<cfset tmpStruct['filter-'&variables.arrFilter[i].name] = variables.arrFilter[i].value />
				<cfset arrayAppend(returnArray,tmpStruct)>
			<cfelse>
				<cfthrow type="breezeAPI.filter.allowedFilters" detail="The filter #variables.arrFilter[i].name# is not an allowed filter for this method." />
			</cfif>
		</cfloop>
		<cfreturn returnArray />
	</cffunction>
	
	<cffunction name="setAllowedFilters" access="public" output="false" returntype="void">
		<cfargument name="allowedFilters" type="string" required="true" />
		
		<cfset variables.allowedFilters = arguments.allowedFilters />
	</cffunction>
	<cffunction name="getAllowedFilters" access="public" output="false" returntype="string">
		<cfreturn variables.allowedFilters />
	</cffunction>
</cfcomponent>