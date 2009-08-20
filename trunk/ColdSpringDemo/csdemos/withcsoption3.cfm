<cfset properties = StructNew() />  
<cfset properties.dsn = "cfartgallery" />
<cfset beanFactory = CreateObject('component', 'coldspring.beans.DefaultXmlBeanFactory').init(defaultProperties=properties) />  
<cfset beanFactory.loadBeans('/config/coldspring-option3.xml') />  

<cfset artGalleryService = beanFactory.getBean("artGalleryService") />
<cfset art = createObject("component","com.withcsoption2.art.art").init(url.artid) />
<cfset artGalleryService.getart(art) />