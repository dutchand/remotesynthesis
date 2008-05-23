<!--- Document Information -----------------------------------------------------

Title:      Transfer.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Main class of the transfer lib

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		11/07/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="Transfer" hint="Main class of the transfer lib">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="Transfer" output="false">
	<cfargument name="datasource" hint="The datasource BO" type="transfer.com.sql.Datasource" required="Yes">
	<cfargument name="configReader" hint="XML reader for the config file" type="transfer.com.io.XMLFileReader" required="Yes">
	<cfargument name="definitionPath" hint="Path to where the definitions are kept" type="string" required="Yes">
	<cfargument name="version" hint="the version of Transfer" type="string" required="Yes">

	<cfscript>
		var facadeFactory = createObject("component", "transfer.com.facade.FacadeFactory").init(arguments.version);
		var javaLoader = createObject("component", "transfer.com.util.JavaLoader").init(facadeFactory.getServerFacade());
		var cacheconfigManager = createObject("component", "transfer.com.cache.CacheConfigManager").init(javaLoader, arguments.configReader);
		
		facadeFactory.configure(cacheconfigManager);

		setUtility(createObject("component", "transfer.com.util.Utility").init());

		setObjectManager(createObject("component", "transfer.com.object.ObjectManager").init(arguments.configReader));

		setSQLManager(createObject("component", "transfer.com.sql.SQLManager").init(arguments.dataSource, arguments.configReader, getObjectManager(), getUtility()));

		setTQLManager(createObject("component", "transfer.com.tql.TQLManager").init(javaLoader, getObjectManager(), arguments.datasource));

		setDynamicManager(createObject("component", "transfer.com.dynamic.DynamicManager").init(arguments.definitionPath, getObjectManager(), getSQLManager()));

		setCacheManager(createObject("component", "transfer.com.cache.CacheManager").init(getObjectManager(), cacheConfigManager, facadeFactory, javaLoader));

		setDiscardQueueHandler(createObject("component", "transfer.com.cache.DiscardQueueHandler").init(facadeFactory, this));

		setEventManager(createObject("component", "transfer.com.events.EventManager").init(cacheConfigManager, facadeFactory));

		return this;
	</cfscript>
</cffunction>

<cffunction name="new" hint="Creates a new, empty TransferObject decorated with the given classes methods" access="public" returntype="TransferObject" output="false">
	<cfargument name="class" hint="The name of the package and class (Case Sensitive)" type="string" required="Yes">
	<cfscript>
		//get the BO
		var object = getObjectManager().getObject(arguments.class);
		var transfer = 0;
		var decorator = 0;

		//running discard queue
		getDiscardQueueHandler().run();

		//lets build it
		transfer = getDynamicManager().createTransferObject(object);

		if(object.hasDecorator())
		{
			decorator = getDynamicManager().createDecorator(object, transfer);
			decorator = decorator.init(this, transfer, getUtility(), getSQLManager().getNullable());

			getEventManager().fireAfterNewEvent(decorator);

			return decorator;
		}

		transfer = transfer.init(this, getUtility(), getSQLManager().getNullable(), transfer);

		getEventManager().fireAfterNewEvent(transfer);

		return transfer;
	</cfscript>
</cffunction>

