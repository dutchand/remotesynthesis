<!--- Document Information -----------------------------------------------------

Title:      EventManager.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Manages Transfer events

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		26/08/2005		Created

------------------------------------------------------------------------------->

<cfcomponent name="EventManager" hint="Manages Transfer events">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="EventManager" output="false">
	<cfargument name="cacheConfigManager" hint="The cache manager" type="transfer.com.cache.CacheConfigManager" required="Yes">
	<cfargument name="facadeFactory" hint="The facade factory to access caches" type="transfer.com.facade.FacadeFactory" required="Yes">
	<cfscript>
		setTransferEventPool(createObject("component", "transfer.com.events.collections.TransferEventPool").init());
		setCacheConfigManager(arguments.CacheConfigManager);
		setFacadeFactory(arguments.facadeFactory);
		setSoftReferenceAdapterPool(createObject("component", "transfer.com.events.adapter.collections.SoftReferenceAdapterPool").init());

		return this;
	</cfscript>
</cffunction>

<!--- get adapters --->

<cffunction name="getObjectAdapter" hint="returns an Object adapter for an object" access="public" returntype="transfer.com.events.adapter.ObjectAdapter" output="false">
	<cfargument name="object" hint="The object to be adapted" type="any" required="Yes">
	<cfreturn createObject("component", "transfer.com.events.adapter.ObjectAdapter").init(arguments.object) />
</cffunction>

<cffunction name="getSoftReferenceAdapter" hint="Get the adapter for soft references" access="public" returntype="transfer.com.events.adapter.SoftReferenceAdapter" output="false">
	<cfargument name="softRef" hint="java.lang.SoftRef: The softref to be adapted" type="any" required="Yes">
	<cfargument name="transfer" hint="the transfer object to adapt" type="transfer.com.TransferObject" required="Yes">
	<cfreturn getSoftReferenceAdapterPool().getSoftReferenceAdapter(arguments.softRef, arguments.transfer)/>
</cffunction>

<!--- add observer functions --->
<cffunction name="addBeforeCreateObserver" hint="Adds a before create observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="transfer.com.events.adapter.AbstractBaseEventActionAdapter" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "beforecreate");
	</cfscript>
</cffunction>

<cffunction name="addAfterCreateObserver" hint="Adds a after create observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="transfer.com.events.adapter.AbstractBaseEventActionAdapter" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "aftercreate");
	</cfscript>
</cffunction>

<cffunction name="addBeforeUpdateObserver" hint="Adds a before Update observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="transfer.com.events.adapter.AbstractBaseEventActionAdapter" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "beforeupdate");
	</cfscript>
</cffunction>

<cffunction name="addAfterUpdateObserver" hint="Adds a after Update observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="transfer.com.events.adapter.AbstractBaseEventActionAdapter" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "afterupdate");
	</cfscript>
</cffunction>

<cffunction name="addBeforeDeleteObserver" hint="Adds a before Delete observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="transfer.com.events.adapter.AbstractBaseEventActionAdapter" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "beforedelete");
	</cfscript>
</cffunction>

<cffunction name="addAfterDeleteObserver" hint="Adds a after Delete observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="transfer.com.events.adapter.AbstractBaseEventActionAdapter" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "afterdelete");
	</cfscript>
</cffunction>

<cffunction name="addBeforeDiscardObserver" hint="Adds a before discard observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="transfer.com.events.adapter.AbstractBaseEventActionAdapter" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "beforediscard");
	</cfscript>
</cffunction>

<cffunction name="addAfterNewObserver" hint="Adds a after new observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="transfer.com.events.adapter.AbstractBaseEventActionAdapter" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "afternew");
	</cfscript>
</cffunction>

<!--- remove observer functions --->

<cffunction name="removeBeforeCreateObserver" hint="removes a before create observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "beforecreate");
	</cfscript>
</cffunction>

<cffunction name="removeAfterCreateObserver" hint="removes a after create observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "aftercreate");
	</cfscript>
</cffunction>

<cffunction name="removeBeforeUpdateObserver" hint="removes a before Update observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "beforeupdate");
	</cfscript>
</cffunction>

<cffunction name="removeAfterUpdateObserver" hint="removes a after Update observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "afterupdate");
	</cfscript>
</cffunction>

<cffunction name="removeBeforeDeleteObserver" hint="removes a before Delete observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "beforedelete");
	</cfscript>
