<!--- Document Information -----------------------------------------------------

Title:      XMLFileReader.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Reads XML files and performs operations on them

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		04/11/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="XMLFileReader" hint="Reads XML files and performs operations on them">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="XMLFileReader" output="false">
	<cfargument name="path" hint="Absolute path to the file" type="string" required="Yes">
	<cfscript>
		setFileReader(createObject("component", "FileReader").init(arguments.path));
		setXML(XMLParse(getFileReader().getContent()));

		return this;
	</cfscript>
</cffunction>

<cffunction name="getPath" hint="The path to the xml file" access="public" returntype="string" output="false">
	<cfreturn getFileReader().getPath()>
</cffunction>

<cffunction name="getXML" access="public" returntype="xml" output="false">
	<cfreturn instance.XML />
</cffunction>

<cffunction name="search" hint="Searches the xml via an xpath" access="public" returntype="array" output="false">
	<cfargument name="xpath" hint="The xpath to search under" type="string" required="Yes">

	<cfreturn xmlsearch(getXML(), arguments.xpath)>
</cffunction>
<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setXML" access="private" returntype="void" output="false">
	<cfargument name="XML" type="xml" required="true">
	<cfset instance.XML = arguments.XML />
</cffunction>

<cffunction name="getFileReader" access="private" returntype="FileReader" output="false">
	<cfreturn instance.FileReader />
</cffunction>

<cffunction name="setFileReader" access="private" returntype="void" output="false">
	<cfargument name="FileReader" type="FileReader" required="true">
	<cfset instance.FileReader = arguments.FileReader />
</cffunction>

</cfcomponent>