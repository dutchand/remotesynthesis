<cfset dsn = "cfartgallery" />
<cfset artistDAO = createObject("component","com.nocs.artists.artistDAO").init(dsn) />
<!--- the artistDAO isn't actually used below, this is for example purposes --->
<cfset artDAO = createObject("component","com.nocs.art.artDAO").init(dsn,artistDAO) />
<cfset artGateway = createObject("component","com.nocs.art.artGateway").init(dsn) />
<cfset artistGateway = createObject("component","com.nocs.artists.artistGateway").init(dsn) />
<cfset artGalleryService = createObject("component","com.nocs.artGalleryServiceOption2").init(artDAO,artGateway,artistDAO,artistGateway) />
<cfset art = createObject("component","com.nocs.art.art").init(url.artid) />
<cfset artGalleryService.getart(art) />