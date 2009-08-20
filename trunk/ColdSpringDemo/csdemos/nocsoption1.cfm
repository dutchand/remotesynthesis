<cfset artGalleryService = createObject("component","com.nocs.artGalleryServiceOption1").init("cfartgallery") />
<cfset art = createObject("component","com.nocs.art.art").init(url.artid) />
<cfset artGalleryService.getart(art) />