<!--- Document Information -----------------------------------------------------

Title:      SoftReferenceHandler.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    A place to manage all the soft references in the system

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		20/02/2007		Created

------------------------------------------------------------------------------->

<cfcomponent name="SoftReferenceHandler" hint="Handles Soft References in Transfer" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="SoftReferenceHandler" output="false">
	<cfargument name="facadeFactory" hint="The facade factpry for getting to the cache" type="transfer.com.facade.FacadeFactory" required="Yes">
	<cfscript>
		//instance scope please
		variables.instance = StructNew();

		setFacadeFactory(arguments.facadeFactory);
		setReferenceQueue(createObject("java", "java.lang.ref.ReferenceQueue").init());
		setReferenceClassMap(StructNew());
		setTransferObjectHashMap(StructNew());
		setReferenceMap(StructNew());
		setSystem(createObject("java", "java.lang.System"));

		return this;
	</cfscript>
</cffunction>

<cffunction name="register" hint="Registers a new TransferObject with the Handler, and returns a java.ref.softReference" access="public" returntype="any" output="false">
	<cfargument name="transfer" hint="The transfer object" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var softRef = createObject("java", "java.lang.ref.SoftReference").init(arguments.transfer, getReferenceQueue());
		var ident = getSystem().identityHashCode(arguments.transfer);

		//just do a check, as it may exist somehow
		if(StructKeyExists(getReferenceClassMap(), softRef)
			OR structKeyExists(getTransferObjectHashMap(), ident)
			OR StructKeyExists(getReferenceMap(), softRef)
			)
		{
			reap();
		}
		
		try
		{
			StructInsert(getTransferObjectHashMap(), ident, softRef);
			StructInsert(getReferenceMap(), softRef, ident); //this is for reap() operations
			StructInsert(getReferenceClassMap(), softRef, arguments.transfer.getClassName());
		}
		catch(Expression exc) 
		{   //on the odd chance that this already exists, re-discard and reap it, to make sure it's gone.
			discard(arguments.transfer);
			reap();
			register(arguments.transfer);
		}

		return softRef;
	</cfscript>
</cffunction>

<cffunction name="discard" hint="discards a TransferObject manualy" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer object" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var hash = getSystem().identityHashCode(arguments.transfer);
		var softRef = 0;
	</cfscript>
	<cfif StructKeyExists(getTransferObjectHashMap(), hash)>
		<cflock name="transfer.softReferenceHandler.#hash#" throwontimeout="true" timeout="60">
			<cfscript>
				if(StructKeyExists(getTransferObjectHashMap(), hash))
				{
					softRef = getTransferObjectHashMap().get(hash);

					if(isDefined("softRef"))
					{
						softRef.clear();
						//enqueue for cleanup
						softRef.enqueue();
					}
				}
			</cfscript>
		</cflock>
	</cfif>
</cffunction>

<!--- <cffunction name="getSoftReference" hint="returns the soft reference for a TransferObject. Could be null" access="public" returntype="any" output="false">
	<cfargument name="transfer" hint="The transfer object" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var hash = getSystem().identityHashCode(arguments.transfer);

		return getTransferObjectHashMap().get(hash);
	</cfscript>
</cffunction> --->

