<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"    
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:php="http://php.net/xsl"
	exclude-result-prefixes="xsl php">

<xsl:output omit-xml-declaration="yes"	indent="yes" />

<xsl:variable name="start_html_comment">&#60;!--</xsl:variable>

<xsl:variable name="end_html_comment">--&#62;</xsl:variable>

  <xsl:template match="/">
  	<xsl:call-template name="NoWrapper"/>
  </xsl:template>
  
  <xsl:template name="NoWrapper">
<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"&gt;
</xsl:text>
<html>
<head>


<link rel="shortcut icon" href="/favicon.ico" />

<xsl:value-of select="$start_html_comment" disable-output-escaping="yes"/>[if lt IE 7.]<xsl:value-of select="'&gt;'" disable-output-escaping="yes"/>
	<link rel="stylesheet" type="text/css" media="screen" href="/sf/sf_default/css/ie.css" />
<xsl:value-of select="'&lt;'" disable-output-escaping="yes"/>![endif]<xsl:value-of select="$end_html_comment"  disable-output-escaping="yes"/>

<link rel="stylesheet" type="text/css" media="screen" href="/sf/sf_default/css/screen.css" />
</head>
<body>
<div class="sfTContainer">
	<a href="http://www.symfony-project.com/"><img alt="symfony PHP Framework" class="sfTLogo" src="/sf/sf_default/images/sfTLogo.png" height="39" width="186" /></a>
	<div class="sfTMessageContainer sfTAlert"> 
  <img alt="page not found" class="sfTMessageIcon" src="/sf/sf_default/images/icons/cancel48.png" height="48" width="48" />  <div class="sfTMessageWrap">
    <h1>Oops! Page Not Found</h1>

    <h5>The server returned a 404 response.</h5>
  </div>
</div>
<dl class="sfTMessageInfo">
  <dt>Did you type the URL?</dt>
  <dd>You may have typed the address (URL) incorrectly. Check it to make sure you've got the exact right spelling, capitalization, etc.</dd>

  <dt>Did you follow a link from somewhere else at this site?</dt>

  <dd>If you reached this page from another part of this site, please email us at <a href="mailto:[email]">[email]</a> so we can correct our mistake.</dd>

  <dt>Did you follow a link from another site?</dt>
  <dd>Links from other sites can sometimes be outdated or misspelled. Email us at <a href="mailto:[email]">[email]</a> where you came from and we can try to contact the other site in order to fix the problem.</dd>

  <dt>What's next</dt>
  <dd>
    <ul class="sfTIconList">
      <li class="sfTLinkMessage"><a href="javascript:history.go(-1)">Back to previous page</a></li>
      <li class="sfTLinkMessage"><a href="/index.php/">Go to Homepage</a></li>
    </ul>
  </dd>

</dl>
</div>
</body>
</html>
  </xsl:template>
	
</xsl:stylesheet>