<cffunction name="get" hint="Retrieves a populated TransferObject of a given class and primary key. If no object exists for this key, an empty instance of the class is returned." access="public" returntype="TransferObject" output="false">
	<cfargument name="class" hint="The name of the package and class (Case Sensitive)" type="string" required="Yes">
	<cfargument name="key" hint="Primary key for the object in the DB" type="string" required="Yes">

	<cfscript>
		var transfer = 0;

		//running discard queue
		getDiscardQueueHandler().run();
	</cfscript>

	<cftry>
		<!---
		double check lock it so that we only ever get one version of an object in the
		persistance scope
		 --->
		<cfif NOT isCached(arguments.class, arguments.key)>
			<cflock name="transfer.get.#arguments.class#.#arguments.key#" throwontimeout="true" timeout="60">
			<cfscript>
				//is in persistance manager
				if(NOT isCached(arguments.class, arguments.key))
				{
					//if not put it in
					transfer = new(arguments.class);

					//run the query
					getDynamicManager().populate(transfer, arguments.key);

					//turn on the event handlers (done in cache now)
					//transfer.getOriginalTransferObject().initEventObservers();

					//set to non dirty, and persisted
					transfer.getOriginalTransferObject().setIsDirty(false);
					transfer.getOriginalTransferObject().setIsPersisted(true);

					//put it in persistance
					cache(transfer);

					/*
					shoot it back out, in case it's a 'none' cached item,
					we don't want it looking for itself further down
					*/
					return transfer;
				}
			</cfscript>
			</cflock>
		</cfif>
		<cfscript>
			//get out of persistance and return
			return getCacheManager().get(arguments.class, arguments.key);
		</cfscript>

		<!--- if the cache actually got expired between, try again --->
		<cfcatch type="java.lang.Exception">
			<cfswitch expression="#cfcatch.Type#">
				<!--- catch it if it gets removed along the way --->
				<cfcase value="com.compoundtheory.objectcache.ObjectNotFoundException">
					<cfreturn get(arguments.class, arguments.key) />
				</cfcase>
				<cfdefaultcase>
					<cfrethrow>
				</cfdefaultcase>
			</cfswitch>
		</cfcatch>

<!--- 		<cfcatch type="ObjectNotFoundException">
			<cfreturn get(arguments.class, arguments.key) />
		</cfcatch>
--->

		<cfcatch type="EmptyQueryException">
			<cfscript>
				//if not found, return a empty object
				return new(arguments.class);
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="save" hint="If the object has yet to be instatiated, it is inserted into the db, otherwise it is updated" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer to save" type="TransferObject" required="Yes">
	<cfargument name="useTransaction" hint="Whether or not to use an internal transaction block" type="boolean" required="No" default="true">
	<cfscript>
		//check and apply as required
		if(arguments.transfer.getIsPersisted())
		{
			update(arguments.transfer, arguments.useTransaction);
		}
		else
		{
			create(arguments.transfer, arguments.useTransaction);
		}
	</cfscript>
</cffunction>

<cffunction name="create" hint="Creates a new transfer in the DB. Sets the transfer's ID, and persists the object." access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer to create in the DB" type="TransferObject" required="Yes">
	<cfargument name="useTransaction" hint="Whether or not to use an internal transaction block" type="boolean" required="No" default="true">
	<cfscript>
		//check to make sure it's not been created before
		if(arguments.transfer.getIsPersisted())
		{
			throw("ObjectAlreadyCreatedException", "Transfer Object has already been created", "The Transfer Object of type '"& arguments.transfer.getClassName() &"' has already been created in the database.");
		}

		//running discard queue
		getDiscardQueueHandler().run();

		getEventManager().fireBeforeCreateEvent(arguments.transfer);

		getSQLManager().create(arguments.transfer.getOriginalTransferObject(), arguments.useTransaction);

		//refresh
		getDynamicManager().refreshInsert(arguments.transfer);

		//set to non dirty, and persistant
		arguments.transfer.getOriginalTransferObject().setIsDirty(false);

		//if not valid, don't cache it
		if(arguments.transfer.getOriginalTransferObject().validateCacheState())
		{
			cache(arguments.transfer);
		}

		arguments.transfer.getOriginalTransferObject().setIsPersisted(true);

		getEventManager().fireAfterCreateEvent(arguments.transfer);

		//handle transaction based caching
		if(getCacheManager().isTransactionScoped(arguments.transfer))
		{
			discard(arguments.transfer);
		}
	</cfscript>
</cffunction>

