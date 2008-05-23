<!--- Document Information -----------------------------------------------------

Title:      ManyToMany.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    BO for Many To Many connection

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		29/07/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="ManyToMany" hint="BO for a Many to Many connection" extends="AbstractBaseComposition">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ManyToMany" output="false">
	<cfscript>
		super.init();
		
		setTable("");

		setLinkTo(createObject("component", "Link").init());
		setLinkFrom(createObject("component", "Link").init());
		setCollection(createObject("component", "Collection").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="getTable" access="public" returntype="string" output="false">
	<cfreturn instance.Table />
</cffunction>

<cffunction name="getLinkTo" access="public" returntype="Link" output="false">
	<cfreturn instance.LinkTo />
</cffunction>

<cffunction name="getLinkFrom" access="public" returntype="Link" output="false">
	<cfreturn instance.LinkFrom />
</cffunction>

<cffunction name="getCollection" access="public" returntype="Collection" output="false">
	<cfreturn instance.Collection />
</cffunction>

<cffunction name="setMemento" hint="Sets the state of the object" access="public" returntype="void" output="false">
	<cfargument name="memento" hint="the state to be set" type="struct" required="Yes">
	<cfscript>
		super.setMemento(arguments.memento);
		
		setTable(arguments.memento.table);
		
		getLinkTo().setMemento(arguments.memento.linkTo);
		getLinkFrom().setMemento(arguments.memento.linkFrom);

		getCollection().setMemento(arguments.memento.collection);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setTable" access="private" returntype="void" output="false">
	<cfargument name="Table" type="string" required="true">
	<cfset instance.Table = arguments.Table />
</cffunction>

<cffunction name="setLinkFrom" access="private" returntype="void" output="false">
	<cfargument name="LinkFrom" type="Link" required="true">
	<cfset instance.LinkFrom = arguments.LinkFrom />
</cffunction>

<cffunction name="setLinkTo" access="private" returntype="void" output="false">
	<cfargument name="LinkTo" type="Link" required="true">
	<cfset instance.LinkTo = arguments.LinkTo />
</cffunction>

<cffunction name="setCollection" access="private" returntype="void" output="false">
	<cfargument name="Collection" type="Collection" required="true">
	<cfset instance.Collection = arguments.Collection />
</cffunction>

</cfcomponent>