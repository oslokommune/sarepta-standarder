<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:epj1="http://www.kith.no/xmlstds/epj/epj1/2008-02-20" xmlns:epj2="http://www.kith.no/xmlstds/epj/epj2/2008-02-20" exclude-result-prefixes="epj1 epj2">

	<!-- Inngår i Hdirs visningsfiler versjon 1.0
		Laget i XMLSpy v2012 rel2 (http://www.altova.com) av Jan Sigurd Dragsjø (helsedirektoratet.no) -->
	<!-- Variabel for standard antall kolonner i tabellene-->
	<xsl:variable name="std-col" select="8"/>
	<!-- Visning av innhold i Cave -->
	<xsl:template match="epj1:Cave">
		<xsl:variable name="antCave">
			<xsl:choose>
				<xsl:when test="count(.//epj1:StikkordCave) = 0">1</xsl:when>
				<xsl:otherwise><xsl:value-of select="count(.//epj1:StikkordCave)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select=".//epj1:StikkordCave">
			<tr>
				<xsl:if test="position()=1">
					<th rowspan="{($antCave)}">Cave</th>
				</xsl:if>
				<td colspan="{(($std-col)-2)*number(not(epj2:Journaltekst))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="epj1:CaveStikkord"/>
					</xsl:call-template>
				</td>
				<xsl:apply-templates select="epj2:Journaltekst" mode="utenRad"><xsl:with-param name="antKolonner" select="2"/></xsl:apply-templates>
			</tr>
		</xsl:for-each>
		<xsl:apply-templates select="epj1:Allerginotat"/>
	</xsl:template>
	<!-- Visning av innhold i Allerginotat -->
	<xsl:template match="epj1:Allerginotat">
		<xsl:variable name="kolonnefyll" select="number(boolean(epj1:Allergi/epj1:VirkestoffLegemiddel | epj1:Allergi/epj1:KodeAnnetStoff))"/>
		<xsl:variable name="antNotat">
			<xsl:choose>
				<xsl:when test="count(.//epj2:Journaltekst) = 0">1</xsl:when>
				<xsl:otherwise>count(.//epj2:Journaltekst)</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr>
			<xsl:for-each select="epj1:Allergi">
				<th rowspan="{$antNotat}">Allergisk&#160;mot:&#160;<xsl:value-of select="epj1:AllergiskMot"/>&#160;</th>
				<xsl:if test="epj1:VirkestoffLegemiddel or epj1:KodeAnnetStoff">
					<td rowspan="{$antNotat}">
						<xsl:if test="epj1:VirkestoffLegemiddel">
							<div>
								<b>ATC:</b>&#160;
								<xsl:for-each select="epj1:VirkestoffLegemiddel">
									<xsl:choose>
										<xsl:when test="@DN">
											<xsl:value-of select="@DN"/>
										</xsl:when>
										<xsl:when test="@OT">
											<xsl:value-of select="@OT"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@V"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>&#160;
							</div>
						</xsl:if>
						<xsl:if test="epj1:KodeAnnetStoff">
							<div>
								<b>Stoff:</b>&#160;
								<xsl:for-each select="epj1:KodeAnnetStoff">
									<xsl:choose>
										<xsl:when test="@DN">
											<xsl:value-of select="@DN"/>
										</xsl:when>
										<xsl:when test="@OT">
											<xsl:value-of select="@OT"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@V"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>&#160;
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				<td rowspan="{$antNotat}" colspan="{(($std-col)-2-$kolonnefyll)*number(not(../epj2:Journaltekst))+1}">
					<xsl:if test="epj1:HensynVedForskrivning='true' or epj1:HensynMatDrikke='true'">
						Ta&#160;hensyn&#160;<xsl:if test="epj1:HensynVedForskrivning='true'">ved&#160;forskrivning<xsl:if test="epj1:HensynMatDrikke='true'">&#160;og </xsl:if></xsl:if>
						<xsl:if test="epj1:HensynMatDrikke='true'">i&#160;forbindelse&#160;med&#160;mat&#160;og&#160;drikke</xsl:if>
					</xsl:if>
					<xsl:if test="epj1:Kontaktallergi='true' or epj1:PollenInnsektstikk='true'">
						<div>
							Gjelder&#160;ved&#160;<xsl:if test="epj1:Kontaktallergi='true'">kontakt<xsl:if test="epj1:PollenInnsektstikk='true'">&#160;og </xsl:if></xsl:if>
							<xsl:if test="epj1:PollenInnsektstikk='true'">insektstikk,&#160;pollen&#160;eller&#160;lignende</xsl:if>
						</div>
					</xsl:if>
					<xsl:if test="epj1:AnafylaktiskeReaksjoner">
						<div>Har&#160;hatt&#160;anafylaktiske&#160;reaksjoner:&#160;
							<xsl:choose>
								<xsl:when test="epj1:AnafylaktiskeReaksjoner/@DN">
									<xsl:value-of select="epj1:AnafylaktiskeReaksjoner/@DN"/>&#160;
								</xsl:when>
								<xsl:when test="epj1:AnafylaktiskeReaksjoner/@V">
									<xsl:for-each select="epj1:AnafylaktiskeReaksjoner">
										<xsl:call-template name="k-1103"/>&#160;
									</xsl:for-each>
								</xsl:when>
							</xsl:choose>
						</div>
					</xsl:if>
				</td>
			</xsl:for-each>
			<xsl:for-each select="epj2:Journaltekst">
				<xsl:if test="position()=1">
					<xsl:apply-templates select="." mode="utenRad"><xsl:with-param name="antKolonner" select="2+$kolonnefyll"/></xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
		</tr>
		<xsl:for-each select="epj2:Journaltekst">
			<xsl:if test="position()!=1">
				<tr>
					<xsl:apply-templates select="." mode="utenRad"><xsl:with-param name="antKolonner" select="2+$kolonnefyll"/></xsl:apply-templates>
				</tr>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- Kodeverk -->
	<xsl:template name="k-1103">
		<xsl:choose>
			<xsl:when test="@V='1'">Ja</xsl:when>
			<xsl:when test="@V='2'">Nei</xsl:when>
			<xsl:when test="@V='9'">Ukjent</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
