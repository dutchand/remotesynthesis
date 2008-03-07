<cfparam name="attributes.query" type="query" />
<cfparam name="attributes.jsPath" type="string" default="" />
<cfparam name="attributes.includeJQueryScript" type="boolean" default="true" />
<cfparam name="attributes.includeUIScript" type="boolean" default="true" />
<cfparam name="attributes.includeCSSTheme" type="boolean" default="true" />

<cfsetting enablecfoutputonly="true" />
<cffunction name="_getSortOrderInt" access="private" output="false" returntype="numeric">
	<cfargument name="sortString" type="string" required="true" />
	
	<cfif sortString eq "none">
		<cfreturn -1 />
	<cfelseif sortString eq "asc">
		<cfreturn 0 />
	<cfelse>
		<cfreturn 1 />
	</cfif>
</cffunction>
<!---
 Returns all the matches of a regular expression within a string.
 
 @param regex 	 Regular expression. (Required)
 @param text 	 String to search. (Required)
 @return Returns a structure. 
 @author Ben Forta (ben@forta.com) 
 @version 1, July 15, 2005 
--->
<cffunction name="_reFindAll" output="true" returnType="struct">
   <cfargument name="regex" type="string" required="yes">
   <cfargument name="text" type="string" required="yes">

   <!--- Define local variables --->	
   <cfset var results=structNew()>
   <cfset var pos=1>
   <cfset var subex="">
   <cfset var done=false>
	
   <!--- Initialize results structure --->
   <cfset results.len=arraynew(1)>
   <cfset results.pos=arraynew(1)>

   <!--- Loop through text --->
   <cfloop condition="not done">

      <!--- Perform search --->
      <cfset subex=reFind(arguments.regex, arguments.text, pos, true)>
      <!--- Anything matched? --->
      <cfif subex.len[1] is 0>
         <!--- Nothing found, outta here --->
         <cfset done=true>
      <cfelse>
         <!--- Got one, add to arrays --->
         <cfset arrayappend(results.len, subex.len[1])>
         <cfset arrayappend(results.pos, subex.pos[1])>
         <!--- Reposition start point --->
         <cfset pos=subex.pos[1]+subex.len[1]>
      </cfif>
   </cfloop>

   <!--- If no matches, add 0 to both arrays --->
   <cfif arraylen(results.len) is 0>
      <cfset arrayappend(results.len, 0)>
      <cfset arrayappend(results.pos, 0)>
   </cfif>

   <!--- and return results --->
   <cfreturn results>
</cffunction>
	
<cfif thisTag.ExecutionMode eq "start">

<cfset caller._sortabletable = structNew() />
<cfparam name="caller._sortabletable.tableid" default="0" />
<cfparam name="caller._sortabletable.includeJQueryScript" default="#attributes.includeJQueryScript#" />
<cfparam name="caller._sortabletable.includeUIScript" default="#attributes.includeUIScript#" />
<cfparam name="caller._sortabletable.includeCSSTheme" default="#attributes.includeCSSTheme#" />
<cfset caller._sortabletable.tableid = caller._sortabletable.tableid + 1 />

<cfoutput>
<cfif caller._sortabletable.includeJQueryScript>
	<link rel="stylesheet" href="#attributes.jsPath#/themes/flora/flora.all.css" type="text/css" media="screen" title="Flora (Default)" />
	<cfset caller._sortabletable.includeCSSTheme = false />
</cfif>
<cfif caller._sortabletable.includeJQueryScript>
	
	<script type="text/javascript" src="#attributes.jsPath#/jquery-1.2.1.js"></script>
	<cfset caller._sortabletable.includeJQueryScript = false />
</cfif>
<cfif caller._sortabletable.includeUIScript>
	<script  src="#attributes.jsPath#/ui.tablesorter.js"></script>
	<cfset caller._sortabletable.includeUIScript = false />
</cfif>
</cfoutput>
<cfelse>
<!--- build the sort and disable js string --->
<cfset sortList = "" />
<cfset disableList = "" />
<cfloop from="1" to="#arrayLen(thisTag.columns)#" index="i">
	<cfif len(thisTag.columns[i].sort) and _getSortOrderInt(thisTag.columns[i].sort) gte 0>
		<cfset sortList = listAppend(sortList,"[#i-1#,#_getSortOrderInt(thisTag.columns[i].sort)#]")>
	<cfelseif thisTag.columns[i].disable eq true>
		<cfset disableList = listAppend(disableList,"#i-1#: { sorter: false}")>
	</cfif>
</cfloop>
<cfset separator = "" />
<cfoutput>
	<script>
		$(document).ready(function(){
		$("##table-#caller._sortabletable.tableid#").tablesorter({<cfif len(sortList)><cfset separator = ",">sortList: [#sortList#]</cfif><cfif len(disableList)><cfset separator = ",">#separator#headers: {#disableList#}</cfif>#separator#widgets: ['zebra']});
		});
	</script>
	<table id="table-#caller._sortabletable.tableid#" class="tablesorter" border="0" cellpadding="0" cellspacing="1">
		<thead>
			<tr>
			<cfloop from="1" to="#arrayLen(thisTag.columns)#" index="i">
				<td>#thisTag.columns[i].title#</td>
			</cfloop>
			</tr>
		</thead>
		<tbody>
		<cfloop query="attributes.query">
			<tr>
			<cfloop from="1" to="#arrayLen(thisTag.columns)#" index="i">
				<td>
				<cfif len(thisTag.columns[i].pre)>
					<cfset pre = thisTag.columns[i].pre />
					<cfif reFind("\{\w+\}",thisTag.columns[i].pre)>
						<cfset exp = _reFindAll("\{[^{]+\}",thisTag.columns[i].pre) />
						<cfloop from="1" to="#arrayLen(exp.len)#" index="j">
							<cftry>
								<cfset col = mid(thisTag.columns[i].pre,exp.pos[j],exp.len[j])>
								<cfset val = attributes.query[ReplaceList(col,"{,}",",")][attributes.query.currentrow] />
								<cfset pre = replaceNoCase(pre,col,val) />
								<cfcatch type="any">
									<cfrethrow />
								</cfcatch>
							</cftry>
						</cfloop>
					</cfif>
					#pre#
				</cfif>
				<cfif len(thisTag.columns[i].format)>
					#evaluate(thisTag.columns[i].format)#
				<cfelseif len(thisTag.columns[i].column)>
					#attributes.query[thisTag.columns[i].column][attributes.query.currentrow]#
				</cfif>
				<cfif len(thisTag.columns[i].post)>#thisTag.columns[i].post#</cfif>
				</td>
			</cfloop>
			</tr>
		</cfloop>
		</tbody>
	</table>
</cfoutput>
</cfif>
<cfsetting enablecfoutputonly="false" />