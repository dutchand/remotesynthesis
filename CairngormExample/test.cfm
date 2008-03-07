<cfset dnsRemote = createObject("component","com.cf.dnsRemote") />
<cfset arr = dnsRemote.doQuery('remotesynthesis.com','ANY','IN',true) />
<cfdump var="#arr#">