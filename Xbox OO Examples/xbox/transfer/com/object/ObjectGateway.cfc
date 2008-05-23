<!--- Document Information -----------------------------------------------------

Title:      ObjectGateway.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    gateway to queries on the XML structure

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		11/10/2005		Created

------------------------------------------------------------------------------->

<cfcomponent name="ObjectGateway" hint="gateway to queries on the XML structure">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="ObjectGateway" output="false">
	<cfargument name="configReader" hint="XML config reader" type="transfer.com.io.XMLFileReader" required="Yes">
	<cfscript>
		setConfigReader(arguments.configReader);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getManyToManyLinksByClassLinkTo" hint="Gets a query of Many to Many details by the class it is linked to" access="public" returntype="query" output="false">
	<cfargument name="className" hint="The classname to search on" type="string" required="Yes">

	<cfscript>
		//get all many to many that have a link to the given class
		var result = getConfigReader().search("/transfer/objectDefinitions//manytomany[link[2][@to='#arguments.className#']]");
		var iterator = result.iterator();

		var qManyToMany = QueryNew("table, columnTo");

		var manytomany = 0;

		while(iterator.hasNext())
		{
			manytomany = iterator.next();

			QueryAddRow(qManyToMany);
			QuerySetCell(qManyToMany, "table", manyToMany.xmlAttributes.table);
			QuerySetCell(qManyToMany, "columnTo", manyToMany.xmlChildren[2].xmlAttributes.column);
		}

		return qManyToMany;
	</cfscript>
</cffunction>
<!---
<cffunction name="getClassNameByOneToManyLinkTo" hint="Retrives the class names of all objects that have a One to Many relationship with this class. Query Columns are: OneToManyName,className,linkColumn" access="public" returntype="query" output="false">
	<cfargument name="className" hint="The classname to search on" type="string" required="Yes">
	<cfscript>
		var result = getConfigReader().search("/transfer/objectDefinitions//object[onetomany[link[@to='#arguments.className#']]]");
		var qObjects = QueryNew("OneToManyName,className,linkColumn");
		var object = 0;
		var iterator = result.iterator();
		var element = 0;
		var column = 0;
		var onetomanyName = 0;

		//going to need to get the parent recursively all the way up and rewrite the xpath every time
		while(iterator.hasNext())
		{
			object = iterator.next();

			//let's get the column and name
			element = xmlParse(ToString(object));
			column = XMLSearch(element, "/object/onetomany/link[@to='#arguments.className#']");
			onetomanyName = XMLSearch(element, "/object/onetomany[link[@to='#arguments.className#']]");

			QueryAddRow(qObjects);
			QuerySetCell(qObjects, "oneToManyName", oneToManyName[1].xmlAttributes.name);
			QuerySetCell(qObjects, "className", getParentPath(object.xmlattributes.name, object.xmlattributes.table));
			QuerySetCell(qObjects, "linkColumn", column[1].xmlAttributes.column);
		}
	</cfscript>

	<cfquery dbtype="query">
		select oneToManyName, className, linkColumn
		from
		qObjects
		order by className asc
	</cfquery>

	<cfscript>
		return qObjects;
	</cfscript>
</ cffunction>
 --->
<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<!---
<cffunction name="getParentPath" hint="Gets the parent of an item" access="private" returntype="string" output="false">
	<cfargument name="Name" hint="The name of the object" type="string" required="Yes">
	<cfargument name="table" hint="The name of the table for the object" type="string" required="Yes">
	<cfargument name="path" hint="The path we're on" type="string" required="No" default="">
	<cfargument name="xpath" hint="The xpath that is currently set" type="string" required="No" default="/transfer/objectDefinitions//object[@name='#arguments.name#'][@table='#arguments.table#']" >
	<cfscript>
		var item = getConfigReader().search(arguments.xpath);

		//lets recurse
		if(item[1].xmlname neq "objectDefinitions")
		{
			arguments.xpath = arguments.xpath & "/..";
			arguments.path = ListPrepend(arguments.path, item[1].xmlAttributes.name, ".");
			arguments.path = getParentPath(arguments.name, arguments.table, arguments.path, arguments.xpath);
		}

		return arguments.path;
	</cfscript>
</ cffunction>
--->

<cffunction name="getConfigReader" access="private" returntype="transfer.com.io.XMLFileReader" output="false">
	<cfreturn instance.ConfigReader />
</cffunction>

<cffunction name="setConfigReader" access="private" returntype="void" output="false">
	<cfargument name="ConfigReader" type="transfer.com.io.XMLFileReader" required="true">
	<cfset instance.ConfigReader = arguments.ConfigReader />
</cffunction>

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>

</cfcomponent>