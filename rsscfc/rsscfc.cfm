<cfsetting enablecfoutputonly="true" />
<cfcontent reset="true" />
<cfset rss = createObject("component","rss").init("http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml") />

<cfoutput>
<cfif not structIsEmpty(rss.getImage())><img src="#rss.getImage().url#" alt="#rss.getImage().title#" /></cfif>
<h3 style="margin:0px;">#rss.getTitle()#</h3>
<cfloop condition="#rss.hasNextItem()#">
	<cfset rssItem = rss.next() />
	<div style="margin-top:10px;margin-bottom:10px;"><strong><a href="#rssItem.getLink()#">#rssItem.getTitle()#</a></strong> <span style="font-size:11px;">(published on #dateFormat(rssItem.getPubDate(),"long")#)</span><br />
	<cfif len(rssItem.getAuthor())>by #rssItem.getAuthor()#<br /></cfif>
	#rssItem.getDescription()#
	</div>
</cfloop>
</cfoutput>

<cfabort>

<!--- 
	you can actually create an RSS feed with the components,
	but the underlying java api appears to be limited
	it doesn't have all the necessary setters for the rss.item
 --->
<cfset rss = createObject("component","rss").init() />
<cfset rss.setTitle("Testing Rss") />
<cfset rss.setLink("http://www.remotesynthesis.com/blog/index.cfm") />
<cfset rss.setDescription("description") />
<cfset rss.addItem(title="title1",link="http://www.link1.com",description="description1",guid="www.link1.com") />
<cfset rss.addItem(title="title2",link="http://www.link2.com",description="description2",guid="www.link1.com") />

<cfloop condition="#rss.hasNextItem()#">
	<cfset rssItem = rss.next() />
	<cfoutput><p>#rssItem.getTitle()#</p></cfoutput>
</cfloop>

<cfcontent reset="true" />
<cfoutput>#rss.getXMLString()#</cfoutput>
