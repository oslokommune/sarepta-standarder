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
	
	
	<!-- Visning av innhold i Notater -->
	<xsl:template name="Notater">
		<xsl:for-each select="child::*[local-name()=&quot;GenereltJournalnotat&quot;]">
			<xsl:call-template name="GenereltJournalnotat"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Generelt journalnotat -->
	<xsl:template name="GenereltJournalnotat">
		<xsl:for-each select="child::*[local-name()=&quot;Journaltekst&quot;]">
			<tr>
				<xsl:call-template name="Journaltekst"><xsl:with-param name="antKolonner" select="0"/></xsl:call-template>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Journaltekst -->
	<xsl:template name="Journaltekst">
		<xsl:param name="antKolonner"/>
		<xsl:if test="child::*[local-name()=&quot;Overskriftskode&quot;]">
			<th>
				<xsl:for-each select="child::*[local-name()=&quot;Overskriftskode&quot;]">
					<xsl:choose>
						<xsl:when test="contains(@S, '9141')"><xsl:call-template name="k-9141"/>&#160;</xsl:when>
						<xsl:when test="contains(@S, '9142')"><xsl:call-template name="k-9142"/>&#160;</xsl:when>
						<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
			</th>
		</xsl:if>
		<td width="{((($std-col)-number($antKolonner)-count(child::*[local-name()=&quot;Overskriftskode&quot;])-1)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-number($antKolonner)-count(child::*[local-name()=&quot;Overskriftskode&quot;])-1)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1}">
			<xsl:call-template name="line-breaks">
				<xsl:with-param name="text" select="child::*[local-name()=&quot;Notat&quot;]"/>
			</xsl:call-template><br/>
		</td>
		<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
			<th>Merknad</th>
			<td width="{(($std-col)-($antKolonner)-count(child::*[local-name()=&quot;Overskriftskode&quot;])-2)*$std-td}px" colspan="{($std-col)-($antKolonner)-count(child::*[local-name()=&quot;Overskriftskode&quot;])-2}">
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
				</xsl:call-template><br/>
			</td>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
