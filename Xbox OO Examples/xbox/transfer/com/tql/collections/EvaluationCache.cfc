<cfcomponent name="EvaluationCache" hint="Cache for storing evaluations of TQL" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="EvaluationCache" output="false">
	<cfscript>
		setReferenceQueue(createObject("java", "java.lang.ref.ReferenceQueue").init());
		setEvaluationCache(StructNew());
		setSoftRefLookup(StructNew());

		return this;
	</cfscript>
</cffunction>

<cffunction name="add" hint="Adds a new evaluation for TQL into the cache" access="public" returntype="void" output="false">
	<cfargument name="tql" hint="The TQL string" type="string" required="Yes">
	<cfargument name="evaluation" hint="The evaluation array" type="array" required="Yes">
	<cfscript>
		var softRef = createObject("java", "java.lang.ref.SoftReference").init(arguments.evaluation, getReferenceQueue());
		var hashValue = hash(arguments.tql);

		//allow overwrites, it doesn't matter
		structInsert(getEvaluationCache(), hashValue, softRef, true);
		structInsert(getSoftRefLookup(), softRef, hashValue, true);
	</cfscript>
</cffunction>

<cffunction name="has" hint="If it has the tql evaluation or not" access="public" returntype="boolean" output="false">
	<cfargument name="tql" hint="The TQL string" type="string" required="Yes">
	<cfscript>
		var hashValue = hash(arguments.tql);

		reap();

		if(StructKeyExists(getEvaluationCache(), hashValue))
		{
			return true;
		}

		return false;
	</cfscript>
</cffunction>

<cffunction name="get" hint="gets an evaluation. If one isn't around, returns an empty array" access="public" returntype="array" output="false">
	<cfargument name="tql" hint="The TQL string" type="string" required="Yes">
	<cfscript>
		var softRef = 0;
		var hashValue = hash(arguments.tql);
		var evaluation = 0;

		reap();

		if(StructKeyExists(getEvaluationCache(), hashValue))
		{
			try
			{
				softRef = StructFind(getEvaluationCache(), hashValue);
				evaluation = softRef.get();

				if(isDefined("evaluation")) //not null
				{
					return evaluation;
				}
			}
			catch(Expression exc)
			{
				//do nothing
			}
		}

		return ArrayNew(1);
	</cfscript>
</cffunction>

<cffunction name="reap" hint="reaps the collected objects out of the pool" access="private" returntype="void" output="false">
	<cfscript>
		var softRef = getReferenceQueue().poll();
		var hashValue = 0;

		while(isDefined("softRef"))
		{
			hashValue = StructFind(getSoftRefLookup(), softRef);

			StructDelete(getSoftRefLookup(), softRef);
			StructDelete(getEvaluationCache(), hashValue);

			softRef = getReferenceQueue().poll();
		}
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getSoftRefLookup" access="private" returntype="struct" output="false">
	<cfreturn variables.softRefLookup />
</cffunction>

<cffunction name="setSoftRefLookup" access="private" returntype="void" output="false">
	<cfargument name="softRefLookup" type="struct" required="true">
	<cfset variables.softRefLookup = arguments.softRefLookup />
</cffunction>

<cffunction name="getEvaluationCache" access="private" returntype="struct" output="false">
	<cfreturn instance.EvaluationCache />
</cffunction>

<cffunction name="setEvaluationCache" access="private" returntype="void" output="false">
	<cfargument name="EvaluationCache" type="struct" required="true">
	<cfset instance.EvaluationCache = arguments.EvaluationCache />
</cffunction>

<cffunction name="getReferenceQueue" access="private" returntype="any" output="false">
	<cfreturn instance.ReferenceQueue />
</cffunction>

<cffunction name="setReferenceQueue" access="private" returntype="void" output="false">
	<cfargument name="ReferenceQueue" type="any" required="true">
	<cfset instance.ReferenceQueue = arguments.ReferenceQueue />
</cffunction>

</cfcomponent>