<cffunction name="update" hint="Updates the record of a Transfer object in the database" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transferObject to update" type="TransferObject" required="Yes">
	<cfargument name="useTransaction" hint="Whether or not to use an internal transaction block" type="boolean" required="No" default="true">
	<cfscript>
		var cachedObject = 0;

		//check to make sure it's not been created before
		if(NOT arguments.transfer.getIsPersisted())
		{
			throw("ObjectNotCreatedException", "Transfer Object has already not been created", "The Transfer Object of type '"& arguments.transfer.getClassName() &"' has not been created in the database.");
		}

		//running discard queue
		getDiscardQueueHandler().run();

		if(arguments.transfer.getIsDirty())
		{
			cachedObject = getCacheManager().synchronise(arguments.transfer);

			getEventManager().fireBeforeUpdateEvent(cachedObject);

			getSQLManager().update(cachedObject.getOriginalTransferObject(), arguments.useTransaction);

			//refresh
			getDynamicManager().refreshUpdate(cachedObject);

			//set to non dirty
			cachedObject.getOriginalTransferObject().setIsDirty(false);

			//do it on the original just in case
			arguments.transfer.getOriginalTransferObject().setIsDirty(false);

			//if not valid, discard it
			if(NOT cachedObject.getOriginalTransferObject().validateCacheState())
			{
				discard(cachedObject);
			}

			getEventManager().fireAfterUpdateEvent(cachedObject);

			//handle transaction based caching
			if(getCacheManager().isTransactionScoped(cachedObject))
			{
				discard(cachedObject);
			}
		}
	</cfscript>
</cffunction>

<cffunction name="delete" hint="Deletes a transfer from the database and discard it from persistance." access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transferObject to delete" type="TransferObject" required="Yes">
	<cfargument name="useTransaction" hint="Whether or not to use an internal transaction block" type="boolean" required="No" default="true">
	<cfscript>
		var cachedObject = 0;
		//running discard queue
		getDiscardQueueHandler().run();

		//only run if it's in the DB
		if(arguments.transfer.getIsPersisted())
		{
			cachedObject = getCacheManager().synchronise(arguments.transfer);

			getEventManager().fireBeforeDeleteEvent(cachedObject);

			getSQLManager().delete(cachedObject, arguments.useTransaction);

			//set the cached object
			cachedObject.getOriginalTransferObject().setIsDirty(true);
			cachedObject.getOriginalTransferObject().setIsPersisted(false);

			//do the original one too
			arguments.transfer.getOriginalTransferObject().setIsDirty(true);
			arguments.transfer.getOriginalTransferObject().setIsPersisted(false);

			getEventManager().fireAfterDeleteEvent(cachedObject);

			discard(cachedObject);
		}
	</cfscript>
</cffunction>

<cffunction name="discard" hint="Discard the object from the cache" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transferObject to delete" type="TransferObject" required="Yes">
	<cfscript>
		removeBeforeDiscardObserver(arguments.transfer);
		removeAfterDeleteObserver(arguments.transfer);
		removeAfterCreateObserver(arguments.transfer);
		removeAfterUpdateObserver(arguments.transfer);

		getEventManager().fireBeforeDiscardEvent(arguments.transfer);

		getCacheManager().discard(arguments.transfer);
	</cfscript>
</cffunction>

<cffunction name="discardByClassAndKey" hint="Discards an Object by its class and its key, if it exists" access="public" returntype="void" output="false">
	<cfargument name="className" hint="The class name of the object to discard" type="string" required="Yes">
	<cfargument name="key" hint="The primary key value for the object" type="string" required="Yes">
	<cfset var transfer = 0 />

	<cfif getCacheManager().have(arguments.className, key)>
		<cfscript>
			transfer = getCacheManager().get(arguments.className, key);
			discard(transfer);
		</cfscript>
		<cftry>
			<cfcatch type="java.lang.Exception">
				<cfswitch expression="#cfcatch.Type#">
					<!--- catch it if it gets removed along the way --->
					<cfcase value="com.compoundtheory.objectcache.ObjectNotFoundException">
						<!--- do nothing --->
					</cfcase>
					<cfdefaultcase>
						<cfrethrow>
					</cfdefaultcase>
				</cfswitch>
			</cfcatch>
		</cftry>
	</cfif>
</cffunction>

<cffunction name="discardByClassAndKeyArray" hint="Discards an Object by its class and each key in an array, if it exists" access="public" returntype="void" output="false">
	<cfargument name="className" hint="The class name of the object to discard" type="string" required="Yes">
	<cfargument name="keyArray" hint="The primary key values for the object" type="array" required="Yes">
	<cfscript>
		var iterator = arguments.keyArray.iterator();

		while(iterator.hasNext())
		{
			discardByClassAndKey(arguments.className, iterator.next());
		}
	</cfscript>
</cffunction>

