<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output method="text"></xsl:output>
    <xsl:template match="/">0
        <xsl:text>INSERT INTO </xsl:text>
        <xsl:value-of select="name(/*)"/>
        <xsl:text> VALUES ( </xsl:text>
        <xsl:for-each select="//@*">
            <xsl:value-of select="."/>
            <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="*/*[count(child::*) = 0] ">
            <xsl:value-of select="."/>
            <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>);|</xsl:text><br/>
        <xsl:for-each select="*/*[count(child::*) > 0]">
            <xsl:text>INSERT INTO </xsl:text>
            <xsl:value-of select="name(.)"/>
            <xsl:text> VALUES ( </xsl:text>
            <xsl:for-each select="@*">
                <xsl:value-of select="."/>
                <xsl:text>, </xsl:text>
            </xsl:for-each>
            <xsl:for-each select="*">
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text> );|&#10;</xsl:text>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>