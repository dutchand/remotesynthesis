<!--- Document Information -----------------------------------------------------

Title:      DiscardQueueHandler.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Handles discarding items off the discard queue

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		17/05/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="DiscardQueueHandler" hint="Handles discarding items off the discard queue">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="DiscardQueueHandler" output="false">
	<cfargument name="facadeFactory" hint="The facade factpry for getting to the cache" type="transfer.com.facade.FacadeFactory" required="Yes">
	<cfargument name="transfer" hint="Need transfer to call discard" type="transfer.com.Transfer" required="Yes">
	<cfscript>
		setFacadeFactory(arguments.facadeFactory);
		setTransfer(arguments.transfer);
	
		return this;
	</cfscript>
</cffunction>

<cffunction name="run" hint="Runs the aspect of clearing out discard queues" access="public" returntype="void" output="false">
	<cfscript>
		handleQueue(getFacadeFactory().getApplicationFacade());
		handleQueue(getFacadeFactory().getInstanceFacade());
		handleQueue(getFacadeFactory().getRequestFacade());
		handleQueue(getFacadeFactory().getServerFacade());
		handleQueue(getFacadeFactory().getSessionFacade());
		//really not required, but to keep clean
		handleQueue(getFacadeFactory().getNoneFacade());
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="handleQueue" hint="Handles a single queue instance" access="private" returntype="void" output="false">
	<cfargument name="facade" hint="The facade to handle" type="transfer.com.facade.AbstractBaseFacade" required="Yes">
	<cfscript>
		var cacheManager = 0;
		var queueLen = 0;
		var counter = 1;
		var transferObject = 0;
		
		if(arguments.facade.hasCacheManager())
		{
			cacheManager = arguments.facade.getCacheManager();
			queueLen = cacheManager.discardQueueSize();
			for(; counter lte queueLen; counter = counter + 1)
			{
				//do check again - minimise multithread issues
				if(NOT cacheManager.discardQueueIsEmpty())
				{
					try
					{
						transferObject = cacheManager.popFromDiscardQueue();
						getTransfer().discard(transferObject);
					}
					catch(org.apache.commons.collections.BufferUnderflowException exc)
					{
						//ignore it, we don't really care
					}
				}
			}
		}
	</cfscript>
</cffunction>

<cffunction name="getFacadeFactory" access="private" returntype="transfer.com.facade.FacadeFactory" output="false">
	<cfreturn instance.FacadeFactory />
</cffunction>

<cffunction name="setFacadeFactory" access="private" returntype="void" output="false">
	<cfargument name="FacadeFactory" type="transfer.com.facade.FacadeFactory" required="true">
	<cfset instance.FacadeFactory = arguments.FacadeFactory />
</cffunction>

<cffunction name="getTransfer" access="private" returntype="transfer.com.Transfer" output="false">
	<cfreturn instance.Transfer />
</cffunction>

<cffunction name="setTransfer" access="private" returntype="void" output="false">
	<cfargument name="Transfer" type="transfer.com.Transfer" required="true">
	<cfset instance.Transfer = arguments.Transfer />
</cffunction>

</cfcomponent>