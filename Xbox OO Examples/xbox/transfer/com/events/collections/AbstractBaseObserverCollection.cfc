<!--- Document Information -----------------------------------------------------

Title:      AbstractBaseObserverCollection.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Abstract Base Class for Observer collections

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		06/10/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="AbstractBaseObserverCollection" hint="Abstract Base Class for Observer collections">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="void" output="false">
	<cfargument name="actionMethodName" hint="the method name to invoke on the action" type="string" required="Yes">
	<cfscript>
		var linkedHashMap = createObject("java", "java.util.LinkedHashMap").init();
		var Collections = createObject("java", "java.util.Collections");

		setSystem(createObject("java", "java.lang.System"));

		setCollection(Collections.synchronizedMap(linkedHashMap));

		setActionMethodName(arguments.actionMethodName);
		setMethodInvoker(createObject("component", "transfer.com.dynamic.MethodInvoker").init());
	</cfscript>
</cffunction>

<cffunction name="addObserver" hint="Adds an observer" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to be added" type="transfer.com.events.adapter.AbstractBaseEventActionAdapter" required="Yes">
	<cfscript>
		StructInsert(getCollection(), arguments.observer.getHashCode(), arguments.observer, true);
	</cfscript>
</cffunction>

<cffunction name="removeObserver" hint="Removes an observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to be removed (may be the soft reference)" type="any" required="Yes">
	<cfscript>
		var hash = getSystem().identityHashCode(arguments.observer);

		removeObserverByHash(hash);
	</cfscript>
</cffunction>

<cffunction name="removeObserverByHash" hint="If you have the identity hash code, you can remove it" access="public" returntype="void" output="false">
	<cfargument name="hash" hint="The hash code to remove" type="string" required="Yes">
	<cfscript>
		StructDelete(getCollection(), arguments.hash);
	</cfscript>
</cffunction>

<cffunction name="fireEvent" hint="Fires off the event to all the Observers" access="public" returntype="void" output="false">
	<cfargument name="event" hint="The event to fire" type="transfer.com.events.TransferEvent" required="Yes">
	<cfscript>
		var iterator = 0;
		var observer = 0;

		iterator = getIterator();

		while(iterator.hasNext())
		{
			getMethodInvoker().invokeMethod(iterator.next(), getActionMethodName(), arguments);
		}
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getIterator" hint="Gets an iterator of a clone of the observer collection to avoid ConcurrentModificationExceptions" access="private" returntype="any" output="false">
	<cfreturn createObject("java", "java.util.LinkedList").init(getCollection().values()).iterator()>
</cffunction>

<cffunction name="getCollection" access="private" returntype="any" output="false">
	<cfreturn instance.Collection />
</cffunction>

<cffunction name="setCollection" access="private" returntype="void" output="false">
	<cfargument name="Collection" type="any" required="true">
	<cfset instance.Collection = arguments.Collection />
</cffunction>

<cffunction name="getMethodInvoker" access="private" returntype="transfer.com.dynamic.MethodInvoker" output="false">
	<cfreturn instance.MethodInvoker />
</cffunction>

<cffunction name="setMethodInvoker" access="private" returntype="void" output="false">
	<cfargument name="MethodInvoker" type="transfer.com.dynamic.MethodInvoker" required="true">
	<cfset instance.MethodInvoker = arguments.MethodInvoker />
</cffunction>

<cffunction name="getActionMethodName" access="private" returntype="string" output="false">
	<cfreturn instance.ActionMethodName />
</cffunction>

<cffunction name="setActionMethodName" access="private" returntype="void" output="false">
	<cfargument name="ActionMethodName" type="string" required="true">
	<cfset instance.ActionMethodName = arguments.ActionMethodName />
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

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>

</cfcomponent>