<cffunction name="discardByClassAndKeyQuery" hint="Discards an Object by its class and each key in an array, if it exists" access="public" returntype="void" output="false">
	<cfargument name="className" hint="The class name of the object to discard" type="string" required="Yes">
	<cfargument name="keyQuery" hint="The primary key values for the object" type="query" required="Yes">
	<cfargument name="columnName" hint="The name of the column the the id is in" type="string" required="Yes">
	<cfscript>
		var key = 0;
	</cfscript>

	<cfloop query="arguments.keyQuery">
		<cfscript>
			key = arguments.keyQuery[arguments.columnName][arguments.keyQuery.currentRow];

			discardByClassAndKey(arguments.className, key);
		</cfscript>
	</cfloop>
</cffunction>

<cffunction name="recycle" hint="Recycle an TransferObject for reuse by the system later on. This is good for performance. Only do this once a TransferObject has been deleted or discarded, and is not stored in any shared scopes, as the object's state is reset" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transferObject to delete" type="TransferObject" required="Yes">
	<cfscript>
		if(NOT arguments.transfer.getIsPersisted())
		{
			removeBeforeDeleteObserver(arguments.transfer);
			removeBeforeDiscardObserver(arguments.transfer);
			removeAfterDeleteObserver(arguments.transfer);
			removeAfterCreateObserver(arguments.transfer);
			removeAfterUpdateObserver(arguments.transfer);
		}

		//let's clean and recycle
		getDynamicManager().recycle(getDynamicManager().cleanTransfer(arguments.transfer.getOriginalTransferObject()));
	</cfscript>
</cffunction>

<!--- Meta Data --->

<cffunction name="getTransferMetaData" hint="Returns the Object meta data for a given transferobject class" access="public" returntype="transfer.com.object.Object" output="false">
	<cfargument name="className" hint="The class name of the transfer object" type="string" required="Yes">
	<cfreturn getObjectManager().getObject(arguments.className)>
</cffunction>

<!--- Get a query --->

<cffunction name="createQuery" hint="creates a query object for TQL interpretation" access="public" returntype="transfer.com.tql.Query" output="false">
	<cfargument name="tql" hint="The Transfer Query Language query" type="string" required="Yes">
	<cfreturn getTQLManager().createQuery(arguments.tql) />
</cffunction>

<!--- gateway functions --->

<cffunction name="list" hint="Lists a series of object values" access="public" returntype="query" output="false">
	<cfargument name="className" hint="The class of the objects to list" type="string" required="Yes">
	<cfargument name="orderProperty" hint="The property to order by" type="string" required="No" default="">
	<cfargument name="orderASC" hint="Boolean whether to order by ASC, otherwise order by DESC" type="boolean" required="No" default="true">
	<cfargument name="useAliases" hint="Boolean as to whether or not to alias columns with the transfer property names" type="boolean" required="no" default="true">

	<cfscript>
		return getSQLManager().list(arguments.className, arguments.orderProperty, arguments.orderASC, arguments.useAliases);
	</cfscript>
</cffunction>

<cffunction name="listByProperty" hint="Lists a series of values, filtered by a given value" access="public" returntype="query" output="false">
	<cfargument name="className" hint="The class of the objects to list" type="string" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to filter by" type="string" required="Yes">
	<cfargument name="propertyValue" hint="The value to filter by (only simple values)" type="any" required="Yes">
	<cfargument name="orderProperty" hint="The property to order by" type="string" required="No" default="">
	<cfargument name="orderASC" hint="Boolean whether to order by ASC, otherwise order by DESC" type="boolean" required="No" default="true">
	<cfargument name="useAliases" hint="Boolean as to whether or not to alias columns with the transfer property names" type="boolean" required="no" default="true">

	<cfscript>
		return getSQLManager().listByProperty(arguments.className,
												arguments.propertyName,
												arguments.propertyValue,
												false,
												arguments.orderProperty,
												arguments.orderASC,
												arguments.useAliases);
	</cfscript>
</cffunction>

