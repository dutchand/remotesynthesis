<!--- Document Information -----------------------------------------------------

Title:      rss.cfc

Author:     Brian Rinaldi
Email:      brinaldi@remotesynthesis.com

Website:    http://www.remotesynthesis.com

Purpose:    Create and parse RSS feeds
			mjxml java docs - http://www.myjavatools.com/projects/v.1.4.2/xml/doc/com/myjavatools/xml/Rss.html
			javaLoader.cfc v0.1 - http://www.compoundtheory.com/?action=javaloader.index

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Brian Rinaldi	05/09/2006		Created

------------------------------------------------------------------------------->
<cfcomponent>
	<cffunction name="init" access="public" output="false" returntype="rss">
		<cfargument name="url" type="string" required="false" />
		
		<cfset var arrURLs = arrayNew(1) />
		<cfset variables.instance = structNew() />
		<!--- mjxml.jar is required --->
		<cfset arrURLs[1] = getDirectoryFromPath(getCurrentTemplatePath()) & "mjxml.jar" />
		<!--- mark mandel's java loader is required --->
		<cfset variables.javaLoader = createObject("component","javaLoader").init(arrURLs) />
		<!--- start the current iterator position at 0 --->
		<cfset variables.currentPosition = 0 />

		<cfif structKeyExists(arguments,"url")>
			<cfset loadURL(arguments.url) />
		<cfelse>
			<cfset initRSS() />
		</cfif>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="loadURL" access="public" output="false" returntype="void">
		<cfargument name="url" type="string" required="true" />
		
		<cfset var rssURL=createObject('java','java.net.URL')>
		<cfset rssURL.init(arguments.url) />
		<cfset initRSS(rssURL) />
	</cffunction>
