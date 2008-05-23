<!--- 
	  
  Copyright (c) 2005, Chris Scott, David Ross
  All rights reserved.
	
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  $Id: Breadcrumb.cfc,v 1.1 2005/10/10 02:03:15 rossd Exp $
  $Log: Breadcrumb.cfc,v $
  Revision 1.1  2005/10/10 02:03:15  rossd
  ok, moved all controller cfcs into net/klondike/controller

  Revision 1.1  2005/10/10 01:52:05  rossd
  renamed /model to /controller to reflect best practice

  Revision 1.1  2005/10/09 20:12:06  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.

  Revision 1.2  2005/10/09 19:01:32  chris
  Added proper licensing and switched to MethodInterceptor Araound Advice for logging


--->
 
<cfcomponent displayname="Breadcrumb" 
			 hint="adds items to and retrievs the breadcrumb" 
			 extends="MachII.framework.Listener" 
			 output="false">
		
		<cffunction name="addCrumb" access="public" returntype="array" output="false">
			<cfargument name="crumb" type="string" required="yes" />
			<cfargument name="reset" type="boolean" required="yes" default="false" />
			<cfset var crumbloc = 0>
			<cfset var newbreadcrumb = ArrayNew(1)>
			<cfif not structKeyExists(session, "breadcrumb")>
				<cfset session.breadcrumb = arrayNew(1)>
			</cfif>
			
			<cfscript>
				//  reset breadcrumbs if necessary
				if(arguments.reset) {
					ArrayClear(session.breadcrumb);
				}
				// see if current fuseaction is in the breadcrumb
				crumbloc = ListFind(ArrayToList(session.breadcrumb),crumb);
				if(crumbloc GT 0) {
					for(i = 1; i LTE crumbloc; i=i+1) {
						ArrayAppend(newbreadcrumb,session.breadcrumb[i]);
					}
					session.breadcrumb = newbreadcrumb;
				} else {
					// or add the current crumb to the stored breadcrumbs 
					ArrayAppend(session.breadcrumb,crumb);
				}
			</cfscript>
			
			<cfreturn session.breadcrumb />
			
		</cffunction>
		
		<cffunction name="getCrumbs" access="public" returntype="array" output="false">
			<cfreturn session.breadcrumb />
		</cffunction>

</cfcomponent>