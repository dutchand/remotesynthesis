<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<cfif thisTag.executionMode EQ "start">
	
	<!--- all categories --->
	<mangox:TemplatePod id="categories" title="ARCHIVES BY SUBJECT">
		<mango:Categories parent="">
			<mango:Category>
				<a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty title />"><mango:CategoryProperty title /> (<mango:CategoryProperty postcount />)</a><br />
			</mango:Category>
		</mango:Categories>
	</mangox:TemplatePod>
	
	<!--- text-link-ads --->
	<mangox:TemplatePod id="tla" title="SPONSORED LINKS">
		<cfparam name="url.reloadTLA" default="false" />
		<cfif not structKeyExists(application,"tla") or url.reloadTLA>
			<cfset application.tla = createObject("component","tla").init("V25HD8FESF3FKPOZ8IUJ") />
		</cfif>
		<cfif dateCompare(application.tla.getLastUpdated(),dateAdd("h",-1,now())) eq -1 or url.reloadTLA>
			<cfset application.tla.setInventory() />
		</cfif>
		<cfset tlaquery = application.tla.getInventoryAsQuery() />
		<cfif tlaquery.recordCount gt 0>
			<cfoutput query="tlaquery">
				<div style="float:left;clear:none;margin:0;width:100%;display:inline;padding:0;"><span style="display:block;padding:3px;width:100%;color:##C2D9F8;margin:0;font-size: 12px;">
					#beforetext#
					<a style="font-size:12px;" href="#url#">#text#</a>
					#aftertext#</span>
				</div>
			</cfoutput>
		</cfif>
	</mangox:TemplatePod>
	
	<!--- all archives by month --->
	<mangox:TemplatePod id="monthly-archives" title="MONTHLY ARCHIVES">
		<mango:Archives type="month" from="1" count="12"><mango:Archive>
			<a href="<mango:ArchiveProperty link />"><mango:ArchiveProperty title dateformat="mmmm yyyy" /> (<mango:ArchiveProperty postcount />)</a><br />
		</mango:Archive></mango:Archives>
		<a href="<mango:Blog basePath />pages/archive.cfm">Older than <mango:Archives type="month" from="12" count="12"><mango:Archive><mango:ArchiveProperty title dateformat="mmmm yyyy" /></mango:Archive></mango:Archives></a>
	</mangox:TemplatePod>
				
	<!--- feeds --->
	<!---<mangox:TemplatePod id="feeds" title="FEEDS">
	 	<a href="<mango:Blog rssurl />" class="last">RSS Feed</a><br />
		<a href="<mango:Blog atomurl />" class="last">ATOM Feed</a>
	</mangox:TemplatePod>--->
				
	<!--- output all the pods, including the ones added by plugins --->
	<mangox:Pods>
		<mangox:Pod>
		<div class="sidebar-box">
			<div class="pushpin">
			</div>
			<div class="sidebar-box-inner">
			<mangox:PodProperty ifHasTitle>
			<span style="font-weight:bold;font-size:15px;"><mangox:PodProperty title /></span><br /><br />
				<mangox:PodProperty content />
			</mangox:PodProperty>
			</div>
		</div>
		</mangox:Pod>
	</mangox:Pods>
</cfif>