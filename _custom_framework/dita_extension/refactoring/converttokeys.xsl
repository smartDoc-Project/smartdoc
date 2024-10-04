<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="xml" 
        indent="yes" 
        doctype-public="-//OASIS//DTD DITA Map//EN" 
        doctype-system="map.dtd"/>
  
    
    <!-- Match the root element and create the map element -->
    <xsl:template match="/">
        <xsl:variable name="reference"><xsl:value-of select="/document/reference"/></xsl:variable>
         <xsl:result-document href="keys-{$reference}.ditamap">
        <map>
            <title><xsl:value-of select="$reference"/></title>
            <xsl:apply-templates select="*"/>
        </map>
         </xsl:result-document>
    </xsl:template>
    
    <!-- Template to generate unique IDs for elements with non-empty text values -->
    <xsl:template match="*[text()[normalize-space()]]">
        <xsl:variable name="ancestors">
            <xsl:for-each select="ancestor-or-self::*">
                <xsl:value-of select="name()"/>
                <xsl:if test="position() != last()">.</xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <keydef>
            <xsl:attribute name="keys">
                <xsl:value-of select="lower-case($ancestors)"/>
            </xsl:attribute>
            <topicmeta>
                <keywords>
                    <keyword>
                        <xsl:value-of select="." disable-output-escaping="yes"/>
                    </keyword>
                </keywords>
            </topicmeta>
        </keydef>
    </xsl:template>
</xsl:stylesheet>
