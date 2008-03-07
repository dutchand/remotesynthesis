<cfcomponent displayname="Breeze Sort Object">
	<cffunction name="init" access="public" output="false" returntype="sort">
		<cfargument name="allowedSorts" type="string" required="false" default="" />
		<!--- NOTE: sorts will be performed in the order in which they are added --->
		<cfset variables.arrSort = arrayNew(1) />
		<cfset setAllowedSorts(arguments.allowedSorts) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addItem" access="public" output="false" returntype="sort">
		<cfargument name="sort" type="string" required="true" />
		<cfargument name="sortOrder" type="string" required="false" default="asc" />
		
		<cfset var sortStruct = structNew() />
		<cfset sortStruct['name'] = arguments.sort />
		<cfset sortStruct['order'] = arguments.sortOrder />
		<cfset arrayAppend(variables.arrSort,sortStruct) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSortArray" access="public" output="false" returntype="array">
		<cfargument name="allowedSorts" type="string" required="false" />
		
		<cfset var returnArray = arrayNew(1) />
		<cfset var i = 0 />
		<cfset var tmpStruct = "" />
		
		<cfif structKeyExists(arguments,"allowedSorts")>
			<cfset setAllowedSorts(arguments.allowedSorts) />
		</cfif>
		<cfif not len(getAllowedSorts())>
			<cfthrow type="breezeAPI.sort.allowedSorts" detail="You must set the allowed sorts list before getting the sort array" />
		</cfif>
		<cfloop from="1" to="#arrayLen(variables.arrSort)#" index="i">
			<cfif listFind(getAllowedSorts(),variables.arrSort[i].name)>
				<cfset tmpStruct = structNew() />
				<cfset tmpStruct['sort-'&variables.arrSort[i].name] = variables.arrSort[i].order />
				<cfset arrayAppend(returnArray,tmpStruct)>
			<cfelse>
				<cfthrow type="breezeAPI.sort.allowedSorts" detail="The sort #variables.arrSort[i].name# is not an allowed sort for this method." />
			</cfif>
		</cfloop>
		<cfreturn returnArray />
	</cffunction>
	
	<cffunction name="setAllowedSorts" access="public" output="false" returntype="void">
		<cfargument name="allowedSorts" type="string" required="true" />
		
		<cfset variables.allowedSorts = arguments.allowedSorts />
	</cffunction>
	<cffunction name="getAllowedSorts" access="public" output="false" returntype="string">
		<cfreturn variables.allowedSorts />
	</cffunction>
</cfcomponent>