</cffunction>

<cffunction name="removeAfterDeleteObserver" hint="removes a after Delete observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "afterdelete");
	</cfscript>
</cffunction>

<cffunction name="removeBeforeDiscardObserver" hint="removes a before Delete observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "beforediscard");
	</cfscript>
</cffunction>

<cffunction name="removeAfterNewObserver" hint="removes a after new observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "afternew");
	</cfscript>
</cffunction>

<!--- Fire Event Methods --->

<cffunction name="fireBeforeCreateEvent" hint="Fires a before create event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "beforecreate");
	</cfscript>
</cffunction>

<cffunction name="fireAfterCreateEvent" hint="Fires a After create event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "aftercreate");
	</cfscript>
</cffunction>

<cffunction name="fireBeforeUpdateEvent" hint="Fires a before Update event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "beforeupdate");
	</cfscript>
</cffunction>

<cffunction name="fireAfterUpdateEvent" hint="Fires a After Update event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "afterupdate");
	</cfscript>
</cffunction>

<cffunction name="fireBeforeDeleteEvent" hint="Fires a before Delete event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "beforedelete");
	</cfscript>
</cffunction>

<cffunction name="fireAfterDeleteEvent" hint="Fires a After Delete event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "afterdelete");
	</cfscript>
</cffunction>

<cffunction name="fireBeforeDiscardEvent" hint="Fires a After Delete event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "beforediscard");
	</cfscript>
</cffunction>

<cffunction name="fireAfterNewEvent" hint="Fires a After New event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "afterNew");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="fireEvent" hint="fire an event on a ObserverCollection" access="private" returntype="void" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="type" hint="key for what type of collection to get" type="string" required="Yes">
	<cfscript>
		var event = getTransferEventPool().getTransferEvent(arguments.transfer);
		var scope = getCacheConfigManager().getCacheConfig().getConfig(arguments.transfer.getClassName()).getScope();

		//run the instance scope one
		getCollectionByType(getFacadeFactory().getInstanceFacade(), arguments.type, "instance").fireEvent(event);

		//if we've got a transfer outside of instance scope
		if(scope neq "instance")
		{
			getObserverCollection(arguments.transfer, arguments.type).fireEvent(event);
		}

		//put it back
		getTransferEventPool().recycle(event);
	</cfscript>
</cffunction>

<cffunction name="addObserver" hint="add an observer, if a TransferObject, make it a soft ref" access="private" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="transfer.com.events.adapter.AbstractBaseEventActionAdapter" required="Yes">
	<cfargument name="type" hint="key for what type of collection to get" type="string" required="Yes">
	<cfscript>
		var adapted = arguments.observer.getAdapted();
		if(isDefined("adapted"))
		{
			getObserverCollection(adapted, arguments.type).addObserver(arguments.observer);
		}
	</cfscript>
</cffunction>

<cffunction name="removeObserver" hint="removes an observer, if a TransferObject, make it a soft ref" access="private" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfargument name="type" hint="key for what type of collection to get" type="string" required="Yes">
	<cfscript>
		getObserverCollection(arguments.observer, arguments.type).removeObserver(arguments.observer);
	</cfscript>
</cffunction>

<cffunction name="getObserverCollection" hint="Returns the beforeCreateObserverCollection from the right scope" access="private" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfargument name="object" hint="The object that is being passed in" type="any" required="Yes">
	<cfargument name="type" hint="key for what type to get" type="string" required="Yes">
	<cfscript>
		var facade = 0;
		var cacheConfig = 0;
		var scope = "instance";

		if(isTransferObject(arguments.object))
		{
			cacheConfig = getCacheConfigManager().getCacheConfig();
			scope = cacheConfig.getConfig(arguments.object.getClassName()).getScope();
		}

		facade = getFacadeFactory().getFacadeByScope(scope);
		return getCollectionByType(facade, arguments.type, scope);
	</cfscript>
</cffunction>

