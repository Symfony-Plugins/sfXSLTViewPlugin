<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="xsl php" xmlns:php="http://php.net/xsl">

<xsl:output 
		omit-xml-declaration="yes"
		indent="yes" />

<xsl:decimal-format
	name="currencyformat"/>

<!--This is your main template-->

<xsl:template name="HeaderWrapper">
	<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
               "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"&gt;
	</xsl:text>
<html>
	<head>
    	<title>Display Video</title>
    </head>
	<body>
    	<div id="container">
    		<xsl:apply-templates select="XML"/>
    		<div id="stripTop"><xsl:text> </xsl:text></div>
        	<div id="VideoFooter"><xsl:text> </xsl:text></div>
        	<xsl:text> </xsl:text>
	    </div>
	</body>
</html>
</xsl:template>

</xsl:stylesheet>