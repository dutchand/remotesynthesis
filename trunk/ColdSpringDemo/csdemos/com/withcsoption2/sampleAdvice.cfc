<cfcomponent output="false" extends="coldspring.aop.MethodInterceptor">  

	<cffunction name="init" returntype="any" output="false" access="public">  
		<cfreturn this />  
	</cffunction>  
  	
	<cffunction name="invokeMethod" returntype="any" access="public" output="false" hint="">  
			<cfargument name="methodInvocation" type="coldspring.aop.MethodInvocation" required="true" />  
			<cfset var local =  structNew() />
			
			<cfif structKeyExists(arguments.methodInvocation.getArguments(),"art")>
				<cfset arguments.methodInvocation.getArguments()["art"].setArtID(arguments.methodInvocation.getArguments()["art"].getArtID()+1) />
			</cfif>
			
			<!--- Proceed with the method call to the underlying CFC. --->  
  			<cfset local.result = arguments.methodInvocation.proceed() />  
			
			<!--- Return the result of the method call. --->  
			<cfreturn local.result />  
	</cffunction>  

</cfcomponent>  