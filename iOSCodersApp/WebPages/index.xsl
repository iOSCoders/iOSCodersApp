<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:template match="/">
    <html>
      <head>
        <title>
          <xsl:for-each select="root/title">
            <xsl:apply-templates/>
          </xsl:for-each>
        </title>
        <meta http-equiv="cache-control" content="no-cache" />
        <link rel="stylesheet" href="xslstyle.css" type="text/css" />
      </head>
      <body>
        <xsl:for-each select="root/item|root/download">
          <p>
            <xsl:element name="a">
              <xsl:attribute name="href"><xsl:value-of select="."/>.xml</xsl:attribute>
              <xsl:value-of select="."/>
            </xsl:element>
          </p>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
