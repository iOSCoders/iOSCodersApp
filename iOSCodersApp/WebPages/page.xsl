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
        <!-- <meta http-equiv="refresh" content="-1"/> -->
        <link rel="stylesheet" href="xslstyle.css" type="text/css" />
      </head>
      <script src="jquery.min.js"/>
      <body>
        <xsl:for-each select="root/title">
          <h2>
            <xsl:apply-templates/>
          </h2>
        </xsl:for-each>
        <xsl:for-each select="root/subject">
          <div class="heading">
            <xsl:attribute name="collapsed">
              <xsl:value-of select="@collapsed"/>
            </xsl:attribute>
            <xsl:value-of select="@name"/>
          </div>
          <xsl:for-each select="node">
            <div class="sub-heading">
              <xsl:value-of select="@name"/>
            </div>
            <xsl:apply-templates/>
          </xsl:for-each>
        </xsl:for-each>
        <div>
	      <xsl:element name="a">
	        <xsl:attribute="href">update.xml</xsl:attribute>Update.xml
	      </xsl:element>
        </div>
        <script src="fmt.js"/>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="content">
    <div class="content">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="ci">
    <dd>
      <span>
        <input type="checkbox" checked="checked"/>
        <xsl:value-of select="."/>
      </span>
    </dd>
  </xsl:template>
  <xsl:template match="ui">
    <dd>
      <input type="checkbox"/>
      <xsl:value-of select="."/>
    </dd>
  </xsl:template>
  <xsl:template match="site">
    <a href="http://www.meetup.com/IOS-Coders/">iOS Coders Meet Up</a>
  </xsl:template>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
