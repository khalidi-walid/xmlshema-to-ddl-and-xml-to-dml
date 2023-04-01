<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  version="1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:output method="text" omit-xml-declaration="yes" />

    <xsl:variable name="contents" select="/|document(//xs:include/@schemaLocation)" />
    <xsl:variable name="complexTypes" select="$contents//xs:complexType[@name]" />

    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="/" >
        <xsl:for-each select="$contents" >
           <xsl:apply-templates select=".//xs:schema//xs:element" />
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="xs:element">
        <xsl:variable name="complexType" select="xs:complexType[not(@name)]" />
        <xsl:if test="$complexType">
            <xsl:variable name="fields" select="$complexType/xs:sequence/xs:element[not(@type=$complexTypes/@name)]|$complexType/xs:attribute|$complexType/xs:simpleContent|$complexType/xs:simpleContent/xs:extension/xs:attribute" />
            <xsl:if test="$fields">
                <xsl:variable name="tableName" select="@name" />
                <xsl:variable name="generatedKey" select="concat($tableName, '_id')" />
                <xsl:text>CREATE TABLE </xsl:text>
                <xsl:value-of select="$tableName" />    
                <xsl:text> (</xsl:text>
                <xsl:value-of select="$generatedKey"/>
                <xsl:text > intger PRIMARY KEY, </xsl:text>
                <xsl:variable name="ancestorTables" select="ancestor::xs:element[@name][xs:complexType[xs:sequence[xs:element[@type]] or xs:attribute[@type]]] | $contents//xs:element[@type=current()/child::*/@name]" />
                <xsl:if test="$ancestorTables">
                    <xsl:variable name="foreignKey" select="concat( $ancestorTables[1]/@name, '_id' )" />
                    <xsl:value-of select="$foreignKey" />
                    <xsl:text> intger</xsl:text>
                    <xsl:text> CONSTRAINT FK_</xsl:text>
                    <xsl:value-of select="concat($ancestorTables[1]/@name, '_id')" />
                    <xsl:text> FOREIGN KEY REFERENCES </xsl:text>
                    <xsl:value-of select="$ancestorTables[1]/@name" />
                    <xsl:text> ( </xsl:text>
                    <xsl:value-of select="$foreignKey" />
                    <xsl:text> ) </xsl:text>
                </xsl:if>
                <xsl:for-each select="$fields[not(@type=$complexTypes/@name)]">
                    <xsl:choose>
                        <xsl:when test="@name">
                            <xsl:value-of select="@name" />
                        </xsl:when>
                        <xsl:when test="local-name()='simpleContent'">
                            <xsl:value-of select="concat(parent::*/@name,'_Text')" />
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="@type">
                            <xsl:call-template name="Types">
                                <xsl:with-param name="type" select="@type" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="Types">
                                <xsl:with-param name="type" select="xs:extension/@base" />
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="@minOccurs=0"> NULL</xsl:if>
                    <xsl:if test="position()&lt;last()">, </xsl:if>
                </xsl:for-each>
                <xsl:text> );|</xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template name="Types">
        <xsl:param name="type" />
        <xsl:choose>
            <xsl:when test="substring-after($type,':')='int'"> intger</xsl:when>
                <xsl:when test="substring-after($type, ':')='string'"> varchar<xsl:if test="local-name()!='restriction'">(255)</xsl:if>
            </xsl:when>
            <xsl:when test="substring-after($type,':')='date'"> date</xsl:when>
            <xsl:when test="substring-after($type,':')='boolean'"> boolean</xsl:when>
            <xsl:when test="substring-after($type,':')='decimal'"> decimal</xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$contents//xs:simpleType[@name=$type]" mode="derivedType" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
