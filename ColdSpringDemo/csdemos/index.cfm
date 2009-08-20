<cfparam name="url.type" default="none" />
<cfparam name="url.artID" default="1" />

<p>There's not much exciting to show, but to prove I'm not faking it:</p>
<p>
<a href="index.cfm?type=nocsoption1">No ColdSpring (createObject in constructor)</a></br />
<a href="index.cfm?type=nocsoption2&artID=2">No ColdSpring (dependencies passed in)</a></br />
<a href="index.cfm?type=withcsoption1&artID=3">With ColdSpring (constructor args)</a></br />
<a href="index.cfm?type=withcsoption2&artID=4">With ColdSpring (autowire)</a></br />
<a href="index.cfm?type=withcsoption3&artID=5">With ColdSpring (AOP + Remote Proxy)</a></br />
</p>
<cfswitch expression="#url.type#">
	<cfcase value="nocsoption1">
		<cfinclude template="nocsoption1.cfm" />
		<cfdump var="#art#" />
	</cfcase>
	<cfcase value="nocsoption2">
		<cfinclude template="nocsoption2.cfm" />
		<cfdump var="#art#" />
	</cfcase>
	<cfcase value="withcsoption1">
		<cfinclude template="withcsoption1.cfm" />
		<cfdump var="#art#" />
	</cfcase>
	<cfcase value="withcsoption2">
		<cfinclude template="withcsoption2.cfm" />
		<cfdump var="#art#" />
	</cfcase>
	<cfcase value="withcsoption3">
		<cfinclude template="withcsoption3.cfm" />
		<cfdump var="passed id: #url.artID#" />
		<cfdump var="#art#" />
		<p>Generated Remote Proxy WSDL: <a href="/com/withcsoption2/artGalleryServiceRemote.cfc?wsdl">/com/withcsoption2/artGalleryServiceRemote.cfc?wsdl</a></p>
	</cfcase>
</cfswitch>
