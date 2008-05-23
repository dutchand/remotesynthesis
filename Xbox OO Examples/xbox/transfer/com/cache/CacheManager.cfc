<!--- Document Information -----------------------------------------------------

Title:      CacheManager.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Manages data persistance

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		19/07/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="CacheManager" hint="Manages data persistance">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="CacheManager" output="false">
	<cfargument name="objectManager" hint="Need to object manager for making queries" type="transfer.com.object.ObjectManager" required="Yes">
	<cfargument name="cacheConfigManager" hint="The cache config manager" type="transfer.com.cache.CacheConfigManager" required="Yes">
	<cfargument name="facadeFactory" hint="The facade factory to access caches" type="transfer.com.facade.FacadeFactory" required="Yes">
	<cfargument name="javaLoader" hint="The JavaLoader for loading the caching objects" type="transfer.com.util.JavaLoader" required="Yes">
	<cfscript>
		setObjectManager(arguments.objectManager);
		setMethodInvoker(createObject("component", "transfer.com.dynamic.MethodInvoker").init());
		setCacheConfigManager(arguments.cacheConfigManager);
		setFacadeFactory(arguments.facadeFactory);
		setJavaLoader(arguments.javaLoader);
		setSoftReferenceHandler(createObject("component", "transfer.com.cache.SoftReferenceHandler").init(getFacadeFactory()));
		setValidateCacheState(createObject("component", "transfer.com.cache.ValidateCacheState").init(getObjectManager(), this, getMethodInvoker()));
		setCacheSynchronise(createObject("component", "transfer.com.cache.CacheSynchronise").init(getObjectManager(), this, getMethodInvoker()));

		return this;
	</cfscript>
</cffunction>

<cffunction name="register" hint="Registers the TransferObject for caching with a soft reference, returns java.lang.ref.SoftReference" access="public" returntype="any" output="false">
	<cfargument name="transfer" hint="The transfer object to be registered" type="transfer.com.TransferObject" required="Yes">
	<cfreturn getSoftReferenceHandler().register(arguments.transfer) />
</cffunction>

<cffunction name="add" hint="Adds a Transfer Object to the Pool" access="public" returntype="void" output="false">
	<cfargument name="softRef" hint="java.lang.ref.SoftReference: The soft ref to the transfer object to be stored" type="any" required="Yes">
	<cfscript>
		var transfer = arguments.softRef.get();
		var object = 0;
		var key = 0;
		var cache = 0;

		getSoftReferenceHandler().reap();

		if(isDefined("transfer"))
		{
			object = getObjectManager().getObject(transfer.getClassName());
			cache = retrieveCache(object.getClassName());
			key = getMethodInvoker().invokeMethod(transfer, "get" & object.getPrimaryKey().getName());
			key = cleanKey(object.getClassName(), key);

			cache.add(object.getClassName(), key, softRef);
		}
	</cfscript>
</cffunction>

<cffunction name="have" hint="Checks if the Transfer is persistent in this" access="public" returntype="boolean" output="false">
	<cfargument name="class" hint="The name of the class" type="string" required="Yes">
	<cfargument name="key" hint="The key for the id of the data" type="string" required="Yes">

	<cfscript>
		var cache = retrieveCache(arguments.class);

		arguments.key = cleanKey(arguments.class, arguments.key);

		return cache.has(arguments.class, arguments.key);
	</cfscript>
</cffunction>

<cffunction name="get" hint="gets a TransferObject from the pool" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="class" hint="The name of the class" type="string" required="Yes">
	<cfargument name="key" hint="The key for the id of the data" type="string" required="Yes">
	<cfscript>
		var cache = retrieveCache(arguments.class);
		var transfer = 0;

		getSoftReferenceHandler().reap();

		arguments.key = cleanKey(arguments.class, arguments.key);

		return cache.get(arguments.class, arguments.key);
	</cfscript>
</cffunction>