<cffunction name="reap" hint="reaps the collected objects out of the pool" access="public" returntype="void" output="false">
	<cfscript>
		var softRef = getReferenceQueue().poll();
		var class = 0;
		var hash = 0;

		while(isDefined("softRef"))
		{
			if(StructKeyExists(getReferenceClassMap(), softRef))
			{
				//we know it is here, as once it's popped off, it's yours
				class = StructFind(getReferenceClassMap(), softRef);
				hash = StructFind(getReferenceMap(), softRef);

				//tell the world that we've been reap'd!!!
				handleReap(softRef, getFacadeFactory().getInstanceFacade());
				handleReap(softRef, getFacadeFactory().getApplicationFacade());
				handleReap(softRef, getFacadeFactory().getRequestFacade());
				handleReap(softRef, getFacadeFactory().getServerFacade());
				handleReap(softRef, getFacadeFactory().getSessionFacade());
				//really not required, but to keep clean
				handleReap(softRef, getFacadeFactory().getNoneFacade());

				StructDelete(getTransferObjectHashMap(), hash);
				StructDelete(getReferenceClassMap(), softRef);
				StructDelete(getReferenceMap(), softRef);

				softRef = getReferenceQueue().poll();
			}
		}
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="handleReap" hint="Handles a single reap for a facade" access="private" returntype="void" output="false">
	<cfargument name="softRef" hint="java.lang.ref.SoftReference: The soft reference to reap" type="any" required="Yes">
	<cfargument name="facade" hint="The facade to handle" type="transfer.com.facade.AbstractBaseFacade" required="Yes">
	<cfscript>
		var hash = StructFind(getReferenceMap(), softRef);
		//reap on the caching layer
		if(arguments.facade.hasCacheManager())
		{
			arguments.facade.getCacheManager().reap(StructFind(getReferenceClassMap(), softRef), arguments.softRef);
		}

		//reap on the observer layer
		if(arguments.facade.hasAfterCreateObserverCollection())
		{
			arguments.facade.getAfterCreateObserverCollection().removeObserverByHash(hash);
		}

		if(arguments.facade.hasAfterUpdateObserverCollection())
		{
			arguments.facade.getAfterUpdateObserverCollection().removeObserverByHash(hash);
		}

		if(arguments.facade.hasAfterDeleteObserverCollection())
		{
			arguments.facade.getAfterDeleteObserverCollection().removeObserverByHash(hash);
		}

		if(arguments.facade.hasBeforeCreateObserverCollection())
		{
			arguments.facade.getBeforeCreateObserverCollection().removeObserverByHash(hash);
		}

		if(arguments.facade.hasBeforeUpdateObserverCollection())
		{
			arguments.facade.getBeforeUpdateObserverCollection().removeObserverByHash(hash);
		}

		if(arguments.facade.hasBeforeDeleteObserverCollection())
		{
			arguments.facade.getBeforeDeleteObserverCollection().removeObserverByHash(hash);
		}

		if(arguments.facade.hasBeforeDiscardObserverCollection())
		{
			arguments.facade.getBeforeDiscardObserverCollection().removeObserverByHash(hash);
		}
	</cfscript>
</cffunction>

<cffunction name="getTransferObjectHashMap" access="private" returntype="struct" output="false">
	<cfreturn instance.TransferObjectHashMap />
</cffunction>

<cffunction name="setTransferObjectHashMap" access="private" returntype="void" output="false">
	<cfargument name="TransferObjectHashMap" type="struct" required="true">
	<cfset instance.TransferObjectHashMap = arguments.TransferObjectHashMap />
</cffunction>

<cffunction name="getReferenceClassMap" access="private" returntype="struct" output="false">
	<cfreturn instance.ReferenceClassMap />
</cffunction>

<cffunction name="setReferenceClassMap" access="private" returntype="void" output="false">
	<cfargument name="ReferenceClassMap" type="struct" required="true">
	<cfset instance.ReferenceClassMap = arguments.ReferenceClassMap />
</cffunction>

<cffunction name="getReferenceMap" access="private" returntype="struct" output="false">
	<cfreturn instance.ReferenceMap />
</cffunction>

<cffunction name="setReferenceMap" access="private" returntype="void" output="false">
	<cfargument name="ReferenceMap" type="struct" required="true">
	<cfset instance.ReferenceMap = arguments.ReferenceMap />
</cffunction>

<cffunction name="getFacadeFactory" access="private" returntype="transfer.com.facade.FacadeFactory" output="false">
	<cfreturn instance.FacadeFactory />
</cffunction>

<cffunction name="setFacadeFactory" access="private" returntype="void" output="false">
	<cfargument name="FacadeFactory" type="transfer.com.facade.FacadeFactory" required="true">
	<cfset instance.FacadeFactory = arguments.FacadeFactory />
</cffunction>

<cffunction name="getReferenceQueue" access="private" hint="java.lang.ref.ReferenceQueue" returntype="any" output="false">
	<cfreturn instance.ReferenceQueue />
</cffunction>

<cffunction name="setReferenceQueue" access="private" returntype="void" output="false">
	<cfargument name="ReferenceQueue" type="any" hint="java.lang.ref.ReferenceQueue" required="true">
	<cfset instance.ReferenceQueue = arguments.ReferenceQueue />
</cffunction>

<cffunction name="getSystem" access="private" returntype="any" output="false">
	<cfreturn instance.System />
</cffunction>

<cffunction name="setSystem" access="private" returntype="void" output="false">
	<cfargument name="System" type="any" required="true">
	<cfset instance.System = arguments.System />
</cffunction>

</cfcomponent>