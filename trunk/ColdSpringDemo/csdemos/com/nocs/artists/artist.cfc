
<cfcomponent displayname="artist" output="false">
		<cfproperty name="ARTISTID" type="string" default="" />
		<cfproperty name="FIRSTNAME" type="string" default="" />
		<cfproperty name="LASTNAME" type="string" default="" />
		<cfproperty name="ADDRESS" type="string" default="" />
		<cfproperty name="CITY" type="string" default="" />
		<cfproperty name="STATE" type="string" default="" />
		<cfproperty name="POSTALCODE" type="string" default="" />
		<cfproperty name="EMAIL" type="string" default="" />
		<cfproperty name="PHONE" type="string" default="" />
		<cfproperty name="FAX" type="string" default="" />
		<cfproperty name="THEPASSWORD" type="string" default="" />
		
	<!---
	PROPERTIES
	--->
	<cfset variables.instance = StructNew() />

	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="init" access="public" returntype="com.nocs.artists.artist" output="false">
		<cfargument name="ARTISTID" type="string" required="false" default="" />
		<cfargument name="FIRSTNAME" type="string" required="false" default="" />
		<cfargument name="LASTNAME" type="string" required="false" default="" />
		<cfargument name="ADDRESS" type="string" required="false" default="" />
		<cfargument name="CITY" type="string" required="false" default="" />
		<cfargument name="STATE" type="string" required="false" default="" />
		<cfargument name="POSTALCODE" type="string" required="false" default="" />
		<cfargument name="EMAIL" type="string" required="false" default="" />
		<cfargument name="PHONE" type="string" required="false" default="" />
		<cfargument name="FAX" type="string" required="false" default="" />
		<cfargument name="THEPASSWORD" type="string" required="false" default="" />
		
		<!--- run setters --->
		<cfset setARTISTID(arguments.ARTISTID) />
		<cfset setFIRSTNAME(arguments.FIRSTNAME) />
		<cfset setLASTNAME(arguments.LASTNAME) />
		<cfset setADDRESS(arguments.ADDRESS) />
		<cfset setCITY(arguments.CITY) />
		<cfset setSTATE(arguments.STATE) />
		<cfset setPOSTALCODE(arguments.POSTALCODE) />
		<cfset setEMAIL(arguments.EMAIL) />
		<cfset setPHONE(arguments.PHONE) />
		<cfset setFAX(arguments.FAX) />
		<cfset setTHEPASSWORD(arguments.THEPASSWORD) />
		
		<cfreturn this />
 	</cffunction>

	<!---
	PUBLIC FUNCTIONS
	--->
	<cffunction name="setMemento" access="public" returntype="com.nocs.artists.artist" output="false">
		<cfargument name="memento" type="struct" required="yes"/>
		<cfset variables.instance = arguments.memento />
		<cfreturn this />
	</cffunction>
	<cffunction name="getMemento" access="public" returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="validate" access="public" returntype="array" output="false">
		<cfset var errors = arrayNew(1) />
		<cfset var thisError = structNew() />
		
		<!--- ARTISTID --->
		<cfif (len(trim(getARTISTID())) AND NOT IsSimpleValue(trim(getARTISTID())))>
			<cfset thisError.field = "ARTISTID" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "ARTISTID is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getARTISTID())) GT 10)>
			<cfset thisError.field = "ARTISTID" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "ARTISTID is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- FIRSTNAME --->
		<cfif (len(trim(getFIRSTNAME())) AND NOT IsSimpleValue(trim(getFIRSTNAME())))>
			<cfset thisError.field = "FIRSTNAME" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "FIRSTNAME is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getFIRSTNAME())) GT 20)>
			<cfset thisError.field = "FIRSTNAME" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "FIRSTNAME is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- LASTNAME --->
		<cfif (len(trim(getLASTNAME())) AND NOT IsSimpleValue(trim(getLASTNAME())))>
			<cfset thisError.field = "LASTNAME" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "LASTNAME is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getLASTNAME())) GT 20)>
			<cfset thisError.field = "LASTNAME" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "LASTNAME is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- ADDRESS --->
		<cfif (len(trim(getADDRESS())) AND NOT IsSimpleValue(trim(getADDRESS())))>
			<cfset thisError.field = "ADDRESS" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "ADDRESS is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getADDRESS())) GT 50)>
			<cfset thisError.field = "ADDRESS" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "ADDRESS is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- CITY --->
		<cfif (len(trim(getCITY())) AND NOT IsSimpleValue(trim(getCITY())))>
			<cfset thisError.field = "CITY" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "CITY is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getCITY())) GT 20)>
			<cfset thisError.field = "CITY" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "CITY is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- STATE --->
		<cfif (len(trim(getSTATE())) AND NOT IsSimpleValue(trim(getSTATE())))>
			<cfset thisError.field = "STATE" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "STATE is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getSTATE())) GT 2)>
			<cfset thisError.field = "STATE" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "STATE is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- POSTALCODE --->
		<cfif (len(trim(getPOSTALCODE())) AND NOT IsSimpleValue(trim(getPOSTALCODE())))>
			<cfset thisError.field = "POSTALCODE" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "POSTALCODE is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getPOSTALCODE())) GT 10)>
			<cfset thisError.field = "POSTALCODE" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "POSTALCODE is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- EMAIL --->
		<cfif (len(trim(getEMAIL())) AND NOT IsSimpleValue(trim(getEMAIL())))>
			<cfset thisError.field = "EMAIL" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "EMAIL is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getEMAIL())) GT 50)>
			<cfset thisError.field = "EMAIL" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "EMAIL is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- PHONE --->
		<cfif (len(trim(getPHONE())) AND NOT IsSimpleValue(trim(getPHONE())))>
			<cfset thisError.field = "PHONE" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "PHONE is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getPHONE())) GT 20)>
			<cfset thisError.field = "PHONE" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "PHONE is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- FAX --->
		<cfif (len(trim(getFAX())) AND NOT IsSimpleValue(trim(getFAX())))>
			<cfset thisError.field = "FAX" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "FAX is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getFAX())) GT 12)>
			<cfset thisError.field = "FAX" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "FAX is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- THEPASSWORD --->
		<cfif (len(trim(getTHEPASSWORD())) AND NOT IsSimpleValue(trim(getTHEPASSWORD())))>
			<cfset thisError.field = "THEPASSWORD" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "THEPASSWORD is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getTHEPASSWORD())) GT 8)>
			<cfset thisError.field = "THEPASSWORD" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "THEPASSWORD is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<cfreturn errors />
	</cffunction>

	<!---
	ACCESSORS
	--->
	<cffunction name="setARTISTID" access="public" returntype="void" output="false">
		<cfargument name="ARTISTID" type="string" required="true" />
		<cfset variables.instance.ARTISTID = arguments.ARTISTID />
	</cffunction>
	<cffunction name="getARTISTID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ARTISTID />
	</cffunction>

	<cffunction name="setFIRSTNAME" access="public" returntype="void" output="false">
		<cfargument name="FIRSTNAME" type="string" required="true" />
		<cfset variables.instance.FIRSTNAME = arguments.FIRSTNAME />
	</cffunction>
	<cffunction name="getFIRSTNAME" access="public" returntype="string" output="false">
		<cfreturn variables.instance.FIRSTNAME />
	</cffunction>

	<cffunction name="setLASTNAME" access="public" returntype="void" output="false">
		<cfargument name="LASTNAME" type="string" required="true" />
		<cfset variables.instance.LASTNAME = arguments.LASTNAME />
	</cffunction>
	<cffunction name="getLASTNAME" access="public" returntype="string" output="false">
		<cfreturn variables.instance.LASTNAME />
	</cffunction>

	<cffunction name="setADDRESS" access="public" returntype="void" output="false">
		<cfargument name="ADDRESS" type="string" required="true" />
		<cfset variables.instance.ADDRESS = arguments.ADDRESS />
	</cffunction>
	<cffunction name="getADDRESS" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ADDRESS />
	</cffunction>

	<cffunction name="setCITY" access="public" returntype="void" output="false">
		<cfargument name="CITY" type="string" required="true" />
		<cfset variables.instance.CITY = arguments.CITY />
	</cffunction>
	<cffunction name="getCITY" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CITY />
	</cffunction>

	<cffunction name="setSTATE" access="public" returntype="void" output="false">
		<cfargument name="STATE" type="string" required="true" />
		<cfset variables.instance.STATE = arguments.STATE />
	</cffunction>
	<cffunction name="getSTATE" access="public" returntype="string" output="false">
		<cfreturn variables.instance.STATE />
	</cffunction>

	<cffunction name="setPOSTALCODE" access="public" returntype="void" output="false">
		<cfargument name="POSTALCODE" type="string" required="true" />
		<cfset variables.instance.POSTALCODE = arguments.POSTALCODE />
	</cffunction>
	<cffunction name="getPOSTALCODE" access="public" returntype="string" output="false">
		<cfreturn variables.instance.POSTALCODE />
	</cffunction>

	<cffunction name="setEMAIL" access="public" returntype="void" output="false">
		<cfargument name="EMAIL" type="string" required="true" />
		<cfset variables.instance.EMAIL = arguments.EMAIL />
	</cffunction>
	<cffunction name="getEMAIL" access="public" returntype="string" output="false">
		<cfreturn variables.instance.EMAIL />
	</cffunction>

	<cffunction name="setPHONE" access="public" returntype="void" output="false">
		<cfargument name="PHONE" type="string" required="true" />
		<cfset variables.instance.PHONE = arguments.PHONE />
	</cffunction>
	<cffunction name="getPHONE" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PHONE />
	</cffunction>

	<cffunction name="setFAX" access="public" returntype="void" output="false">
		<cfargument name="FAX" type="string" required="true" />
		<cfset variables.instance.FAX = arguments.FAX />
	</cffunction>
	<cffunction name="getFAX" access="public" returntype="string" output="false">
		<cfreturn variables.instance.FAX />
	</cffunction>

	<cffunction name="setTHEPASSWORD" access="public" returntype="void" output="false">
		<cfargument name="THEPASSWORD" type="string" required="true" />
		<cfset variables.instance.THEPASSWORD = arguments.THEPASSWORD />
	</cffunction>
	<cffunction name="getTHEPASSWORD" access="public" returntype="string" output="false">
		<cfreturn variables.instance.THEPASSWORD />
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
