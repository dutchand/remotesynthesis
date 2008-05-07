<cfcomponent output="false">
	<cfset variables.jlf = createObject("component", "cfdns.util.JavaLoaderFactory").init() />
	<cfset variables.jlf.setClassName("cfdns.javaloader.JavaLoader") />
	<cfset variables.jlf.addPath(expandPath("/cfdns/lib/dnsjava-2.0.3.jar")) />
	<cfset variables.dns = createObject("component", "cfdns.DNS").init(jlf.getJavaLoader()) />

	<cffunction name="doQuery" access="remote" output="false" returntype="com.cf.record[]">
		<cfargument name="name" type="string" required="true"/>
		<cfargument name="type" type="string" required="true"/>
		<cfargument name="class" type="string" required="true"/>
		<cfargument name="throwOnError" type="boolean" required="true" default="false"/>
		
		<cfset var i = 0 />
		<cfset var x = 0 />
		<cfset var keyName = "" />
		<cfset var record = "" />
		<cfset var recordXml = "" />
		<cfset var queryXML = xmlParse(dns.doQuery(arguments.name,arguments.type,arguments.class,arguments.throwOnError).getXML()) />
		<cfset var args = structNew() />
		<cfset var arrReturn = arrayNew(1) />
		<cfloop from="1" to="#arrayLen(queryXML.message.sections.xmlChildren)#" index="i">
			<cfset args.sectionID = queryXML.message.sections.xmlChildren[i].xmlAttributes.id />
			<cfset args.sectionName = queryXML.message.sections.xmlChildren[i].xmlAttributes.name />
			<cfloop from="1" to="#arrayLen(queryXML.message.sections.xmlChildren[i].xmlChildren)#" index="x">
				<cfset recordXml = queryXML.message.sections.xmlChildren[i].xmlChildren[x] />
				<cfloop collection="#recordXml.record.xmlAttributes#" item="keyName">
					<cfset args[keyName] = recordXml.record.xmlAttributes[keyName] />
				</cfloop>
				<cfset record = createObject("component","com.cf.record").init(argumentCollection=args) />
				<cfset arrayAppend(arrReturn,record) />
			</cfloop>
		</cfloop>
		<cfreturn arrReturn />
	</cffunction>
	
	<cffunction name="getQueryTypes" access="remote" output="false" returntype="array">
		<cfset var arrTypes = arrayNew(1) />
		<cfset var stType =  "" />
		<cfset var i = 0 />
		<cfset var values = "ANY,A,IPSECKEY,LOC,MX,NS,PTR,SIG,SOA,SPF,SSHFP,TXT" />
		<cfset var labels = "Any,Address (A),IPSEC Key,Location,Mail Exchanger (MX),Name Server (NS),Pointer Record (PTR),Signature,Start of Authority (SOA),Sender Policy Framework,SSH Key Fingerprint,Text" />
		<cfloop from="1" to="#listLen(values)#" index="i">
			<cfset stType = structNew() />
			<cfset stType.data = listGetAt(values,i) />
			<cfset stType.label = listGetAt(labels,i) />
			<cfset arrayAppend(arrTypes,stType) />
		</cfloop>
		<cfreturn arrTypes />
	</cffunction>
	
	<cffunction name="getQueryClasses" access="remote" output="false" returntype="array">
		<cfset var arrClasses = arrayNew(1) />
		<cfset var stClass =  "" />
		<cfset var i = 0 />
		<cfset var values = "ANY,IN,CH,CHAOS,HS,HESIOD" />
		<cfset var labels = "Any,Internet (IN),Chaos (CH),Chaos (CHAOS),Hesiod (HS),Hesiod (HESIOD)" />
		<cfloop from="1" to="#listLen(values)#" index="i">
			<cfset stClass = structNew() />
			<cfset stClass.data = listGetAt(values,i) />
			<cfset stClass.label = listGetAt(labels,i) />
			<cfset arrayAppend(arrClasses,stClass) />
		</cfloop>
		<cfreturn arrClasses />
	</cffunction>
</cfcomponent>