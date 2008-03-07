<cfcomponent displayname="Connect API">
	<cffunction name="init" access="public" output="false" returntype="connectAPI">
		<cfargument name="url" type="string" required="true" />
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
		<cfargument name="proxyServer" type="string" required="false" />
		<cfargument name="proxyPort" type="numeric" required="false" />
		<cfargument name="proxyUser" type="string" required="false" />
		<cfargument name="proxyPassword" type="string" required="false" />
		
		<!--- set an empty session --->
		<cfset setBreezeSession("") />
		<cfset setURL(arguments.url) />
		<cfset setUsername(arguments.username) />
		<cfset setPassword(arguments.password) />
		<cfset setProxyServer(arguments.proxyServer) />
		<cfset setProxyPort(arguments.proxyPort) />
		<cfset setProxyUser(arguments.proxyUser) />
		<cfset setProxyPassword(arguments.proxyPassword) />
		<cfset login() />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSort" access="public" output="false" returntype="sort">
		<cfreturn createObject("component","sort").init() />
	</cffunction>
	
	<cffunction name="getFilter" access="public" output="false" returntype="filter">
		<cfreturn createObject("component","filter").init() />
	</cffunction>
	
	<cffunction name="setURL" access="private" output="false" returntype="void">
		<cfargument name="url" type="string" required="true" />
		<cfset variables.url = arguments.url />
	</cffunction>
	<cffunction name="getURL" access="private" output="false" returntype="string">
		<cfreturn variables.url />
	</cffunction>
	
	<cffunction name="setUsername" access="private" output="false" returntype="void">
		<cfargument name="username" type="string" required="true" />
		<cfset variables.username = arguments.username />
	</cffunction>
	<cffunction name="getUsername" access="private" output="false" returntype="string">
		<cfreturn variables.username />
	</cffunction>
	
	<cffunction name="setPassword" access="private" output="false" returntype="void">
		<cfargument name="password" type="string" required="true" />
		<cfset variables.password = arguments.password />
	</cffunction>
	<cffunction name="getPassword" access="private" output="false" returntype="string">
		<cfreturn variables.password />
	</cffunction>
	
	<cffunction name="setProxyServer" access="private" output="false" returntype="void">
		<cfargument name="proxyServer" type="string" required="true" />
		<cfset variables.proxyServer = arguments.proxyServer />
	</cffunction>
	<cffunction name="getProxyServer" access="private" output="false" returntype="string">
		<cfreturn variables.proxyServer />
	</cffunction>
	
	<cffunction name="setProxyPort" access="private" output="false" returntype="void">
		<cfargument name="proxyPort" type="numeric" required="true" />
		<cfset variables.proxyPort = arguments.proxyPort />
	</cffunction>
	<cffunction name="getProxyPort" access="private" output="false" returntype="string">
		<cfreturn variables.proxyPort />
	</cffunction>
	
	<cffunction name="setProxyUser" access="private" output="false" returntype="void">
		<cfargument name="proxyUser" type="string" required="true" />
		<cfset variables.proxyUser = arguments.proxyUser />
	</cffunction>
	<cffunction name="getProxyUser" access="private" output="false" returntype="string">
		<cfreturn variables.proxyUser />
	</cffunction>
	
	<cffunction name="setProxyPassword" access="private" output="false" returntype="void">
		<cfargument name="proxyPassword" type="string" required="true" />
		<cfset variables.proxyPassword = arguments.proxyPassword />
	</cffunction>
	<cffunction name="getProxyPassword" access="private" output="false" returntype="string">
		<cfreturn variables.proxyPassword />
	</cffunction>
	
	<cffunction name="login" access="private" output="false" returntype="boolean">
		<cfset var paramsXML = createParams(action="login",login=getUserName(),password=getPassword()) />
		<cfset var response = doAction(paramsXML) />
		<cfif response.results.status.xmlAttributes.code eq "ok">
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
	<cffunction name="logout" access="public" output="false" returntype="boolean">
		<cfset var paramsXML = createParams(action="logout",session=getBreezeSession()) />
		<cfset var response = doAction(paramsXML) />
		<cfif response.results.status.xmlAttributes.code eq "ok">
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<cffunction name="setBreezeSession" access="private" output="false" returntype="void">
		<cfargument name="breezeSession" type="string" required="true" />
		<cfset variables.breezeSession = arguments.breezeSession />
	</cffunction>
	<cffunction name="getBreezeSession" access="private" output="false" returntype="string">
		<cfreturn variables.breezeSession />
	</cffunction>
	
	<cffunction name="isAllowableLang" access="private" output="false" returntype="boolean">
		<cfargument name="lang" required="true" />
		
		<cfset var allowableLangList = "en,eng,fr,fre,de,ger,ja,jpn,ko,kor" />
		<cfif listFind(allowableLangList,arguments.lang)>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<cffunction name="isAllowableType" access="private" output="false" returntype="boolean">
		<cfargument name="parentType" required="true" />
		<cfargument name="type" required="true" />
		
		<cfset var types = structNew() />
		<cfset var types['sco'] = "content,course,curriculum,event,folder,link,meeting,session,tree" />
		<cfset var types['content'] = "archive,attachment,authorware,authorware,course,curriculum,external-event,flv,image,meeting,presentation,swf" />
		<cfset var types['principals'] = "admins,authors,course-admins,event-admins,event-group,everyone,external-group,external-user,group,guest,learners,live-admins,seminar-admins,user" />
		<cfset var types['custom'] = "required,optional,optional-no-self-reg" />
		<cfif listFind(types[arguments.parentType],arguments.type)>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<cffunction name="doAction" access="private" output="false" returntype="xml">
		<cfargument name="argsXML" type="xml" required="true" />
		<cfset var url = getURL() />
		<cfif len(getBreezeSession())>
			<cfset url = url & "?session=" & getBreezeSession() />
		</cfif>
		<cfif len(getProxyServer())>
			<cfif not len(getProxyPort()) or not len(getProxyUser()) or not len(getProxyPassword())>
				<cfthrow errorcode="connectAPI.proxyInfo" message="You must supply all proxy info including server, port, user and password." />
			</cfif>
			<cfhttp url="#url#" method="post" proxyserver="#getProxyServer()#" proxyport="#getProxyPort()#" proxyuser="#getProxyUser()#" proxypassword="#getProxyPassword()#">
				<cfhttpparam type="xml" value="#arguments.argsXML#" />
			</cfhttp>
		<cfelse>
			<cfhttp url="#url#" method="post">
				<cfhttpparam type="xml" value="#arguments.argsXML#" />
			</cfhttp>
		</cfif>
		<cfif not len(getBreezeSession()) and findNoCase("breezesession",cfhttp.header)>
			<cfset setBreezeSession(ListLast(ListFirst(cfhttp.header, ";"), "=")) />
		</cfif>
		<cfreturn xmlParse(cfhttp.FileContent) />
	</cffunction>
	
	<cffunction name="createParams" access="private" output="false" returntype="string" hint="accepts any arguments list and sends back as param formatted xml">
		<cfset var returnXML = "" />
		<cfset var thisItem = "" />
		<cfoutput>
		<cfxml variable="returnXML">
		<params>
		<cfloop collection="#arguments#" item="thisItem">
			<param name="#thisItem#">#xmlFormat(arguments[thisItem])#</param>
		</cfloop>
		</params>
		</cfxml>
		</cfoutput>
		<cfreturn returnXML />
	</cffunction>
	
	<cffunction name="appendSorts" access="private" output="false" returntype="void">
		<cfargument name="params" type="struct" required="true" />
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="allowedSortValues" type="string" required="true" />
		<cfset var i = 0 />
		<cfset var sortArray = arguments.sort.getSortArray(arguments.allowedSortValues) />
		<cfloop from="1" to="#arrayLen(sortArray)#" index="i">
			<cfset structAppend(params,sortArray[i]) />
		</cfloop>
	</cffunction>
	
	<cffunction name="appendFilters" access="private" output="false" returntype="void">
		<cfargument name="params" type="struct" required="true" />
		<cfargument name="filter" type="filter" required="false" />
		<cfargument name="allowedFilterValues" type="string" required="true" />
		<cfset var i = 0 />
		<cfset var filterArray = arguments.filter.getFilterArray(arguments.allowedFilterValues) />
		<cfloop from="1" to="#arrayLen(filterArray)#" index="i">
			<cfset structAppend(params,filterArray[i]) />
		</cfloop>
	</cffunction>
	
	<!--- general functions --->
	<cffunction name="commonInfo" access="public" output="false" returntype="xml">
		<cfargument name="domain" type="string" required="false" default="" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="common-info" />
		<cfif len(arguments.domain)>
			<cfset params['domain'] = arguments.domain />
		</cfif>
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<!--- user functions --->
	<cffunction name="principalUpdate" access="public" output="false" returntype="xml">
		<cfargument name="first_name" type="string" required="true" />
		<cfargument name="last_name" type="string" required="true" />
		<cfargument name="login" type="string" required="true" hint="email" />
		<cfargument name="password" type="string" required="true" />
		<cfargument name="email" type="string" required="true" hint="email" />
		<cfargument name="type" type="string" required="false" default="user" />
		<cfargument name="send_email" type="boolean" required="false" default="true" />
		<cfargument name="has_children" type="boolean" required="false" default="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="principal-update" />
		<cfset params['first-name'] = arguments.first_name />
		<cfset params['last-name'] = arguments.last_name />
		<cfset params['login'] = arguments.login />
		<cfset params['password'] = arguments.password />
		<cfset params['type'] = arguments.type />
		<cfset params['send-email'] = arguments.send_email />
		<cfset params['has-children'] = arguments.has_children />
		<cfset params['email'] = arguments.email />
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="principalList" access="public" output="false" returntype="xml">
		<cfargument name="group_id" type="string" required="false" default="" />
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="principal-list" />
		
		<cfif len(arguments.group_id)>
			<cfset params['group-id'] = arguments.group_id />
		</cfif>
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,"manager-id,principal-id,account-id,type,has-children,is-primary,is-hidden,name,login,email") />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,"manager-id,principal-id,account-id,type,has-children,is-primary,is-hidden,name,login,email") />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<!--- reporting functions --->
	<cffunction name="reportAccountMeetingAttendance" access="public" output="false" returntype="xml">
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-account-meeting-attendance" />
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,"date-closed,date-created,login,participant-name,principal-id,sco-name,tr.sco_id,transcript-id") />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,"date-closed,date-created,login,principal-id,tr.sco_id,transcript-id") />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportActiveMeetingPresenters" access="public" output="false" returntype="xml">
		<cfargument name="sco_id" type="string" required="false" default="" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-active-meeting-presenters" />
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportActiveMeetings" access="public" output="false" returntype="xml">
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-active-meetings" />
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportBulkConsolidatedTransactions" access="public" output="false" returntype="xml">
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset var allowedSortsAndFilters = "date-created,login,name,principal-id,score,status,transaction-id,url,user-name" />
		<cfset params['action']="report-bulk-consolidated-transactions" />
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,allowedSortsAndFilters) />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,allowedSortsAndFilters) />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportBulkObjects" access="public" output="false" returntype="xml">
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset var allowedSortsAndFilters = "date-modified,name,type,url" />
		<cfset params['action']="report-bulk-objects" />
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,allowedSortsAndFilters) />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,allowedSortsAndFilters) />
		</cfif>

		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportBulkQuestions" access="public" output="false" returntype="xml">
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset var allowedSortsAndFilters = "date-created,principal-id,question,response,score,transaction-id" />
		<cfset params['action']="report-bulk-questions" />
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,allowedSortsAndFilters) />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,allowedSortsAndFilters) />
		</cfif>

		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportBulkSlideViews" access="public" output="false" returntype="xml">
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset var allowedSortsAndFilters = "date-created,page,principal-id,transaction-id" />
		<cfset params['action']="report-bulk-slide-views" />
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,allowedSortsAndFilters) />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,allowedSortsAndFilters) />
		</cfif>

		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportBulkUsers" access="public" output="false" returntype="xml">
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset var allowedSortsAndFilters = "email,login,manager,name,principal-id,type" />
		<cfset params['action']="report-bulk-users" />
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,allowedSortsAndFilters) />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,allowedSortsAndFilters) />
		</cfif>

		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportCourseStatus" access="public" output="false" returntype="xml">
		<cfargument name="principal_id" type="string" required="false" default="" />
		<cfargument name="sco_id" type="string" required="false" default="" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-my-meetings" />
		<!--- Note: Only one of the principal-id or sco-id parameters needs to be passed in, based on the type of information needed. --->
		<cfif len(arguments.principal_id)>
			<cfset params['principal-id'] = arguments.principal_id />
		<cfelseif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportMeetingAttendance" access="public" output="false" returntype="xml">
		<cfargument name="sco_id" type="string" required="false" default="" />
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset var allowedSortsAndFilters = "answered-survey,date-created,date-end,login,participant-name,principal-id,sco-id,sco-name,session-name,transcript-id" />
		<cfset params['action']="report-meeting-attendance" />
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,allowedSortsAndFilters) />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,allowedSortsAndFilters) />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportMeetingConcurrentUsers" access="public" output="false" returntype="xml">
		<cfargument name="sco_id" type="string" required="false" default="" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-meeting-concurrent-users" />
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportMeetingSessions" access="public" output="false" returntype="xml">
		<cfargument name="sco_id" type="string" required="false" default="" />
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-meeting-sessions" />
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,"asset-id,date-created,date-end,num-participants,sco-id") />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,"asset-id,date-created,date-end,sco-id") />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportMeetingSummary" access="public" output="false" returntype="xml">
		<cfargument name="sco_id" type="string" required="false" default="" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-meeting-summary" />
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportMyCourses" access="public" output="false" returntype="xml">
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-my-courses" />
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,"date-begin,date-created,date-modified,expired,name,sco-id") />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,"date-begin,date-created,date-modified,name,sco-id") />
		</cfif>

		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportMyEvents" access="public" output="false" returntype="xml">
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-my-events" />
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,"date-begin,date-end,description,domain-name,duration,icon,sco-id,url-path") />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,"date-begin,date-end,description,domain-name,icon,sco-id,url-path") />
		</cfif>

		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportMyMeetings" access="public" output="false" returntype="xml">
		<cfargument name="sort" type="sort" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-my-meetings" />
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,"active-participants,date-begin,date-end,duration,expired,icon,permission-id,sco-id,status") />
		</cfif>

		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportQuizInteractions" access="public" output="false" returntype="xml">
		<cfargument name="sco_id" type="string" required="false" default="" />
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset var allowedSortsAndFilters = "date-created,description,display-seq,interaction-id,name,response,score,sco-name,sco-id,transcript-id" />
		<cfset params['action']="report-quiz-interactions" />
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,allowedSortsAndFilters) />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,allowedSortsAndFilters) />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportQuizQuestionAnswerDistribution" access="public" output="false" returntype="xml">
		<cfargument name="interaction_id" type="string" required="false" default="" />
		<cfargument name="sco_id" type="string" required="false" default="" />
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset var allowedSortsAndFilters = "display_seq,interaction_id,num-selected,response,score" />
		<cfset params['action']="report-quiz-question-answer-distribution" />
		<cfif len(arguments.interaction_id)>
			<cfset params['interaction-id'] = arguments.interaction_id />
		</cfif>
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,allowedSortsAndFilters) />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,allowedSortsAndFilters) />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportQuizQuestionDistribution" access="public" output="false" returntype="xml">
		<cfargument name="sco_id" type="string" required="false" default="" />
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-quiz-question-distribution" />
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,"description,display-seq,interaction-id,name,num-correct,num-incorrect,percentage-correct,score,total-responses") />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,"description,display-seq,interaction-id,name") />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportQuizQuestionResponse" access="public" output="false" returntype="xml">
		<cfargument name="interaction_id" type="string" required="false" default="" />
		<cfargument name="sco_id" type="string" required="false" default="" />
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset var allowedSortsAndFilters = "date-created,interaction-id,principal-id,response,user-name" />
		<cfset params['action']="report-quiz-question-response" />
		<cfif len(arguments.interaction_id)>
			<cfset params['interaction-id'] = arguments.interaction_id />
		</cfif>
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,allowedSortsAndFilters) />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,allowedSortsAndFilters) />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportQuizSummary" access="public" output="false" returntype="xml">
		<cfargument name="sco_id" type="string" required="false" default="" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-quiz-summary" />
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportQuizTakers" access="public" output="false" returntype="xml">
		<cfargument name="sco_id" type="string" required="false" default="" />
		<cfargument name="principal_id" type="string" required="false" default="" />
		<cfargument name="type" type="string" required="false" default="" />
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset var allowedSortsAndFilters = "answered-survey,attempts,contact-id,date-created,login,principal-id,principal-name,status,score,time-taken,transcript-id" />
		<cfset var allowedTypes = "course,presentation,meeting" />
		<cfset params['action']="report-quiz-takers" />
		
		<!--- To get a list of SCOs that a specified principal viewed, pass the principal-id parameter instead of the sco-id parameter. --->
		<cfif len(arguments.sco_id)>
			<cfset params['sco_id'] = arguments.sco_id />
		<cfelseif len(arguments.principal_id)>
			<cfset params['principal-id'] = arguments.principal_id />
		</cfif>
		
		<!--- In addition, you can restrict the list of the SCOs to a specific type by passing an optional type parameter --->
		<cfif listFind(allowedTypes,arguments.type)>
			<cfset params['type'] = arguments.type />
		</cfif>
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,allowedSortsAndFilters) />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,allowedSortsAndFilters) />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportQuotas" access="public" output="false" returntype="xml">
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-quotas" />
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportScoSlides" access="public" output="false" returntype="xml">
		<cfargument name="sco_id" type="string" required="false" default="" />
		<cfargument name="asset_id" type="string" required="false" default="" />
		<cfargument name="sort" type="sort" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-sco-slides" />
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		<cfif len(arguments.asset_id)>
			<cfset params['asset-id'] = arguments.asset_id />
		</cfif>
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,"date-created,slide,views") />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="reportScoViews" access="public" output="false" returntype="xml">
		<cfargument name="sco_id" type="string" required="false" default="" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="report-sco-views" />
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<!--- sco functions --->
	<cffunction name="scoContents" access="public" output="false" returntype="xml">
		<cfargument name="sco_id" type="string" required="false" default="" />
		<cfargument name="sort" type="sort" required="false" />
		<cfargument name="filter" type="filter" required="false" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="sco-contents" />
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		
		<!-- handle sorts if provided --->
		<cfif structKeyExists(arguments,"sort")>
			<cfset appendSorts(params,sort,"date-begin,date-end,date-modified,duration,is-folder,name,sco-id,status,type") />
		</cfif>
		<!-- handle filters if provided --->
		<cfif structKeyExists(arguments,"filter")>
			<cfset appendFilters(params,filter,"date-begin,date-end,date-modified,name,sco-id,status,type") />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="scoExpandedContents" access="public" output="false" returntype="xml">
		<cfargument name="sco_id" type="string" required="false" default="" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="sco-expanded-contents" />
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="scoInfo" access="public" output="false" returntype="xml">
		<cfargument name="sco_id" type="string" required="false" default="" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="sco-info" />
		<cfif len(arguments.sco_id)>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="scoShortcuts" access="public" output="false" returntype="xml">
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="sco-shortcuts" />
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<cffunction name="scoUpdate" access="public" output="false" returntype="xml">
		<cfargument name="author_info_1" type="string" required="false" default="" />
		<cfargument name="author_info_2" type="string" required="false" default="" />
		<cfargument name="author_info_3" type="string" required="false" default="" />
		<cfargument name="date_begin" type="date" required="false" />
		<cfargument name="date_end" type="date" required="false" />
		<cfargument name="description" type="string" required="false" default="" />
		<cfargument name="email" type="string" required="false" default="" />
		<cfargument name="first_name" type="string" required="false" default="" />
		<cfargument name="folder_id" type="numeric" required="false" />
		<cfargument name="lang" type="string" required="false" default="" />
		<cfargument name="icon" type="string" required="false" default="" />
		<cfargument name="last_name" type="string" required="false" default="" />
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="sco_id" type="numeric" required="false" />
		<cfargument name="sco_tag" type="string" required="false" default="" />
		<cfargument name="source_sco_id" type="numeric" required="false" />
		<cfargument name="type" type="string" required="false" default="" />
		<cfargument name="url_path" type="string" required="false" default="" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="sco-update" />
		<cfif len(arguments.author_info_1)>
			<cfset params['author-info-1'] = arguments.author_info_1 />
		</cfif>
		<cfif len(arguments.author_info_2)>
			<cfset params['author-info-2'] = arguments.author_info_2 />
		</cfif>
		<cfif len(arguments.author_info_3)>
			<cfset params['author-info-3'] = arguments.author_info_3 />
		</cfif>
		<cfif structKeyExists(arguments,"date_begin")>
			<cfset params['date-begin'] = arguments.date_begin />
		</cfif>
		<cfif structKeyExists(arguments,"date_end")>
			<cfset params['date-end'] = arguments.date_end />
		</cfif>
		<cfif len(arguments.description)>
			<cfset params['description'] = arguments.description />
		</cfif>
		<cfif len(arguments.email)>
			<cfset params['email'] = arguments.email />
		</cfif>
		<cfif len(arguments.first_name)>
			<cfset params['first-name'] = arguments.first_name />
		</cfif>
		<cfif structKeyExists(arguments,"folder_id")>
			<cfset params['folder-id'] = arguments.folder_id />
		</cfif>
		<cfif len(arguments.lang) and isAllowableLang(arguments.lang)>
			<cfset params['lang'] = arguments.lang />
		</cfif>
		<cfif len(arguments.icon)>
			<cfset params['icon'] = arguments.icon />
		</cfif>
		<cfif len(arguments.last_name)>
			<cfset params['last-name'] = arguments.last_name />
		</cfif>
		<cfif len(arguments.name)>
			<cfset params['name'] = arguments.name />
		</cfif>
		<cfif structKeyExists(arguments,"sco_id")>
			<cfset params['sco-id'] = arguments.sco_id />
		</cfif>
		<cfif len(arguments.sco_tag)>
			<cfset params['sco-tag'] = arguments.sco_tag />
		</cfif>
		<cfif structKeyExists(arguments,"source_sco_id")>
			<cfset params['source-sco-id'] = arguments.source_sco_id />
		</cfif>
		<cfif len(arguments.type) and isAllowableType("sco",arguments.type)>
			<cfset params['type'] = arguments.type />
		</cfif>
		<cfif len(arguments.url_path)>
			<cfset params['url-path'] = arguments.url_path />
		</cfif>
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
	
	<!--- permissions functions --->
	<cffunction name="permissionsUpdate" access="public" output="false" returntype="xml">
		<cfargument name="acl_id" type="numeric" required="true" />
		<cfargument name="principal_id" type="numeric" required="true" />
		<cfargument name="permission_id" type="string" required="true" />
		
		<cfset var paramsXML = "" />
		<cfset var params = structNew() />
		<cfset params['action']="permissions-update" />
		<cfset params['acl-id'] = arguments.acl_id />
		<cfset params['principal-id'] = arguments.principal_id />
		<cfset params['permission-id'] = arguments.permission_id />
		<cfset paramsXML = createParams(argumentCollection=params) />
		<cfreturn doAction(paramsXML) />
	</cffunction>
</cfcomponent>