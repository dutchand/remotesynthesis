<cfcomponent>
	<cffunction name="init" access="public" output="false" returntype="rssItem">
		<!--- initialize by passing the java object --->
		<cfargument name="jRssItem" required="true" type="any" />

		<cfset variables.instance = structNew() />
		<cfset variables.instance.rssItem = arguments.jRssItem />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getTitle" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rssItem.getTitle() />
	</cffunction>
	
	<cffunction name="getLink" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rssItem.getLink() />
	</cffunction>
	
	<cffunction name="getDescription" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rssItem.getDescription() />
	</cffunction>
	<cffunction name="setDescription" access="public" output="false" returntype="void">
		<cfargument name="description" type="string" required="true" />
		<cfset variables.instance.rssItem.setDescription(arguments.description) />
	</cffunction>
	
	<cffunction name="getAuthor" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rssItem.getAuthor() />
	</cffunction>
	<cffunction name="setAuthor" access="public" output="false" returntype="void">
		<cfargument name="author" type="string" required="true" />
		<cfset variables.instance.rssItem.setAuthor(arguments.author) />
	</cffunction>
	
	<cffunction name="getCategory" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rssItem.getCategory() />
	</cffunction>
	<cffunction name="setCategory" access="public" output="false" returntype="void">
		<cfargument name="category" type="string" required="true" />
		<cfset variables.instance.rssItem.setCategory(arguments.category) />
	</cffunction>
	
	<cffunction name="getComments" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rssItem.getComments() />
	</cffunction>
	<cffunction name="setComments" access="public" output="false" returntype="void">
		<cfargument name="comments" type="string" required="true" />
		<cfset variables.instance.rssItem.setComments(arguments.comments) />
	</cffunction>
	
	<cffunction name="getGuid" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rssItem.getGuid() />
	</cffunction>
	
	<cffunction name="getPubDate" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rssItem.getPubDate() />
	</cffunction>
	<cffunction name="setPubDate" access="public" output="false" returntype="void">
		<cfargument name="pubdate" type="string" required="true" />
		<cfset variables.instance.rssItem.setPubDate(arguments.pubdate) />
	</cffunction>
	
	<cffunction name="getExpirationDate" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rssItem.getExpirationDate() />
	</cffunction>
	<cffunction name="setExpirationDate" access="public" output="false" returntype="void">
		<cfargument name="expirationDate" type="string" required="true" />
		<cfset variables.instance.rssItem.setExpirationDate(arguments.expirationDate) />
	</cffunction>
	
	<cffunction name="getSource" access="public" output="false" returntype="struct">
		<cfset var stSource = structNew() />
		<!--- trim forces them to return as empty string instead of undefined if no source exists --->
		<cfset stSource.name = trim(variables.instance.rssItem.getSourceName()) />
		<cfset stSource.url = trim(variables.instance.rssItem.getSourceUrl()) />
		<cfreturn stSource />
	</cffunction>
	<cffunction name="setSource" access="public" output="false" returntype="void">
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="url" type="string" required="false" default="" />
		<cfset variables.instance.rssItem.setSource(arguments.url,arguments.name) />
	</cffunction>
	
	<cffunction name="getEnclosure" access="public" output="false" returntype="struct">
		<cfset var stEnclosure = structNew() />
		<!--- trim forces them to return as empty string instead of undefined if no source exists --->
		<cfset stEnclosure.url = trim(variables.instance.rssItem.getEnclosureUrl()) />
		<cfset stEnclosure.length = trim(variables.instance.rssItem.getEnclosureLength()) />
		<cfset stEnclosure.type = trim(variables.instance.rssItem.getEnclosureType()) />
		<cfreturn stEnclosure />
	</cffunction>
	<cffunction name="setEnclosure" access="public" output="false" returntype="void">
		<cfargument name="url" type="string" required="false" default="" />
		<cfargument name="length" type="string" required="false" default="" />
		<cfargument name="type" type="string" required="false" default="" />
		<cfset variables.instance.rssItem.setEnclosure(arguments.url,arguments.length,arguments.type) />
	</cffunction>
	
	<cffunction name="getUrl" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rssItem.getUrl() />
	</cffunction>
	<cffunction name="setUrl" access="public" output="false" returntype="void">
		<cfargument name="url" type="string" required="true" />
		<cfset variables.instance.rssItem.setUrl(arguments.url) />
	</cffunction>
	
	<cffunction name="getjItem" access="public" output="false" returntype="any">
		<cfreturn variables.instance.rssItem />
	</cffunction>
	
	<cffunction name="dump" access="public" output="true" returntype="void">
		<cfdump var="#variables.instance#" />
	</cffunction>
</cfcomponent>