<cffunction name="discard" hint="removes a transfer from the cache" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer object to be stored" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var object = getObjectManager().getObject(arguments.transfer.getClassName());
		var key = getMethodInvoker().invokeMethod(arguments.transfer, "get" & object.getPrimaryKey().getName());
		var cache = retrieveCache(object.getClassName());

		key = cleanKey(object.getClassName(), key);

		getSoftReferenceHandler().discard(arguments.transfer);
		
		//soft ref should have already handled this.
		//cache.discard(object.getClassName(), arguments.transfer);

		getSoftReferenceHandler().reap();
	</cfscript>
</cffunction>

<!--- <cffunction name="getSoftReference" hint="returns the soft reference for a TransferObject. Could be null" access="public" returntype="any" output="false">
	<cfargument name="transfer" hint="The transfer object" type="transfer.com.TransferObject" required="Yes">
	<cfreturn getSoftReferenceHandler().getSoftReference(arguments.transfer) />
</cffunction> --->

<cffunction name="isTransactionScoped" hint="Is this transaction scoped or not" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The transfer object to be stored" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var scope = getCacheConfigManager().getCacheConfig().getConfig(arguments.transfer.getClassName()).getScope();

		return (scope eq "transaction");
	</cfscript>
</cffunction>

<cffunction name="synchronise" hint="syncronises the data, and returns the cached TransferObject if there is one, otherwise returns the original TransferObject" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="transfer" hint="The transfer object to syncronise" type="transfer.com.TransferObject" required="Yes">
	<cfreturn getCacheSynchronise().synchronise(arguments.transfer) />
</cffunction>

<cffunction name="validateIsCached" hint="validates if a TransferObject is the same one as in cache" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The transfer object to syncronise" type="transfer.com.TransferObject" required="Yes">
	<cfreturn getValidateCacheState().validateIsCached(arguments.transfer) />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="cleanKey" hint="Makes sure the key is formatted properly" access="public" returntype="string" output="false">
	<cfargument name="class" hint="The name of the class" type="string" required="Yes">
	<cfargument name="key" hint="The key for the id of the data" type="string" required="Yes">
	<cfscript>
		var primaryKey = getObjectManager().getObject(arguments.class).getPrimaryKey();

		switch(primaryKey.getType())
		{
			case "guid":case "uuid":
				arguments.key = UCase(arguments.key);
			break;
			default:
				//could be 'null' so, check
				if(isNumeric(arguments.key))
				{
					arguments.key = trimTrailingDecimalZeros(arguments.key);
				}
		}

		return JavaCast("string", arguments.key);
	</cfscript>
</cffunction>

<cffunction name="retrieveCache" hint="Returns a com.compoundtheory.objectcache.CacheManager" access="public" returntype="any" output="false">
	<cfargument name="class" hint="The name of the class" type="string" required="Yes">
	<cfscript>
		var cacheConfig = getCacheConfigManager().getCacheConfig();

		var scope = cacheConfig.getConfig(arguments.class).getScope();

		var facade = getFacadeFactory().getFacadeByScope(scope);
		</cfscript>

		<!--- double lock, so that only one object --->
		<cfif NOT facade.hasCacheManager()>
			<cflock name="CacheManager.retrievecache.#arguments.class#" timeout="60" throwontimeout="true">
				<cfscript>
					if(NOT facade.hasCacheManager())
					{
						//handle special case
						if(scope eq "none")
						{
							facade.setCacheManager(getJavaLoader().create("com.compoundtheory.objectcache.DummyCacheManager").init(cacheConfig));
						}
						else
						{
							facade.setCacheManager(getJavaLoader().create("com.compoundtheory.objectcache.CacheManager").init(cacheConfig));
						}
					}
				</cfscript>
			</cflock>
		</cfif>

		<cfscript>
		return facade.getCacheManager();
	</cfscript>
</cffunction>

