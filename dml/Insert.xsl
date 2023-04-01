<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
<xsl:template match="/">
        <xsl:for-each select="node()">
            <xsl:for-each select="*">
                INSERT INTO  <xsl:value-of select="name(..)"/>.<xsl:value-of select="name(.)"/> VALUES (
                    <xsl:for-each select="*">
                                <xsl:value-of select="."/>
                                <xsl:if test="position() != last()" >, </xsl:if>
                    </xsl:for-each>
            )</xsl:for-each>
        </xsl:for-each>
</xsl:template>
</xsl:stylesheet>
