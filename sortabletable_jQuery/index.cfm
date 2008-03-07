<cfquery name="getProjects" datasource="dsn">
	SELECT TOP 50 * FROM opensourceresource
</cfquery>
<html>
	<head>
	
	</head>
	<body>
<cf_sortabletable jsPath="jquery/" query="#getProjects#">
    <cf_sortablecolumn column="title" title="Project Name" />
    <cf_sortablecolumn column="clickCount" title="Clicks" sort="desc" />
    <cf_sortablecolumn column="dateAdded" title="Date Added" format="dateFormat(dateAdded,'mmm dd, yyyy ') & timeFormat(dateAdded,'h:mm tt')" />
    <cf_sortablecolumn disable="true" pre="<a href='#CGI.SCRIPT_NAME#?id={resourceid}&clicks={clickCount}'>edit</a>" />
</cf_sortabletable>
	</body>
</html>