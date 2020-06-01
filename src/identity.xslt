<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:lab9="urn:1LAB9fJYvmL9FUQREiUc2Rz7weVCm42qBs">
	<xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
	
	<xsl:template match="lab9:*" priority="2">
  		<xsl:element name="{local-name()}">
    			<xsl:apply-templates select="node()|@*" />
  		</xsl:element>
	</xsl:template>

	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
