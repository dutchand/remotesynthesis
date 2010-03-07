<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
<mango:Author>
<title><mango:Blog title /></title>
	<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=<mango:Blog charset />" />
	<meta name="generator" content="Mango <mango:Blog version />" />
	<meta name="description" content="<mango:Blog description />" />
	<meta name="robots" content="index, follow" />

	<link rel="alternate" type="application/atom+xml" title="Atom" href="<mango:Blog atomurl />" />
	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<mango:Blog rssurl />" />	
	<link rel="EditURI" type="application/rsd+xml" title="RSD" href="<mango:Blog apiurl />" />
	
	<link rel="stylesheet" type="text/css" href="<mango:Blog skinurl />assets/styles/style.css" />
	
	<script language="javascript" src="<mango:Blog skinurl />sleight.js"></script>
<mango:Event name="beforeHtmlHeadEnd" />
</head>
<body>
<mango:Event name="beforeHtmlBodyStart" />
<div align="center">
	<div id="bg-top" align="left">
		<div id="sadrzaj-top">
			<div id="zaglavlje">
			
				<div id="title">
					<a href="<mango:Blog url />"><img src="<mango:Blog skinurl />/assets/images/logo_trans.png" alt="Remote Synthesis" border="0" /></a>
				</div>
				
				<div style="margin-top:10px;">
				<form action="<mango:Blog searchUrl />" method="post" onSubmit="return(this.search.value.length != 0)">
					Search my blog: <input name="term" type="text" size="15" />
					<input type="submit" value="Go" name="go" class="button" />
				</form>
				</div>
			</div>
		</div>
	</div>
	<div id="bg-mid" align="left">
		<div id="sadrzaj-mid">
			<div id="navigacija">
				<ul>
					<li><a href="<mango:Blog basePath />">blog</a></li>
					<li><a href="<mango:Blog basePath />pages/about.cfm">about me</a></li>
				<mango:Pages><mango:Page>
					<li><a href="<mango:PageProperty link>" title="<mango:PageProperty title />"><mango:PageProperty title /></a></li></mango:Page></mango:Pages>
					<li><a href="<mango:Blog basePath />cfopensourcelist">cf open source list</a></li>
				</ul>
				<mango:Event name="afterSideBarStart" number="1" />
				<!-- secondary content start -->
				<mangox:PodGroup locationId="sidebar" template="index">
					<template:sidebar />
				</mangox:PodGroup>	
				<!-- secondary content end -->
				<mango:Event name="beforeSideBarEnd" number="1" />

			</div>
			<div id="content">
			<!-- primary content start -->
			<h3>About <mango:AuthorProperty name /></h3>
			<div class="content">
				<mango:AuthorProperty description />
			</div>
			<!-- primary content end -->
			</div>
		</div>
	</div>
	<div id="bg-bot" align="left">
		<div id="sadrzaj-bot" align="center">
			
			<div id="footer">
			Copyright &copy; 2008 RemoteSynthesis.com
			</div>
		</div>
	</div>
</div>
</mango:Author>
<mango:Event name="beforeHtmlBodyEnd" />
</body>
</html>