<cffunction name="listByPropertyMap" hint="Lists values, filtered by a Struct of Property : Value properties" access="public" returntype="query" output="false">
	<cfargument name="className" hint="The class of the objects to list" type="string" required="Yes">
	<cfargument name="propertyMap" hint="Struct with keys that match to properties, and values to filter by" type="struct" required="Yes">
	<cfargument name="orderProperty" hint="The property to order by" type="string" required="No" default="">
	<cfargument name="orderASC" hint="Boolean whether to order by ASC, otherwise order by DESC" type="boolean" required="No" default="true">
	<cfargument name="useAliases" hint="Boolean as to whether or not to alias columns with the transfer property names" type="boolean" required="no" default="true">

	<cfscript>
		return getSQLManager().listByPropertyMap(arguments.className,
													arguments.propertyMap,
													false,
													arguments.orderProperty,
													arguments.orderASC,
													arguments.useAliases);
	</cfscript>
</cffunction>

<cffunction name="listByWhere" hint="Lists a series of values, filtered by a given value" access="public" returntype="query" output="false">
	<cfargument name="className" hint="The class of the objects to list" type="string" required="Yes">
	<cfargument name="whereSQL" hint="The where statement for the SQL Query (Do not include the 'where'). Properties can be defined as {propertyName}." type="any" required="Yes">
	<cfargument name="orderProperty" hint="The property to order by" type="string" required="No" default="">
	<cfargument name="orderASC" hint="Boolean whether to order by ASC, otherwise order by DESC" type="boolean" required="No" default="true">
	<cfargument name="useAliases" hint="Boolean as to whether or not to alias columns with the transfer property names" type="boolean" required="no" default="true">

	<cfscript>
		return getSQLManager().listByWhere(arguments.className,
											arguments.whereSQL,
											false,
											arguments.orderProperty,
											arguments.orderASC,
											arguments.useAliases);
	</cfscript>
</cffunction>

<cffunction name="listByQuery" hint="List by a TQL Query" access="public" returntype="query" output="false">
	<cfargument name="query" hint="A TQL Query object" type="transfer.com.tql.Query" required="Yes">

	<cfscript>
		return getTQLManager().evaluateQuery(arguments.query);
	</cfscript>
</cffunction>

<!--- readBy methods --->

<cffunction name="readByProperty" hint="retrieve an object by it's unique property. Throws an Exception if more than one object found" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="className" hint="The class of the objects to find" type="string" required="Yes">
	<cfargument name="propertyName" hint="The name of the property to find" type="string" required="Yes">
	<cfargument name="propertyValue" hint="The value to find (only simple values)" type="any" required="Yes">

	<cfscript>
		var qResults = getSQLManager().listByProperty(className=arguments.className,
														propertyName=arguments.propertyName,
														propertyValue=arguments.propertyValue,
														onlyRetrievePrimaryKey=true,
														useAliases=false);

		return read(arguments.className, qResults);
	</cfscript>
</cffunction>

<cffunction name="readByPropertyMap" hint="retrieve and object by a set of unique properties.  Throws an Exception if more than one object found" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="className" hint="The class of the objects to list" type="string" required="Yes">
	<cfargument name="propertyMap" hint="Struct with keys that match to properties, and values to filter by" type="struct" required="Yes">
	<cfscript>
		var qResults = getSQLManager().listByPropertyMap(className=arguments.className,
															propertyMap=arguments.propertyMap,
															onlyRetrievePrimaryKey=true,
															useAliases=false);

		return read(arguments.className, qResults);
	</cfscript>
</cffunction>

<cffunction name="readByWhere" hint="retrieve an object by it's unique where statement value. Throws an Exception if more than one object found" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="className" hint="The class of the objects to find" type="string" required="Yes">
	<cfargument name="whereSQL" hint="The where statement for the SQL Query (Do not include the 'where'). Properties can be defined as {propertyName}" type="any" required="Yes">

	<cfscript>
		var qResults = getSQLManager().listByWhere(className=arguments.className,
													whereSQL=arguments.whereSQL,
													onlyRetrievePrimaryKey=true,
													useAliases=false);

		return read(arguments.className, qResults);
	</cfscript>
</cffunction>

<cffunction name="readByQuery" hint="returve an object by a TQL query.  The query must either start with 'from' or only have one column in its result" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="className" hint="The class of the objects to find" type="string" required="Yes">
	<cfargument name="query" hint="TQL Query object" type="transfer.com.tql.Query" required="Yes">
	<cfscript>
		var qResults = 0;
		arguments.query.setAliasColumns(false);

		qResults = getTQLManager().evaluateQuery(arguments.query, true, arguments.className);

		return read(arguments.className, qResults);
	</cfscript>
