<cfcomponent output="false">
	<cffunction name="init" access="public" output="false" returntype="com.withcs.artGalleryService">
		<cfargument name="artDAO" type="com.withcs.art.artDAO" required="true" />
		<cfargument name="artGateway" type="com.withcs.art.artGateway" required="true" />
		<cfargument name="artistDAO" type="com.withcs.artists.artistDAO" required="true" />
		<cfargument name="artistGateway" type="com.withcs.artists.artistGateway" required="true" />
		
		<cfset variables.artDAO = arguments.artDAO />
		<cfset variables.artGateway = artGateway />
		<cfset variables.artistDAO = artistDAO />
		<cfset variables.artistGateway = artistGateway />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createart" access="public" output="false" returntype="com.withcs.art.art">
		<cfargument name="ARTID" type="string" required="false" />
		<cfargument name="ARTISTID" type="string" required="false" />
		<cfargument name="ARTNAME" type="string" required="false" />
		<cfargument name="DESCRIPTION" type="string" required="false" />
		<cfargument name="PRICE" type="numeric" required="false" />
		<cfargument name="LARGEIMAGE" type="string" required="false" />
		<cfargument name="MEDIAID" type="string" required="false" />
		<cfargument name="ISSOLD" type="numeric" required="false" />
			
		<cfset var art = createObject("component","com.withcs.art.art").init(argumentCollection=arguments) />
		
		<cfif len(arguments.artistID)>
			<cfset artist = createObject("component","com.withcs.artists.artist").init(artistID=arguments.artistID) />
			<cfset art.setArtist(getartist(artist)) />
		</cfif>
		
		<cfreturn art />
	</cffunction>

	<cffunction name="getart" access="public" output="false" returntype="com.withcs.art.art">
		<cfargument name="art" type="com.withcs.art.art" required="false" />
		
		<cfset variables.artDAO.read(art) />
		<cfreturn art />
	</cffunction>

	<cffunction name="getarts" access="public" output="false" returntype="array">
		<cfargument name="ARTID" type="string" required="false" />
		<cfargument name="ARTISTID" type="string" required="false" />
		<cfargument name="ARTNAME" type="string" required="false" />
		<cfargument name="DESCRIPTION" type="string" required="false" />
		<cfargument name="PRICE" type="numeric" required="false" />
		<cfargument name="LARGEIMAGE" type="string" required="false" />
		<cfargument name="MEDIAID" type="string" required="false" />
		<cfargument name="ISSOLD" type="numeric" required="false" />
		
		<cfreturn variables.artGateway.getByAttributes(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="saveart" access="public" output="false" returntype="boolean">
		<cfargument name="art" type="com.withcs.art.art" required="true" />

		<cfreturn variables.artDAO.save(art) />
	</cffunction>

	<cffunction name="deleteart" access="public" output="false" returntype="boolean">
		
		<cfset var art = createart(argumentCollection=arguments) />
		<cfreturn variables.artDAO.delete(art) />
	</cffunction>
	
	<cffunction name="createartist" access="public" output="false" returntype="com.withcs.artists.artist">
		<cfargument name="ARTISTID" type="string" required="false" />
		<cfargument name="FIRSTNAME" type="string" required="false" />
		<cfargument name="LASTNAME" type="string" required="false" />
		<cfargument name="ADDRESS" type="string" required="false" />
		<cfargument name="CITY" type="string" required="false" />
		<cfargument name="STATE" type="string" required="false" />
		<cfargument name="POSTALCODE" type="string" required="false" />
		<cfargument name="EMAIL" type="string" required="false" />
		<cfargument name="PHONE" type="string" required="false" />
		<cfargument name="FAX" type="string" required="false" />
		<cfargument name="THEPASSWORD" type="string" required="false" />
		
			
		<cfset var artist = createObject("component","com.withcs.artists.artist").init(argumentCollection=arguments) />
		<cfreturn artist />
	</cffunction>

	<cffunction name="getartist" access="public" output="false" returntype="artist">
		<cfargument name="artist" type="com.withcs.artists.artist" required="false" />
		
		<cfset variables.artistDAO.read(artist) />
		<cfreturn artist />
	</cffunction>

	<cffunction name="getartists" access="public" output="false" returntype="array">
		<cfargument name="ARTISTID" type="string" required="false" />
		<cfargument name="FIRSTNAME" type="string" required="false" />
		<cfargument name="LASTNAME" type="string" required="false" />
		<cfargument name="ADDRESS" type="string" required="false" />
		<cfargument name="CITY" type="string" required="false" />
		<cfargument name="STATE" type="string" required="false" />
		<cfargument name="POSTALCODE" type="string" required="false" />
		<cfargument name="EMAIL" type="string" required="false" />
		<cfargument name="PHONE" type="string" required="false" />
		<cfargument name="FAX" type="string" required="false" />
		<cfargument name="THEPASSWORD" type="string" required="false" />
		
		<cfreturn variables.artistGateway.getByAttributes(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="saveartist" access="public" output="false" returntype="boolean">
		<cfargument name="artist" type="com.withcs.artists.artist" required="true" />

		<cfreturn variables.artistDAO.save(artist) />
	</cffunction>

	<cffunction name="deleteartist" access="public" output="false" returntype="boolean">
		
		<cfset var artist = createartist(argumentCollection=arguments) />
		<cfreturn variables.artistDAO.delete(artist) />
	</cffunction>
 </cfcomponent>