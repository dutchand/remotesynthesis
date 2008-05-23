<!--- Document Information -----------------------------------------------------

Title:      Link.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    BO of a link from one property to the component

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		29/07/2005		Created

------------------------------------------------------------------------------->

<cfcomponent name="Link" hint="BO of a link from one property to the component">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Link" output="false">
	<cfscript>
		setColumn("");
		setTo("");		
			
		return this;
	</cfscript>
</cffunction>

<cffunction name="getColumn" access="public" returntype="string" output="false">
	<cfreturn instance.Column />
</cffunction>

<cffunction name="getTo" access="public" returntype="string" output="false">
	<cfreturn instance.To />
</cffunction>

<cffunction name="setMemento" hint="Sets the state of the object" access="public" returntype="void" output="false">
	<cfargument name="memento" hint="the state to be set" type="struct" required="Yes">
	<cfscript>
		setTo(arguments.memento.to);
		setColumn(arguments.memento.column);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setTo" access="private" returntype="void" output="false">
	<cfargument name="To" type="string" required="true">
	<cfset instance.To = arguments.To />
</cffunction>

<cffunction name="setColumn" access="private" returntype="void" output="false">
	<cfargument name="Column" type="string" required="true">
	<cfset instance.Column = arguments.Column />
</cffunction>

</cfcomponent>