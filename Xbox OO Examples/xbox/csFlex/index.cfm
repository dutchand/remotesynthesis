<!--- 
	this service should be a singleton and in application scope
	in your application. this would be in onApplictionStart() in application.cfc
 --->
<cfset props = structNew() />
<cfset props.dsn = "xbox" />
<cfset application.factory= createObject("component","coldspring.beans.DefaultXmlBeanFactory").init(defaultProperties=props)/>
<cfset application.factory.loadBeansFromXmlFile(expandPath("/csFlex/config/services.xml"),true)/>
<cfset application.factory.getBean("consoleService_remote") />

<!-- saved from url=(0014)about:internet -->
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
</head>

<body scroll="no" style="margin:0;padding:0">
<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
		id="main" width="100%" height="100%"
		codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
		<param name="movie" value="main.swf" />
		<param name="quality" value="high" />
		<param name="bgcolor" value="#869ca7" />
		<param name="allowScriptAccess" value="sameDomain" />
		<embed src="main.swf" quality="high" bgcolor="#869ca7"
			width="100%" height="100%" name="main" align="middle"
			play="true"
			loop="false"
			quality="high"
			allowScriptAccess="sameDomain"
			type="application/x-shockwave-flash"
			pluginspage="http://www.adobe.com/go/getflashplayer">
		</embed>
</object>
</body>
</html>