<!--- general feed metadata --->
	<cffunction name="getVersion" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getVersion() />
	</cffunction>
	
	<cffunction name="getOriginalVersion" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getOriginalVersion() />
	</cffunction>
	
	<cffunction name="getTitle" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getTitle() />
	</cffunction>
	<cffunction name="setTitle" access="public" output="false" returntype="void">
		<cfargument name="title" type="string" required="true" />
		<cfset variables.instance.rss.setTitle(arguments.title) />
	</cffunction>
	
	<cffunction name="getLink" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getLink() />
	</cffunction>
	<cffunction name="setLink" access="public" output="false" returntype="void">
		<cfargument name="link" type="string" required="true" />
		<cfset variables.instance.rss.setLink(arguments.link) />
	</cffunction>
	
	<cffunction name="getDescription" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getDescription() />
	</cffunction>
	<cffunction name="setDescription" access="public" output="false" returntype="void">
		<cfargument name="description" type="string" required="true" />
		<cfset variables.instance.rss.setDescription(arguments.description) />
	</cffunction>
	
	<cffunction name="getLanguage" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getLanguage() />
	</cffunction>
	<cffunction name="setLanguage" access="public" output="false" returntype="void">
		<cfargument name="language" type="string" required="true" />
		<cfset variables.instance.rss.setLanguage(arguments.language) />
	</cffunction>
	
	<cffunction name="getPubDate" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getPubDate() />
	</cffunction>
	<cffunction name="setPubDate" access="public" output="false" returntype="void">
		<cfargument name="pubdate" type="string" required="true" />
		<cfset variables.instance.rss.setPubDate(arguments.pubdate) />
	</cffunction>
	
	<cffunction name="getLastBuildDate" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getLastBuildDate() />
	</cffunction>
	<cffunction name="setLastBuildDate" access="public" output="false" returntype="void">
		<cfargument name="lastBuildDate" type="string" required="true" />
		<cfset variables.instance.rss.setLastBuildDate(arguments.lastBuildDate) />
	</cffunction>
	
	<cffunction name="getGenerator" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getGenerator() />
	</cffunction>
	<cffunction name="setGenerator" access="public" output="false" returntype="void">
		<cfargument name="generator" type="string" required="true" />
		<cfset variables.instance.rss.setGenerator(arguments.generator) />
	</cffunction>
	
	<cffunction name="getDocs" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getDocs() />
	</cffunction>
	<cffunction name="setDocs" access="public" output="false" returntype="void">
		<cfargument name="docs" type="string" required="true" />
		<cfset variables.instance.rss.setDocs(arguments.docs) />
	</cffunction>
	
	<cffunction name="getManagingEditor" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getManagingEditor() />
	</cffunction>
	<cffunction name="setManagingEditor" access="public" output="false" returntype="void">
		<cfargument name="managingEditor" type="string" required="true" />
		<cfset variables.instance.rss.setManagingEditor(arguments.managingEditor) />
	</cffunction>
	
	<cffunction name="getWebmaster" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getWebmaster() />
	</cffunction>
	<cffunction name="setWebmaster" access="public" output="false" returntype="void">
		<cfargument name="webmaster" type="string" required="true" />
		<cfset variables.instance.rss.setWebmaster(arguments.webmaster) />
	</cffunction>
	
	<cffunction name="getCategory" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getCategory() />
	</cffunction>
	<cffunction name="setCategory" access="public" output="false" returntype="void">
		<cfargument name="category" type="string" required="true" />
		<cfset variables.instance.rss.setCategory(arguments.category) />
	</cffunction>
	
	<cffunction name="getTtl" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getTtl() />
	</cffunction>
	<cffunction name="setTtl" access="public" output="false" returntype="void">
		<cfargument name="ttl" type="string" required="true" />
		<cfset variables.instance.rss.setTtl(arguments.ttl) />
	</cffunction>
	
	<cffunction name="getImage" access="public" output="false" returntype="struct">
		<cfset var jImage = variables.instance.rss.getImage() />
		<cfset var stImage = structNew() />
		<cftry>
			<cfset stImage.Description = jImage.getDescription() />
			<cfset stImage.Link = jImage.getLink() />
			<cfset stImage.Name = jImage.getName() />
			<cfset stImage.Title = jImage.getTitle() />
			<cfset stImage.URL = jImage.getUrl() />
			<cfset stImage.Width = jImage.getWidth() />
			<cfset stImage.Height = jImage.getHeight() />
			<cfcatch type="any">
				<!--- if there is no image defined an error is generated --->
			</cfcatch>
		</cftry>
		<cfreturn stImage />
	</cffunction>
	<cffunction name="setImage" access="public" output="false" returntype="void">
		<cfargument name="title" type="string" required="true" />
		<cfargument name="url" type="string" required="true" />
		<cfargument name="link" type="string" required="true" />
		<cfargument name="description" type="string" required="false" default="" />
		<cfargument name="height" type="string" required="false" default="" />
		<cfargument name="width" type="string" required="false" default="" />
		
		<cfset variables.instance.rss.setImage(arguments.title,arguments.description,arguments.url,arguments.link,arguments.width,arguments.height)>
	</cffunction>
	
	<cffunction name="getRating" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getRating() />
	</cffunction>
	<cffunction name="setRating" access="public" output="false" returntype="void">
		<cfargument name="rating" type="string" required="true" />
		<cfset variables.instance.rss.setRating(arguments.rating) />
	</cffunction>
	
	<cffunction name="getTextInput" access="public" output="false" returntype="struct">
		<cfset var jTextInput = variables.instance.rss.getTextInput() />
		<cfset var stTextInput = structNew() />
		<cftry>
			<cfset stTextInput.Description = jTextInput.getDescription() />
			<cfset stTextInput.Link = jTextInput.getLink() />
			<cfset stTextInput.Name = jTextInput.getName() />
			<cfset stTextInput.Title = jTextInput.getTitle() />
			<cfcatch type="any">
				<!--- if there is no text input defined an error is generated --->
			</cfcatch>
		</cftry>
		<cfreturn stTextInput />
	</cffunction>
	<cffunction name="setTextInput" access="public" output="false" returntype="void">
		<cfargument name="title" type="string" required="true" />
		<cfargument name="name" type="string" required="true" />
		<cfargument name="link" type="string" required="true" />
		<cfargument name="description" type="string" required="true" />
		
		<cfset variables.instance.rss.setTextInput(arguments.title,arguments.description,arguments.name,arguments.link)>
	</cffunction>
	
	<cffunction name="getSkipHours" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getSkipHours() />
	</cffunction>
	<cffunction name="setSkipHours" access="public" output="false" returntype="void">
		<cfargument name="skipHours" type="string" required="true" />
		<cfset variables.instance.rss.setSkipHours(arguments.skipHours) />
	</cffunction>
	
	<cffunction name="getSkipDays" access="public" output="false" returntype="string">
		<cfreturn variables.instance.rss.getSkipDays() />
	</cffunction>
	<cffunction name="setSkipDays" access="public" output="false" returntype="void">
		<cfargument name="skipDays" type="string" required="true" />
		<cfset variables.instance.rss.setSkipDays(arguments.skipDays) />
	</cffunction>
	<!--- NOTE: not implemented - getters and setters for cloud --->
