<?xml version="1.0" encoding="UTF-8"?>

<!-- Visningsfil for eReseptmeldingen: M2 Individuell søknad om refusjon til HELFO
	- Visningen håndterer vedlegg av en eller flere M12 Søknadssvar - Individuell søknad om refusjon til HELFO-->
<!-- Siste endring:
	- 2015-09-24: Oppdatert til siste versjon av 2.5 datert 2015-05-26. Felles kodeverksfil innført.
	- 2013-10-31: Oppdatert til å kunne håndtere Forskrivning-2013-10-08
	- 2013-08-13: Versjon for eResept v2.5
	- 2011-02-11: Første versjon -->
	
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" xmlns:fk1="http://www.kith.no/xmlstds/felleskomponent1" xmlns:m2="http://www.kith.no/xmlstds/eresept/m2/2014-12-01" xmlns:m12="http://www.kith.no/xmlstds/eresept/m12/2014-12-01" xmlns:base="http://www.kith.no/xmlstds/base64container" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="mh fk1 m2 m12 base xhtml">

	<xsl:import href="../../Felleskomponenter/meldingshode2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/funksjoner.xsl"/>
	<xsl:import href="../../Felleskomponenter/base64decoder.xsl"/>
	<xsl:import href="../../Felleskomponenter/kodeverk.xsl"/>
	
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	
	<!-- Vedlegg i denne sammenhengen er en eller flere m12-meldinger -->
	<xsl:param name="vedlegg"/>
	<xsl:variable name="antall-legemidler" select="count(//m2:OmsoktLegemiddel)"/>
	<!-- Variabel for hvilken stil visningen har. Tilgjengelige stiler er: Document, One-line-doc, No-line-doc -->
	<xsl:variable name="stil" select="'One-line-doc'"/>
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Individuell søknad om refusjon til HELFO</title>
				<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
				<style type="text/css">
					<xsl:value-of select="document('../../Felleskomponenter/KITH-visning.css')" disable-output-escaping="yes"/>
				</style>
			</head>
			<body>
				<xsl:apply-templates select="mh:MsgHead"/>
			</body>
		</html>
	</xsl:template>
	<!-- Visning av meldingshodet. Tilpasset vinduskonvolutt ved utskrift -->
	<xsl:template match="mh:MsgHead">
		<xsl:call-template name="Topp"/>
		<xsl:call-template name="Innhold"/>
		<xsl:choose>
			<!-- Inngang for å komponere egen bunn i EgetBunnTillegg nedenfor. Foreløpig hoppes den over -->
			<xsl:when test="not(1)">
				<xsl:call-template name="BunnTillegg">
					<xsl:with-param name="stil" select="$stil"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="Bunn">
					<xsl:with-param name="stil" select="$stil"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Template som kalles fra BunnTillegg i meldingshodet. Kan brukes til visning av egenkomponert bunn -->
	<xsl:template name="EgetBunnTillegg">
	</xsl:template>
	<xsl:template name="Innhold" match="m2:SoknadHelfo">
		<div class="{$stil}">
			<xsl:for-each select="//m2:SoknadHelfo">
				<h1>Individuell søknad om refusjon til HELFO</h1>
				<xsl:choose>
					<xsl:when test="$antall-legemidler=1">
						<h2>Omsøkt legemiddel</h2>
					</xsl:when>
					<xsl:when test="$antall-legemidler &gt; 1">
						<h2>Omsøkte legemidler</h2>
					</xsl:when>
				</xsl:choose>
				<xsl:for-each select="//m2:OmsoktLegemiddel">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
				<xsl:for-each select="//m2:SoknadNaringsmiddel">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
				<xsl:if test="//m2:BehRegime">
					<h2>Andre legemidler i behandlingsregimet</h2>
					<table>
						<tbody>
							<xsl:for-each select="//m2:BehRegime">
								<xsl:apply-templates select="."/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<xsl:if test="//m2:TidligereBeh">
					<xsl:if test="//m2:SoknadNaringsmiddel">
						<h2>Tidligere brukte næringsmidler</h2>
					</xsl:if>
					<xsl:if test="//m2:OmsoktLegemiddel">
						<h2>Tidligere brukte legemidler</h2>
					</xsl:if>
					<table>
						<tbody>
							<xsl:for-each select="//m2:TidligereBeh">
								<xsl:apply-templates select="."/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<table>
					<tbody>
						<tr>
							<td width="50%" style="border-style:none">
								<h2>Diagnoser</h2>
								<table>
									<tbody>
										<xsl:for-each select="m2:Diagnose">
											<tr>
												<td>
													<xsl:choose>
														<xsl:when test="contains(@S, '7434')">
															<xsl:call-template name="k-7434"/>
														</xsl:when>
														<xsl:when test="contains(@S, '7435')">
															<xsl:call-template name="k-7435"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:call-template name="k-dummy"/>
														</xsl:otherwise>
													</xsl:choose>
												</td>
											</tr>
										</xsl:for-each>
										<xsl:for-each select="m2:Bidiagnose">
											<tr>
												<td>
													<xsl:choose>
														<xsl:when test="contains(@S, '7434')">
															<xsl:call-template name="k-7434"/>
														</xsl:when>
														<xsl:when test="contains(@S, '7435')">
															<xsl:call-template name="k-7435"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:call-template name="k-dummy"/>
														</xsl:otherwise>
													</xsl:choose>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</td>
							<td width="50%" valign="top" style="border-style:none">
								<h2>Refusjon</h2>
								<table>
									<tbody>
										<xsl:for-each select="m2:RefHjemmel">
											<tr>
												<td>
													<xsl:choose>
														<xsl:when test="contains(@S, '7427')">
															<xsl:call-template name="k-7427"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:call-template name="k-dummy"/>
														</xsl:otherwise>
													</xsl:choose>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
				<h2>Relevant informasjon</h2>
				<table>
					<tbody>
						<xsl:if test="m2:Begrunnelse or m2:Merknad or //m2:Alvorlighetsgrad">
							<tr>
								<xsl:if test="m2:Begrunnelse">
									<th width="25%">Begrunnelse</th>
								</xsl:if>
								<xsl:if test="m2:Merknad">
									<th width="25%">Merknad</th>
								</xsl:if>
								<xsl:if test="//m2:Alvorlighetsgrad">
									<th width="25%">Alvorlighetsgrad</th>
								</xsl:if>
							</tr>
							<tr>
								<xsl:if test="m2:Begrunnelse">
									<td width="25%">
										<xsl:value-of select="m2:Begrunnelse"/>
									</td>
								</xsl:if>
								<xsl:if test="m2:Merknad">
									<td width="25%">
										<xsl:value-of select="m2:Merknad"/>
									</td>
								</xsl:if>
								<xsl:if test="//m2:Alvorlighetsgrad">
									<td width="25%">
										<xsl:value-of select="//m2:Alvorlighetsgrad"/>
									</td>
								</xsl:if>
							</tr>
						</xsl:if>
						<xsl:if test="m2:Soknad3a or m2:Soknad4a or m2:Vedlegg">
							<tr>
								<xsl:if test="m2:Soknad3a/m2:Refusjonskode">
									<th width="25%">Refusjonskode</th>
								</xsl:if>
								<xsl:if test="m2:Soknad3a/m2:Underterm">
									<th width="25%">Underterm til ICPC-kode</th>
								</xsl:if>
								<xsl:if test="m2:Soknad4a/m2:Genotype">
									<th width="25%">Genotype for hepatitt C-infeksjon</th>
								</xsl:if>
								<xsl:if test="m2:Soknad4a/m2:GradLeverskade">
									<th width="25%">Grad av leverskade</th>
								</xsl:if>
								<xsl:if test="m2:Vedlegg">
									<th width="25%">Referanser til vedlegg</th>
								</xsl:if>
							</tr>
							<tr>
								<xsl:if test="m2:Soknad3a/m2:Refusjonskode">
									<td width="25%">
										<xsl:for-each select="m2:Soknad3a/m2:Refusjonskode">
											<xsl:choose>
												<xsl:when test="contains(@S, '7434')">
													<xsl:call-template name="k-7434"/>
												</xsl:when>
												<xsl:when test="contains(@S, '7435')">
													<xsl:call-template name="k-7435"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="k-dummy"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</td>
								</xsl:if>
								<xsl:if test="m2:Soknad3a/m2:Underterm">
									<td width="25%">
										<xsl:value-of select="m2:Soknad3a/m2:Underterm"/>
									</td>
								</xsl:if>
								<xsl:if test="m2:Soknad4a/m2:Genotype">
									<td width="25%">
										<xsl:for-each select="m2:Soknad4a/m2:Genotype">
											<xsl:choose>
												<xsl:when test="contains(@S, '7508')">
													<xsl:call-template name="k-7508"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="k-dummy"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</td>
								</xsl:if>
								<xsl:if test="m2:Soknad4a/m2:GradLeverskade">
									<td width="25%">
										<xsl:for-each select="m2:Soknad4a/m2:GradLeverskade">
											<xsl:choose>
												<xsl:when test="contains(@S, '7509')">
													<xsl:call-template name="k-7509"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="k-dummy"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</td>
								</xsl:if>
								<xsl:if test="m2:Vedlegg">
									<td width="25%">
										<xsl:for-each select="m2:Vedlegg">
											<xsl:if test="position() != 1"><br/></xsl:if>
											<xsl:value-of select="."/>
										</xsl:for-each>
									</td>
								</xsl:if>
							</tr>
						</xsl:if>
						<xsl:if test="m2:KroniskSykdom or m2:LangvarigBeh or m2:BrukUtenforSykehus">
							<tr>
								<xsl:if test="m2:KroniskSykdom">
									<td width="25%">
										<xsl:choose>
											<xsl:when test="m2:KroniskSykdom/@V = 1">
												<input type="checkbox" disabled="disabled" checked="checked">Kronisk sykdom</input>
											</xsl:when>
											<xsl:otherwise>
												<input type="checkbox" disabled="disabled">Kronisk sykdom</input>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</xsl:if>
								<xsl:if test="m2:LangvarigBeh">
									<td width="25%">
										<xsl:choose>
											<xsl:when test="m2:LangvarigBeh/@V = 1">
												<input type="checkbox" disabled="disabled" checked="checked">Langvarig behandling</input>
											</xsl:when>
											<xsl:otherwise>
												<input type="checkbox" disabled="disabled">Langvarig behandling</input>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</xsl:if>
								<xsl:if test="m2:BrukUtenforSykehus">
									<td width="25%">
										<xsl:choose>
											<xsl:when test="m2:BrukUtenforSykehus/@V = 1">
												<input type="checkbox" disabled="disabled" checked="checked">Bruk utenfor sykehus</input>
											</xsl:when>
											<xsl:otherwise>
												<input type="checkbox" disabled="disabled">Bruk utenfor sykehus</input>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</xsl:if>
							</tr>
						</xsl:if>
						<xsl:if test="m2:SamPasient or m2:SamVedtak or m2:Forstegangs">
							<tr>
								<xsl:if test="m2:SamPasient">
									<td width="25%">
										<xsl:choose>
											<xsl:when test="m2:SamPasient/@V = 1">
												<input type="checkbox" disabled="disabled" checked="checked">Samtykke</input>
											</xsl:when>
											<xsl:otherwise>
												<input type="checkbox" disabled="disabled">Samtykke</input>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</xsl:if>
								<xsl:if test="m2:SamVedtak">
									<td width="25%">
										<xsl:choose>
											<xsl:when test="m2:SamVedtak/@V = 1">
												<input type="checkbox" disabled="disabled" checked="checked">Samtykke kopi</input>
											</xsl:when>
											<xsl:otherwise>
												<input type="checkbox" disabled="disabled">Samtykke kopi</input>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</xsl:if>
								<xsl:if test="m2:Forstegangs">
									<td width="25%">
										<xsl:choose>
											<xsl:when test="m2:Forstegangs/@V = 1">
												<input type="checkbox" disabled="disabled" checked="checked">Førstegangssøknad</input>
											</xsl:when>
											<xsl:otherwise>
												<input type="checkbox" disabled="disabled">Førstegangssøknad</input>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</xsl:if>
							</tr>
						</xsl:if>
						<xsl:if test="//m2:Yrkesskade or m2:Soknad3b">
							<tr>
								<xsl:if test="//m2:Yrkesskade/m2:Vedtak">
									<td width="25%">
										<xsl:choose>
											<xsl:when test="//m2:Yrkesskade/m2:Vedtak/@V = 1">
												<input type="checkbox" disabled="disabled" checked="checked">Har&#160;vedtak&#160;om&#160;yrkesskade</input>
											</xsl:when>
											<xsl:otherwise>
												<input type="checkbox" disabled="disabled">Har&#160;vedtak&#160;om&#160;yrkesskade</input>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</xsl:if>
								<xsl:if test="//m2:Yrkesskade/m2:Arsak">
									<td width="25%">
										<xsl:choose>
											<xsl:when test="//m2:Yrkesskade/m2:Arsak/@V = 1">
												<input type="checkbox" disabled="disabled" checked="checked">Yrkesskade&#160;årsak&#160;til&#160;behandlingsbehovet</input>
											</xsl:when>
											<xsl:otherwise>
												<input type="checkbox" disabled="disabled">Yrkesskade&#160;årsak&#160;til&#160;behandlingsbehovet</input>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</xsl:if>
								<xsl:if test="m2:Soknad3b/m2:SjeldenSykdom">
									<td width="25%">
										<xsl:choose>
											<xsl:when test="m2:Soknad3b/m2:SjeldenSykdom/@V = 1">
												<input type="checkbox" disabled="disabled" checked="checked">Sjelden&#160;sykdom</input>
											</xsl:when>
											<xsl:otherwise>
												<input type="checkbox" disabled="disabled">Sjelden&#160;sykdom</input>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</xsl:if>
							</tr>
						</xsl:if>
					</tbody>
				</table>
				<xsl:if test="m2:Instituert or m2:Institueringstidspunkt">
					<h2>Instituert av</h2>
					<table>
						<tbody>
							<tr>
								<xsl:if test="m2:Instituert">
									<th width="25%">Navn</th>
								</xsl:if>
								<xsl:if test="m2:Institueringstidspunkt">
									<th width="25%">Institueringstidspunkt</th>
								</xsl:if>
							</tr>
							<tr>
								<xsl:if test="m2:Instituert">
									<td width="25%">
										<xsl:if test="m2:Instituert/m2:Helseperson">
											<xsl:value-of select="m2:Instituert/m2:Helseperson/m2:Fornavn"/>&#160;<xsl:value-of select="m2:Instituert/m2:Helseperson/m2:Etternavn"/>
											<xsl:if test="m2:Instituert/m2:Organisasjon/m2:Inst">&#160;&#160;</xsl:if>
										</xsl:if>
										<xsl:if test="m2:Instituert/m2:Organisasjon/m2:Inst">
											<xsl:value-of select="m2:Instituert/m2:Organisasjon/m2:Inst"/>&#160;<xsl:value-of select="m2:Instituert/m2:Organisasjon/m2:Dept"/>
										</xsl:if>
									</td>
								</xsl:if>
								<xsl:if test="m2:Institueringstidspunkt">
									<td width="25%">
										<xsl:value-of select="m2:Institueringstidspunkt"/>
									</td>
								</xsl:if>
							</tr>
						</tbody>
					</table>
				</xsl:if>
				<xsl:if test="string-length($vedlegg) != 0">
					<xsl:apply-templates select="$vedlegg//m12:Soknadssvar"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:apply-templates select="//m12:Soknadssvar"/>
			<xsl:for-each select="//mh:RefDoc[mh:MsgType/@V='A' and not(.//m12:Soknadssvar)]">
				<xsl:if test="position()=1">
					<h2>Vedlegg</h2>
				</xsl:if>			
				<table>
					<tbody>
						<xsl:if test="mh:Content or mh:FileReference">
							<xsl:choose>
								<xsl:when test="contains(mh:MimeType,'plain') or contains(mh:MimeType,'text') or contains(mh:MimeType,'xml')">
									<tr>
										<th>Tekst</th>
										<xsl:choose>
											<xsl:when test="mh:FileReference">
												<td>
													<a>
														<xsl:attribute name="href"><xsl:value-of select="mh:FileReference"/></xsl:attribute>Filreferanse
													</a>
												</td>
											</xsl:when>
											<xsl:when test="mh:Content">
												<td>
													<xsl:choose>
														<xsl:when test="mh:Content/base:Base64Container">
															<xsl:call-template name="convertBase64ToAscii">
																<xsl:with-param name="base64String" select="mh:Content/base:Base64Container"/>
															</xsl:call-template>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="mh:Content"/>
														</xsl:otherwise>
													</xsl:choose>
												</td>
											</xsl:when>
										</xsl:choose>
									</tr>
								</xsl:when>
								<xsl:when test="contains(mh:MimeType,'image')">
									<tr>
										<th>Bilde</th>
										<xsl:choose>
											<xsl:when test="mh:FileReference">
												<td>
													<img>
														<xsl:attribute name="src"><xsl:value-of select="mh:FileReference"/></xsl:attribute>
														<xsl:attribute name="alt">Bilde fra ekstern URL</xsl:attribute>
													</img>
												</td>
											</xsl:when>
											<xsl:when test="mh:Content">
												<td>
													<xsl:choose>
														<xsl:when test="mh:Content/base:Base64Container">
															<img>
																<xsl:attribute name="src"><xsl:value-of select="concat('data:',mh:MimeType,';base64,',mh:Content/base:Base64Container)"/></xsl:attribute>
																<xsl:attribute name="alt">Bilde vedlagt som base64-kode</xsl:attribute>
															</img>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="mh:Content"/>
														</xsl:otherwise>
													</xsl:choose>
												</td>
											</xsl:when>
										</xsl:choose>
									</tr>
								</xsl:when>
								<xsl:when test="contains(mh:MimeType,'pdf')">
									<tr>
										<th>PDF</th>
										<xsl:choose>
											<xsl:when test="mh:FileReference">
												<td>
													<object>
														<xsl:attribute name="data"><xsl:value-of select="concat(mh:FileReference,'&#35;view&#61;FitH&#38;toolbar&#61;1')"/></xsl:attribute>
														<xsl:attribute name="type">application/pdf</xsl:attribute>
														<xsl:attribute name="width">100%</xsl:attribute>
														<xsl:attribute name="height">500px</xsl:attribute>
													</object>
												</td>
											</xsl:when>
											<xsl:when test="mh:Content">
												<td>
													<xsl:choose>
														<xsl:when test="mh:Content/base:Base64Container">
															<object>
																<xsl:attribute name="data"><xsl:value-of select="concat('data:application/pdf;base64,',mh:Content/base:Base64Container)"/></xsl:attribute>
																<xsl:attribute name="type">application/pdf</xsl:attribute>
																<xsl:attribute name="width">100%</xsl:attribute>
																<xsl:attribute name="height">500px</xsl:attribute>
															</object>
															<p> <!-- Denne paragrafen blir aktivert når pdf-visningen feiler - f.eks. med InternetExplorer -->
																<b>Visning av vedlagte pdf-fil feilet.</b><br/>
																Vanligste årsak er bruk av Internet Explorer, eller manglende plug-in.
															</p>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="mh:Content"/>
														</xsl:otherwise>
													</xsl:choose>
												</td>
											</xsl:when>
										</xsl:choose>
									</tr>
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<th>Uhåndterbar mimetype</th>
											<!--<xsl:choose>
												<xsl:when test="mh:Content">
													<xsl:value-of select="mh:Content"/>
												</xsl:when>
												<xsl:when test="mh:FileReference">
													<xsl:value-of select="mh:FileReference"/>
												</xsl:when>
											</xsl:choose> -->
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:if test="mh:MsgType or mh:Id or mh:IssueDate or mh:MimeType or mh:Compression">
							<tr>
								<th>Metadata</th>
								<td colspan="3">
									<xsl:if test="mh:MsgType">
										<b>Meldingstype&#160;</b><xsl:value-of select="mh:MsgType/@DN"/>&#160;
									</xsl:if>
									<xsl:if test="mh:Id">
										<b>Id:&#160;</b><xsl:value-of select="mh:Id"/>&#160;
									</xsl:if>
									<xsl:if test="mh:IssueDate">
										<b>Utstedt-dato:&#160;</b><xsl:call-template name="skrivUtDateTime"><xsl:with-param name="oppgittTid" select="mh:IssueDate/@V"/></xsl:call-template>&#160;
									</xsl:if>
									<xsl:if test="mh:MimeType">
										<b>Mimetype:&#160;</b><xsl:value-of select="mh:MimeType"/>&#160;
									</xsl:if>
									<xsl:if test="mh:Compression">
										<b>Komprimering:&#160;</b><xsl:value-of select="mh:Compression/@DN"/>&#160;
									</xsl:if>
									<xsl:if test="mh:Description">
										<b>Beskrivelse:&#160;</b>
										<xsl:call-template name="line-breaks">
											<xsl:with-param name="text" select="mh:Description"/>
										</xsl:call-template>&#160;
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
					</tbody>
				</table>
			</xsl:for-each>
		</div>
	</xsl:template>
	<xsl:template match="m2:OmsoktLegemiddel">
		<xsl:variable name="refId">
			<xsl:choose>
				<xsl:when test="$antall-legemidler=1">
					<xsl:value-of select="/.//mh:MsgId"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="m2:Uuid"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<table>
			<tbody>
				<xsl:if test="m2:ForskrivningB64 or ../m2:IngenTidlBeh or string-length($vedlegg) != 0">
					<xsl:variable name="konvertertBase64">
						<xsl:call-template name="convertBase64ToAscii">
							<xsl:with-param name="base64String" select="m2:ForskrivningB64"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="m2:ForskrivningB64 and contains($konvertertBase64, 'Legemiddelblanding')">
							<xsl:if test="not(preceding-sibling::m2:OmsoktLegemiddel)">
								<tr>
									<xsl:call-template name="fellesLegemiddelTopp">
										<xsl:with-param name="konvertertBase64" select="$konvertertBase64"/>
									</xsl:call-template>
									<xsl:call-template name="fellesLegemiddelAvsluttningTopp"/>
								</tr>
							</xsl:if>
							<tr>
								<xsl:call-template name="fellesLegemiddelBunn">
									<xsl:with-param name="konvertertBase64" select="$konvertertBase64"/>
								</xsl:call-template>
								<xsl:call-template name="fellesLegemiddelAvsluttningBunn">
									<xsl:with-param name="refId" select="$refId"/>
								</xsl:call-template>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="not(preceding-sibling::m2:OmsoktLegemiddel)">
								<tr>
									<xsl:call-template name="fellesLegemiddelKortTopp">
										<xsl:with-param name="konvertertBase64" select="$konvertertBase64"/>
									</xsl:call-template>
									<xsl:call-template name="fellesLegemiddelAvsluttningTopp"/>
								</tr>
							</xsl:if>
							<tr>
								<xsl:call-template name="fellesLegemiddelKortBunn">
									<xsl:with-param name="konvertertBase64" select="$konvertertBase64"/>
								</xsl:call-template>
								<xsl:call-template name="fellesLegemiddelAvsluttningBunn">
									<xsl:with-param name="refId" select="$refId"/>
								</xsl:call-template>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</tbody>
		</table>
		<xsl:if test="not(following-sibling::m2:OmsoktLegemiddel)">
			<p/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="m2:BehRegime">
		<table>
			<tbody>
				<xsl:for-each select="m2:ForskrivningB64">
					<xsl:variable name="konvertertBase64">
						<xsl:call-template name="convertBase64ToAscii">
							<xsl:with-param name="base64String" select="."/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="contains($konvertertBase64, 'Legemiddelblanding')">
							<xsl:if test="position() = 1">
								<tr>
									<xsl:call-template name="fellesLegemiddelTopp">
										<xsl:with-param name="konvertertBase64" select="$konvertertBase64"/>
									</xsl:call-template>
								</tr>
							</xsl:if>
							<tr>
								<xsl:call-template name="fellesLegemiddelBunn">
									<xsl:with-param name="konvertertBase64" select="$konvertertBase64"/>
								</xsl:call-template>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="position() = 1">
								<tr>
									<xsl:call-template name="fellesLegemiddelKortTopp">
										<xsl:with-param name="konvertertBase64" select="$konvertertBase64"/>
									</xsl:call-template>
								</tr>
							</xsl:if>
							<tr>
								<xsl:call-template name="fellesLegemiddelKortBunn">
									<xsl:with-param name="konvertertBase64" select="$konvertertBase64"/>
								</xsl:call-template>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</tbody>
		</table>
		<xsl:if test="not(following-sibling::m2:BehRegime)">
			<p/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="m2:SoknadNaringsmiddel">
		<h2>Omsøkt næringsmiddel</h2>
		<xsl:variable name="refId" select="/.//mh:MsgId"/>
		<table>
			<tbody>
				<xsl:if test="m2:Produktgruppe/@DN or m2:Varenavn or string-length($vedlegg) != 0">
					<tr>
						<xsl:if test="m2:Produktgruppe/@DN">
							<th width="25%">Produktgruppe</th>
						</xsl:if>
						<xsl:if test="m2:Varenavn">
							<th width="25%">Varenavn</th>
						</xsl:if>
						<xsl:if test="string-length($vedlegg) != 0">
							<th width="25%">Søknadssvar</th>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="m2:Produktgruppe/@DN">
							<td width="25%">
								<xsl:value-of select="m2:Produktgruppe/@DN"/>
							</td>
						</xsl:if>
						<xsl:if test="m2:Varenavn">
							<td width="25%">
								<xsl:value-of select="m2:Varenavn"/>
							</td>
						</xsl:if>
						<xsl:if test="string-length($vedlegg) != 0">
							<td width="25%">
								<xsl:choose>
									<xsl:when test="count($vedlegg//m12:Soknadssvar) != 0">
										<xsl:choose>
											<xsl:when test="count($vedlegg//m12:Soknadssvar[$refId = m12:RefSoknad]) != 0">
												<xsl:value-of select="$vedlegg//m12:Soknadssvar[$refId = m12:RefSoknad]/m12:Beslutning/@DN"/>
											</xsl:when>
											<xsl:otherwise>
											Mangler vedlagt søknadssvar med samsvarende referanse
										</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
									Mangler vedlagt søknadssvar
								</xsl:otherwise>
								</xsl:choose>
							</td>
						</xsl:if>
					</tr>
				</xsl:if>
				<xsl:if test="m2:Beskrivelse">
					<tr>
						<th width="25%">Beskrivelse</th>
					</tr>
					<tr>
						<td width="25%">
							<xsl:value-of select="m2:Beskrivelse"/>
						</td>
					</tr>
				</xsl:if>
			</tbody>
		</table>
		<p/>
	</xsl:template>
	<xsl:template match="m2:TidligereBeh">
		<xsl:if test="m2:Varenavn or m2:Beskrivelse">
			<xsl:if test="not(preceding-sibling::m2:TidligereBeh)">
				<tr>
					<xsl:if test="m2:Varenavn">
						<th width="25%">Varenavn</th>
					</xsl:if>
					<xsl:if test="m2:Beskrivelse">
						<th width="25%">Beskrivelse</th>
					</xsl:if>
				</tr>
			</xsl:if>
			<tr>
				<xsl:if test="m2:Varenavn">
					<td width="25%">
						<xsl:value-of select="m2:Varenavn"/>
					</td>
				</xsl:if>
				<xsl:if test="m2:Beskrivelse">
					<td width="25%">
						<xsl:value-of select="m2:Beskrivelse"/>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="m2:ForskrivningB64 or m2:SarligeGrunner">
			<xsl:variable name="konvertertBase64">
				<xsl:call-template name="convertBase64ToAscii">
					<xsl:with-param name="base64String" select="m2:ForskrivningB64"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="not(preceding-sibling::m2:TidligereBeh)">
				<tr>
					<xsl:if test="m2:ForskrivningB64 and contains($konvertertBase64, 'NavnFormStyrke')">
						<th width="25%">NavnFormStyrke</th>
					</xsl:if>
					<xsl:if test="m2:SarligeGrunner/@DN">
						<th width="25%">Særlige grunner</th>
					</xsl:if>
				</tr>
			</xsl:if>
			<tr>
				<xsl:if test="m2:ForskrivningB64 and contains($konvertertBase64, 'NavnFormStyrke')">
					<td width="25%">
						<xsl:value-of select="substring-after(substring-before($konvertertBase64, '&lt;/NavnFormStyrke&gt;'),'&lt;NavnFormStyrke&gt;')"/>
					</td>
				</xsl:if>
				<xsl:if test="m2:SarligeGrunner/@DN">
					<td width="25%">
						<xsl:value-of select="m2:SarligeGrunner/@DN"/>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
	</xsl:template>
	<xsl:template match="m12:Soknadssvar">
		<h2>M12 - Søknadssvar</h2>
		<table>
			<tbody>
				<xsl:if test="m12:OmsoktVare or m12:Begrunnelse">
					<tr>
						<xsl:if test="m12:OmsoktVare">
							<th width="25%">Omsøkt vare</th>
						</xsl:if>
						<xsl:if test="m12:Begrunnelse">
							<th width="25%">Begrunnelse</th>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="m12:OmsoktVare">
							<td width="25%">
								<xsl:value-of select="m12:OmsoktVare"/>
							</td>
						</xsl:if>
						<xsl:if test="m12:Begrunnelse">
							<td width="25%">
								<xsl:value-of select="m12:Begrunnelse"/>
							</td>
						</xsl:if>
					</tr>
				</xsl:if>
				<xsl:if test="m12:Beslutning or m12:Avslagsgrunn or m12:Vedtaksdato">
					<tr>
						<xsl:if test="m12:Beslutning">
							<th width="25%">Beslutning</th>
						</xsl:if>
						<xsl:if test="m12:Avslagsgrunn">
							<th width="25%">Avslagsgrunn</th>
						</xsl:if>
						<xsl:if test="m12:Vedtaksdato">
							<th width="25%">Vedtaksdato</th>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="m12:Beslutning">
							<td width="25%">
								<xsl:for-each select="m12:Beslutning">
									<xsl:call-template name="k-7482"/>
								</xsl:for-each>
							</td>
						</xsl:if>
						<xsl:if test="m12:Avslagsgrunn">
							<td width="25%">
								<xsl:for-each select="m12:Avslagsgrunn">
									<xsl:if test="position() != 1"><br/></xsl:if>
									<xsl:call-template name="k-7481"/>
								</xsl:for-each>
							</td>
						</xsl:if>
						<xsl:if test="m12:Vedtaksdato">
							<td width="25%">
								<xsl:value-of select="m12:Vedtaksdato"/>
							</td>
						</xsl:if>
					</tr>
				</xsl:if>
				<xsl:for-each select="m12:VedtaketOmfatter">
					<tr>
						<td>
							<h2>Vedtaket omfatter</h2>
						</td>
					</tr>
					<xsl:if test="m12:Varenavn or m12:ProdGruppe or m12:DoseDognMaks">
						<tr>
							<xsl:if test="m12:Varenavn">
								<th width="25%">Varenavn</th>
							</xsl:if>
							<xsl:if test="m12:ProdGruppe">
								<th width="25%">Gruppe</th>
							</xsl:if>
							<xsl:if test="m12:DoseDognMaks">
								<th width="25%">Maks døgndose</th>
							</xsl:if>
						</tr>
						<tr>
							<xsl:if test="m12:Varenavn">
								<td width="25%">
									<xsl:value-of select="m12:Varenavn"/>
								</td>
							</xsl:if>
							<xsl:if test="m12:ProdGruppe">
								<td width="25%">
									<xsl:for-each select="m12:ProdGruppe">
										<xsl:if test="position() != 1"><br/></xsl:if>
										<xsl:choose>
											<xsl:when test="contains(@S, '7403')">
												<xsl:call-template name="k-7403"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="k-dummy"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</td>
							</xsl:if>
							<xsl:if test="m12:DoseDognMaks">
								<td width="25%">
									<xsl:value-of select="m12:DoseDognMaks/@V"/>&#160;<xsl:value-of select="m12:DoseDognMaks/@U"/>
								</td>
							</xsl:if>
						</tr>
					</xsl:if>
					<xsl:if test="m12:RefHjemmel or m12:RefKode or m12:GyldigTil">
						<tr>
							<xsl:if test="m12:RefHjemmel">
								<th width="25%">Refusjonshjemmel</th>
							</xsl:if>
							<xsl:if test="m12:RefKode">
								<th width="25%">Ref.kode</th>
							</xsl:if>
							<xsl:if test="m12:GyldigTil">
								<th width="25%">Gyldig til</th>
							</xsl:if>
						</tr>
						<tr>
							<xsl:if test="m12:RefHjemmel">
								<td width="25%">
									<xsl:for-each select="m12:RefHjemmel">
										<xsl:if test="position() != 1"><br/></xsl:if>
										<xsl:choose>
											<xsl:when test="contains(@S, '7427')">
												<xsl:call-template name="k-7427"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="k-dummy"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</td>
							</xsl:if>
							<xsl:if test="m12:RefKode">
								<td width="25%">
									<xsl:for-each select="m12:RefKode">
										<xsl:if test="position() != 1"><br/></xsl:if>
										<xsl:choose>
											<xsl:when test="contains(@S, '7434')">
												<xsl:call-template name="k-7434"/>
											</xsl:when>
											<xsl:when test="contains(@S, '7435')">
												<xsl:call-template name="k-7435"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="k-dummy"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</td>
							</xsl:if>
							<xsl:if test="m12:GyldigTil">
								<td width="25%">
									<xsl:value-of select="m12:GyldigTil"/>
								</td>
							</xsl:if>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
	<!-- Felles templates -->
	<xsl:template name="fellesLegemiddelTopp">
		<xsl:param name="konvertertBase64"/>
		<xsl:if test="string-length($konvertertBase64) != 0 and contains($konvertertBase64, 'Navn')">
			<th width="20%">Navn</th>
		</xsl:if>
		<xsl:if test="string-length($konvertertBase64) != 0 and contains($konvertertBase64, 'TilbOppl')">
			<th width="20%">Tilberedning</th>
		</xsl:if>
		<xsl:if test="string-length($konvertertBase64) != 0 and contains($konvertertBase64, 'Legemiddelform')">
			<th width="20%">Legemiddelform</th>
		</xsl:if>
		<xsl:if test="string-length($konvertertBase64) != 0 and (contains($konvertertBase64, 'BestanddelLegemiddel') or contains($konvertertBase64, 'BestanddelAnnet') or contains($konvertertBase64, 'BestanddelVirkestoff'))">
			<th width="20%">Bestanddel</th>
		</xsl:if>
	</xsl:template>
	<xsl:template name="fellesLegemiddelKortTopp">
		<xsl:param name="konvertertBase64"/>
		<xsl:if test="string-length($konvertertBase64) != 0 and contains($konvertertBase64, 'Reseptgruppe')">
			<th width="25%">Reseptgruppe</th>
		</xsl:if>
		<xsl:if test="string-length($konvertertBase64) != 0 and contains($konvertertBase64, 'NavnFormStyrke')">
			<th width="25%">NavnFormStyrke</th>
		</xsl:if>
	</xsl:template>
	<xsl:template name="fellesLegemiddelAvsluttningTopp">
		<xsl:if test="../m2:IngenTidlBeh">
			<th>Årsak til at forhåndsgodkjenning ikke er forsøkt</th>
		</xsl:if>
		<xsl:if test="string-length($vedlegg) != 0">
			<th>Søknadssvar</th>
		</xsl:if>
	</xsl:template>
	<xsl:template name="fellesLegemiddelBunn">
		<xsl:param name="konvertertBase64"/>
		<xsl:if test="string-length($konvertertBase64) != 0 and contains($konvertertBase64, 'Navn')">
			<td width="20%" valign="top">
				<xsl:value-of select="substring-before(substring-after($konvertertBase64, 'Navn&gt;'),'&lt;/')"/>
			</td>
		</xsl:if>
		<xsl:if test="string-length($konvertertBase64) != 0 and contains($konvertertBase64, 'TilbOppl')">
			<td width="20%" valign="top">
				<xsl:value-of select="substring-before(substring-after($konvertertBase64, 'TilbOppl&gt;'),'&lt;/')"/>
			</td>
		</xsl:if>
		<xsl:if test="string-length($konvertertBase64) != 0 and contains($konvertertBase64, 'Legemiddelform')">
			<td width="20%" valign="top">
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($konvertertBase64,'Legemiddelform '),'/'),'DN=&quot;'),'&quot;')"/>
			</td>
		</xsl:if>
		<xsl:if test="string-length($konvertertBase64) != 0 and (contains($konvertertBase64, 'BestanddelLegemiddel') or contains($konvertertBase64, 'BestanddelAnnet') or contains($konvertertBase64, 'BestanddelVirkestoff'))">
			<td width="20%" valign="top">
				<xsl:if test="contains($konvertertBase64, 'BestanddelLegemiddel')">
					<xsl:call-template name="skrivUtBestanddelLegemiddel">
						<xsl:with-param name="tekst" select="substring-after($konvertertBase64, 'BestanddelLegemiddel&gt;')"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="contains($konvertertBase64, 'BestanddelAnnet')">
					<xsl:call-template name="skrivUtBestanddelAnnet">
						<xsl:with-param name="tekst" select="substring-after($konvertertBase64, 'BestanddelAnnet&gt;')"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="contains($konvertertBase64, 'BestanddelVirkestoff')">
					<xsl:call-template name="skrivUtBestanddelVirkestoff">
						<xsl:with-param name="tekst" select="substring-after($konvertertBase64, 'BestanddelVirkestoff&gt;')"/>
					</xsl:call-template>
				</xsl:if>
			</td>
		</xsl:if>
	</xsl:template>
	<xsl:template name="fellesLegemiddelKortBunn">
		<xsl:param name="konvertertBase64"/>
		<xsl:if test="string-length($konvertertBase64) != 0 and contains($konvertertBase64, 'Reseptgruppe')">
			<td width="25%" valign="top">
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($konvertertBase64,'Reseptgruppe '),'/'),'DN=&quot;'),'&quot;')"/>
			</td>
		</xsl:if>
		<xsl:if test="string-length($konvertertBase64) != 0 and contains($konvertertBase64, 'NavnFormStyrke')">
			<td width="25%" valign="top">
				<xsl:value-of select="substring-before(substring-after($konvertertBase64, 'NavnFormStyrke&gt;'),'&lt;/')"/>
			</td>
		</xsl:if>
	</xsl:template>
	<xsl:template name="fellesLegemiddelAvsluttningBunn">
		<xsl:param name="refId"/>
		<xsl:if test="../m2:IngenTidlBeh">
			<td valign="top">
				<xsl:for-each select="../m2:IngenTidlBeh">
					<xsl:call-template name="k-7507"/>
				</xsl:for-each>
			</td>
		</xsl:if>
		<xsl:if test="string-length($vedlegg) != 0">
			<td>
				<xsl:choose>
					<xsl:when test="count($vedlegg//m12:Soknadssvar) != 0">
						<xsl:choose>
							<xsl:when test="count($vedlegg//m12:Soknadssvar[$refId = m12:RefSoknad]) != 0">
								<xsl:value-of select="$vedlegg//m12:Soknadssvar[$refId = m12:RefSoknad]/m12:Beslutning/@DN"/>
							</xsl:when>
							<xsl:otherwise>
							Mangler vedlagt søknadssvar med samsvarende referanse
						</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
					Mangler vedlagt søknadssvar
				</xsl:otherwise>
				</xsl:choose>
			</td>
		</xsl:if>
	</xsl:template>
	<xsl:template name="skrivUtBestanddelLegemiddel">
		<xsl:param name="tekst"/>
		<div>
			<xsl:if test="contains($tekst, 'NavnFormStyrke')">
				<xsl:value-of select="substring-before(substring-after($tekst, 'NavnFormStyrke&gt;'),'&lt;/')"/>&#160;
			</xsl:if>
			<xsl:if test="contains($tekst, 'Mengde')">
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Mengde '),'/'),'V=&quot;'),'&quot;')"/>&#160;
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Mengde '),'/'),'U=&quot;'),'&quot;')"/>
			</xsl:if>
			<xsl:if test="contains($tekst, 'Utblanding')">
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Adqs '),'/'),'DN=&quot;'),'&quot;')"/>&#160;
			</xsl:if>
		</div>
		<xsl:if test="contains(substring-after($tekst,'BestanddelLegemiddel&gt;'), 'BestanddelLegemiddel')">
			<xsl:call-template name="skrivUtBestanddelLegemiddel">
				<xsl:with-param name="tekst" select="substring-after(substring-after($tekst,'BestanddelLegemiddel&gt;'),'BestanddelLegemiddel&gt;')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="skrivUtBestanddelAnnet">
		<xsl:param name="tekst"/>
		<div>
			<xsl:if test="contains($tekst, 'NavnFormStyrke')">
				<xsl:value-of select="substring-before(substring-after($tekst, 'NavnFormStyrke&gt;'),'&lt;/')"/>&#160;
			</xsl:if>
			<xsl:if test="contains($tekst, 'Mengde')">
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Mengde '),'/'),'V=&quot;'),'&quot;')"/>&#160;
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Mengde '),'/'),'U=&quot;'),'&quot;')"/>
			</xsl:if>
			<xsl:if test="contains($tekst, 'Utblanding')">
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Adqs '),'/'),'DN=&quot;'),'&quot;')"/>&#160;
			</xsl:if>
			<xsl:if test="contains($tekst, 'Styrke')">
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Teller '),'/'),'V=&quot;'),'&quot;')"/>
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Teller '),'/'),'U=&quot;'),'&quot;')"/>&#160;/&#160;
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Nevner '),'/'),'V=&quot;'),'&quot;')"/>
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Nevner '),'/'),'U=&quot;'),'&quot;')"/>
			</xsl:if>
		</div>
		<xsl:if test="contains(substring-after($tekst,'BestanddelAnnet&gt;'), 'BestanddelAnnet')">
			<xsl:call-template name="skrivUtBestanddelAnnet">
				<xsl:with-param name="tekst" select="substring-after(substring-after($tekst,'BestanddelAnnet&gt;'),'BestanddelAnnet&gt;')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="skrivUtBestanddelVirkestoff">
		<xsl:param name="tekst"/>
		<div>
			<xsl:if test="contains($tekst, 'Navn')">
				<xsl:value-of select="substring-before(substring-after($tekst, 'Navn&gt;'),'&lt;/')"/>&#160;
			</xsl:if>
			<xsl:if test="contains($tekst, 'Mengde')">
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Mengde '),'/'),'V=&quot;'),'&quot;')"/>&#160;
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Mengde '),'/'),'U=&quot;'),'&quot;')"/>
			</xsl:if>
			<xsl:if test="contains($tekst, 'Styrke')">
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Teller '),'/'),'V=&quot;'),'&quot;')"/>
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Teller '),'/'),'U=&quot;'),'&quot;')"/>&#160;/&#160;
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Nevner '),'/'),'V=&quot;'),'&quot;')"/>
				<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'Nevner '),'/'),'U=&quot;'),'&quot;')"/>
			</xsl:if>
		</div>
		<xsl:if test="contains(substring-after($tekst,'BestanddelVirkestoff&gt;'), 'BestanddelVirkestoff')">
			<xsl:call-template name="skrivUtBestanddelVirkestoff">
				<xsl:with-param name="tekst" select="substring-after(substring-after($tekst,'BestanddelVirkestoff&gt;'),'BestanddelVirkestoff&gt;')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
