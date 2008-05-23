<!--- Document Information -----------------------------------------------------

Title:      ObjectManager.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Manages the Object configurations

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		13/07/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="ObjectManager" hint="Manages the Object configurations">

<cfscript>
	instance = StructNew();

	//constants
	static = Structnew();
	static.LINKS_BY_CLASS_QUERY_KEY = "linksByClass";
	static.ONE_TO_MANY_LINKS_TO_QUERY_KEY = "onetomanyLinkTo";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="ObjectManager" output="false">
	<cfargument name="configReader" hint="The XML Reader for the config file" type="transfer.com.io.XMLFileReader" required="Yes">

	<cfscript>
		setObjectDAO(createObject("component", "ObjectDAO").init(arguments.configReader));
		setObjectPool(createObject("component", "transfer.com.collections.ObjectPool").init());
		setObjectGateway(createObject("component", "ObjectGateway").init(arguments.configReader));
		setQueryCache(createObject("component", "transfer.com.collections.QueryCache").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="getObject" hint="creates an Object meta data for use" access="public" returntype="Object" output="false">
	<cfargument name="class" hint="The class to be retrieving" type="string" required="Yes">

	<cfscript>
		var object = 0;
	</cfscript>

	<cfif NOT getObjectPool().has(arguments.class)>
		<cflock name="transfer.ObjectManager.getObject.#arguments.class#" timeout="60" throwontimeout="true">
			<cfscript>
				//get the defintion
				if(NOT getObjectPool().has(arguments.class))
				{
					object = getObjectDAO().getObject(createEmptyObject(), arguments.class);
					getObjectPool().add(object, arguments.class);
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfscript>
		return getObjectPool().get(arguments.class);
	</cfscript>
</cffunction>

<cffunction name="getObjectLazyManyToOne" hint="creates an Object with only a single many to one, with it's lazy attribute set to true" access="public" returntype="Object" output="false">
	<cfargument name="class" hint="The class to be retrieving" type="string" required="Yes">
	<cfargument name="name" hint="The name of the many to one" type="string" required="Yes">
	<cfscript>
		var object = 0;
		var key = arguments.class & "|" & arguments.name & "|LazyManyToOne";
		var manytoone = 0;
	</cfscript>

	<cfif NOT getObjectPool().has(key)>
		<cflock name="transfer.ObjectManager.getObjectLazyManyToOne.#key#" timeout="60" throwontimeout="true">
			<cfscript>
				//get the defintion
				if(NOT getObjectPool().has(key))
				{
					//new object
					object = getObjectDAO().getObject(createEmptyObject(), arguments.class);

					//let's massage it so that it represents an object with the item we want.
					manytoone = object.getManyToOneByName(arguments.name);

					manytoone.setIsLazy(false);

					object.clearManyToOne();
					object.clearManyToMany();
					object.clearOneToMany();

					object.addManyToOne(manytoone);

					getObjectPool().add(object, key);
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfscript>
		return getObjectPool().get(key);
	</cfscript>
</cffunction>

<cffunction name="getObjectLazyOneToMany" hint="creates an Object with only a single onetomany, with it's lazy attribute set to true" access="public" returntype="Object" output="false">
	<cfargument name="class" hint="The class to be retrieving" type="string" required="Yes">
	<cfargument name="name" hint="The name of the onetomany" type="string" required="Yes">
	<cfscript>
		var object = 0;
		var key = arguments.class & "|" & arguments.name & "|LazyOneToMany";
		var onetomany = 0;
	</cfscript>

	<cfif NOT getObjectPool().has(key)>
		<cflock name="transfer.ObjectManager.getObjectLazyOneToMany.#key#" timeout="60" throwontimeout="true">
			<cfscript>
				//get the defintion
				if(NOT getObjectPool().has(key))
				{
					//new object
					object = getObjectDAO().getObject(createEmptyObject(), arguments.class);

					//let's massage it so that it represents an object with the item we want.
					onetomany = object.getOneToManyByName(arguments.name);

					onetomany.setIsLazy(false);

					object.clearManyToOne();
					object.clearManyToMany();
					object.clearOneToMany();

					object.addOneToMany(onetomany);

					getObjectPool().add(object, key);
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfscript>
		return getObjectPool().get(key);
	</cfscript>
</cffunction>

<cffunction name="getObjectLazyManyToMany" hint="creates an Object with only a single manytomany, with it's lazy attribute set to true" access="public" returntype="Object" output="false">
	<cfargument name="class" hint="The class to be retrieving" type="string" required="Yes">
	<cfargument name="name" hint="The name of the manytomany" type="string" required="Yes">
	<cfscript>
		var object = 0;
		var key = arguments.class & "|" & arguments.name & "|LazyManyToMany";
		var manytomany = 0;
	</cfscript>

	<cfif NOT getObjectPool().has(key)>
		<cflock name="transfer.ObjectManager.getObjectLazyOneToMany.#key#" timeout="60" throwontimeout="true">
			<cfscript>
				//get the defintion
				if(NOT getObjectPool().has(key))
				{
					//new object
					object = getObjectDAO().getObject(createEmptyObject(), arguments.class);

					//let's massage it so that it represents an object with the item we want.
					manytomany = object.getManyToManyByName(arguments.name);

					manytomany.setIsLazy(false);

					object.clearManyToOne();
					object.clearManyToMany();
					object.clearOneToMany();

					object.addManyToMany(manytomany);

					getObjectPool().add(object, key);
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfscript>
		return getObjectPool().get(key);
	</cfscript>
</cffunction>

<cffunction name="getObjectLazyParentOneToMany" hint="creates an Object with no compositions" access="public" returntype="transfer.com.object.Object" output="false">
	<cfargument name="class" hint="The class to be retrieving" type="string" required="Yes">
	<cfscript>
		var object = 0;
		var key = arguments.class & "|LazyParentOneToMany";
		var manytomany = 0;
	</cfscript>

	<cfif NOT getObjectPool().has(key)>
		<cflock name="transfer.ObjectManager.getObjectLazyParentOneToMany.#key#" timeout="60" throwontimeout="true">
			<cfscript>
				//get the defintion
				if(NOT getObjectPool().has(key))
				{
					//new object
					object = getObjectDAO().getObject(createEmptyObject(), arguments.class);

					//let's massage it so that it represents an object with the item we want.
					object.clearManyToOne();
					object.clearManyToMany();
					object.clearOneToMany();

					getObjectPool().add(object, key);
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfscript>
		return getObjectPool().get(key);
	</cfscript>
</cffunction>

<cffunction name="getManyToManyLinksByClassLinkTo" hint="Gets a query of Many to Many details by the class it is linked to" access="public" returntype="query" output="false">
	<cfargument name="className" hint="The classname to search on" type="string" required="Yes">
	<cfscript>
		var key = static.LINKS_BY_CLASS_QUERY_KEY & "|" & arguments.className;
	</cfscript>

	<cfif not getQueryCache().checkQuery(key)>
		<cflock name="transfer.ObjectManager.getManyToManyLinksByClassLinkTo.#arguments.className#" timeout="60" throwontimeout="true">
			<cfscript>
				if(not getQueryCache().checkQuery(key))
				{
					getQueryCache().cacheQuery(getObjectGateway().getManyToManyLinksByClassLinkTo(arguments.className), key);
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfscript>
		return getQueryCache().getQuery(key);
	</cfscript>
</cffunction>


<!---
<cffunction name="getClassNameByOneToManyLinkTo" hint="Retrives the class names of all objects that have a One to Many relationship with this class" access="public" returntype="query" output="false">
	<cfargument name="className" hint="The classname to search on" type="string" required="Yes">
	<cfscript>
		var key = static.ONE_TO_MANY_LINKS_TO_QUERY_KEY & "|" & arguments.className;
	</cfscript>

	<cfif not getQueryCache().checkQuery(key)>
		<cflock name="transfer.ObjectManager.getClassNameByOneToManyLinkTo.#arguments.className#" timeout="60" throwontimeout="true">
			<cfscript>
				if(not getQueryCache().checkQuery(key))
				{
					getQueryCache().cacheQuery(getObjectGateway().getClassNameByOneToManyLinkTo(arguments.className), key);
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfscript>
		return getQueryCache().getQuery(key);
	</cfscript>
</ cffunction>
--->
<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="createEmptyObject" hint="Creates an empty Object BO" access="public" returntype="Object" output="false">
	<cfreturn createObject("component", "Object").init()>
</cffunction>

<cffunction name="getObjectDao" access="private" returntype="ObjectDAO" output="false">
	<cfreturn instance.ObjectDao />
</cffunction>

<cffunction name="setObjectDao" access="private" returntype="void" output="false">
	<cfargument name="ObjectDao" type="ObjectDAO" required="true">
	<cfset instance.ObjectDao = arguments.ObjectDao />
</cffunction>

<cffunction name="getObjectPool" access="private" returntype="transfer.com.collections.ObjectPool" output="false">
	<cfreturn instance.ObjectPool />
</cffunction>

<cffunction name="setObjectPool" access="private" returntype="void" output="false">
	<cfargument name="ObjectPool" type="transfer.com.collections.ObjectPool" required="true">
	<cfset instance.ObjectPool = arguments.ObjectPool />
</cffunction>

<cffunction name="getObjectGateway" access="private" returntype="ObjectGateway" output="false">
	<cfreturn instance.ObjectGateway />
</cffunction>

<cffunction name="setObjectGateway" access="private" returntype="void" output="false">
	<cfargument name="ObjectGateway" type="ObjectGateway" required="true">
	<cfset instance.ObjectGateway = arguments.ObjectGateway />
</cffunction>

<cffunction name="getQueryCache" access="private" returntype="transfer.com.collections.QueryCache" output="false">
	<cfreturn instance.QueryCache />
</cffunction>

<cffunction name="setQueryCache" access="private" returntype="void" output="false">
	<cfargument name="QueryCache" type="transfer.com.collections.QueryCache" required="true">
	<cfset instance.QueryCache = arguments.QueryCache />
</cffunction>

</cfcomponent>