<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:epj1="http://www.kith.no/xmlstds/epj/epj1/2008-02-20" xmlns:epj2="http://www.kith.no/xmlstds/epj/epj2/2008-02-20" exclude-result-prefixes="epj1 epj2">

	<!-- Inngår i Hdirs visningsfiler versjon 1.0
		Laget i XMLSpy v2012 rel2 (http://www.altova.com) av Jan Sigurd Dragsjø (helsedirektoratet.no) -->
	<!-- Variabel for standard antall kolonner i tabellene-->
	<xsl:variable name="std-col" select="8"/>
	<!-- Visning av innhold i Generelt journalnotat -->
	<xsl:template match="epj2:GenereltJournalnotat">
		<xsl:for-each select="epj2:Journaltekst">
			<tr>
				<xsl:apply-templates select="." mode="utenRad"><xsl:with-param name="antKolonner" select="0"/></xsl:apply-templates>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Journaltekst -->
	<xsl:template match="epj2:Journaltekst" mode="utenRad">
		<xsl:param name="antKolonner"/>
		<xsl:if test="epj2:Overskriftskode">
			<th>
				<xsl:for-each select="epj2:Overskriftskode">
					<xsl:choose>
						<xsl:when test="contains(@S, '9141')">
							<xsl:call-template name="k-9141"/>
						</xsl:when>
						<xsl:when test="contains(@S, '9142')">
							<xsl:call-template name="k-9142"/>
						</xsl:when>
						<xsl:when test="@DN">
							<xsl:value-of select="@DN"/>
						</xsl:when>
						<xsl:when test="@OT">
							<xsl:value-of select="@OT"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@V"/>
						</xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
			</th>
		</xsl:if>
		<td colspan="{(($std-col)-number($antKolonner)-count(epj2:Overskriftskode)-1)*number(not(epj2:Merknad))+1}">
			<xsl:call-template name="line-breaks">
				<xsl:with-param name="text" select="epj2:Notat"/>
			</xsl:call-template><br/>
		</td>
		<xsl:if test="epj2:Merknad">
			<th>Merknad</th>
			<td colspan="{(($std-col)-($antKolonner)-count(epj2:Overskriftskode)-2)}">
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="epj2:Merknad"/>
				</xsl:call-template><br/>
			</td>
		</xsl:if>
	</xsl:template>
	<!-- Kodeverk -->
	<xsl:template name="k-9141">
		<xsl:choose>
			<xsl:when test="@V='1'">Innkomststatus</xsl:when>
			<xsl:when test="@V='7'">Sykepleiediagnose</xsl:when>
			<xsl:when test="@V='8'">Sykepleiesammenfatning</xsl:when>
			<xsl:when test="@V='12'">Status&#160;ved&#160;utskrivning</xsl:when>
			<xsl:when test="@V='13'">Pasientens&#160;egne&#160;vurderinger</xsl:when>
			<xsl:when test="@V='14'">Praktiske&#160;opplysninger</xsl:when>
			<xsl:when test="@V='88'">Annet</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9142">
		<xsl:choose>
			<xsl:when test="@V='PROB'">Aktuell&#160;problemstilling</xsl:when>
			<xsl:when test="@V='FO'">Forløp&#160;og&#160;behandling</xsl:when>
			<xsl:when test="@V='FU'">Funn&#160;og&#160;undersøkelsesresultat</xsl:when>
			<xsl:when test="@V='FA'">Familie/sosialt</xsl:when>
			<xsl:when test="@V='SYKM'">Sykmelding</xsl:when>
			<xsl:when test="@V='VU'">Vurdering</xsl:when>
			<xsl:when test="@V='UTRED'">Forventet/ønsket undersøkelser/behandling</xsl:when>
			<xsl:when test="@V='HJ'">Funksjonsnivå/hjelpetiltak</xsl:when>
			<xsl:when test="@V='IP'">Informasjon&#160;til pasient/pårørende</xsl:when>
			<xsl:when test="@V='TS'">Tidligere&#160;sykdommer</xsl:when>
			<xsl:when test="@V='OP'">Planer&#160;for videre&#160;oppfølging</xsl:when>
			<xsl:when test="@V='AAI'">Årsak&#160;til innleggelse</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