<cffunction name="getCollectionByType" hint="Returns the right collection created, from a Facade" access="private" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfargument name="facade" hint="The facade to find the type of collection from" type="transfer.com.facade.AbstractBaseFacade" required="Yes">
	<cfargument name="type" hint="key for what type to get" type="string" required="Yes">
	<cfargument name="scope" hint="The scope the object is cached in" type="string" required="Yes">

	<!---
	Double locked it all, so we only get one
	--->
	<cfswitch expression="#arguments.type#">
		<cfcase value="aftercreate">
			<cfif NOT facade.hasAfterCreateObserverCollection()>
				<cflock name="eventmanager.getcollectionbyytpe.#arguments.type#" timeout="60" throwontimeout="true">
					<cfif NOT facade.hasAfterCreateObserverCollection()>
						<cfset facade.setAfterCreateObserverCollection(createObserverCollection(arguments.type, scope))>
					</cfif>
				</cflock>
			</cfif>
			<cfreturn facade.getAfterCreateObserverCollection()>
		</cfcase>

		<cfcase value="afterdelete">
			<cfif NOT facade.hasAfterDeleteObserverCollection()>
				<cflock name="eventmanager.getcollectionbyytpe.#arguments.type#" timeout="60" throwontimeout="true">
					<cfif NOT facade.hasAfterDeleteObserverCollection()>
						<cfset facade.setAfterDeleteObserverCollection(createObserverCollection(arguments.type, scope))>
					</cfif>
				</cflock>
			</cfif>
			<cfreturn facade.getAfterDeleteObserverCollection()>
		</cfcase>

		<cfcase value="afterupdate">
			<cfif NOT facade.hasAfterUpdateObserverCollection()>
				<cflock name="eventmanager.getcollectionbyytpe.#arguments.type#" timeout="60" throwontimeout="true">
					<cfif NOT facade.hasAfterUpdateObserverCollection()>
						<cfset facade.setAfterUpdateObserverCollection(createObserverCollection(arguments.type, scope))>
					</cfif>
				</cflock>
			</cfif>
			<cfreturn facade.getAfterUpdateObserverCollection()>
		</cfcase>

		<cfcase value="beforecreate">
			<cfif NOT facade.hasBeforeCreateObserverCollection()>
				<cflock name="eventmanager.getcollectionbyytpe.#arguments.type#" timeout="60" throwontimeout="true">
					<cfif NOT facade.hasBeforeCreateObserverCollection()>
						<cfset facade.setBeforeCreateObserverCollection(createObserverCollection(arguments.type, scope))>
					</cfif>
				</cflock>
			</cfif>
			<cfreturn facade.getBeforeCreateObserverCollection()>
		</cfcase>

		<cfcase value="beforedelete">
			<cfif NOT facade.hasBeforeDeleteObserverCollection()>
				<cflock name="eventmanager.getcollectionbyytpe.#arguments.type#" timeout="60" throwontimeout="true">
					<cfif NOT facade.hasBeforeDeleteObserverCollection()>
						<cfset facade.setBeforeDeleteObserverCollection(createObserverCollection(arguments.type, scope))>
					</cfif>
				</cflock>
			</cfif>
			<cfreturn facade.getBeforeDeleteObserverCollection()>
		</cfcase>

		<cfcase value="beforeupdate">
			<cfif NOT facade.hasBeforeUpdateObserverCollection()>
				<cflock name="eventmanager.getcollectionbyytpe.#arguments.type#" timeout="60" throwontimeout="true">
					<cfif NOT facade.hasBeforeUpdateObserverCollection()>
						<cfset facade.setBeforeUpdateObserverCollection(createObserverCollection(arguments.type, scope))>
					</cfif>
				</cflock>
			</cfif>
			<cfreturn facade.getBeforeUpdateObserverCollection()>
		</cfcase>

		<cfcase value="beforediscard">
			<cfif NOT facade.hasBeforeDiscardObserverCollection()>
				<cflock name="eventmanager.getcollectionbyytpe.#arguments.type#" timeout="60" throwontimeout="true">
					<cfif NOT facade.hasBeforeDiscardObserverCollection()>
						<cfset facade.setBeforeDiscardObserverCollection(createObserverCollection(arguments.type, scope))>
					</cfif>
				</cflock>
			</cfif>
			<cfreturn facade.getBeforeDiscardObserverCollection()>
		</cfcase>

		<cfcase value="afternew">
			<cfif NOT facade.hasAfterNewObserverCollection()>
				<cflock name="eventmanager.getcollectionbyytpe.#arguments.type#" timeout="60" throwontimeout="true">
					<cfif NOT facade.hasAfterNewObserverCollection()>
						<cfset facade.setAfterNewObserverCollection(createObserverCollection(arguments.type, scope))>
					</cfif>
				</cflock>
			</cfif>
			<cfreturn facade.getAfterNewObserverCollection()>
		</cfcase>

		<cfdefaultcase>
			<cfset throw("InvalidObserverCollectionExceotion", "This is not a valid observercollection" ,"The collection type of '#arguments.type#' is not valid")>
		</cfdefaultcase>
	</cfswitch>
