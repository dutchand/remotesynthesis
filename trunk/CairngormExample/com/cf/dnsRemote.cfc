<cfcomponent output="false">
	<cfset variables.jlf = createObject("component", "cfdns.util.JavaLoaderFactory").init() />
	<cfset variables.jlf.setClassName("cfdns.javaloader.JavaLoader") />
	<cfset variables.jlf.addPath(expandPath("/cfdns/lib/dnsjava-2.0.3.jar")) />
	<cfset variables.dns = createObject("component", "cfdns.DNS").init(jlf.getJavaLoader()) />

	<cffunction name="doQuery" access="remote" output="false" returntype="com.cf.record[]">
		<cfargument name="name" type="string" required="true"/>
		<cfargument name="type" type="string" required="true" default=""/>
		<cfargument name="class" type="string" required="true" default=""/>
		<cfargument name="throwOnError" type="boolean" required="true" default="false"/>
		
		<cfset var i = 0 />
		<cfset var x = 0 />
		<cfset var keyName = "" />
		<cfset var record = "" />
		<cfset var queryXML = xmlParse(dns.doQuery(arguments.name,arguments.type,arguments.class,arguments.throwOnError).getXML()) />
		<cfset var args = structNew() />
		<cfset var arrReturn = arrayNew(1) />
		<cfloop from="1" to="#arrayLen(queryXML.message.sections.xmlChildren)#" index="i">
			<cfset args.sectionID = queryXML.message.sections.xmlChildren[i].xmlAttributes.id />
			<cfset args.sectionName = queryXML.message.sections.xmlChildren[i].xmlAttributes.name />
			<cfloop from="1" to="#arrayLen(queryXML.message.sections.section.records.xmlChildren)#" index="x">
				<cfloop collection="#queryXML.message.sections.xmlChildren[i].records.xmlChildren[x].xmlAttributes#" item="keyName">
					<cfset args[keyName] = queryXML.message.sections.xmlChildren[i].records.xmlChildren[x].xmlAttributes[keyName] />
				</cfloop>
				<cfset record = createObject("component","com.cf.record").init(argumentCollection=args) />
				<cfset arrayAppend(arrReturn,record) />
			</cfloop>
		</cfloop>
		<cfreturn arrReturn />
	</cffunction>
</cfcomponent>