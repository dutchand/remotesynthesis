<!--- Document Information -----------------------------------------------------

Title:      ParentOneToMany.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Represents the parents of a One to many collection

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		01/09/2006		Created

------------------------------------------------------------------------------->

<cfcomponent name="ParentOneToMany" hint="Represents the parent of a One to many collection" extends="AbstractBaseComposition">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ParentOneToMany" output="false">
	<cfscript>
		super.init();
		setLink(createObject("component", "Link").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="setMemento" hint="Sets the state of the object" access="public" returntype="void" output="false">
	<cfargument name="memento" hint="the state to be set" type="struct" required="Yes">
	<cfscript>
		super.setMemento(arguments.memento);
		getLink().setMemento(arguments.memento.link);
	</cfscript>
</cffunction>

<cffunction name="getLink" access="public" returntype="link" output="false">
	<cfreturn instance.Link />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setLink" access="private" returntype="void" output="false">
	<cfargument name="Link" type="link" required="true">
	<cfset instance.Link = arguments.Link />
</cffunction>

</cfcomponent>