</cffunction>

<cffunction name="createObserverCollection" hint="Returns the right collection created, unless it's for 'None' scoped intances" access="private" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfargument name="type" hint="key for what type to get" type="string" required="Yes">
	<cfargument name="scope" hint="The scope the object is cached in" type="string" required="Yes">
	<cfscript>
		if(scope eq "none")
		{
			return createObject("component", "transfer.com.events.collections.DummyObserverCollection").init();
		}

		//this switch controls what is being loaded
		switch(arguments.type)
		{
			case "aftercreate":
				return createObject("component", "collections.AfterCreateObserverCollection").init();
			break;
			case "afterdelete":
				return createObject("component", "collections.AfterDeleteObserverCollection").init();
			break;
			case "afterupdate":
				return createObject("component", "collections.AfterUpdateObserverCollection").init();
			break;
			case "beforecreate":
				return createObject("component", "collections.BeforeCreateObserverCollection").init();
			break;
			case "beforedelete":
				return createObject("component", "collections.BeforeDeleteObserverCollection").init();
			break;
			case "beforeupdate":
				return createObject("component", "collections.BeforeUpdateObserverCollection").init();
			break;
			case "beforediscard":
				return createObject("component", "collections.BeforeDiscardObserverCollection").init();
			break;
			case "afterNew":
				return createObject("component", "collections.AfterNewObserverCollection").init();
			break;
			default:
				throw("InvalidObserverCollectionExceotion", "This is not a valid observercollection" ,"The collection type of '#arguments.type#' is not valid");
		}
	</cfscript>
</cffunction>

<cffunction name="isTransferObject" hint="Is this a transferObject?" access="public" returntype="boolean" output="false">
	<cfargument name="object" hint="The object that is being passed in" type="web-inf.cftags.component" required="Yes">
	<cfscript>
		var metadata = getMetaData(arguments.object);

		while(StructKeyExists(metadata, "extends"))
		{
			if(LCase(metadata.name) eq "transfer.com.transferobject")
			{
				return true;
			}

			metadata = metadata.extends;
		}

		return false;
	</cfscript>
</cffunction>

<cffunction name="getSoftReferenceAdapterPool" access="private" returntype="transfer.com.events.adapter.collections.SoftReferenceAdapterPool" output="false">
	<cfreturn instance.SoftReferenceAdapterPool />
</cffunction>

<cffunction name="setSoftReferenceAdapterPool" access="private" returntype="void" output="false">
	<cfargument name="SoftReferenceAdapterPool" type="transfer.com.events.adapter.collections.SoftReferenceAdapterPool" required="true">
	<cfset instance.SoftReferenceAdapterPool = arguments.SoftReferenceAdapterPool />
</cffunction>

<cffunction name="getTransferEventPool" access="private" returntype="transfer.com.events.collections.TransferEventPool" output="false">
	<cfreturn variables.TransferEventPool />
</cffunction>

<cffunction name="setTransferEventPool" access="private" returntype="void" output="false">
	<cfargument name="TransferEventPool" type="transfer.com.events.collections.TransferEventPool" required="true">
	<cfset variables.TransferEventPool = arguments.TransferEventPool />
</cffunction>

<cffunction name="getCacheConfigManager" access="private" returntype="transfer.com.cache.CacheConfigManager" output="false">
	<cfreturn instance.CacheConfigManager />
</cffunction>

<cffunction name="setCacheConfigManager" access="private" returntype="void" output="false">
	<cfargument name="cacheConfigManager" type="transfer.com.cache.CacheConfigManager" required="true">
	<cfset instance.CacheConfigManager = arguments.CacheConfigManager />
</cffunction>

<cffunction name="getFacadeFactory" access="private" returntype="transfer.com.facade.FacadeFactory" output="false">
	<cfreturn instance.FacadeFactory />
</cffunction>

<cffunction name="setFacadeFactory" access="private" returntype="void" output="false">
	<cfargument name="FacadeFactory" type="transfer.com.facade.FacadeFactory" required="true">
	<cfset instance.FacadeFactory = arguments.FacadeFactory />
</cffunction>

</cfcomponent>