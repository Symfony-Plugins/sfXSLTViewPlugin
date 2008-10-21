<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="xsl php" xmlns:php="http://php.net/xsl">

<xsl:output method="xml" 
			omit-xml-declaration="yes"
			indent="yes"
			encoding="utf-8"/>

<xsl:include href="layout.xsl"/>

<!-- start the stylesheet -->
<xsl:template match="/">
	<xsl:call-template name="HeaderWrapper"/>
</xsl:template>

<!-- xml tempate -->
<xsl:template match="XML">
	
	<div id="headerVideo">
	    <img src="/uploads/logos/{Job/client_logo}" alt="{Job/companyname}" />
    </div>
        
    <div id="video">
    	<xsl:apply-templates select="Videofiles/Videofile">
        	<xsl:with-param name="JobID" select="Job/id" />
        	<xsl:with-param name="VideoTitle" select="Job/video_title" />
        </xsl:apply-templates>
        <div style="clear:left">Client: <xsl:value-of select="Job/client_name" /></div>
		<div>Information: <xsl:value-of select="Job/client_info" /></div>
	</div>
	
</xsl:template>

<!--Video file template-->
<xsl:template match="Videofile">
	<xsl:param name="JobID"/>
	<xsl:param name="VideoTitle"/>
	<xsl:variable name="position" select="position()-1"/>
	<div style="margin-left:40px;margin-right:40px;">
		<object type="application/x-shockwave-flash" data="/player_flv_maxi.swf" width="320" height="240">
			<param name="movie" value="/player_flv_maxi.swf" />
    		<param name="allowFullScreen" value="true" />
    		<param name="FlashVars" value="flv=/video/showvid/jobid/{$JobID}/position/{$position}&amp;title={$VideoTitle}&amp;autoload=1&amp;volume=75" />
		</object>
	</div>
</xsl:template>

</xsl:stylesheet>