<cfcomponent name="AbstractBaseSemiSoftRefObjectPool" hint="A object pool that maintains two collections, one hard reference, one soft reference">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="hardReferenceAmount" hint="The amount of hard references to keep" type="numeric" required="Yes">
	<cfscript>
		//hard one
		var BufferUtil = createObject("java", "org.apache.commons.collections.BufferUtils");
		var fifo = createObject("java", "org.apache.commons.collections.UnboundedFifoBuffer").init(arguments.hardReferenceAmount);
		fifo = BufferUtil.synchronizedBuffer(fifo);

		setHardReferenceAmount(arguments.hardReferenceAmount);

		setHardQueue(fifo);

		//soft one
		fifo = createObject("java", "org.apache.commons.collections.UnboundedFifoBuffer").init();
		fifo = BufferUtil.synchronizedBuffer(fifo);

		setSoftQueue(fifo);

		setReferenceQueue(createObject("java", "java.lang.ref.ReferenceQueue").init());

		refill();
	</cfscript>
</cffunction>

<cffunction name="push" hint="Pushes an object onto the queue" access="public" returntype="void" output="false">
	<cfargument name="object" hint="the object to push on" type="web-inf.cftags.component" required="Yes">
	<cfscript>
		var softRef = 0;

		if(getHardQueue().size() lt getHardReferenceAmount())
		{
			getHardQueue().add(arguments.object);
		}
		else
		{
			softRef = createObject("java", "java.lang.ref.SoftReference").init(arguments.object, getReferenceQueue());
			getSoftQueue().add(softRef);
		}
	</cfscript>
</cffunction>

<cffunction name="pop" hint="pops an objects outta the queue" access="public" returntype="web-inf.cftags.component" output="false">
	<cfscript>
		var object = 0;

		if(NOT getSoftQueue().isEmpty())
		{
			reap();
			object = popSoftQueue();

			if(isObject(object))
			{
				return object;
			}
		}

		if(NOT getHardQueue().isEmpty())
		{
			try
			{
				return getHardQueue().remove();
			}
			catch(org.apache.commons.collections.BufferUnderflowException exc)
			{
				return pop();
			}
		}

		refill();

		return pop();
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="refill" hint="refill the hard cache" access="private" returntype="void" output="false">
	<cfscript>
		var refillAmount = getHardReferenceAmount() - getHardQueue().size();
		var counter = 0;

		for(; counter lt refillAmount; counter = counter + 1)
		{
			getHardQueue().add(getNewObject());
		}
	</cfscript>
</cffunction>

<cffunction name="reap" hint="reaps the collected objects out of the pool" access="private" returntype="void" output="false">
	<cfscript>
		var softRef = getReferenceQueue().poll();

		while(isDefined("softRef"))
		{
			try
			{
				getSoftQueue().remove(softRef);
			}
			catch(java.lang.ArrayIndexOutOfBoundsException exc)
			{
				/*
					do nothing - this is a hard to reproduce error 
					in the Apache Commons UnboundedFifoBuffer
					that can throw this exception on a remove(obj) call.
					
					This softRef will eventually get removed when the 
					queue is polled.
				*/
			}
			softRef = getReferenceQueue().poll();
		}
	</cfscript>
</cffunction>

<cffunction name="popSoftQueue" hint="pops an object off the soft queue if one exists, otherwise returns 'false'" access="public" returntype="any" output="false">
	<cfscript>
		var softRef = 0;
		var obj = 0;
		
		//do the check again, as we did a reap();
		if(NOT getSoftQueue().isEmpty())
		{
			try
			{
				softRef = getSoftQueue().remove();
				obj = softRef.get();
			
				if(isDefined("obj"))
				{
					return obj;
				}
				
				//if it's not empty, then go get me another one
				return popSoftQueue();
			}
			catch(org.apache.commons.collections.BufferUnderflowException exc)
			{
				return false;
			}
		}
		
		return false;
	</cfscript>
</cffunction>

<cffunction name="getNewObject" hint="virtual method: returns the new CFC to repopulate the pool" access="private" returntype="web-inf.cftags.component" output="false">
	<cfthrow type="transfer.VirtualMethodException" message="This method is virtual and must be overwritten">
</cffunction>

<cffunction name="getHardReferenceAmount" access="private" returntype="numeric" output="false">
	<cfreturn instance.hardReferenceAmount />
</cffunction>

<cffunction name="setHardReferenceAmount" access="private" returntype="void" output="false">
	<cfargument name="hardReferenceAmount" type="numeric" required="true">
	<cfset instance.hardReferenceAmount = arguments.hardReferenceAmount />
</cffunction>

<cffunction name="getSoftQueue" access="private" hint="org.apache.commons.collections.UnboundedFifoBuffer" returntype="any" output="false">
	<cfreturn instance.SoftQueue />
</cffunction>

<cffunction name="setSoftQueue" access="private" returntype="void" output="false">
	<cfargument name="SoftQueue" hint="org.apache.commons.collections.UnboundedFifoBuffer" type="any" required="true">
	<cfset instance.SoftQueue = arguments.SoftQueue />
</cffunction>

<cffunction name="getReferenceQueue" access="private" hint="java.lang.ref.ReferenceQueue" returntype="any" output="false">
	<cfreturn instance.ReferenceQueue />
</cffunction>

<cffunction name="setReferenceQueue" access="private" returntype="void" output="false">
	<cfargument name="ReferenceQueue" type="any" hint="java.lang.ref.ReferenceQueue" required="true">
	<cfset instance.ReferenceQueue = arguments.ReferenceQueue />
</cffunction>

<cffunction name="getHardQueue" access="private" hint="org.apache.commons.collections.UnboundedFifoBuffer" returntype="any" output="false">
	<cfreturn instance.HardQueue />
</cffunction>

<cffunction name="setHardQueue" access="private" returntype="void" output="false">
	<cfargument name="HardQueue" hint="org.apache.commons.collections.UnboundedFifoBuffer" type="any" required="true">
	<cfset instance.HardQueue = arguments.HardQueue />
</cffunction>

</cfcomponent>