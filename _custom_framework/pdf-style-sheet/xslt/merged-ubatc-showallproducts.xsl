<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="rootmap" select="/"></xsl:param>
    
    <!-- Match the root element and create the map element -->
    <xsl:template match="ph[@keyref='product_name']">
      	<!-- <ol> -->
        	<xsl:for-each select="text">
    	      <!-- <li><xsl:value-of select="."/></li> -->
        	    <p outputclass="coverpage_tradename  uppercase reducedlinespacing"  class="coverpage_tradename  uppercase reducedlinespacing"><xsl:value-of select="."/></p>
        	</xsl:for-each>
        <!-- </ol> -->
    </xsl:template>
</xsl:stylesheet>