</cffunction>

<!--- add observer functions --->

<cffunction name="addBeforeCreateObserver" hint="Adds an object as a observer of before create events" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="web-inf.cftags.component" required="Yes">
	<cfscript>
		getEventManager().addBeforeCreateObserver(getEventManager().getObjectAdapter(arguments.observer));
	</cfscript>
</cffunction>

<cffunction name="addAfterCreateObserver" hint="Adds an object as a observer of after create events" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="any" required="Yes">
	<cfscript>
		getEventManager().addAfterCreateObserver(getEventManager().getObjectAdapter(arguments.observer));
	</cfscript>
</cffunction>

<cffunction name="addBeforeUpdateObserver" hint="Adds an object as a observer of before update events" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="any" required="Yes">
	<cfscript>
		getEventManager().addBeforeUpdateObserver(getEventManager().getObjectAdapter(arguments.observer));
	</cfscript>
</cffunction>

<cffunction name="addAfterUpdateObserver" hint="Adds an object as a observer of after update events" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="any" required="Yes">
	<cfscript>
		getEventManager().addAfterUpdateObserver(getEventManager().getObjectAdapter(arguments.observer));
	</cfscript>
</cffunction>

<cffunction name="addBeforeDeleteObserver" hint="Adds an object as a observer of before delete events" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="any" required="Yes">
	<cfscript>
		getEventManager().addBeforeDeleteObserver(getEventManager().getObjectAdapter(arguments.observer));
	</cfscript>
</cffunction>

<cffunction name="addAfterDeleteObserver" hint="Adds an object as a observer of after delete events" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="any" required="Yes">
	<cfscript>
		getEventManager().addAfterDeleteObserver(getEventManager().getObjectAdapter(arguments.observer));
	</cfscript>
</cffunction>

<cffunction name="addAfterNewObserver" hint="Adds an object as a observer of after new events" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="any" required="Yes">
	<cfscript>
		getEventManager().addAfterNewObserver(getEventManager().getObjectAdapter(arguments.observer));
	</cfscript>
</cffunction>

<!--- remove observer functions --->

<cffunction name="removeBeforeCreateObserver" hint="removes an observer of before create events" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="any" required="Yes">
	<cfscript>
		getEventManager().removeBeforeCreateObserver(arguments.observer);
	</cfscript>
</cffunction>

<cffunction name="removeAfterCreateObserver" hint="removes an observer of after create events" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="any" required="Yes">
	<cfscript>
		getEventManager().removeAfterCreateObserver(arguments.observer);
	</cfscript>
</cffunction>

<cffunction name="removeBeforeUpdateObserver" hint="removes an observer of before update events" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="any" required="Yes">
	<cfscript>
		getEventManager().removeBeforeUpdateObserver(arguments.observer);
	</cfscript>
</cffunction>

<cffunction name="removeAfterUpdateObserver" hint="removes an observer of after update events" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="any" required="Yes">
	<cfscript>
		getEventManager().removeAfterUpdateObserver(arguments.observer);
	</cfscript>
</cffunction>

<cffunction name="removeBeforeDeleteObserver" hint="removes an observer of Before Delete events" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="any" required="Yes">
	<cfscript>
		getEventManager().removeBeforeDeleteObserver(arguments.observer);
	</cfscript>
</cffunction>

<cffunction name="removeAfterDeleteObserver" hint="removes an observer of after Delete events" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="any" required="Yes">
	<cfscript>
		getEventManager().removeAfterDeleteObserver(arguments.observer);
	</cfscript>
</cffunction>

<cffunction name="removeAfterNewObserver" hint="removes an observer of after new events" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="any" required="Yes">
	<cfscript>
		getEventManager().removeAfterNewObserver(arguments.observer);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!--- these functions are for transferObjects --->

