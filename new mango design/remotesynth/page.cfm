<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<mango:Page>
<title><mango:PageProperty title /> | <mango:Blog title /></title>
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
		<mango:Pages parentPage=""><mango:Page>
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
		<div class="content">
			<div class="content-top">
				<div class="content-date">
					<cfoutput><span style="font-size:11px;">#dateFormat(now(),"mmm dd")#</span><br />#year(now())#</cfoutput>
				</div>
				<div align="center" class="comment-count">
					<mango:PageProperty commentCount />
				</div>
			</div>
			<div class="content-mid">
				<div class="content-inner">
					<span class="content-header"><mango:PageProperty title /></span>
					<mango:PageProperty body />
			<mango:PageProperty ifcommentsallowed>
					<p style="font-size:18px;color:#F4F243;">...........................................................................................................</p>
					<mango:PostProperty ifCommentCountLT="1">
					<p style="font-size:13px;color:#F4F243;">There are currently no comments for this entry.</p>
					</mango:PostProperty>
				<mango:PostProperty ifCommentCountGT="0">
					<mango:Comments>
						<mango:Comment>
					<mango:CommentProperty ifIsAuthor><blockquote style="margin-right:0px;"></mango:CommentProperty>
					<div id="comment">
						<div class="gravatar">
							<div class="gravatar-inner">
							<mangox:Gravatar size="40" defaultimg="assets/images/nogravatar.png" />
							</div>
						</div>
						<div class="comment-left<mango:CommentProperty ifIsAuthor>-author</mango:CommentProperty>">
						</div>
						<div class="comment-inner<mango:CommentProperty ifIsAuthor>-author</mango:CommentProperty>">
							<div class="comment-top<mango:CommentProperty ifIsAuthor>-author</mango:CommentProperty>">
							</div>
							<div class="comment-body<mango:CommentProperty ifIsAuthor>-author</mango:CommentProperty>">
							<a name="comment-<mango:CommentProperty id />"></a>
							<p><span class="comment-byline"><span class="comment-name"><mango:CommentProperty ifhasurl><a href="<mango:CommentProperty url />"></mango:CommentProperty><mango:CommentProperty name /><mango:CommentProperty ifhasurl></a></mango:CommentProperty></span> says:</span></p>
								<blockquote><mango:CommentProperty content /></blockquote>
							<p align="right" style="font-size:11px;">Posted on <mango:CommentProperty date /> at <mango:CommentProperty time /></p>
							</div>
							<div class="comment-bot<mango:CommentProperty ifIsAuthor>-author</mango:CommentProperty>">
							</div>
						</div>
					</div><br clear="left" /><br />
					<mango:CommentProperty ifIsAuthor></blockquote></mango:CommentProperty>
						</mango:Comment>
						</mango:Comments>
				</mango:PostProperty>
		</mango:PageProperty>
		<!--- todo: add comment form --->
				</div>
			</div>
			<div class="content-bot">
			</div>
		</div>
	</div>
</div>
<div id="footer">
&copy; Copyright 2010 Brian Rinaldi
</div>
</mango:Page>
<mango:Event name="beforeHtmlBodyEnd" />
</body>
</html>