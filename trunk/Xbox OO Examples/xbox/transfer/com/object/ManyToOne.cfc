<!--- Document Information -----------------------------------------------------

Title:      ManyToOne.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Many to One connection BO

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		17/08/2005		Created

------------------------------------------------------------------------------->

<cfcomponent name="ManyToOne" hint="Many to One connection BO" extends="AbstractBaseComposition">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ManyToOne" output="false">
	<cfscript>
		super.init();
		
		setLink(createObject("component", "Link").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="getLink" access="public" returntype="Link" output="false">
	<cfreturn instance.Link />
</cffunction>

<cffunction name="setMemento" hint="Sets the state of the object" access="public" returntype="void" output="false">
	<cfargument name="memento" hint="the state to be set" type="struct" required="Yes">
	<cfscript>
		super.setMemento(arguments.memento);

		getLink().setMemento(arguments.memento.link);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setLink" access="private" returntype="void" output="false">
	<cfargument name="Link" type="Link" required="true">
	<cfset instance.Link = arguments.Link />
</cffunction>

</cfcomponent>