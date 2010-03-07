<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<title><mango:Blog title /></title>
<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=<mango:Blog charset />" />
<meta name="generator" content="Mango <mango:Blog version />" />
<meta name="description" content="<mango:Blog description />" />
<meta name="robots" content="index, follow" />

<link rel="alternate" type="application/atom+xml" title="Atom" href="<mango:Blog atomurl />" />
<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<mango:Blog rssurl />" />	
<link rel="EditURI" type="application/rsd+xml" title="RSD" href="<mango:Blog apiurl />" />

<link rel="stylesheet" type="text/css" href="<mango:Blog skinurl />assets/styles/rs.css" />
<script type="text/javascript" src="<mango:Blog skinurl />assets/js/jquery-1.4.2.min.js"></script>
<script language="JavaScript">
$(document).ready(function() {
	$(".navitem").hover(function() {
		$(this).addClass("navitem-selected");
	},
	function() {
		$(this).removeClass("navitem-selected");
	});
});
</script>
<mango:Event name="beforeHtmlHeadEnd" />
</head>
<body>
<mango:Event name="beforeHtmlBodyStart" />
<div id="header" align="center">
	<div id="header-inner">
		
	</div>
</div>
<div id="header-bot" align="center">
</div>
<div id="nav-outer" align="center">
	<div id="nav">
		<div id="nav-inner">
			<div class="navitem">
				<a href="<mango:Blog basePath />" style="color:#233d63;text-decoration:none;">blog</a>
			</div>
			<img src="<mango:Blog skinurl />assets/images/nav-divider.png" />
		<mango:Pages><mango:Page>
			<div class="navitem">
				<a href="<mango:PageProperty link>" title="<mango:PageProperty title />" style="color:#233d63;text-decoration:none;"><mango:PageProperty title /></a>
			</div>
			<img src="<mango:Blog skinurl />assets/images/nav-divider.png" /></mango:Page></mango:Pages>
			<div id="search">
			<form action="<mango:Blog searchUrl />" method="post" onSubmit="return(this.search.value.length != 0)">
				<div style="width:160px;float:left;"><input type="text" name="search" size="20" /></div>
				<div style="width:84px;float:left;"><input type="image" name="searchSubmit" src="<mango:Blog skinurl />assets/images/search-button.png" value="search" /></div>
			</form>
			</div>
		</div>
	</div>
	<div id="main" align="left">
		<div id="sidebar-right">
			<div align="center">
			<a href="http://twitter.com/remotesynth"><img src="<mango:Blog skinurl />assets/images/twitter-button.png" alt="twitter" width="62" height="62" border="0" /></a>
			<a href="http://facebook.com/brian.rinaldi"><img src="<mango:Blog skinurl />assets/images/facebook-button.png" alt="facebook" width="62" height="62" border="0" /></a>
			<a href="<mango:blog rssurl />"><img src="<mango:Blog skinurl />assets/images/RSS-button.png" alt="twitter" width="62" height="62" border="0" /></a>
			</div>
			<mango:Event name="afterSideBarStart" number="1" />
			<!-- secondary content start -->
			<mangox:PodGroup locationId="sidebar" template="index">
				<template:sidebar />
			</mangox:PodGroup>	
			<!-- secondary content end -->
			<mango:Event name="beforeSideBarEnd" number="1" />
		</div>
<mango:Archive pageSize="5">
	<div id="archive">
	<mango:ArchiveProperty ifIsType="category"><h1>Category: <mango:ArchiveProperty title /></h1></mango:ArchiveProperty>
	<mango:ArchiveProperty ifIsType="month"><h1>Viewing by month: <mango:ArchiveProperty title dateformat="mmmm yyyy" /></h1></mango:ArchiveProperty>
	<mango:ArchiveProperty ifIsType="day"><h1>Viewing by day: <mango:ArchiveProperty title dateformat="dd mmmm yyyy" /></h1></mango:ArchiveProperty>
	<mango:ArchiveProperty ifIsType="year"><h1>Viewing by year: <mango:ArchiveProperty title dateformat="yyyy" /></h1></mango:ArchiveProperty>
	<mango:ArchiveProperty ifIsType="search"><h1>Search results for: <mango:ArchiveProperty title /></h1></mango:ArchiveProperty>
	<mango:ArchiveProperty ifIsType="author"><h1>Viewing by author: <mango:ArchiveProperty title /></h1></mango:ArchiveProperty>
	<mango:ArchiveProperty ifIsType="unknown"><h1>No archives</h1></mango:ArchiveProperty>
	</div>
	
<mango:Posts count="5">
		<mango:Post>
		<div class="content">
			<div class="content-top">
				<div class="content-date">
					<span style="font-size:11px;"><mango:PostProperty date dateformat="mmm dd" /></span><br /><mango:PostProperty date dateformat="yyyy" />
				</div>
				<div align="center" class="comment-count">
					<mango:PostProperty commentCount />
				</div>
			</div>
			<div class="content-mid">
				<div class="content-inner">
			<a class="content-header" href="<mango:PostProperty link />"><mango:PostProperty title /></a>
			<mango:PostProperty ifhasExcerpt excerpt />
			<mango:PostProperty ifnothasExcerpt body />
				<mango:PostProperty ifhasExcerpt>
				<p align="right">
				<a href="<mango:PostProperty link />">[More]</a>
				</p></mango:PostProperty>
				</div>
			</div>
			<div class="content-bot">
			</div>
		</div>
		</mango:Post>
</mango:Posts>
<p class="previous">
	<mango:ArchiveProperty ifHasNextPage><a class="previous" href="<mango:ArchiveProperty link pageDifference="1" />">&lt; Previous Entries</a></mango:ArchiveProperty> |  
	<mango:ArchiveProperty ifHasPreviousPage><a class="next" href="<mango:ArchiveProperty link pageDifference="-1" />">Next Entries &gt;</a></mango:ArchiveProperty>
</p>
		
		</mango:Archive>
	</div>
</div>
<div id="footer">
&copy; Copyright 2010 Brian Rinaldi
</div>
<mango:Event name="beforeHtmlBodyEnd" />
</body>
</html>