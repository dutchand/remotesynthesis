<cfcomponent output="false">
	<cffunction name="init" access="public" output="false" returntype="com.withcsoption2.artGalleryService">
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setArtDAO" access="public" output="false" returntype="void">
		<cfargument name="artDAO" type="com.withcsoption2.art.artDAO" required="true" />
		
		<cfset variables.artDAO = arguments.artDAO />
	</cffunction>
	
	<cffunction name="setArtGateway" access="public" output="false" returntype="void">
		<cfargument name="artGateway" type="com.withcsoption2.art.artGateway" required="true" />
		
		<cfset variables.artGateway = artGateway />
	</cffunction>
	
	<cffunction name="setArtistDAO" access="public" output="false" returntype="void">
		<cfargument name="artistDAO" type="com.withcsoption2.artists.artistDAO" required="true" />
		
		<cfset variables.artistDAO = artistDAO />
	</cffunction>
	
	<cffunction name="setArtistGateway" access="public" output="false" returntype="void">
		<cfargument name="artistGateway" type="com.withcsoption2.artists.artistGateway" required="true" />
		
		<cfset variables.artistGateway = artistGateway />
	</cffunction>
	
	<cffunction name="createart" access="public" output="false" returntype="com.withcsoption2.art.art">
		<cfargument name="ARTID" type="string" required="false" />
		<cfargument name="ARTISTID" type="string" required="false" />
		<cfargument name="ARTNAME" type="string" required="false" />
		<cfargument name="DESCRIPTION" type="string" required="false" />
		<cfargument name="PRICE" type="numeric" required="false" />
		<cfargument name="LARGEIMAGE" type="string" required="false" />
		<cfargument name="MEDIAID" type="string" required="false" />
		<cfargument name="ISSOLD" type="numeric" required="false" />
			
		<cfset var art = createObject("component","com.withcsoption2.art.art").init(argumentCollection=arguments) />
		
		<cfif len(arguments.artistID)>
			<cfset artist = createObject("component","com.withcsoption2.artists.artist").init(artistID=arguments.artistID) />
			<cfset art.setArtist(getartist(artist)) />
		</cfif>
		
		<cfreturn art />
	</cffunction>

	<cffunction name="getart" access="public" output="false" returntype="com.withcsoption2.art.art">
		<cfargument name="art" type="com.withcsoption2.art.art" required="false" />
		
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
		<cfargument name="art" type="com.withcsoption2.art.art" required="true" />

		<cfreturn variables.artDAO.save(art) />
	</cffunction>

	<cffunction name="deleteart" access="public" output="false" returntype="boolean">
		
		<cfset var art = createart(argumentCollection=arguments) />
		<cfreturn variables.artDAO.delete(art) />
	</cffunction>
	
	<cffunction name="createartist" access="public" output="false" returntype="com.withcsoption2.artists.artist">
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
		
			
		<cfset var artist = createObject("component","com.withcsoption2.artists.artist").init(argumentCollection=arguments) />
		<cfreturn artist />
	</cffunction>

	<cffunction name="getartist" access="public" output="false" returntype="artist">
		<cfargument name="artist" type="com.withcsoption2.artists.artist" required="false" />
		
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
		<cfargument name="artist" type="com.withcsoption2.artists.artist" required="true" />

		<cfreturn variables.artistDAO.save(artist) />
	</cffunction>

	<cffunction name="deleteartist" access="public" output="false" returntype="boolean">
		
		<cfset var artist = createartist(argumentCollection=arguments) />
		<cfreturn variables.artistDAO.delete(artist) />
	</cffunction>
 </cfcomponent>