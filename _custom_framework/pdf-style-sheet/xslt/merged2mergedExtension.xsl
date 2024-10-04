<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func dita-ot xs ot-placeholder"
    version="2.0">
    
    <!--
    Match only top level tables (i.e tables that are not nested in other tables),
    that contains some footnotes.
  -->
    <xsl:template match="*[contains(@class, 'topic/table')]
        [not(ancestor::*[contains(@class, 'topic/table')])]
        [//*[contains(@class, 'topic/fn')]]">
        <xsl:next-match>
            <xsl:with-param name="top-level-table" select="." tunnel="yes"/>
        </xsl:next-match>
        <!-- Create a list with all the footnotes from the current table. -->
        <ol class="- topic/ol " outputclass="table-fn-container">
            <xsl:for-each select=".//*[contains(@class, 'topic/fn')]">
                <!--
          Try to preserve the footnote ID, if available, so that the xrefs will have a target.
        -->
                <li class="- topic/li " id="{if(@id) then @id else generate-id(.)}"
                    outputclass="table-fn">
                    <xsl:apply-templates select="node()"/>
                </li>
            </xsl:for-each>
        </ol>
    </xsl:template>
    
    <!-- 
    The footnotes that have an ID must be ignored, they are accessible only 
    through existing xrefs (already present in the merged.xml file).
    
    The above template already made a copy of these footnotes in the OL element
    so it is not a problem if markup is not generated for them in the cell.
  -->
    <xsl:template
        match="*[contains(@class, 'topic/entry')]//*[contains(@class, 'topic/fn')][@id]"/>
    
    <!--
    The xrefs to footnotes with IDs inside table-cells. We need to recalculate
    their indexes if their referenced footnote is also in the table.
  -->
    <xsl:template match="*[contains(@class, 'topic/xref')][@type='fn']
        [ancestor::*[contains(@class, 'topic/entry')]]">
        <xsl:param name="top-level-table" tunnel="yes"/>
        <xsl:variable name="destination" select="opentopic-func:getDestinationId(@href)"/>
        <xsl:variable name="fn" select="
            $top-level-table//*[contains(@class, 'topic/fn')][@id = $destination]"/>
        <xsl:choose>
            <xsl:when test="$fn">
                <!-- There is a reference in the table, recalculate index. -->
                <xsl:variable name="fn-number" select="
                    index-of($top-level-table//*[contains(@class, 'topic/fn')], $fn)"/>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="node() except *[contains(@class, 'hi-d/sup')]"/>
                    <sup>
                        <xsl:apply-templates select="child::*[contains(@class, 'hi-d/sup')]/@*"/>
                        <xsl:value-of select="$fn-number"/>
                    </sup>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <!-- There is no reference in the table, keep original index. -->
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
    The footnotes without ID inside table-cells. They are copied in the OL element, but have 
    no xrefs pointing to them (because they have no ID), so xrefs are generated. 
  -->
    <xsl:template
        match="*[contains(@class, 'topic/entry')]//*[contains(@class, 'topic/fn')][not(@id)]">
        <!-- Determine the footnote index in the document order. -->
        <xsl:param name="top-level-table" tunnel="yes"/>
        <xsl:variable name="fn-number" select="
            index-of($top-level-table//*[contains(@class, 'topic/fn')], .)"/>
        <xref type="fn" class="- topic/xref "
            href="#{generate-id(.)}" outputclass="table-fn-call">
            <!-- Generate an extra <sup>, identical to what DITA-OT generates for other xrefs. -->
            <sup class="+ topic/ph hi-d/sup ">
                <xsl:value-of select="$fn-number"/>
            </sup>
        </xref>
    </xsl:template>
    
    <!-- Customisation pour afficher la liste de tous les produits couverts pat l'ATG dans la page de couverture du document -->
    <!-- Match the root element and create the map element -->
    <xsl:template 
        match="ph[@keyref='product_name']">
        <ol>
        <xsl:for-each select="//keydef[@keys='product_name']/topicmeta/keywords/keyword">
            <li><xsl:value-of select="."/></li>
            <!-- <p outputclass="coverpage_name uppercase reducedlinespacing"><b><xsl:value-of select="."/></b></p> -->
        </xsl:for-each>
        </ol>
    </xsl:template>
    
</xsl:stylesheet>