<cffunction name="trimTrailingDecimalZeros" hint="Removes trailing decimal zeros - makes sure numeric values come through the same " access="private" returntype="numeric" output="false">
	<cfargument name="number" hint="The number to format" type="numeric" required="Yes">
	<cfscript>
		//first wave
		var returnNumber = rereplaceNoCase(arguments.number, "\.[0]+$", "");

		//second wave
		return rereplaceNoCase(returnNumber, "(\.)([0-9]*?)([0]+)$", "\1\2");
	</cfscript>
</cffunction>

<cffunction name="getSoftReferenceHandler" access="private" returntype="transfer.com.cache.SoftReferenceHandler" output="false">
	<cfreturn instance.SoftReferenceHandler />
</cffunction>

<cffunction name="setSoftReferenceHandler" access="private" returntype="void" output="false">
	<cfargument name="SoftReferenceHandler" type="transfer.com.cache.SoftReferenceHandler" required="true">
	<cfset instance.SoftReferenceHandler = arguments.SoftReferenceHandler />
</cffunction>

<cffunction name="getCacheConfigManager" access="private" returntype="transfer.com.cache.CacheConfigManager" output="false">
	<cfreturn instance.CacheConfigManager />
</cffunction>

<cffunction name="setCacheConfigManager" access="private" returntype="void" output="false">
	<cfargument name="CacheConfigManager" type="transfer.com.cache.CacheConfigManager" required="true">
	<cfset instance.CacheConfigManager = arguments.CacheConfigManager />
</cffunction>

<cffunction name="getFacadeFactory" access="private" returntype="transfer.com.facade.FacadeFactory" output="false">
	<cfreturn instance.FacadeFactory />
</cffunction>

<cffunction name="setFacadeFactory" access="private" returntype="void" output="false">
	<cfargument name="FacadeFactory" type="transfer.com.facade.FacadeFactory" required="true">
	<cfset instance.FacadeFactory = arguments.FacadeFactory />
</cffunction>

<cffunction name="getObjectManager" access="private" returntype="transfer.com.object.ObjectManager" output="false">
	<cfreturn instance.ObjectManager />
</cffunction>

<cffunction name="setObjectManager" access="private" returntype="void" output="false">
	<cfargument name="ObjectManager" type="transfer.com.object.ObjectManager" required="true">
	<cfset instance.ObjectManager = arguments.ObjectManager />
</cffunction>

<cffunction name="getMethodInvoker" access="private" returntype="transfer.com.dynamic.MethodInvoker" output="false">
	<cfreturn instance.MethodInvoker />
</cffunction>

<cffunction name="setMethodInvoker" access="private" returntype="void" output="false">
	<cfargument name="MethodInvoker" type="transfer.com.dynamic.MethodInvoker" required="true">
	<cfset instance.MethodInvoker = arguments.MethodInvoker />
</cffunction>

<cffunction name="getJavaLoader" access="private" returntype="transfer.com.util.JavaLoader" output="false">
	<cfreturn instance.JavaLoader />
</cffunction>

<cffunction name="setJavaLoader" access="private" returntype="void" output="false">
	<cfargument name="JavaLoader" type="transfer.com.util.JavaLoader" required="true">
	<cfset instance.JavaLoader = arguments.JavaLoader />
</cffunction>

<cffunction name="getCacheSynchronise" access="private" returntype="transfer.com.cache.CacheSynchronise" output="false">
	<cfreturn instance.CacheSynchronise />
</cffunction>

<cffunction name="setCacheSynchronise" access="private" returntype="void" output="false">
	<cfargument name="CacheSynchronise" type="transfer.com.cache.CacheSynchronise" required="true">
	<cfset instance.CacheSynchronise = arguments.CacheSynchronise />
</cffunction>

<cffunction name="getValidateCacheState" access="private" returntype="transfer.com.cache.ValidateCacheState" output="false">
	<cfreturn instance.ValidateCacheState />
</cffunction>

<cffunction name="setValidateCacheState" access="private" returntype="void" output="false">
	<cfargument name="ValidateCacheState" type="transfer.com.cache.ValidateCacheState" required="true">
	<cfset instance.ValidateCacheState = arguments.ValidateCacheState />
</cffunction>

</cfcomponent>