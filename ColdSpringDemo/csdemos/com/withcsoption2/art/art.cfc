<cfcomponent displayname="art" output="false">
		<cfproperty name="ARTID" type="string" default="" />
		<cfproperty name="ARTIST" type="com.withcsoption2.artists.artist" default="" />
		<cfproperty name="ARTNAME" type="string" default="" />
		<cfproperty name="DESCRIPTION" type="string" default="" />
		<cfproperty name="PRICE" type="numeric" default="" />
		<cfproperty name="LARGEIMAGE" type="string" default="" />
		<cfproperty name="MEDIAID" type="string" default="" />
		<cfproperty name="ISSOLD" type="numeric" default="" />
		
	<!---
	PROPERTIES
	--->
	<cfset variables.instance = StructNew() />

	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="init" access="public" returntype="com.withcsoption2.art.art" output="false">
		<cfargument name="ARTID" type="string" required="false" default="" />
		<cfargument name="ARTIST" type="com.withcsoption2.artists.artist" required="false" default="#createObject('component','com.withcsoption2.artists.artist').init()#" />
		<cfargument name="ARTNAME" type="string" required="false" default="" />
		<cfargument name="DESCRIPTION" type="string" required="false" default="" />
		<cfargument name="PRICE" type="string" required="false" default="" />
		<cfargument name="LARGEIMAGE" type="string" required="false" default="" />
		<cfargument name="MEDIAID" type="string" required="false" default="" />
		<cfargument name="ISSOLD" type="string" required="false" default="" />
		
		<!--- run setters --->
		<cfset setARTID(arguments.ARTID) />
		<cfset setARTIST(arguments.ARTIST) />
		<cfset setARTNAME(arguments.ARTNAME) />
		<cfset setDESCRIPTION(arguments.DESCRIPTION) />
		<cfset setPRICE(arguments.PRICE) />
		<cfset setLARGEIMAGE(arguments.LARGEIMAGE) />
		<cfset setMEDIAID(arguments.MEDIAID) />
		<cfset setISSOLD(arguments.ISSOLD) />
		
		<cfreturn this />
 	</cffunction>

	<cffunction name="setARTID" access="public" returntype="void" output="false">
		<cfargument name="ARTID" type="string" required="true" />
		<cfset variables.instance.ARTID = arguments.ARTID />
	</cffunction>
	<cffunction name="getARTID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ARTID />
	</cffunction>

	<cffunction name="setARTIST" access="public" returntype="void" output="false">
		<cfargument name="ARTIST" type="com.withcsoption2.artists.artist" required="true" />
		<cfset variables.instance.ARTIST = arguments.ARTIST />
	</cffunction>
	<cffunction name="getARTIST" access="public" returntype="com.withcsoption2.artists.artist" output="false">
		<cfreturn variables.instance.ARTIST />
	</cffunction>

	<cffunction name="setARTNAME" access="public" returntype="void" output="false">
		<cfargument name="ARTNAME" type="string" required="true" />
		<cfset variables.instance.ARTNAME = arguments.ARTNAME />
	</cffunction>
	<cffunction name="getARTNAME" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ARTNAME />
	</cffunction>

	<cffunction name="setDESCRIPTION" access="public" returntype="void" output="false">
		<cfargument name="DESCRIPTION" type="string" required="true" />
		<cfset variables.instance.DESCRIPTION = arguments.DESCRIPTION />
	</cffunction>
	<cffunction name="getDESCRIPTION" access="public" returntype="string" output="false">
		<cfreturn variables.instance.DESCRIPTION />
	</cffunction>

	<cffunction name="setPRICE" access="public" returntype="void" output="false">
		<cfargument name="PRICE" type="string" required="true" />
		<cfset variables.instance.PRICE = arguments.PRICE />
	</cffunction>
	<cffunction name="getPRICE" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PRICE />
	</cffunction>

	<cffunction name="setLARGEIMAGE" access="public" returntype="void" output="false">
		<cfargument name="LARGEIMAGE" type="string" required="true" />
		<cfset variables.instance.LARGEIMAGE = arguments.LARGEIMAGE />
	</cffunction>
	<cffunction name="getLARGEIMAGE" access="public" returntype="string" output="false">
		<cfreturn variables.instance.LARGEIMAGE />
	</cffunction>

	<cffunction name="setMEDIAID" access="public" returntype="void" output="false">
		<cfargument name="MEDIAID" type="string" required="true" />
		<cfset variables.instance.MEDIAID = arguments.MEDIAID />
	</cffunction>
	<cffunction name="getMEDIAID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.MEDIAID />
	</cffunction>

	<cffunction name="setISSOLD" access="public" returntype="void" output="false">
		<cfargument name="ISSOLD" type="string" required="true" />
		<cfset variables.instance.ISSOLD = arguments.ISSOLD />
	</cffunction>
	<cffunction name="getISSOLD" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ISSOLD />
	</cffunction>


	<!---
	DUMP
	--->
	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="false" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

</cfcomponent>
