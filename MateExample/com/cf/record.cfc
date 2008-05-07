<cfcomponent output="false">
	<cfproperty name="sectionID" type="string" required="false" />
	<cfproperty name="sectionName" type="string" required="false" />
	<cfproperty name="className" type="string" required="false" />
	<cfproperty name="recordName" type="string" required="false" />
	<cfproperty name="type" type="string" required="false" />
	<cfproperty name="additionalName" type="string" required="false" />
	<cfproperty name="target" type="string" required="false" />
	<cfproperty name="ttl" type="string" required="false" />
	
	<cffunction name="init" access="public" output="false" returntype="com.cf.record">
		<cfargument name="sectionID" type="string" required="false" default="" />
		<cfargument name="sectionName" type="string" required="false" default="" />
		<cfargument name="className" type="string" required="false" default="" />
		<cfargument name="recordName" type="string" required="false" default="" />
		<cfargument name="type" type="string" required="false" default="" />
		<cfargument name="additionalName" type="string" required="false" default="" />
		<cfargument name="target" type="string" required="false" default="" />
		<cfargument name="ttl" type="string" required="false" default="" />
		
		<cfset setSectionID(arguments.sectionID) />
		<cfset setSectionName(arguments.sectionName) />
		<cfset setClassName(arguments.className) />
		<cfset setRecordName(arguments.recordName) />
		<cfset setType(arguments.type) />
		<cfset setAdditionalName(arguments.additionalName) />
		<cfset setTarget(arguments.target) />
		<cfset setTtl(arguments.ttl) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setSectionID" access="public" output="false" returntype="void">
		<cfargument name="sectionID" type="string" required="true" />
		
		<cfset variables.sectionID = arguments.sectionID />
	</cffunction>
	<cffunction name="getSectionID" access="public" output="false" returntype="string">
		<cfreturn variables.sectionID />
	</cffunction>
	
	<cffunction name="setSectionName" access="public" output="false" returntype="void">
		<cfargument name="sectionName" type="string" required="true" />
		
		<cfset variables.sectionName = arguments.sectionName />
	</cffunction>
	<cffunction name="getSectionName" access="public" output="false" returntype="string">
		<cfreturn variables.sectionName />
	</cffunction>
	
	<cffunction name="setClassName" access="public" output="false" returntype="void">
		<cfargument name="className" type="string" required="true" />
		
		<cfset variables.className = arguments.className />
	</cffunction>
	<cffunction name="getClassName" access="public" output="false" returntype="string">
		<cfreturn variables.className />
	</cffunction>
	
	<cffunction name="setRecordName" access="public" output="false" returntype="void">
		<cfargument name="recordName" type="string" required="true" />
		
		<cfset variables.recordName = arguments.recordName />
	</cffunction>
	<cffunction name="getRecordName" access="public" output="false" returntype="string">
		<cfreturn variables.recordName />
	</cffunction>
	
	<cffunction name="setType" access="public" output="false" returntype="void">
		<cfargument name="type" type="string" required="true" />
		
		<cfset variables.type = arguments.type />
	</cffunction>
	<cffunction name="getType" access="public" output="false" returntype="string">
		<cfreturn variables.type />
	</cffunction>
	
	<cffunction name="setAdditionalName" access="public" output="false" returntype="void">
		<cfargument name="additionalName" type="string" required="true" />
		
		<cfset variables.additionalName = arguments.additionalName />
	</cffunction>
	<cffunction name="getAdditionalName" access="public" output="false" returntype="string">
		<cfreturn variables.additionalName />
	</cffunction>
	
	<cffunction name="setTarget" access="public" output="false" returntype="void">
		<cfargument name="target" type="string" required="true" />
		
		<cfset variables.target = target />
	</cffunction>
	<cffunction name="getTarget" access="public" output="false" returntype="string">
		<cfreturn variables.target />
	</cffunction>
	
	<cffunction name="setTtl" access="public" output="false" returntype="void">
		<cfargument name="ttl" type="string" required="true" />
		
		<cfset variables.ttl = ttl />
	</cffunction>
	<cffunction name="getTtl" access="public" output="false" returntype="string">
		<cfreturn variables.ttl />
	</cffunction>
</cfcomponent>