<cffunction name="cache" hint="Adds the object to the cache manager" access="package" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer object to cache" type="TransferObject" required="Yes">
	<cfscript>
		var softRef = getCacheManager().register(arguments.transfer);

		var object = getObjectManager().getObject(arguments.transfer.getClassName());

		var hasManyToMany = object.hasManyToMany();
		var hasOneToMany = object.hasOneToMany();
		var hasParentOneToMany = object.hasParentOneToMany();
		var hasManyToOne = object.hasManyToOne();
		var adapter = 0;

		getCacheManager().add(softRef);

		if(hasManyToMany OR hasOneToMany OR hasParentOneToMany OR hasManyToOne)
		{
			adapter = getEventManager().getSoftReferenceAdapter(softRef, arguments.transfer);

			if(hasOneToMany)
			{
				getEventManager().addAfterCreateObserver(adapter);
			}

			if(hasOneToMany or hasManyToMany or hasParentOneToMany or hasManyToOne)
			{
				getEventManager().addAfterDeleteObserver(adapter);
			}

			if(hasManyToMany OR hasOneToMany)
			{
				getEventManager().addAfterUpdateObserver(adapter);
			}

			if(hasManyToMany OR hasOneToMany OR hasManyToOne OR hasParentOneToMany)
			{
				getEventManager().addBeforeDiscardObserver(adapter);
			}
		}
	</cfscript>
</cffunction>

<cffunction name="isCached" hint="Check if a transfer of a particular class is cached" access="package" returntype="boolean" output="false">
	<cfargument name="class" hint="The name of the class" type="string" required="Yes">
	<cfargument name="key" hint="The key for the id of the data" type="string" required="Yes">
	<cfscript>
		return getCacheManager().have(arguments.class, arguments.key);
	</cfscript>
</cffunction>

<cffunction name="addBeforeDiscardObserver" hint="Adds an object as a observer of before discard events" access="package" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="web-inf.cftags.component" required="Yes">
	<cfscript>
		var deleteObserver = getInterfaceProxy().implement(arguments.observer, "IBeforeDiscardEventObserver");
		getEventManager().addBeforeDiscardObserver(deleteObserver);
	</cfscript>
</cffunction>

<cffunction name="loadManyToOne" hint="LazyLoads the required manytone data into an object" access="package" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer to load into" type="TransferObject" required="Yes">
	<cfargument name="name" hint="The name of the manytoone to load" type="string" required="Yes">
	<cfscript>
		getDynamicManager().populateManyToOne(arguments.transfer, arguments.name);
	</cfscript>
</cffunction>

<cffunction name="loadOneToMany" hint="LazyLoads the required onetomany data into an object" access="package" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer to load into" type="TransferObject" required="Yes">
	<cfargument name="name" hint="The name of the onetomany to load" type="string" required="Yes">
	<cfscript>
		getDynamicManager().populateOneToMany(arguments.transfer, arguments.name);
	</cfscript>
</cffunction>

<cffunction name="loadManyToMany" hint="LazyLoads the required manytomany data into an object" access="package" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer to load into" type="TransferObject" required="Yes">
	<cfargument name="name" hint="The name of the manytomany to load" type="string" required="Yes">
	<cfscript>
		getDynamicManager().populateManyToMany(arguments.transfer, arguments.name);
	</cfscript>
</cffunction>

<cffunction name="loadParentOneToMany" hint="LazyLoads the required external onetomany data into an object" access="package" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer to load into" type="TransferObject" required="Yes">
	<cfargument name="name" hint="The name of the manytomany to load" type="string" required="Yes">
	<cfscript>
		getDynamicManager().populateParentOneToMany(arguments.transfer, arguments.name);
	</cfscript>
</cffunction>

<cffunction name="validateIsCached" hint="validates if a TransferObject is the same one as in cache" access="package" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The transfer object to syncronise" type="transfer.com.TransferObject" required="Yes">
	<cfreturn getCacheManager().validateIsCached(arguments.transfer) />
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="read" hint="Retrieves an object from a simple row query" access="private" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="className" hint="The class of the objects to find" type="string" required="Yes">
	<cfargument name="query" hint="The query to retrieve from" type="query" required="Yes">

	<cfscript>
		if(arguments.query.recordcount gt 1)
		{
			throw("MultipleRecordsFoundException",					"The parameters provided resulted in more than one record",
					"The query for '#arguments.className#' resulted in #arguments.query.recordCount# records in the Query");
		}
		else if(ListLen(arguments.query.columnList) gt 1)
		{
			throw("MultipleColumnsFoundException",
					"Read operations can only have one column in the results",
					"The query for '#arguments.className#' resulted in the following columns being present: #arguments.query.columnList#");
		}

		if(arguments.query.recordcount)
		{
			return get(arguments.classname, arguments.query[arguments.query.columnList][1]);
		}

		return new(arguments.className);
	</cfscript>
