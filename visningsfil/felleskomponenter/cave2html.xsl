<?xml version="1.0" encoding="UTF-8"?>
	<!-- Endringslogg
	- 04.12.15: Innføring av felles kodeverksfil. Småjusteringer på layout.
	-->
	<!-- Om
	- Inngår i Hdirs visningsfiler versjon 2.0
	- Laget i XMLSpy v2016 (http://www.altova.com) av Jan Sigurd Dragsjø (nhn.no)
	-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- Filer som må importeres. Vanligvis gjøres dette i hovedfila som importerer denne komponentfila. Derfor er de kommentert ut.
	<xsl:import href="funksjoner.xsl"/> 
	<xsl:import href="kodeverk.xsl"/> -->
	
	<!-- Variabel for standard antall kolonner i tabellene-->
	<xsl:variable name="std-col" select="8"/>
	<xsl:variable name="std-td" select="100"/>
	
	<!-- Visning av innhold i Cave -->
	<xsl:template name="Cave">
		<xsl:variable name="antCave">
			<xsl:choose>
				<xsl:when test="count(.//child::*[local-name()=&quot;StikkordCave&quot;]) = 0">1</xsl:when>
				<xsl:otherwise><xsl:value-of select="count(.//child::*[local-name()=&quot;StikkordCave&quot;])"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select=".//child::*[local-name()=&quot;StikkordCave&quot;]">
			<tr>
				<xsl:if test="position()=1">
					<th rowspan="{($antCave)}">Cave</th>
				</xsl:if>
				<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;Journaltekst&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;Journaltekst&quot;]))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;CaveStikkord&quot;]"/>
					</xsl:call-template>
				</td>
				<xsl:for-each select="child::*[local-name()=&quot;Journaltekst&quot;]">
					<xsl:call-template name="Journaltekst"><xsl:with-param name="antKolonner" select="2"/></xsl:call-template>
				</xsl:for-each>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Allerginotat&quot;]">
			<xsl:call-template name="Allerginotat"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Allerginotat -->
	<xsl:template name="Allerginotat">
		<xsl:variable name="kolonnefyll" select="number(boolean(child::*[local-name()=&quot;Allergi&quot;]/child::*[local-name()=&quot;VirkestoffLegemiddel&quot;] | child::*[local-name()=&quot;Allergi&quot;]/child::*[local-name()=&quot;KodeAnnetStoff&quot;]))"/>
		<xsl:variable name="antNotat">
			<xsl:choose>
				<xsl:when test="count(.//child::*[local-name()=&quot;Journaltekst&quot;]) = 0">1</xsl:when>
				<xsl:otherwise>count(.//child::*[local-name()=&quot;Journaltekst&quot;])</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr>
			<xsl:for-each select="child::*[local-name()=&quot;Allergi&quot;]">
				<th rowspan="{$antNotat}">Allergisk&#160;mot:&#160;<xsl:value-of select="child::*[local-name()=&quot;AllergiskMot&quot;]"/>&#160;</th>
				<xsl:if test="child::*[local-name()=&quot;VirkestoffLegemiddel&quot;] or child::*[local-name()=&quot;KodeAnnetStoff&quot;]">
					<td rowspan="{$antNotat}">
						<xsl:if test="child::*[local-name()=&quot;VirkestoffLegemiddel&quot;]">
							<div>
								<b>ATC:</b>&#160;
								<xsl:for-each select="child::*[local-name()=&quot;VirkestoffLegemiddel&quot;]">
									<xsl:call-template name="k-dummy"/>&#160;
								</xsl:for-each>&#160;
							</div>
						</xsl:if>
						<xsl:if test="child::*[local-name()=&quot;KodeAnnetStoff&quot;]">
							<div>
								<b>Stoff:</b>&#160;
								<xsl:for-each select="child::*[local-name()=&quot;KodeAnnetStoff&quot;]">
									<xsl:call-template name="k-dummy"/>&#160;
								</xsl:for-each>&#160;
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				<td width="{((($std-col)-2-$kolonnefyll)*number(not(../child::*[local-name()=&quot;Journaltekst&quot;]))+1)*$std-td}px" rowspan="{$antNotat}" colspan="{(($std-col)-2-$kolonnefyll)*number(not(../child::*[local-name()=&quot;Journaltekst&quot;]))+1}">
					<xsl:if test="child::*[local-name()=&quot;HensynVedForskrivning&quot;]='true' or child::*[local-name()=&quot;HensynMatDrikke&quot;]='true'">
						Ta&#160;hensyn&#160;<xsl:if test="child::*[local-name()=&quot;HensynVedForskrivning&quot;]='true'">ved&#160;forskrivning<xsl:if test="child::*[local-name()=&quot;HensynMatDrikke&quot;]='true'">&#160;og </xsl:if></xsl:if>
						<xsl:if test="child::*[local-name()=&quot;HensynMatDrikke&quot;]='true'">i&#160;forbindelse&#160;med&#160;mat&#160;og&#160;drikke</xsl:if>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;Kontaktallergi&quot;]='true' or child::*[local-name()=&quot;PollenInnsektstikk&quot;]='true'">
						<div>
							Gjelder&#160;ved&#160;<xsl:if test="child::*[local-name()=&quot;Kontaktallergi&quot;]='true'">kontakt<xsl:if test="child::*[local-name()=&quot;PollenInnsektstikk&quot;]='true'">&#160;og </xsl:if></xsl:if>
							<xsl:if test="child::*[local-name()=&quot;PollenInnsektstikk&quot;]='true'">insektstikk,&#160;pollen&#160;eller&#160;lignende</xsl:if>
						</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;AnafylaktiskeReaksjoner&quot;]">
						<div>Har&#160;hatt&#160;anafylaktiske&#160;reaksjoner:&#160;
							<xsl:for-each select="child::*[local-name()=&quot;StikkordCave&quot;]">
								<xsl:call-template name="k-1103"/>&#160;
							</xsl:for-each>
						</div>
					</xsl:if>
				</td>
			</xsl:for-each>
			<xsl:for-each select="child::*[local-name()=&quot;Journaltekst&quot;]">
				<xsl:if test="position()=1">
					<xsl:call-template name="Journaltekst"><xsl:with-param name="antKolonner" select="2+$kolonnefyll"/></xsl:call-template>
				</xsl:if>
			</xsl:for-each>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;Journaltekst&quot;]">
			<xsl:if test="position()!=1">
				<tr>
					<xsl:call-template name="Journaltekst"><xsl:with-param name="antKolonner" select="2+$kolonnefyll"/></xsl:call-template>
				</tr>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
