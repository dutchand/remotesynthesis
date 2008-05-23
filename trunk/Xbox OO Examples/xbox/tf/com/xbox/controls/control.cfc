<cfcomponent displayname="control" output="false" extends="transfer.com.TransferDecorator">		<cfproperty name="controlID" type="uuid" default="" />		<cfproperty name="wireless" type="Boolean" default="" />		<cfproperty name="headset" type="Boolean" default="" />			<cffunction name="useHeadset" access="public" returntype="void" output="false">		<cfif getHeadset()>			<cfset variables.headsetInUse = true />		<cfelse>			<cfthrow errorcode="com.xbox.controls.control.headsetNotSupported" />		</cfif>	</cffunction>	<cffunction name="removeHeadset" access="public" returntype="void" output="false">		<cfset variables.headsetInUse = false />	</cffunction>	<cffunction name="isHeadsetInUse" access="public" returntype="boolean" output="false">		<cfreturn variables.headsetInUse />	</cffunction></cfcomponent>