</cffunction>

<cffunction name="removeBeforeDiscardObserver" hint="removes an observer of after discard events" access="private" returntype="void" output="false">
	<cfargument name="observer" hint="The observer" type="any" required="Yes">
	<cfscript>
		getEventManager().removeBeforeDiscardObserver(arguments.observer);
	</cfscript>
</cffunction>

<cffunction name="getObjectManager" access="private" returntype="transfer.com.object.ObjectManager" output="false">
	<cfreturn instance.ObjectManager />
</cffunction>

<cffunction name="setObjectManager" access="private" returntype="void" output="false">
	<cfargument name="ObjectManager" type="transfer.com.object.ObjectManager" required="true">
	<cfset instance.ObjectManager = arguments.ObjectManager />
</cffunction>

<cffunction name="getCacheManager" access="private" returntype="transfer.com.cache.CacheManager" output="false">
	<cfreturn instance.CacheManager />
</cffunction>

<cffunction name="setCacheManager" access="private" returntype="void" output="false">
	<cfargument name="CacheManager" type="transfer.com.cache.CacheManager" required="true">
	<cfset instance.CacheManager = arguments.CacheManager />
</cffunction>

<cffunction name="getDynamicManager" access="private" returntype="transfer.com.dynamic.DynamicManager" output="false">
	<cfreturn instance.DynamicManager />
</cffunction>

<cffunction name="setDynamicManager" access="private" returntype="void" output="false">
	<cfargument name="DynamicManager" type="transfer.com.dynamic.DynamicManager" required="true">
	<cfset instance.DynamicManager = arguments.DynamicManager />
</cffunction>

<cffunction name="getEventManager" access="private" returntype="transfer.com.events.EventManager" output="false">
	<cfreturn instance.EventManager />
</cffunction>

<cffunction name="setEventManager" access="private" returntype="void" output="false">
	<cfargument name="EventManager" type="transfer.com.events.EventManager" required="true">
	<cfset instance.EventManager = arguments.EventManager />
</cffunction>

<cffunction name="getUtility" access="private" returntype="transfer.com.util.Utility" output="false">
	<cfreturn instance.Utility />
</cffunction>

<cffunction name="setUtility" access="private" returntype="void" output="false">
	<cfargument name="Utility" type="transfer.com.util.Utility" required="true">
	<cfset instance.Utility = arguments.Utility />
</cffunction>

<cffunction name="getDiscardQueueHandler" access="private" returntype="transfer.com.cache.DiscardQueueHandler" output="false">
	<cfreturn instance.DiscardQueueHandler />
</cffunction>

<cffunction name="setDiscardQueueHandler" access="private" returntype="void" output="false">
	<cfargument name="DiscardQueueHandler" type="transfer.com.cache.DiscardQueueHandler" required="true">
	<cfset instance.DiscardQueueHandler = arguments.DiscardQueueHandler />
</cffunction>

<cffunction name="getSQLManager" access="private" returntype="transfer.com.sql.SQLManager" output="false">
	<cfreturn instance.SQLManager />
</cffunction>

<cffunction name="setSQLManager" access="private" returntype="void" output="false">
	<cfargument name="SQLManager" type="transfer.com.sql.SQLManager" required="true">
	<cfset instance.SQLManager = arguments.SQLManager />
</cffunction>

<cffunction name="getTQLManager" access="private" returntype="transfer.com.tql.TQLManager" output="false">
	<cfreturn instance.TQLManager />
</cffunction>

<cffunction name="setTQLManager" access="private" returntype="void" output="false">
	<cfargument name="TQLManager" type="transfer.com.tql.TQLManager" required="true">
	<cfset instance.TQLManager = arguments.TQLManager />
</cffunction>

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>

</cfcomponent>