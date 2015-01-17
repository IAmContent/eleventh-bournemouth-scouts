<?xml version="1.0"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    version="2.0">
    <xsl:output method="xhtml" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

    <xsl:param name="renderer-version">0.1</xsl:param>
    <xsl:param name="output-dir" />
    <xsl:param name="base-url">http://www.11thbournemouth.org.uk/</xsl:param>

    <xsl:template match="web-site">
        <html>
            <body>
                <table>
                    <tr>
                        <th>Renderer version:</th>
                        <td><xsl:value-of select="$renderer-version"/></td>
                    </tr>
                    <tr>
                        <th>Time Rendered:</th>
                        <td><xsl:value-of select="fn:current-dateTime()"/></td>
                    </tr>
                </table>
            </body>
        </html>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="page">
        <xsl:variable name="file-name"><xsl:value-of select="@id"/>.html</xsl:variable>
        <xsl:variable name="page-url"><xsl:value-of select="$base-url"/><xsl:value-of select="$file-name"/></xsl:variable>

        <xsl:result-document method="xhtml" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes"
            href="{$output-dir}{$file-name}">

            <html xmlns="http://www.w3.org/1999/xhtml" lang="en-GB">
                <head>

                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

                    <title>11th Bournemouth Scout Group</title>
                    <link rel="stylesheet" href="scouting.css" type="text/css" media="screen" />
                    <link rel="stylesheet" href="custom.css" type="text/css" media="screen" />
                    <link rel="icon" href="images/favicon.ico?v=1" />
                    <link rel="shortcut icon" href="images/favicon.ico?v=1" />

                </head>
                <body>
                    <xsl:call-template name="head" />
                    <div id="page" class="clearfloat">
                        <div id="content">
                            <xsl:call-template name="breadcrumbs" />
                            <xsl:call-template name="content" />
                        </div>
                        <xsl:call-template name="sidebar">
                            <xsl:with-param name="page-url" select="$page-url"/>
                        </xsl:call-template>
                    </div>
                    <xsl:call-template name="footer" />
                </body>
            </html>
        </xsl:result-document>
        <xsl:apply-templates select="page" />
    </xsl:template>

    <xsl:template name="head">
        <div id="head">
            <xsl:call-template name="banner" />
            <xsl:call-template name="navbar" />
        </div>
    </xsl:template>

    <xsl:template name="banner">
        <div>
            <div id="logo" class="left">
                <h1 class="name">
                    <nobr>
                        11<sup>th</sup> Bournemouth Scout Group
                    </nobr>
                </h1>
                <h1 class="desc">Scouting provides fun, challenge and adventure to over 400,000 girls and
                    boys across the UK
                </h1>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="navbar">
        <div id="navbar" class="clearfloat">
            <ul id="page-bar" class="left clearfloat">
                <xsl:for-each select="/web-site/page">
                    <li>
                        <xsl:attribute name="class">
                            <xsl:text>page_item</xsl:text>
                            <xsl:if test="position()!=1">
                                <xsl:text> page-item-2</xsl:text>
                            </xsl:if>
                            <xsl:if test="page">
                                <xsl:text> page_item_has_children</xsl:text>
                            </xsl:if>
                        </xsl:attribute>
                        <xsl:call-template name="page-link"/>
                        <xsl:if test="page">
                            <ul class='children'>
                                <xsl:for-each select="page">
                                    <li class="page_item">
                                        <xsl:call-template name="page-link"/>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </xsl:if>
                    </li>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>

    <xsl:template name="breadcrumbs">
        <span class="breadcrumbs">
            <xsl:for-each select="/web-site/page[1]">
                <xsl:call-template name="page-link"/>
            </xsl:for-each>
            <xsl:if test="generate-id(.)!=generate-id(/web-site/page[1])">
                <xsl:for-each select="ancestor-or-self::page">
                    >
                    <xsl:call-template name="page-link"/>
                </xsl:for-each>
            </xsl:if>
        </span>
        <p />
    </xsl:template>

    <xsl:template name="page-link">
        <a href="{@id}.html">
            <xsl:value-of select="@name" />
        </a>
    </xsl:template>

    <xsl:template name="content">
        <h3 class="title">
            <xsl:apply-templates select="title/node()" />
        </h3>
        <xsl:apply-templates select="content/node()" />
    </xsl:template>

    <xsl:template name="sidebar">
        <xsl:param name="page-url"/>
        <div id="sidebar">
            <div id="tools">
                <h3>Share this page</h3>
                <a href="#" onclick="window.print();return false;">
                    <img src="images/print_icon.jpg" />
                    Print this page
                </a>
                <br />
                <a
                    href="mailto:type_email_address_here?subject=11th%20Bournemouth%20Scout%20Group&amp;body={@name}: {$page-url}"
                    target="_blank">
                    <img src="images/email_16.png" />
                    Email a friend
                </a>
                <br />
                <a href="http://www.facebook.com/sharer.php?u={$page-url}&amp;t={@name}"
                    target="_blank">
                    <img src="images/facebook_16.png" />
                    Share on Facebook
                </a>
                <br />
                <a href="http://twitter.com/home?status={@name}: {$page-url}" target="_blank">
                    <img src="images/twitter_16.png" />
                    Share on Twitter
                </a>
            </div>
            <div>
                <img src="images/neckie.gif" title="11th Bournemouth Neck Scarf" width="170px" height="40" />
            </div>
        </div>
    </xsl:template>

    <xsl:template name="footer">
        <div id="footer">
            <div id="footerall">
                <div id="ceop">
                    <a href="http://www.ceop.gov.uk/">
                        <img src="images/CEOPReportBtn.gif" />
                    </a>
                </div>
                <div id="footer1">
                    <a href="index.html">Home</a>
                    <br />
                    <a href="contact.html">Contact us</a>
                </div>
                <div class="center">
                    <img src="images/banner468x60-option-2.gif" alt="" width="468" height="60" />
                </div>
                <div id="copyright">
                    © 11
                    <sup>th</sup>
                    Bournemouth Scout Group, all rights reserved.
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="@*|node()" name="copy-through">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
