<!--- example taken from http://en.wikipedia.org/wiki/Help:Wikitext_examples --->

<cfset WikiConverter = createObject("component","WikiConverter").init() />
<Cfsavecontent variable="foo">
You can ''italicize text'' by putting 2 
apostrophes on each side. 

3 apostrophes will bold '''the text'''. 

5 apostrophes will bold and italicize 
'''''the text'''''.

(Using 4 apostrophes doesn't do anything
special -- <br> there are just '''' left
over ones'''' that are included as part of the text.)
</Cfsavecontent>
<cfset html = WikiConverter.WikiToHtml("http://localhost/${image}","http://localhost/${title}",foo) />
<cfoutput>#html#</cfoutput>
<cfoutput>#WikiConverter.HtmlToWiki(html)#</cfoutput>