<!--- end feed metadata --->

	<cffunction name="getXMLString" access="public" output="false" returntype="any">
		<!--- 
			the rss class inherits a getValue() method from the basicxmdata class
			however calls to this method returned odd errors in ColdFusion
			therefore the only way I could figure to get the rss was to save a text file and read it back in
			any assitance on this would be helpful --->
		<cfset var tempFilePath = expandPath(".") & "\rss.txt" />
		<cfset var fileContent = "" />
		<cfset var file=createObject('java','java.io.File').init(tempFilePath)>
		<cfset variables.instance.rss.save(file) />
		<cffile action="read" file="#tempFilePath#" variable="fileContent" charset="utf-8" />
		<cfreturn trim(fileContent) />
	</cffunction>
	
	<cffunction name="getItems" access="public" output="false" returntype="array">
		<cfreturn variables.instance.rss.getItems() />
	</cffunction>
	
	<cffunction name="getItemCount" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.rss.getItemCount() />
	</cffunction>
	
	<cffunction name="hasNextItem" access="public" output="false" returntype="boolean">
		<cfreturn variables.currentPosition LT getItemCount() />
	</cffunction>
	
	<cffunction name="next" access="public" output="false" returntype="rssItem">
		<cfset var rssItems = getItems()>
		<cfset var jRssItem = "" />
		<cfset var rssItem =  "" />
		<cfset variables.currentPosition = variables.currentPosition + 1 />
		<cfset jRssItem = rssItems[variables.currentPosition] />
		<cfset rssItem = createObject("component","rssItem").init(jRssItem) />
		<cfreturn rssItem />
	</cffunction>
	
	<cffunction name="getItemByTitle" access="public" output="false" returntype="rssItem">
		<cfargument name="title" type="string" required="true" />
		<cfset var jRssItem = "" />
		<cfset var rssItem = "" />
		
		<cftry>
			<cfset jRssItem = variables.instance.rss.getItem(trim(arguments.title)) />
			<cfset rssItem = createObject("component","rssItem").init(jRssItem) />
			<cfreturn rssItem />
			<cfcatch type="any">
				<cfthrow errorcode="rss.item.notFound" detail="The rss item was not found." />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="findItemByUrl" access="public" output="false" returntype="rssItem">
		<cfargument name="url" type="string" required="true" />
		<cfset var jRssItem = "" />
		<cfset var rssItem = "" />
		
		<cftry>
			<cfset jRssItem = variables.instance.rss.findItemByUrl(trim(arguments.url)) />
			<cfset rssItem = createObject("component","rssItem").init(jRssItem) />
			<cfreturn rssItem />
			<cfcatch type="any">
				<cfthrow errorcode="rss.item.notFound" detail="The rss item was not found." />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="findItemByGuid" access="public" output="false" returntype="rssItem">
		<cfargument name="guid" type="string" required="true" />
		<cfset var jRssItem = "" />
		<cfset var rssItem = "" />
		
		<cftry>
			<cfset jRssItem = variables.instance.rss.findItemByGuid(trim(arguments.guid)) />
			<cfset rssItem = createObject("component","rssItem").init(jRssItem) />
			<cfreturn rssItem />
			<cfcatch type="any">
				<cfthrow errorcode="rss.item.notFound" detail="The rss item was not found." />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="addItem" access="public" output="false" returntype="void">
		<cfargument name="title" type="string" required="false" default="" />
		<cfargument name="link" type="string" required="false" default="" />
		<cfargument name="description" type="string" required="false" default="" />
		<cfargument name="author" type="string" required="false" default="" />
		<cfargument name="pubDate" type="string" required="false" default="" />
		<cfargument name="category" type="string" required="false" default="" />
		<cfargument name="comments" type="string" required="false" default="" />
		<cfargument name="expirationDate" type="string" required="false" default="" />
		<cfargument name="sourceName" type="string" required="false" default="" />
		<cfargument name="sourceURL" type="string" required="false" default="" />
		<cfargument name="enclosureURL" type="string" required="false" default="" />
		<cfargument name="enclosureLength" type="string" required="false" default="" />
		<cfargument name="enclosureType" type="string" required="false" default="" />
		
		<cfset var rssItem = "" />
		<cfset variables.instance.rss.addItem(arguments.title,arguments.link,arguments.description) />
		<cfset rssItem = getItemByTitle(arguments.title) />
		<cfif len(arguments.author)>
			<cfset rssItem.setAuthor(arguments.author) />
		</cfif>
		<cfif len(arguments.author)>
			<cfset rssItem.setPubDate(arguments.pubDate) />
		</cfif>
		<cfif len(arguments.category)>
			<cfset rssItem.setCategory(arguments.category) />
		</cfif>
		<cfif len(arguments.comments)>
			<cfset rssItem.setComments(arguments.comments) />
		</cfif>
		<cfif len(arguments.expirationDate)>
			<cfset rssItem.setExpirationDate(arguments.expirationDate) />
		</cfif>
		<cfif len(arguments.sourceName)>
			<cfset rssItem.setSource(arguments.sourceName,arguments.sourceURL) />
		</cfif>
		<cfif len(arguments.enclosureURL)>
			<cfset rssItem.setEnclosure(arguments.enclosureURL,arguments.enclosureLength,arguments.enclosureType) />
		</cfif>
	</cffunction>
	
	<cffunction name="initRSS" access="private" output="false" returntype="void">
		<cfargument name="rssURL" type="any" required="false" />
		
		<cfif structKeyExists(arguments,"rssURL")>
			<cfset variables.instance.rss = javaLoader.create("com.myjavatools.xml.Rss").init(arguments.rssURL) />
		<cfelse>
			<!--- create an empty rss instance --->
			<cfset variables.instance.rss = javaLoader.create("com.myjavatools.xml.Rss") />
		</cfif>
	</cffunction>
	
	<!---
		NOTE: could not get this to work.
		unfortunately, setter methods within item are limited, thereby making it difficult to create a
		decent rss feed using the addItem method (ex. no setGuid() method exists and one can only
		set a single category
		
	<cffunction name="initRSSItem" access="private" output="false" returntype="void">
		<cfset variables.instance.jRssItem = javaLoader.create("com.myjavatools.xml.Rss.Item") />
	</cffunction> --->
	
	<cffunction name="dump" access="public" output="true" returntype="void">
		<cfdump var="#variables.instance#" />
	</cffunction>
</cfcomponent>