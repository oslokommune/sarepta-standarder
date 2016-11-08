<?xml version="1.0" encoding="utf-8"?>
<!-- Dato oppdatert: 2016-08-17T08:48:45+02:00-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="utf-8"/>
	<xsl:template name="k-dummy">
		<xsl:choose>
			<xsl:when test="@DN"><xsl:value-of select="@DN"/></xsl:when>
			<xsl:when test="@OT"><xsl:value-of select="@OT"/></xsl:when>
			<xsl:otherwise>{ukjent kode}</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-dummy-OT">
		<xsl:choose>
			<xsl:when test="@OT"><xsl:value-of select="@OT"/></xsl:when>
			<xsl:when test="@V"><xsl:value-of select="@V"/><xsl:if test="@DN">: <xsl:value-of select="@DN"/></xsl:if></xsl:when>
			<xsl:when test="@DN"><xsl:value-of select="@DN"/></xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-dummy-V">
		<xsl:choose>
			<xsl:when test="@V"><xsl:value-of select="@V"/><xsl:if test="@DN">: <xsl:value-of select="@DN"/></xsl:if></xsl:when>
			<xsl:when test="@DN"><xsl:value-of select="@DN"/></xsl:when>
			<xsl:when test="@OT"><xsl:value-of select="@OT"/></xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-1101">
		<xsl:choose>
			<xsl:when test="@V='1'">Ja</xsl:when>
			<xsl:when test="@V='2'">Nei</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-1103">
		<xsl:choose>
			<xsl:when test="@V='1'">Ja</xsl:when>
			<xsl:when test="@V='2'">Nei</xsl:when>
			<xsl:when test="@V='9'">Ukjent</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-1204">
		<xsl:choose>
			<xsl:when test="@V='DF'">Deflate</xsl:when>
			<xsl:when test="@V='GZ'">Gzip</xsl:when>
			<xsl:when test="@V='Z'">Compress</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-3101">
		<xsl:choose>
			<xsl:when test="@V='0'">Ikke kjent</xsl:when>
			<xsl:when test="@V='1'">Mann</xsl:when>
			<xsl:when test="@V='2'">Kvinne</xsl:when>
			<xsl:when test="@V='9'">Ikke spesifisert</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-3105">
		<xsl:choose>
			<xsl:when test="@V='1'">Bor hos begge foreldre</xsl:when>
			<xsl:when test="@V='2'">Pendler mellom foreldre</xsl:when>
			<xsl:when test="@V='3'">Bor hos en av foreldrene</xsl:when>
			<xsl:when test="@V='4'">Bor hos en av foreldrene og en eller flere andre voksne</xsl:when>
			<xsl:when test="@V='5'">Bor hos besteforeldre eller andre</xsl:when>
			<xsl:when test="@V='6'">Fosterhjem</xsl:when>
			<xsl:when test="@V='7'">Institusjon</xsl:when>
			<xsl:when test="@V='8'">Bor alene</xsl:when>
			<xsl:when test="@V='9'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-3108">
		<xsl:choose>
			<xsl:when test="@V='T'">Tillatelse</xsl:when>
			<xsl:when test="@V='R'">Reservasjon</xsl:when>
			<xsl:when test="@V='U'">Uavklart</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-3109">
		<xsl:choose>
			<xsl:when test="@V='1'">Ja</xsl:when>
			<xsl:when test="@V='2'">Nei</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-3303">
		<xsl:choose>
			<xsl:when test="@V='AA'">AFAR</xsl:when>
			<xsl:when test="@V='AB'">ABKHASISK</xsl:when>
			<xsl:when test="@V='AE'">AVESTISK</xsl:when>
			<xsl:when test="@V='AF'">AFRIKAANS</xsl:when>
			<xsl:when test="@V='AK'">AKAN</xsl:when>
			<xsl:when test="@V='AM'">AMHARISK</xsl:when>
			<xsl:when test="@V='AN'">ARAGONESISK</xsl:when>
			<xsl:when test="@V='AR'">ARABISK</xsl:when>
			<xsl:when test="@V='AS'">ASSAMESISK</xsl:when>
			<xsl:when test="@V='AV'">AVARISK</xsl:when>
			<xsl:when test="@V='AY'">AYMARA</xsl:when>
			<xsl:when test="@V='AZ'">ASERBAJDSJANSK</xsl:when>
			<xsl:when test="@V='BA'">BASJKIRSK</xsl:when>
			<xsl:when test="@V='BE'">HVITERUSSISK</xsl:when>
			<xsl:when test="@V='BG'">BULGARSK</xsl:when>
			<xsl:when test="@V='BH'">BIHARI</xsl:when>
			<xsl:when test="@V='BI'">BISLAMA</xsl:when>
			<xsl:when test="@V='BM'">BAMBARA</xsl:when>
			<xsl:when test="@V='BN'">BENGALI</xsl:when>
			<xsl:when test="@V='BO'">TIBETANSK</xsl:when>
			<xsl:when test="@V='BR'">BRETONSK</xsl:when>
			<xsl:when test="@V='BS'">BOSNISK</xsl:when>
			<xsl:when test="@V='CA'">KATALANSK</xsl:when>
			<xsl:when test="@V='CE'">TSJETSJENSK</xsl:when>
			<xsl:when test="@V='CH'">CHAMORRO</xsl:when>
			<xsl:when test="@V='CO'">KORSIKANSK</xsl:when>
			<xsl:when test="@V='CR'">CREE</xsl:when>
			<xsl:when test="@V='CS'">TSJEKKISK</xsl:when>
			<xsl:when test="@V='CU'">KIRKESLAVISK</xsl:when>
			<xsl:when test="@V='CV'">TSJUVANSK</xsl:when>
			<xsl:when test="@V='CY'">WALISISK EL. KYMRISK</xsl:when>
			<xsl:when test="@V='DA'">DANSK</xsl:when>
			<xsl:when test="@V='DE'">TYSK</xsl:when>
			<xsl:when test="@V='DV'">DHIVEHI</xsl:when>
			<xsl:when test="@V='DZ'">DZONGKHA</xsl:when>
			<xsl:when test="@V='EE'">EWE</xsl:when>
			<xsl:when test="@V='EL'">GRESK</xsl:when>
			<xsl:when test="@V='EN'">ENGELSK</xsl:when>
			<xsl:when test="@V='EO'">ESPERANTO</xsl:when>
			<xsl:when test="@V='ES'">SPANSK</xsl:when>
			<xsl:when test="@V='ET'">ESTISK</xsl:when>
			<xsl:when test="@V='EU'">BASKISK</xsl:when>
			<xsl:when test="@V='FA'">FARSI EL. PERSISK</xsl:when>
			<xsl:when test="@V='FF'">FULFULDE</xsl:when>
			<xsl:when test="@V='FI'">FINSK</xsl:when>
			<xsl:when test="@V='FJ'">FIJISK</xsl:when>
			<xsl:when test="@V='FO'">FÆRØYSK</xsl:when>
			<xsl:when test="@V='FR'">FRANSK</xsl:when>
			<xsl:when test="@V='FY'">FRISISK</xsl:when>
			<xsl:when test="@V='GA'">IRSK</xsl:when>
			<xsl:when test="@V='GD'">SKOTSK GÆLISK</xsl:when>
			<xsl:when test="@V='GL'">GALISISK</xsl:when>
			<xsl:when test="@V='GN'">GUARANI</xsl:when>
			<xsl:when test="@V='GU'">GUJARATI</xsl:when>
			<xsl:when test="@V='GV'">MANSK</xsl:when>
			<xsl:when test="@V='HA'">HAUSA</xsl:when>
			<xsl:when test="@V='HE'">HEBRAISK</xsl:when>
			<xsl:when test="@V='HI'">HINDI</xsl:when>
			<xsl:when test="@V='HO'">HIRI MOTU</xsl:when>
			<xsl:when test="@V='HR'">KROATISK</xsl:when>
			<xsl:when test="@V='HT'">HAITISK KREOLSK</xsl:when>
			<xsl:when test="@V='HU'">UNGARSK</xsl:when>
			<xsl:when test="@V='HY'">ARMENSK</xsl:when>
			<xsl:when test="@V='HZ'">HERERO</xsl:when>
			<xsl:when test="@V='IA'">INTERLINGUA-</xsl:when>
			<xsl:when test="@V='ID'">INDONESISK</xsl:when>
			<xsl:when test="@V='IE'">INTERLINGUE-</xsl:when>
			<xsl:when test="@V='IG'">IBO</xsl:when>
			<xsl:when test="@V='II'">YI</xsl:when>
			<xsl:when test="@V='IK'">INUPIAK</xsl:when>
			<xsl:when test="@V='IO'">IDO</xsl:when>
			<xsl:when test="@V='IS'">ISLANDSK</xsl:when>
			<xsl:when test="@V='IT'">ITALIENSK</xsl:when>
			<xsl:when test="@V='IU'">INUITTISK</xsl:when>
			<xsl:when test="@V='JA'">JAPANSK</xsl:when>
			<xsl:when test="@V='JV'">JAVANESISK</xsl:when>
			<xsl:when test="@V='KA'">GEORGISK</xsl:when>
			<xsl:when test="@V='KG'">KONGOLESISK</xsl:when>
			<xsl:when test="@V='KI'">GIKUYU</xsl:when>
			<xsl:when test="@V='KJ'">KWANYAMA</xsl:when>
			<xsl:when test="@V='KK'">KASAKHISK</xsl:when>
			<xsl:when test="@V='KL'">GRØNLANDSK</xsl:when>
			<xsl:when test="@V='KM'">KHMER</xsl:when>
			<xsl:when test="@V='KN'">KANNADA</xsl:when>
			<xsl:when test="@V='KO'">KOREANSK</xsl:when>
			<xsl:when test="@V='KR'">KANURI</xsl:when>
			<xsl:when test="@V='KS'">KASHMIRI</xsl:when>
			<xsl:when test="@V='KU'">KURDISK</xsl:when>
			<xsl:when test="@V='KV'">KOMI</xsl:when>
			<xsl:when test="@V='KW'">KORNISK</xsl:when>
			<xsl:when test="@V='KY'">KIRGISISK</xsl:when>
			<xsl:when test="@V='LA'">LATIN</xsl:when>
			<xsl:when test="@V='LB'">LUXEMBURGSK</xsl:when>
			<xsl:when test="@V='LG'">LUGANDA</xsl:when>
			<xsl:when test="@V='LI'">LIMBURGISK</xsl:when>
			<xsl:when test="@V='LN'">LINGALA</xsl:when>
			<xsl:when test="@V='LO'">LAOTISK</xsl:when>
			<xsl:when test="@V='LT'">LITAUISK</xsl:when>
			<xsl:when test="@V='LU'">LUBA-KATANGA</xsl:when>
			<xsl:when test="@V='LV'">LATVISK</xsl:when>
			<xsl:when test="@V='MG'">GASSISK</xsl:when>
			<xsl:when test="@V='MH'">MARSHALLESISK</xsl:when>
			<xsl:when test="@V='MI'">MAORI</xsl:when>
			<xsl:when test="@V='MK'">MAKEDONSK</xsl:when>
			<xsl:when test="@V='ML'">MALAYALAM</xsl:when>
			<xsl:when test="@V='MN'">MONGOLSK</xsl:when>
			<xsl:when test="@V='MO'">MOLDOVSK</xsl:when>
			<xsl:when test="@V='MR'">MARATHI</xsl:when>
			<xsl:when test="@V='MS'">MALAYISK</xsl:when>
			<xsl:when test="@V='MT'">MALTESISK</xsl:when>
			<xsl:when test="@V='MY'">BURMESISK</xsl:when>
			<xsl:when test="@V='NA'">NAURISK</xsl:when>
			<xsl:when test="@V='NB'">BOKMÅL</xsl:when>
			<xsl:when test="@V='ND'">NORD-NDEBELE</xsl:when>
			<xsl:when test="@V='NE'">NEPALI</xsl:when>
			<xsl:when test="@V='NG'">NDONGA</xsl:when>
			<xsl:when test="@V='NL'">NEDERLANDSK</xsl:when>
			<xsl:when test="@V='NN'">NYNORSK</xsl:when>
			<xsl:when test="@V='NO'">NORSK</xsl:when>
			<xsl:when test="@V='NR'">SØR-NDEBELE</xsl:when>
			<xsl:when test="@V='NV'">NAVAJO</xsl:when>
			<xsl:when test="@V='NY'">CHICHEWA</xsl:when>
			<xsl:when test="@V='OC'">OKSITANSK</xsl:when>
			<xsl:when test="@V='OJ'">OJIBWA</xsl:when>
			<xsl:when test="@V='OM'">OROMO</xsl:when>
			<xsl:when test="@V='OR'">ORIYA</xsl:when>
			<xsl:when test="@V='OS'">OSSETISK</xsl:when>
			<xsl:when test="@V='PA'">PANJABI</xsl:when>
			<xsl:when test="@V='PI'">PALI</xsl:when>
			<xsl:when test="@V='PL'">POLSK</xsl:when>
			<xsl:when test="@V='PS'">PASHTO</xsl:when>
			<xsl:when test="@V='PT'">PORTUGISISK</xsl:when>
			<xsl:when test="@V='QU'">QUECHUA</xsl:when>
			<xsl:when test="@V='RM'">RETOROMANSK</xsl:when>
			<xsl:when test="@V='RN'">KIRUNDI</xsl:when>
			<xsl:when test="@V='RO'">RUMENSK</xsl:when>
			<xsl:when test="@V='RU'">RUSSISK</xsl:when>
			<xsl:when test="@V='RW'">KINYARWANDA</xsl:when>
			<xsl:when test="@V='SA'">SANSKRIT</xsl:when>
			<xsl:when test="@V='SC'">SARDISK</xsl:when>
			<xsl:when test="@V='SD'">SINDHI</xsl:when>
			<xsl:when test="@V='SE'">NORDSAMISK</xsl:when>
			<xsl:when test="@V='SG'">SANGO</xsl:when>
			<xsl:when test="@V='SI'">SINGALESISK</xsl:when>
			<xsl:when test="@V='SK'">SLOVAKISK</xsl:when>
			<xsl:when test="@V='SL'">SLOVENSK</xsl:when>
			<xsl:when test="@V='SM'">SAMOANSK</xsl:when>
			<xsl:when test="@V='SN'">SHONA</xsl:when>
			<xsl:when test="@V='SO'">SOMALI</xsl:when>
			<xsl:when test="@V='SQ'">ALBANSK</xsl:when>
			<xsl:when test="@V='SR'">SERBISK</xsl:when>
			<xsl:when test="@V='SS'">SWATI</xsl:when>
			<xsl:when test="@V='ST'">SESOTHO</xsl:when>
			<xsl:when test="@V='SU'">SUNDANESISK</xsl:when>
			<xsl:when test="@V='SV'">SVENSK</xsl:when>
			<xsl:when test="@V='SW'">SWAHILI</xsl:when>
			<xsl:when test="@V='TA'">TAMIL</xsl:when>
			<xsl:when test="@V='TE'">TELUGU</xsl:when>
			<xsl:when test="@V='TG'">TADSJIKISK</xsl:when>
			<xsl:when test="@V='TH'">THAI</xsl:when>
			<xsl:when test="@V='TI'">TIGRINYA</xsl:when>
			<xsl:when test="@V='TK'">TURKMENSK</xsl:when>
			<xsl:when test="@V='TL'">TAGALOG</xsl:when>
			<xsl:when test="@V='TN'">TSWANA</xsl:when>
			<xsl:when test="@V='TO'">TONGANESISK</xsl:when>
			<xsl:when test="@V='TR'">TYRKISK</xsl:when>
			<xsl:when test="@V='TS'">TSONGA</xsl:when>
			<xsl:when test="@V='TT'">TATARISK</xsl:when>
			<xsl:when test="@V='TW'">TWI</xsl:when>
			<xsl:when test="@V='TY'">TAHITISK</xsl:when>
			<xsl:when test="@V='UG'">UIGURISK</xsl:when>
			<xsl:when test="@V='UK'">UKRAINSK</xsl:when>
			<xsl:when test="@V='UR'">URDU</xsl:when>
			<xsl:when test="@V='UZ'">USBEKISK</xsl:when>
			<xsl:when test="@V='VE'">VENDA</xsl:when>
			<xsl:when test="@V='VI'">VIETNAMESISK</xsl:when>
			<xsl:when test="@V='VO'">VOLAPYK</xsl:when>
			<xsl:when test="@V='WA'">VALLONSK</xsl:when>
			<xsl:when test="@V='WO'">WOLOF</xsl:when>
			<xsl:when test="@V='XH'">XHOSA</xsl:when>
			<xsl:when test="@V='YI'">JIDDISCH EL. JIDDISK</xsl:when>
			<xsl:when test="@V='YO'">YORUBA</xsl:when>
			<xsl:when test="@V='ZA'">ZHUANG</xsl:when>
			<xsl:when test="@V='ZH'">KINESISK</xsl:when>
			<xsl:when test="@V='ZU'">ZULU</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-3401">
		<xsl:choose>
			<xsl:when test="@V='H'">Bostedsadresse</xsl:when>
			<xsl:when test="@V='HP'">Folkeregisteradresse</xsl:when>
			<xsl:when test="@V='HV'">Ferieadresse</xsl:when>
			<xsl:when test="@V='INV'">Faktureringsadresse</xsl:when>
			<xsl:when test="@V='PST'">Postadresse</xsl:when>
			<xsl:when test="@V='RES'">Besøksadresse</xsl:when>
			<xsl:when test="@V='TMP'">Midlertidig adresse</xsl:when>
			<xsl:when test="@V='WP'">Arbeidsadresse</xsl:when>
			<xsl:when test="@V='BAD'">Ubrukelig adresse</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-3402">
		<xsl:choose>
			<xsl:when test="@V='0101'">Halden</xsl:when>
			<xsl:when test="@V='0104'">Moss</xsl:when>
			<xsl:when test="@V='0105'">Sarpsborg</xsl:when>
			<xsl:when test="@V='0106'">Fredrikstad</xsl:when>
			<xsl:when test="@V='0111'">Hvaler</xsl:when>
			<xsl:when test="@V='0118'">Aremark</xsl:when>
			<xsl:when test="@V='0119'">Marker</xsl:when>
			<xsl:when test="@V='0121'">Rømskog</xsl:when>
			<xsl:when test="@V='0122'">Trøgstad</xsl:when>
			<xsl:when test="@V='0123'">Spydeberg</xsl:when>
			<xsl:when test="@V='0124'">Askim</xsl:when>
			<xsl:when test="@V='0125'">Eidsberg</xsl:when>
			<xsl:when test="@V='0127'">Skiptvet</xsl:when>
			<xsl:when test="@V='0128'">Rakkestad</xsl:when>
			<xsl:when test="@V='0135'">Råde</xsl:when>
			<xsl:when test="@V='0136'">Rygge</xsl:when>
			<xsl:when test="@V='0137'">Våler</xsl:when>
			<xsl:when test="@V='0138'">Hobøl</xsl:when>
			<xsl:when test="@V='0211'">Vestby</xsl:when>
			<xsl:when test="@V='0213'">Ski</xsl:when>
			<xsl:when test="@V='0214'">Ås</xsl:when>
			<xsl:when test="@V='0215'">Frogn</xsl:when>
			<xsl:when test="@V='0216'">Nesodden</xsl:when>
			<xsl:when test="@V='0217'">Oppegård</xsl:when>
			<xsl:when test="@V='0219'">Bærum</xsl:when>
			<xsl:when test="@V='0220'">Asker</xsl:when>
			<xsl:when test="@V='0221'">Aurskog-Høland</xsl:when>
			<xsl:when test="@V='0226'">Sørum</xsl:when>
			<xsl:when test="@V='0227'">Fet</xsl:when>
			<xsl:when test="@V='0228'">Rælingen</xsl:when>
			<xsl:when test="@V='0229'">Enebakk</xsl:when>
			<xsl:when test="@V='0230'">Lørenskog</xsl:when>
			<xsl:when test="@V='0231'">Skedsmo</xsl:when>
			<xsl:when test="@V='0233'">Nittedal</xsl:when>
			<xsl:when test="@V='0234'">Gjerdrum</xsl:when>
			<xsl:when test="@V='0235'">Ullensaker</xsl:when>
			<xsl:when test="@V='0236'">Nes</xsl:when>
			<xsl:when test="@V='0237'">Eidsvoll</xsl:when>
			<xsl:when test="@V='0238'">Nannestad</xsl:when>
			<xsl:when test="@V='0239'">Hurdal</xsl:when>
			<xsl:when test="@V='0301'">Oslo</xsl:when>
			<xsl:when test="@V='0402'">Kongsvinger</xsl:when>
			<xsl:when test="@V='0403'">Hamar</xsl:when>
			<xsl:when test="@V='0412'">Ringsaker</xsl:when>
			<xsl:when test="@V='0415'">Løten</xsl:when>
			<xsl:when test="@V='0417'">Stange</xsl:when>
			<xsl:when test="@V='0418'">Nord-Odal</xsl:when>
			<xsl:when test="@V='0419'">Sør-Odal</xsl:when>
			<xsl:when test="@V='0420'">Eidskog</xsl:when>
			<xsl:when test="@V='0423'">Grue</xsl:when>
			<xsl:when test="@V='0425'">Åsnes</xsl:when>
			<xsl:when test="@V='0426'">Våler</xsl:when>
			<xsl:when test="@V='0427'">Elverum</xsl:when>
			<xsl:when test="@V='0428'">Trysil</xsl:when>
			<xsl:when test="@V='0429'">Åmot</xsl:when>
			<xsl:when test="@V='0430'">Stor-Elvdal</xsl:when>
			<xsl:when test="@V='0432'">Rendalen</xsl:when>
			<xsl:when test="@V='0434'">Engerdal</xsl:when>
			<xsl:when test="@V='0436'">Tolga</xsl:when>
			<xsl:when test="@V='0437'">Tynset</xsl:when>
			<xsl:when test="@V='0438'">Alvdal</xsl:when>
			<xsl:when test="@V='0439'">Folldal</xsl:when>
			<xsl:when test="@V='0441'">Os</xsl:when>
			<xsl:when test="@V='0501'">Lillehammer</xsl:when>
			<xsl:when test="@V='0502'">Gjøvik</xsl:when>
			<xsl:when test="@V='0511'">Dovre</xsl:when>
			<xsl:when test="@V='0512'">Lesja</xsl:when>
			<xsl:when test="@V='0513'">Skjåk</xsl:when>
			<xsl:when test="@V='0514'">Lom</xsl:when>
			<xsl:when test="@V='0515'">Vågå</xsl:when>
			<xsl:when test="@V='0516'">Nord-Fron</xsl:when>
			<xsl:when test="@V='0517'">Sel</xsl:when>
			<xsl:when test="@V='0519'">Sør-Fron</xsl:when>
			<xsl:when test="@V='0520'">Ringebu</xsl:when>
			<xsl:when test="@V='0521'">Øyer</xsl:when>
			<xsl:when test="@V='0522'">Gausdal</xsl:when>
			<xsl:when test="@V='0528'">Østre Toten</xsl:when>
			<xsl:when test="@V='0529'">Vestre Toten</xsl:when>
			<xsl:when test="@V='0532'">Jevnaker</xsl:when>
			<xsl:when test="@V='0533'">Lunner</xsl:when>
			<xsl:when test="@V='0534'">Gran</xsl:when>
			<xsl:when test="@V='0536'">Søndre Land</xsl:when>
			<xsl:when test="@V='0538'">Nordre Land</xsl:when>
			<xsl:when test="@V='0540'">Sør-Aurdal</xsl:when>
			<xsl:when test="@V='0541'">Etnedal</xsl:when>
			<xsl:when test="@V='0542'">Nord-Aurdal</xsl:when>
			<xsl:when test="@V='0543'">Vestre Slidre</xsl:when>
			<xsl:when test="@V='0544'">Øystre Slidre</xsl:when>
			<xsl:when test="@V='0545'">Vang</xsl:when>
			<xsl:when test="@V='0602'">Drammen</xsl:when>
			<xsl:when test="@V='0604'">Kongsberg</xsl:when>
			<xsl:when test="@V='0605'">Ringerike</xsl:when>
			<xsl:when test="@V='0612'">Hole</xsl:when>
			<xsl:when test="@V='0615'">Flå</xsl:when>
			<xsl:when test="@V='0616'">Nes</xsl:when>
			<xsl:when test="@V='0617'">Gol</xsl:when>
			<xsl:when test="@V='0618'">Hemsedal</xsl:when>
			<xsl:when test="@V='0619'">Ål</xsl:when>
			<xsl:when test="@V='0620'">Hol</xsl:when>
			<xsl:when test="@V='0621'">Sigdal</xsl:when>
			<xsl:when test="@V='0622'">Krødsherad</xsl:when>
			<xsl:when test="@V='0623'">Modum</xsl:when>
			<xsl:when test="@V='0624'">Øvre Eiker</xsl:when>
			<xsl:when test="@V='0625'">Nedre Eiker</xsl:when>
			<xsl:when test="@V='0626'">Lier</xsl:when>
			<xsl:when test="@V='0627'">Røyken</xsl:when>
			<xsl:when test="@V='0628'">Hurum</xsl:when>
			<xsl:when test="@V='0631'">Flesberg</xsl:when>
			<xsl:when test="@V='0632'">Rollag</xsl:when>
			<xsl:when test="@V='0633'">Nore og Uvdal</xsl:when>
			<xsl:when test="@V='0701'">Horten</xsl:when>
			<xsl:when test="@V='0702'">Holmestrand</xsl:when>
			<xsl:when test="@V='0704'">Tønsberg</xsl:when>
			<xsl:when test="@V='0706'">Sandefjord</xsl:when>
			<xsl:when test="@V='0709'">Larvik</xsl:when>
			<xsl:when test="@V='0711'">Svelvik</xsl:when>
			<xsl:when test="@V='0713'">Sande</xsl:when>
			<xsl:when test="@V='0714'">Hof</xsl:when>
			<xsl:when test="@V='0716'">Re</xsl:when>
			<xsl:when test="@V='0719'">Andebu</xsl:when>
			<xsl:when test="@V='0720'">Stokke</xsl:when>
			<xsl:when test="@V='0722'">Nøtterøy</xsl:when>
			<xsl:when test="@V='0723'">Tjøme</xsl:when>
			<xsl:when test="@V='0728'">Lardal</xsl:when>
			<xsl:when test="@V='0805'">Porsgrunn</xsl:when>
			<xsl:when test="@V='0806'">Skien</xsl:when>
			<xsl:when test="@V='0807'">Notodden</xsl:when>
			<xsl:when test="@V='0811'">Siljan</xsl:when>
			<xsl:when test="@V='0814'">Bamble</xsl:when>
			<xsl:when test="@V='0815'">Kragerø</xsl:when>
			<xsl:when test="@V='0817'">Drangedal</xsl:when>
			<xsl:when test="@V='0819'">Nome</xsl:when>
			<xsl:when test="@V='0821'">Bø</xsl:when>
			<xsl:when test="@V='0822'">Sauherad</xsl:when>
			<xsl:when test="@V='0826'">Tinn</xsl:when>
			<xsl:when test="@V='0827'">Hjartdal</xsl:when>
			<xsl:when test="@V='0828'">Seljord</xsl:when>
			<xsl:when test="@V='0829'">Kviteseid</xsl:when>
			<xsl:when test="@V='0830'">Nissedal</xsl:when>
			<xsl:when test="@V='0831'">Fyresdal</xsl:when>
			<xsl:when test="@V='0833'">Tokke</xsl:when>
			<xsl:when test="@V='0834'">Vinje</xsl:when>
			<xsl:when test="@V='0901'">Risør</xsl:when>
			<xsl:when test="@V='0904'">Grimstad</xsl:when>
			<xsl:when test="@V='0906'">Arendal</xsl:when>
			<xsl:when test="@V='0911'">Gjerstad</xsl:when>
			<xsl:when test="@V='0912'">Vegårshei</xsl:when>
			<xsl:when test="@V='0914'">Tvedestrand</xsl:when>
			<xsl:when test="@V='0919'">Froland</xsl:when>
			<xsl:when test="@V='0926'">Lillesand</xsl:when>
			<xsl:when test="@V='0928'">Birkenes</xsl:when>
			<xsl:when test="@V='0929'">Åmli</xsl:when>
			<xsl:when test="@V='0935'">Iveland</xsl:when>
			<xsl:when test="@V='0937'">Evje og Hornnes</xsl:when>
			<xsl:when test="@V='0938'">Bygland</xsl:when>
			<xsl:when test="@V='0940'">Valle</xsl:when>
			<xsl:when test="@V='0941'">Bykle</xsl:when>
			<xsl:when test="@V='1001'">Kristiansand</xsl:when>
			<xsl:when test="@V='1002'">Mandal</xsl:when>
			<xsl:when test="@V='1003'">Farsund</xsl:when>
			<xsl:when test="@V='1004'">Flekkefjord</xsl:when>
			<xsl:when test="@V='1014'">Vennesla</xsl:when>
			<xsl:when test="@V='1017'">Songdalen</xsl:when>
			<xsl:when test="@V='1018'">Søgne</xsl:when>
			<xsl:when test="@V='1021'">Marnardal</xsl:when>
			<xsl:when test="@V='1026'">Åseral</xsl:when>
			<xsl:when test="@V='1027'">Audnedal</xsl:when>
			<xsl:when test="@V='1029'">Lindesnes</xsl:when>
			<xsl:when test="@V='1032'">Lyngdal</xsl:when>
			<xsl:when test="@V='1034'">Hægebostad</xsl:when>
			<xsl:when test="@V='1037'">Kvinesdal</xsl:when>
			<xsl:when test="@V='1046'">Sirdal</xsl:when>
			<xsl:when test="@V='1101'">Eigersund</xsl:when>
			<xsl:when test="@V='1102'">Sandnes</xsl:when>
			<xsl:when test="@V='1103'">Stavanger</xsl:when>
			<xsl:when test="@V='1106'">Haugesund</xsl:when>
			<xsl:when test="@V='1111'">Sokndal</xsl:when>
			<xsl:when test="@V='1112'">Lund</xsl:when>
			<xsl:when test="@V='1114'">Bjerkreim</xsl:when>
			<xsl:when test="@V='1119'">Hå</xsl:when>
			<xsl:when test="@V='1120'">Klepp</xsl:when>
			<xsl:when test="@V='1121'">Time</xsl:when>
			<xsl:when test="@V='1122'">Gjesdal</xsl:when>
			<xsl:when test="@V='1124'">Sola</xsl:when>
			<xsl:when test="@V='1127'">Randaberg</xsl:when>
			<xsl:when test="@V='1129'">Forsand</xsl:when>
			<xsl:when test="@V='1130'">Strand</xsl:when>
			<xsl:when test="@V='1133'">Hjelmeland</xsl:when>
			<xsl:when test="@V='1134'">Suldal</xsl:when>
			<xsl:when test="@V='1135'">Sauda</xsl:when>
			<xsl:when test="@V='1141'">Finnøy</xsl:when>
			<xsl:when test="@V='1142'">Rennesøy</xsl:when>
			<xsl:when test="@V='1144'">Kvitsøy</xsl:when>
			<xsl:when test="@V='1145'">Bokn</xsl:when>
			<xsl:when test="@V='1146'">Tysvær</xsl:when>
			<xsl:when test="@V='1149'">Karmøy</xsl:when>
			<xsl:when test="@V='1151'">Utsira</xsl:when>
			<xsl:when test="@V='1160'">Vindafjord</xsl:when>
			<xsl:when test="@V='1201'">Bergen</xsl:when>
			<xsl:when test="@V='1211'">Etne</xsl:when>
			<xsl:when test="@V='1216'">Sveio</xsl:when>
			<xsl:when test="@V='1219'">Bømlo</xsl:when>
			<xsl:when test="@V='1221'">Stord</xsl:when>
			<xsl:when test="@V='1222'">Fitjar</xsl:when>
			<xsl:when test="@V='1223'">Tysnes</xsl:when>
			<xsl:when test="@V='1224'">Kvinnherad</xsl:when>
			<xsl:when test="@V='1227'">Jondal</xsl:when>
			<xsl:when test="@V='1228'">Odda</xsl:when>
			<xsl:when test="@V='1231'">Ullensvang</xsl:when>
			<xsl:when test="@V='1232'">Eidfjord</xsl:when>
			<xsl:when test="@V='1233'">Ulvik</xsl:when>
			<xsl:when test="@V='1234'">Granvin</xsl:when>
			<xsl:when test="@V='1235'">Voss</xsl:when>
			<xsl:when test="@V='1238'">Kvam</xsl:when>
			<xsl:when test="@V='1241'">Fusa</xsl:when>
			<xsl:when test="@V='1242'">Samnanger</xsl:when>
			<xsl:when test="@V='1243'">Os</xsl:when>
			<xsl:when test="@V='1244'">Austevoll</xsl:when>
			<xsl:when test="@V='1245'">Sund</xsl:when>
			<xsl:when test="@V='1246'">Fjell</xsl:when>
			<xsl:when test="@V='1247'">Askøy</xsl:when>
			<xsl:when test="@V='1251'">Vaksdal</xsl:when>
			<xsl:when test="@V='1252'">Modalen</xsl:when>
			<xsl:when test="@V='1253'">Osterøy</xsl:when>
			<xsl:when test="@V='1256'">Meland</xsl:when>
			<xsl:when test="@V='1259'">Øygarden</xsl:when>
			<xsl:when test="@V='1260'">Radøy</xsl:when>
			<xsl:when test="@V='1263'">Lindås</xsl:when>
			<xsl:when test="@V='1264'">Austrheim</xsl:when>
			<xsl:when test="@V='1265'">Fedje</xsl:when>
			<xsl:when test="@V='1266'">Masfjorden</xsl:when>
			<xsl:when test="@V='1401'">Flora</xsl:when>
			<xsl:when test="@V='1411'">Gulen</xsl:when>
			<xsl:when test="@V='1412'">Solund</xsl:when>
			<xsl:when test="@V='1413'">Hyllestad</xsl:when>
			<xsl:when test="@V='1416'">Høyanger</xsl:when>
			<xsl:when test="@V='1417'">Vik</xsl:when>
			<xsl:when test="@V='1418'">Balestrand</xsl:when>
			<xsl:when test="@V='1419'">Leikanger</xsl:when>
			<xsl:when test="@V='1420'">Sogndal</xsl:when>
			<xsl:when test="@V='1421'">Aurland</xsl:when>
			<xsl:when test="@V='1422'">Lærdal</xsl:when>
			<xsl:when test="@V='1424'">Årdal</xsl:when>
			<xsl:when test="@V='1426'">Luster</xsl:when>
			<xsl:when test="@V='1428'">Askvoll</xsl:when>
			<xsl:when test="@V='1429'">Fjaler</xsl:when>
			<xsl:when test="@V='1430'">Gaular</xsl:when>
			<xsl:when test="@V='1431'">Jølster</xsl:when>
			<xsl:when test="@V='1432'">Førde</xsl:when>
			<xsl:when test="@V='1433'">Naustdal</xsl:when>
			<xsl:when test="@V='1438'">Bremanger</xsl:when>
			<xsl:when test="@V='1439'">Vågsøy</xsl:when>
			<xsl:when test="@V='1441'">Selje</xsl:when>
			<xsl:when test="@V='1443'">Eid</xsl:when>
			<xsl:when test="@V='1444'">Hornindal</xsl:when>
			<xsl:when test="@V='1445'">Gloppen</xsl:when>
			<xsl:when test="@V='1449'">Stryn</xsl:when>
			<xsl:when test="@V='1502'">Molde</xsl:when>
			<xsl:when test="@V='1504'">Ålesund</xsl:when>
			<xsl:when test="@V='1505'">Kristiansund</xsl:when>
			<xsl:when test="@V='1511'">Vanylven</xsl:when>
			<xsl:when test="@V='1514'">Sande</xsl:when>
			<xsl:when test="@V='1515'">Herøy</xsl:when>
			<xsl:when test="@V='1516'">Ulstein</xsl:when>
			<xsl:when test="@V='1517'">Hareid</xsl:when>
			<xsl:when test="@V='1519'">Volda</xsl:when>
			<xsl:when test="@V='1520'">Ørsta</xsl:when>
			<xsl:when test="@V='1523'">Ørskog</xsl:when>
			<xsl:when test="@V='1524'">Norddal</xsl:when>
			<xsl:when test="@V='1525'">Stranda</xsl:when>
			<xsl:when test="@V='1526'">Stordal</xsl:when>
			<xsl:when test="@V='1528'">Sykkylven</xsl:when>
			<xsl:when test="@V='1529'">Skodje</xsl:when>
			<xsl:when test="@V='1531'">Sula</xsl:when>
			<xsl:when test="@V='1532'">Giske</xsl:when>
			<xsl:when test="@V='1534'">Haram</xsl:when>
			<xsl:when test="@V='1535'">Vestnes</xsl:when>
			<xsl:when test="@V='1539'">Rauma</xsl:when>
			<xsl:when test="@V='1543'">Nesset</xsl:when>
			<xsl:when test="@V='1545'">Midsund</xsl:when>
			<xsl:when test="@V='1546'">Sandøy</xsl:when>
			<xsl:when test="@V='1547'">Aukra</xsl:when>
			<xsl:when test="@V='1548'">Fræna</xsl:when>
			<xsl:when test="@V='1551'">Eide</xsl:when>
			<xsl:when test="@V='1554'">Averøy</xsl:when>
			<xsl:when test="@V='1557'">Gjemnes</xsl:when>
			<xsl:when test="@V='1560'">Tingvoll</xsl:when>
			<xsl:when test="@V='1563'">Sunndal</xsl:when>
			<xsl:when test="@V='1566'">Surnadal</xsl:when>
			<xsl:when test="@V='1567'">Rindal</xsl:when>
			<xsl:when test="@V='1571'">Halsa</xsl:when>
			<xsl:when test="@V='1573'">Smøla</xsl:when>
			<xsl:when test="@V='1576'">Aure</xsl:when>
			<xsl:when test="@V='1601'">Trondheim</xsl:when>
			<xsl:when test="@V='1612'">Hemne</xsl:when>
			<xsl:when test="@V='1613'">Snillfjord</xsl:when>
			<xsl:when test="@V='1617'">Hitra</xsl:when>
			<xsl:when test="@V='1620'">Frøya</xsl:when>
			<xsl:when test="@V='1621'">Ørland</xsl:when>
			<xsl:when test="@V='1622'">Agdenes</xsl:when>
			<xsl:when test="@V='1624'">Rissa</xsl:when>
			<xsl:when test="@V='1627'">Bjugn</xsl:when>
			<xsl:when test="@V='1630'">Åfjord</xsl:when>
			<xsl:when test="@V='1632'">Roan</xsl:when>
			<xsl:when test="@V='1633'">Osen</xsl:when>
			<xsl:when test="@V='1634'">Oppdal</xsl:when>
			<xsl:when test="@V='1635'">Rennebu</xsl:when>
			<xsl:when test="@V='1636'">Meldal</xsl:when>
			<xsl:when test="@V='1638'">Orkdal</xsl:when>
			<xsl:when test="@V='1640'">Røros</xsl:when>
			<xsl:when test="@V='1644'">Holtålen</xsl:when>
			<xsl:when test="@V='1648'">Midtre Gauldal</xsl:when>
			<xsl:when test="@V='1653'">Melhus</xsl:when>
			<xsl:when test="@V='1657'">Skaun</xsl:when>
			<xsl:when test="@V='1662'">Klæbu</xsl:when>
			<xsl:when test="@V='1663'">Malvik</xsl:when>
			<xsl:when test="@V='1664'">Selbu</xsl:when>
			<xsl:when test="@V='1665'">Tydal</xsl:when>
			<xsl:when test="@V='1702'">Steinkjer</xsl:when>
			<xsl:when test="@V='1703'">Namsos</xsl:when>
			<xsl:when test="@V='1711'">Meråker</xsl:when>
			<xsl:when test="@V='1714'">Stjørdal</xsl:when>
			<xsl:when test="@V='1717'">Frosta</xsl:when>
			<xsl:when test="@V='1718'">Leksvik</xsl:when>
			<xsl:when test="@V='1719'">Levanger</xsl:when>
			<xsl:when test="@V='1721'">Verdal</xsl:when>
			<xsl:when test="@V='1724'">Verran</xsl:when>
			<xsl:when test="@V='1725'">Namdalseid</xsl:when>
			<xsl:when test="@V='1736'">Snåsa</xsl:when>
			<xsl:when test="@V='1738'">Lierne</xsl:when>
			<xsl:when test="@V='1739'">Røyrvik</xsl:when>
			<xsl:when test="@V='1740'">Namsskogan</xsl:when>
			<xsl:when test="@V='1742'">Grong</xsl:when>
			<xsl:when test="@V='1743'">Høylandet</xsl:when>
			<xsl:when test="@V='1744'">Overhalla</xsl:when>
			<xsl:when test="@V='1748'">Fosnes</xsl:when>
			<xsl:when test="@V='1749'">Flatanger</xsl:when>
			<xsl:when test="@V='1750'">Vikna</xsl:when>
			<xsl:when test="@V='1751'">Nærøy</xsl:when>
			<xsl:when test="@V='1755'">Leka</xsl:when>
			<xsl:when test="@V='1756'">Inderøy</xsl:when>
			<xsl:when test="@V='1804'">Bodø</xsl:when>
			<xsl:when test="@V='1805'">Narvik</xsl:when>
			<xsl:when test="@V='1811'">Bindal</xsl:when>
			<xsl:when test="@V='1812'">Sømna</xsl:when>
			<xsl:when test="@V='1813'">Brønnøy</xsl:when>
			<xsl:when test="@V='1815'">Vega</xsl:when>
			<xsl:when test="@V='1816'">Vevelstad</xsl:when>
			<xsl:when test="@V='1818'">Herøy</xsl:when>
			<xsl:when test="@V='1820'">Alstahaug</xsl:when>
			<xsl:when test="@V='1822'">Leirfjord</xsl:when>
			<xsl:when test="@V='1824'">Vefsn</xsl:when>
			<xsl:when test="@V='1825'">Grane</xsl:when>
			<xsl:when test="@V='1826'">Hattfjelldal</xsl:when>
			<xsl:when test="@V='1827'">Dønna</xsl:when>
			<xsl:when test="@V='1828'">Nesna</xsl:when>
			<xsl:when test="@V='1832'">Hemnes</xsl:when>
			<xsl:when test="@V='1833'">Rana</xsl:when>
			<xsl:when test="@V='1834'">Lurøy</xsl:when>
			<xsl:when test="@V='1835'">Træna</xsl:when>
			<xsl:when test="@V='1836'">Rødøy</xsl:when>
			<xsl:when test="@V='1837'">Meløy</xsl:when>
			<xsl:when test="@V='1838'">Gildeskål</xsl:when>
			<xsl:when test="@V='1839'">Beiarn</xsl:when>
			<xsl:when test="@V='1840'">Saltdal</xsl:when>
			<xsl:when test="@V='1841'">Fauske</xsl:when>
			<xsl:when test="@V='1845'">Sørfold</xsl:when>
			<xsl:when test="@V='1848'">Steigen</xsl:when>
			<xsl:when test="@V='1849'">Hamarøy</xsl:when>
			<xsl:when test="@V='1850'">Tysfjord</xsl:when>
			<xsl:when test="@V='1851'">Lødingen</xsl:when>
			<xsl:when test="@V='1852'">Tjeldsund</xsl:when>
			<xsl:when test="@V='1853'">Evenes</xsl:when>
			<xsl:when test="@V='1854'">Ballangen</xsl:when>
			<xsl:when test="@V='1856'">Røst</xsl:when>
			<xsl:when test="@V='1857'">Værøy</xsl:when>
			<xsl:when test="@V='1859'">Flakstad</xsl:when>
			<xsl:when test="@V='1860'">Vestvågøy</xsl:when>
			<xsl:when test="@V='1865'">Vågan</xsl:when>
			<xsl:when test="@V='1866'">Hadsel</xsl:when>
			<xsl:when test="@V='1867'">Bø</xsl:when>
			<xsl:when test="@V='1868'">Øksnes</xsl:when>
			<xsl:when test="@V='1870'">Sortland</xsl:when>
			<xsl:when test="@V='1871'">Andøy</xsl:when>
			<xsl:when test="@V='1874'">Moskenes</xsl:when>
			<xsl:when test="@V='1902'">Tromsø</xsl:when>
			<xsl:when test="@V='1903'">Harstad</xsl:when>
			<xsl:when test="@V='1911'">Kvæfjord</xsl:when>
			<xsl:when test="@V='1913'">Skånland</xsl:when>
			<xsl:when test="@V='1917'">Ibestad</xsl:when>
			<xsl:when test="@V='1919'">Gratangen</xsl:when>
			<xsl:when test="@V='1920'">Lavangen</xsl:when>
			<xsl:when test="@V='1922'">Bardu</xsl:when>
			<xsl:when test="@V='1923'">Salangen</xsl:when>
			<xsl:when test="@V='1924'">Målselv</xsl:when>
			<xsl:when test="@V='1925'">Sørreisa</xsl:when>
			<xsl:when test="@V='1926'">Dyrøy</xsl:when>
			<xsl:when test="@V='1927'">Tranøy</xsl:when>
			<xsl:when test="@V='1928'">Torsken</xsl:when>
			<xsl:when test="@V='1929'">Berg</xsl:when>
			<xsl:when test="@V='1931'">Lenvik</xsl:when>
			<xsl:when test="@V='1933'">Balsfjord</xsl:when>
			<xsl:when test="@V='1936'">Karlsøy</xsl:when>
			<xsl:when test="@V='1938'">Lyngen</xsl:when>
			<xsl:when test="@V='1939'">Storfjord</xsl:when>
			<xsl:when test="@V='1940'">Gáivuotna Kåfjord</xsl:when>
			<xsl:when test="@V='1941'">Skjervøy</xsl:when>
			<xsl:when test="@V='1942'">Nordreisa</xsl:when>
			<xsl:when test="@V='1943'">Kvænangen</xsl:when>
			<xsl:when test="@V='2002'">Vardø</xsl:when>
			<xsl:when test="@V='2003'">Vadsø</xsl:when>
			<xsl:when test="@V='2004'">Hammerfest</xsl:when>
			<xsl:when test="@V='2011'">Guovdageaidnu Kautokeino</xsl:when>
			<xsl:when test="@V='2012'">Alta</xsl:when>
			<xsl:when test="@V='2014'">Loppa</xsl:when>
			<xsl:when test="@V='2015'">Hasvik</xsl:when>
			<xsl:when test="@V='2017'">Kvalsund</xsl:when>
			<xsl:when test="@V='2018'">Måsøy</xsl:when>
			<xsl:when test="@V='2019'">Nordkapp</xsl:when>
			<xsl:when test="@V='2020'">Porsanger Porsángu Porsanki</xsl:when>
			<xsl:when test="@V='2021'">Kárásjohka Karasjok</xsl:when>
			<xsl:when test="@V='2022'">Lebesby</xsl:when>
			<xsl:when test="@V='2023'">Gamvik</xsl:when>
			<xsl:when test="@V='2024'">Berlevåg</xsl:when>
			<xsl:when test="@V='2025'">Deatnu Tana</xsl:when>
			<xsl:when test="@V='2027'">Unjárga Nesseby</xsl:when>
			<xsl:when test="@V='2028'">Båtsfjord</xsl:when>
			<xsl:when test="@V='2030'">Sør-Varanger</xsl:when>
			<xsl:when test="@V='9999'">Uoppgitt</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-3403">
		<xsl:choose>
			<xsl:when test="@V='030101'">Gamle Oslo</xsl:when>
			<xsl:when test="@V='030102'">Grünerløkka</xsl:when>
			<xsl:when test="@V='030103'">Sagene</xsl:when>
			<xsl:when test="@V='030104'">St.Hanshaugen</xsl:when>
			<xsl:when test="@V='030105'">Frogner</xsl:when>
			<xsl:when test="@V='030106'">Ullern</xsl:when>
			<xsl:when test="@V='030107'">Vestre Aker</xsl:when>
			<xsl:when test="@V='030108'">Nordre Aker</xsl:when>
			<xsl:when test="@V='030109'">Bjerke</xsl:when>
			<xsl:when test="@V='030110'">Grorud</xsl:when>
			<xsl:when test="@V='030111'">Stovner</xsl:when>
			<xsl:when test="@V='030112'">Alna</xsl:when>
			<xsl:when test="@V='030113'">Østensjø</xsl:when>
			<xsl:when test="@V='030114'">Nordstrand</xsl:when>
			<xsl:when test="@V='030115'">Søndre Nordstrand</xsl:when>
			<xsl:when test="@V='030116'">Sentrum</xsl:when>
			<xsl:when test="@V='030117'">Marka</xsl:when>
			<xsl:when test="@V='030199'">Uoppgitt Oslo</xsl:when>
			<xsl:when test="@V='110301'">Hundvåg</xsl:when>
			<xsl:when test="@V='110302'">Tasta</xsl:when>
			<xsl:when test="@V='110303'">Eiganes og Våland</xsl:when>
			<xsl:when test="@V='110304'">Madla</xsl:when>
			<xsl:when test="@V='110305'">Storhaug</xsl:when>
			<xsl:when test="@V='110306'">Hillevåg</xsl:when>
			<xsl:when test="@V='110307'">Hinna</xsl:when>
			<xsl:when test="@V='110399'">Uoppgitt Stavanger</xsl:when>
			<xsl:when test="@V='120101'">Arna</xsl:when>
			<xsl:when test="@V='120102'">Bergenhus</xsl:when>
			<xsl:when test="@V='120103'">Fana</xsl:when>
			<xsl:when test="@V='120104'">Fyllingsdalen</xsl:when>
			<xsl:when test="@V='120105'">Laksevåg</xsl:when>
			<xsl:when test="@V='120106'">Ytrebygda</xsl:when>
			<xsl:when test="@V='120107'">Årstad</xsl:when>
			<xsl:when test="@V='120108'">Åsane</xsl:when>
			<xsl:when test="@V='120199'">Uoppgitt Bergen</xsl:when>
			<xsl:when test="@V='160101'">Midtbyen</xsl:when>
			<xsl:when test="@V='160102'">Østbyen</xsl:when>
			<xsl:when test="@V='160103'">Lerkendal</xsl:when>
			<xsl:when test="@V='160104'">Heimdal</xsl:when>
			<xsl:when test="@V='160199'">Uoppgitt Trondheim</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-4101">
		<xsl:choose>
			<xsl:when test="@V='1'">Ordinær pasient</xsl:when>
			<xsl:when test="@V='11'">Konvensjonspasient behandlet ved ø-hjelp</xsl:when>
			<xsl:when test="@V='12'">Utlending fra land uten avtale (selvbetalende)</xsl:when>
			<xsl:when test="@V='20'">Sykepengeprosjekt</xsl:when>
			<xsl:when test="@V='22'">Forskningsprogram</xsl:when>
			<xsl:when test="@V='30'">Selvbetalende norsk pasient og selvbetalende konvensjonspasient</xsl:when>
			<xsl:when test="@V='40'">Anbudspasienter finansiert via ISF</xsl:when>
			<xsl:when test="@V='50'">Opphold hos avtalespesialist finansiert via ISF</xsl:when>
			<xsl:when test="@V='GR'">Gratis</xsl:when>
			<xsl:when test="@V='IN'">Institusjon</xsl:when>
			<xsl:when test="@V='OF'">Offentlig forsikring</xsl:when>
			<xsl:when test="@V='PA'">Pasient</xsl:when>
			<xsl:when test="@V='PF'">Privat forsikring</xsl:when>
			<xsl:when test="@V='RE'">Rekvirent</xsl:when>
			<xsl:when test="@V='TR'">Trygdekontor</xsl:when>
			<xsl:when test="@V='99'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7300">
		<xsl:choose>
			<xsl:when test="@V='1'">Ut til hjemmet</xsl:when>
			<xsl:when test="@V='2'">Som død</xsl:when>
			<xsl:when test="@V='21'">Annen somatisk enhet ved egen institusjon</xsl:when>
			<xsl:when test="@V='23'">Psykiatrisk enhet/-poliklinikk ved egen institusjon</xsl:when>
			<xsl:when test="@V='31'">Annet somatisk sykehus i Norge</xsl:when>
			<xsl:when test="@V='34'">Somatisk sykehus utenfor Norge</xsl:when>
			<xsl:when test="@V='35'">Rehab. Inst./sykehjem</xsl:when>
			<xsl:when test="@V='39'">Annen helsesinstitusjon</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7303">
		<xsl:choose>
			<xsl:when test="@V='DATO'">Innen dato/klokkeslett</xsl:when>
			<xsl:when test="@V='NORM'">Normal</xsl:when>
			<xsl:when test="@V='OHJELP'">Øyeblikkelig hjelp</xsl:when>
			<xsl:when test="@V='TEL'">Besvares pr. telefon</xsl:when>
			<xsl:when test="@V='TELC'">Telefonsvar CITO</xsl:when>
			<xsl:when test="@V='PK'">Pakkeforløp for kreft (elektiv)</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7304">
		<xsl:choose>
			<xsl:when test="@V='J'">Ja</xsl:when>
			<xsl:when test="@V='N'">Nei</xsl:when>
			<xsl:when test="@V='F'">Kun ved feil</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7305">
		<xsl:choose>
			<xsl:when test="@V='S'">ICD10 stjernekode</xsl:when>
			<xsl:when test="@V='A'">ATC-kode</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7306">
		<xsl:choose>
			<xsl:when test="@V='S'">Planlagt</xsl:when>
			<xsl:when test="@V='P'">Foreløpig rapport</xsl:when>
			<xsl:when test="@V='F'">Endelig rapport</xsl:when>
			<xsl:when test="@V='A'">Tillegg til rapport</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7307">
		<xsl:choose>
			<xsl:when test="@V='1'">Inntatt</xsl:when>
			<xsl:when test="@V='2'">Forskrevet</xsl:when>
			<xsl:when test="@V='3'">Anbefalt å innta</xsl:when>
			<xsl:when test="@V='4'">Anbefalt å slutte å innta</xsl:when>
			<xsl:when test="@V='5'">Benyttes sporadisk</xsl:when>
			<xsl:when test="@V='6'">Benyttes regelmessig</xsl:when>
			<xsl:when test="@V='10'">Allergisk ovenfor</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7309">
		<xsl:choose>
			<xsl:when test="@V='N'">Ny</xsl:when>
			<xsl:when test="@V='M'">Endring</xsl:when>
			<xsl:when test="@V='A'">Tillegg</xsl:when>
			<xsl:when test="@V='H'">Historikk</xsl:when>
			<xsl:when test="@V='C'">Kansellering</xsl:when>
			<xsl:when test="@V='O'">Oppdatert og erstatter tidligere mottatt melding</xsl:when>
			<xsl:when test="@V='X'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7315">
		<xsl:choose>
			<xsl:when test="@V='E'">Epikrise</xsl:when>
			<xsl:when test="@V='H'">Henvisning</xsl:when>
			<xsl:when test="@V='T'">Tilbakemelding på henvisning</xsl:when>
			<xsl:when test="@V='E-P'">Poliklinisk notat</xsl:when>
			<xsl:when test="@V='E-L'">Legevaktsepikrise</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7317">
		<xsl:choose>
			<xsl:when test="@V='MOR'">Mor</xsl:when>
			<xsl:when test="@V='FAR'">Far</xsl:when>
			<xsl:when test="@V='EF'"> Ektefelle</xsl:when>
			<xsl:when test="@V='SA'"> Samboer</xsl:when>
			<xsl:when test="@V='SI'">Søster</xsl:when>
			<xsl:when test="@V='BR'">Bror</xsl:when>
			<xsl:when test="@V='DTR'">Datter</xsl:when>
			<xsl:when test="@V='SØN'">Sønn</xsl:when>
			<xsl:when test="@V='BBN'">Barnebarn</xsl:when>
			<xsl:when test="@V='ASL'">Annen slektning</xsl:when>
			<xsl:when test="@V='VEN'">Venn</xsl:when>
			<xsl:when test="@V='KOL'">Arbeidskollega</xsl:when>
			<xsl:when test="@V='NBO'">Nabo</xsl:when>
			<xsl:when test="@V='ARL'">Annen relasjon</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7318">
		<xsl:choose>
			<xsl:when test="@V='ILE'">Innleggende lege</xsl:when>
			<xsl:when test="@V='BLE'">Behandlende lege</xsl:when>
			<xsl:when test="@V='ULE'">Utskrivende lege</xsl:when>
			<xsl:when test="@V='ANL'">Anestesist</xsl:when>
			<xsl:when test="@V='OPL'">Operatør</xsl:when>
			<xsl:when test="@V='ISS'">Dokumentutsteder</xsl:when>
			<xsl:when test="@V='AUT'">Dokumentgodkjenner</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7319">
		<xsl:choose>
			<xsl:when test="@V='ARP'">Ansvarlig for rapport</xsl:when>
			<xsl:when test="@V='AUT'">Dokumentgodkjenner</xsl:when>
			<xsl:when test="@V='FLE'">Fastlege</xsl:when>
			<xsl:when test="@V='RHI'">Ansvarlig institusjon/tjeneste</xsl:when>
			<xsl:when test="@V='RHP'">Ansvarlig lege</xsl:when>
			<xsl:when test="@V='HHE'">Henvisende helsepersonell</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7321">
		<xsl:choose>
			<xsl:when test="@V='1'">Notat om pasient</xsl:when>
			<xsl:when test="@V='2'">Melding om avvik</xsl:when>
			<xsl:when test="@V='3'">Uspesifisert notat</xsl:when>
			<xsl:when test="@V='4'">Supplerende opplysninger</xsl:when>
			<xsl:when test="@V='5'">Overføring av journal</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7403">
		<xsl:choose>
			<xsl:when test="@V='5'">Medisinsk forbruksmateriell</xsl:when>
			<xsl:when test="@V='501'">Forbruksmateriell ved inkontinens</xsl:when>
			<xsl:when test="@V='50101'">Bleier</xsl:when>
			<xsl:when test="@V='5010101'">Beltebleie (a.i.e.)</xsl:when>
			<xsl:when test="@V='5010102'">Bleiebukse for voksne</xsl:when>
			<xsl:when test="@V='5010103'">Bleier alt i ett (a.i.e.)</xsl:when>
			<xsl:when test="@V='5010104'">Bleier for barn</xsl:when>
			<xsl:when test="@V='5010105'">Bleier lett</xsl:when>
			<xsl:when test="@V='5010106'">Bleier middels</xsl:when>
			<xsl:when test="@V='5010107'">Bleier tung</xsl:when>
			<xsl:when test="@V='5010108'">Innleggsbleier</xsl:when>
			<xsl:when test="@V='5010109'">Bleiebukser for barn</xsl:when>
			<xsl:when test="@V='50102'">Bleieholder</xsl:when>
			<xsl:when test="@V='5010201'">Truser plast</xsl:when>
			<xsl:when test="@V='5010202'">Truser bomull</xsl:when>
			<xsl:when test="@V='5010204'">Bleieholder m/fast innlegg</xsl:when>
			<xsl:when test="@V='5010205'">Bleieholder</xsl:when>
			<xsl:when test="@V='5010206'">Truser mikrofiber u/ben</xsl:when>
			<xsl:when test="@V='50103'">Dråpesamler for menn</xsl:when>
			<xsl:when test="@V='5010301'">Dråpesamler for menn</xsl:when>
			<xsl:when test="@V='50104'">Kladder/sengeunderlegg</xsl:when>
			<xsl:when test="@V='5010401'">Kladder/sengeunderlegg</xsl:when>
			<xsl:when test="@V='50105'">Spesialutstyr (diverse)</xsl:when>
			<xsl:when test="@V='5010501'">Spesialutstyr (diverse)</xsl:when>
			<xsl:when test="@V='5010502'">Rektalkateter med utstyr</xsl:when>
			<xsl:when test="@V='5010503'">Desinfiserende våtservietter</xsl:when>
			<xsl:when test="@V='5010504'">Analirrigasjon-komplett system</xsl:when>
			<xsl:when test="@V='5010505'">Hudfilm - klut</xsl:when>
			<xsl:when test="@V='5010506'">Hudfilm</xsl:when>
			<xsl:when test="@V='50106'">Uridomer og festeutstyr</xsl:when>
			<xsl:when test="@V='5010601'">Festeutstyr for uridomer</xsl:when>
			<xsl:when test="@V='5010602'">Uridomer selvklebende</xsl:when>
			<xsl:when test="@V='5010603'">Uridomer med festestrips</xsl:when>
			<xsl:when test="@V='5010604'">Uridomer uten festestrips</xsl:when>
			<xsl:when test="@V='50107'">Urinposer og festeutstyr</xsl:when>
			<xsl:when test="@V='5010701'">Benposer for legg og lår</xsl:when>
			<xsl:when test="@V='5010702'">Annet flasker/bankepose</xsl:when>
			<xsl:when test="@V='5010703'">Festeutstyr for urinposer</xsl:when>
			<xsl:when test="@V='5010704'">InCare-system</xsl:when>
			<xsl:when test="@V='5010705'">Sterile poser</xsl:when>
			<xsl:when test="@V='5010706'">Urinpose med avtapping</xsl:when>
			<xsl:when test="@V='5010707'">Urinpose uten avtapping</xsl:when>
			<xsl:when test="@V='5010708'">Utbytteposer</xsl:when>
			<xsl:when test="@V='5010709'">Moveen urinposer</xsl:when>
			<xsl:when test="@V='50108'">Utstyr for nefrostomi</xsl:when>
			<xsl:when test="@V='5010801'">Utstyr for nefrostomi</xsl:when>
			<xsl:when test="@V='502'">Forbruksmateriell ved urinretensjon</xsl:when>
			<xsl:when test="@V='50201'">Kateter</xsl:when>
			<xsl:when test="@V='5020101'">Kateter for intravesikal instillasjon, hydrofile</xsl:when>
			<xsl:when test="@V='5020102'">Kateter korttids (uten gel)</xsl:when>
			<xsl:when test="@V='5020103'">Kateter langtids</xsl:when>
			<xsl:when test="@V='5020104'">Kateter striktur, hydrofile</xsl:when>
			<xsl:when test="@V='5020105'">Tappekat. med pose, hydrofile</xsl:when>
			<xsl:when test="@V='5020106'">Tappekat. med pose, m/gel</xsl:when>
			<xsl:when test="@V='5020107'">Tappekat. til interm.kat. hydrofile</xsl:when>
			<xsl:when test="@V='5020108'">Tappekat. til interm.kat. m/gel</xsl:when>
			<xsl:when test="@V='5020109'">Tappekat. til interm.kat.spes behov fuktede,hydrof</xsl:when>
			<xsl:when test="@V='5020110'">Tappekat. til interm.kat.spes behov hydrofile</xsl:when>
			<xsl:when test="@V='5020111'">Tappekat. til interm.kat.u/gel</xsl:when>
			<xsl:when test="@V='5020113'">Diverse utstyr ved urinretensjon</xsl:when>
			<xsl:when test="@V='5020114'">Sterile hansker</xsl:when>
			<xsl:when test="@V='5020115'">Tappekat. til interm.kat.fuktede hydrofile</xsl:when>
			<xsl:when test="@V='50202'">Urinposer og festeutstyr</xsl:when>
			<xsl:when test="@V='5020201'">Benposer for legg og lår</xsl:when>
			<xsl:when test="@V='5020202'">Festeutstyr for urinposer</xsl:when>
			<xsl:when test="@V='5020203'">InCare-system</xsl:when>
			<xsl:when test="@V='5020204'">Sterile poser</xsl:when>
			<xsl:when test="@V='5020205'">Urinpose med avtapping</xsl:when>
			<xsl:when test="@V='5020206'">Urinpose uten avtapping</xsl:when>
			<xsl:when test="@V='5020207'">Utbytteposer</xsl:when>
			<xsl:when test="@V='5020208'">Moveen urinposer</xsl:when>
			<xsl:when test="@V='503'">Forbruksmateriell til strupeopererte</xsl:when>
			<xsl:when test="@V='50301'">Forbruksmateriell til strupeopererte</xsl:when>
			<xsl:when test="@V='5030101'">Kanyler/innerkanyler</xsl:when>
			<xsl:when test="@V='5030102'">Kompresser</xsl:when>
			<xsl:when test="@V='5030103'">Natriumklorid/sterilt vann</xsl:when>
			<xsl:when test="@V='5030104'">Slanger</xsl:when>
			<xsl:when test="@V='5030105'">Stomabandasjer og filtre</xsl:when>
			<xsl:when test="@V='5030106'">Sugekateter</xsl:when>
			<xsl:when test="@V='5030107'">Diverse utstyr til strupeopererte</xsl:when>
			<xsl:when test="@V='5030108'">Makrame- og perlesmekker</xsl:when>
			<xsl:when test="@V='504'">Forbruksmateriell ved diabetes</xsl:when>
			<xsl:when test="@V='50401'">Blodsukkertester</xsl:when>
			<xsl:when test="@V='5040101'">Blodsukkertester</xsl:when>
			<xsl:when test="@V='50402'">Injeksjonskateter</xsl:when>
			<xsl:when test="@V='5040201'">Injeksjonskateter</xsl:when>
			<xsl:when test="@V='50403'">Insulinpenner</xsl:when>
			<xsl:when test="@V='5040301'">Insulinpenner</xsl:when>
			<xsl:when test="@V='5040302'">Insulinpenner med minnefunksjon</xsl:when>
			<xsl:when test="@V='50404'">Insulinsprøyter</xsl:when>
			<xsl:when test="@V='5040401'">30 IE</xsl:when>
			<xsl:when test="@V='5040402'">50 IE</xsl:when>
			<xsl:when test="@V='5040403'">100 IE</xsl:when>
			<xsl:when test="@V='50405'">Lansetter for stikkeapparat</xsl:when>
			<xsl:when test="@V='5040501'">Lansetter for stikkeapparat</xsl:when>
			<xsl:when test="@V='5040502'">Selvutløsende lansetter</xsl:when>
			<xsl:when test="@V='50406'">Nåler til insulinpenner</xsl:when>
			<xsl:when test="@V='5040601'">Nåler til insulinpenner</xsl:when>
			<xsl:when test="@V='50407'">Glukose - og ketontester</xsl:when>
			<xsl:when test="@V='5040701'">Ketontester for urin</xsl:when>
			<xsl:when test="@V='5040702'">Måle sukker i urin</xsl:when>
			<xsl:when test="@V='5040703'">Glukose - og ketontester for urin</xsl:when>
			<xsl:when test="@V='505'">Forbruksmateriell ved stomi</xsl:when>
			<xsl:when test="@V='50501'">Endelsbandasjer - poser, endels, lukket</xsl:when>
			<xsl:when test="@V='5050101'">Poser, endels, lukket m/hudbeskyttelsesplate</xsl:when>
			<xsl:when test="@V='5050102'">Poser m/hudbskytt. plate og innebygget tetningsring</xsl:when>
			<xsl:when test="@V='5050103'">Poser, endels, lukket, m/hudbesk.ring og plaster</xsl:when>
			<xsl:when test="@V='5050104'">Poser, endels, lukket, m/konveks plate</xsl:when>
			<xsl:when test="@V='5050105'">Poser, endels, lukket, m/plaster</xsl:when>
			<xsl:when test="@V='50502'">Endelsbandasjer - stomicap, endels</xsl:when>
			<xsl:when test="@V='5050201'">Stomicap m/hudbeskyttelsesplate</xsl:when>
			<xsl:when test="@V='5050202'">Stomicap m/hudbeskyttelsesring og plaster</xsl:when>
			<xsl:when test="@V='5050203'">Stomicap m/plaster</xsl:when>
			<xsl:when test="@V='50503'">Endelsbandasjer - poser, endels for barn</xsl:when>
			<xsl:when test="@V='5050301'">Poser, endels, tømbar, m/hudbeskyttelsesplate</xsl:when>
			<xsl:when test="@V='5050302'">Poser, endels, uro m/hudbeskyttelsesplate</xsl:when>
			<xsl:when test="@V='50504'">Endelsbandasjer - poser, endels, tømbare</xsl:when>
			<xsl:when test="@V='5050401'">Poser m/filter/integ lukn/innebygget tetningsring</xsl:when>
			<xsl:when test="@V='5050402'">Poser, endels, tømbar, drenasjeposer</xsl:when>
			<xsl:when test="@V='5050403'">Poser, endels, tømbar, m/filter</xsl:when>
			<xsl:when test="@V='5050404'">Poser, endels, tømbar, m/hudbesk.ring og plaster</xsl:when>
			<xsl:when test="@V='5050405'">Poser, endels, tømbar, m/hudbeskyttelsesplate</xsl:when>
			<xsl:when test="@V='5050406'">Poser, endels, tømbar, m/konveks plate</xsl:when>
			<xsl:when test="@V='5050407'">Poser, endels, tømbar, m/plaster</xsl:when>
			<xsl:when test="@V='5050408'">Poser, endels, tømbar, Post Op. (Store)</xsl:when>
			<xsl:when test="@V='5050409'">Poser, endels,tømbar,m/filter,intergr.fors.lukning</xsl:when>
			<xsl:when test="@V='5050410'">Poser,endels,tømbare,konveks m/filter,intergr.f.l.</xsl:when>
			<xsl:when test="@V='5050411'">Poser,endels,tømbar,konveks m/tape</xsl:when>
			<xsl:when test="@V='50505'">Endelsbandasjer - poser, endels, urostomi</xsl:when>
			<xsl:when test="@V='5050501'">Poser, endels, uro m/hudbeskyttelsesplate</xsl:when>
			<xsl:when test="@V='5050502'">Poser, endels, uro m/konveks plate</xsl:when>
			<xsl:when test="@V='5050503'">Poser, endels, uro m/plaster</xsl:when>
			<xsl:when test="@V='5050504'">Poser,endels, uro m/hudbeskyttelsesring og plaster</xsl:when>
			<xsl:when test="@V='5050505'">Poser, endels, uro m/innebygget tetningsring</xsl:when>
			<xsl:when test="@V='50506'">Hjelpemateriell</xsl:when>
			<xsl:when test="@V='5050601'">Barrièrekrem</xsl:when>
			<xsl:when test="@V='5050603'">Belter</xsl:when>
			<xsl:when test="@V='5050604'">Belter med beltefeste</xsl:when>
			<xsl:when test="@V='5050605'">Fikseringsbind</xsl:when>
			<xsl:when test="@V='5050606'">Filter</xsl:when>
			<xsl:when test="@V='5050607'">Hefteplaster</xsl:when>
			<xsl:when test="@V='5050608'">Hudbeskyttelsesplater</xsl:when>
			<xsl:when test="@V='5050609'">Geldannende granulat</xsl:when>
			<xsl:when test="@V='5050610'">Lukkeklips og klemmer til tømbare poser</xsl:when>
			<xsl:when test="@V='5050611'">Løse konvekse ringer</xsl:when>
			<xsl:when test="@V='5050612'">Posedeodoranter</xsl:when>
			<xsl:when test="@V='5050613'">Strøpulver</xsl:when>
			<xsl:when test="@V='5050614'">Sårpasta</xsl:when>
			<xsl:when test="@V='5050615'">Sårplater</xsl:when>
			<xsl:when test="@V='5050616'">Tetningsring og -pasta</xsl:when>
			<xsl:when test="@V='5050617'">Tetningsringer</xsl:when>
			<xsl:when test="@V='5050618'">Tetningstrips</xsl:when>
			<xsl:when test="@V='5050619'">Plasterfjernemidler</xsl:when>
			<xsl:when test="@V='50507'">Hjelpemateriell - kompresser</xsl:when>
			<xsl:when test="@V='5050701'">Gaskompresser</xsl:when>
			<xsl:when test="@V='5050702'">Non-Woven kompresser</xsl:when>
			<xsl:when test="@V='50508'">Hjelpemateriell - poseovertrekk</xsl:when>
			<xsl:when test="@V='5050801'">Poseovertrekk</xsl:when>
			<xsl:when test="@V='50509'">Hjelpemateriell - som må rekvireres spesielt av lege</xsl:when>
			<xsl:when test="@V='5050901'">Brokkbind til stomiopererte m/parastomalt brokk</xsl:when>
			<xsl:when test="@V='5050902'">Hudfilm</xsl:when>
			<xsl:when test="@V='5050903'">Plasterfjernemidler</xsl:when>
			<xsl:when test="@V='5050904'">Spesielle produkter</xsl:when>
			<xsl:when test="@V='5050905'">Utstyr for nefrostomi</xsl:when>
			<xsl:when test="@V='5050906'">Fikseringsbelter</xsl:when>
			<xsl:when test="@V='5050907'">Plateforlenger</xsl:when>
			<xsl:when test="@V='50511'">Irrigasjon - irrigasjonssett</xsl:when>
			<xsl:when test="@V='5051101'">Irrigasjonsermer, m/plaster</xsl:when>
			<xsl:when test="@V='5051102'">Irrigasjonsermer, m/hudbeskyttelsesplate</xsl:when>
			<xsl:when test="@V='5051103'">Irrigasjonsermer,todels,m/plastering og beltefeste</xsl:when>
			<xsl:when test="@V='5051104'">Irrigasjonssett</xsl:when>
			<xsl:when test="@V='50512'">Irrigasjon - irrigasjonssett - løse deler</xsl:when>
			<xsl:when test="@V='5051201'">Konet endestykke</xsl:when>
			<xsl:when test="@V='5051202'">Regulator</xsl:when>
			<xsl:when test="@V='5051203'">Separat slange</xsl:when>
			<xsl:when test="@V='5051204'">Vannbeholdere</xsl:when>
			<xsl:when test="@V='50513'">Stomipropper</xsl:when>
			<xsl:when test="@V='5051301'">Endels stomipropp</xsl:when>
			<xsl:when test="@V='5051302'">Todels stomipropp</xsl:when>
			<xsl:when test="@V='50514'">Todelsbandasjer - plater</xsl:when>
			<xsl:when test="@V='5051401'">Plater for urostomi m/festefolie m/konv. (ACT)</xsl:when>
			<xsl:when test="@V='5051402'">Plater m/festefolie m/hel hudbeskyttelse (ACT)</xsl:when>
			<xsl:when test="@V='5051403'">Plater m/festefolie m/hudbsk.ring og plaster (ACT)</xsl:when>
			<xsl:when test="@V='50515'">Todelsbandasjer - plater</xsl:when>
			<xsl:when test="@V='5051501'">Plater for Post Op. (Store)</xsl:when>
			<xsl:when test="@V='5051502'">Plater for urostomi</xsl:when>
			<xsl:when test="@V='5051503'">Plater for urostomi m/konveksitet</xsl:when>
			<xsl:when test="@V='5051504'">Plater, m/hel hudbeskyttelse</xsl:when>
			<xsl:when test="@V='5051505'">Plater m/hudbeskyttelsesring og plaster</xsl:when>
			<xsl:when test="@V='5051506'">Plater m/konveksitet</xsl:when>
			<xsl:when test="@V='50516'">Todelsbandasjer - poser, todels</xsl:when>
			<xsl:when test="@V='5051601'">Poser m/selvklebende ring, todels, lukket (ACT)</xsl:when>
			<xsl:when test="@V='5051602'">Poser m/selvklebende ring, todels, tømbar (ACT)</xsl:when>
			<xsl:when test="@V='5051603'">Poser m/selvkl.ring, tømbar m/integr.lukn. (ACT)</xsl:when>
			<xsl:when test="@V='50517'">Todelsbandasjer - poser, todels</xsl:when>
			<xsl:when test="@V='5051701'">Poser, todels, lukket</xsl:when>
			<xsl:when test="@V='5051702'">Poser, todels, nattdrenasje</xsl:when>
			<xsl:when test="@V='5051703'">Poser, todels, Post Op.</xsl:when>
			<xsl:when test="@V='5051704'">Poser, todels, spesialpose</xsl:when>
			<xsl:when test="@V='5051705'">Poser, todels, tømbar</xsl:when>
			<xsl:when test="@V='5051706'">Poser, todels, tømbar m/filter</xsl:when>
			<xsl:when test="@V='5051707'">Poser, todels, tømbar m/utskiftbart filter</xsl:when>
			<xsl:when test="@V='5051708'">Poser, todels, urostomi</xsl:when>
			<xsl:when test="@V='5051709'">Poser, todels,tømbar,m/filter og integrert lukking</xsl:when>
			<xsl:when test="@V='50518'">Todelsbandasjer - poser, plater, todels for barn</xsl:when>
			<xsl:when test="@V='5051801'">Plater</xsl:when>
			<xsl:when test="@V='5051802'">Poser, todels, lukket</xsl:when>
			<xsl:when test="@V='5051803'">Poser, todels, tømbar</xsl:when>
			<xsl:when test="@V='5051804'">Poser, todels, urostomi</xsl:when>
			<xsl:when test="@V='50519'">Todelsbandasjer - stomicap, todels</xsl:when>
			<xsl:when test="@V='5051901'">Stomicap, todels</xsl:when>
			<xsl:when test="@V='5051902'">Stomicap, urostomi</xsl:when>
			<xsl:when test="@V='50520'">Urinposer til urostomi</xsl:when>
			<xsl:when test="@V='5052001'">Urinposer til urostomi</xsl:when>
			<xsl:when test="@V='5052002'">Utstyr til urinposer til urostomi</xsl:when>
			<xsl:when test="@V='50521'">Utstyr for kontinente stomier</xsl:when>
			<xsl:when test="@V='5052101'">Bandasjer</xsl:when>
			<xsl:when test="@V='5052102'">Eksplorasjonskrem</xsl:when>
			<xsl:when test="@V='5052103'">Hefteplaster (må rekvireres spesielt av lege)</xsl:when>
			<xsl:when test="@V='5052104'">Katetere</xsl:when>
			<xsl:when test="@V='5052105'">Skyllesprøyte</xsl:when>
			<xsl:when test="@V='5052106'">Spesialbandasje</xsl:when>
			<xsl:when test="@V='50522'">Bind ved rektal blødning/sekresjon</xsl:when>
			<xsl:when test="@V='5052201'">Bind ved rektal blødning/sekresjon</xsl:when>
			<xsl:when test="@V='50523'">Utstyr for nefrostomi</xsl:when>
			<xsl:when test="@V='5052301'">Utstyr for nefrostomi</xsl:when>
			<xsl:when test="@V='50524'">Oppsamlingspose ved redusert tarmfunksjon</xsl:when>
			<xsl:when test="@V='5052401'">Oppsamlingspose ved redusert tarmfunksjon</xsl:when>
			<xsl:when test="@V='506'">Forbruksmateriell til blødere</xsl:when>
			<xsl:when test="@V='50601'">Forbruksmateriell til blødere</xsl:when>
			<xsl:when test="@V='5060101'">Hansker og blodstillende produkter</xsl:when>
			<xsl:when test="@V='5060102'">Kanyler</xsl:when>
			<xsl:when test="@V='5060103'">Kompresser</xsl:when>
			<xsl:when test="@V='5060104'">Sprøyter</xsl:when>
			<xsl:when test="@V='5060105'">Staseslanger, -bånd</xsl:when>
			<xsl:when test="@V='5060106'">3-veis kraner, luer/lock</xsl:when>
			<xsl:when test="@V='507'">Forbruksmateriell til lungesyke</xsl:when>
			<xsl:when test="@V='50701'">Forbruksmateriell til lungesyke</xsl:when>
			<xsl:when test="@V='5070101'">Inhalasjonskamre med eller uten maske</xsl:when>
			<xsl:when test="@V='5070102'">Kanyler</xsl:when>
			<xsl:when test="@V='5070103'">Natriumklorid/sterilt vann</xsl:when>
			<xsl:when test="@V='5070104'">Pefmålere</xsl:when>
			<xsl:when test="@V='5070105'">Sprøyter</xsl:when>
			<xsl:when test="@V='5070106'">Transtracheal kateter og forleng.slange</xsl:when>
			<xsl:when test="@V='5070107'">Utstyr til inhalasjonskamre</xsl:when>
			<xsl:when test="@V='508'">Forbruksmateriell ved veksthormonforstyrrelser</xsl:when>
			<xsl:when test="@V='50801'">Forbruksmateriell ved veksthormonforstyrrelser</xsl:when>
			<xsl:when test="@V='5080101'">Forbruksmateriell ved veksthormonforstyrrelser</xsl:when>
			<xsl:when test="@V='509'">Forbruksmateriell til nyretransplanterte</xsl:when>
			<xsl:when test="@V='50901'">Testmatr. for nyretranspl.</xsl:when>
			<xsl:when test="@V='5090101'">Testmatr. for nyretranspl.</xsl:when>
			<xsl:when test="@V='510'">Hoftebeskyttere</xsl:when>
			<xsl:when test="@V='51001'">Hoftebeskytter</xsl:when>
			<xsl:when test="@V='5100101'">Hoftebeskytter</xsl:when>
			<xsl:when test="@V='511'">Forbruksmateriell til glukosemåling v/intravenøs ernæring</xsl:when>
			<xsl:when test="@V='51101'">Blodsukkertester</xsl:when>
			<xsl:when test="@V='5110101'">Blodsukkertester</xsl:when>
			<xsl:when test="@V='51102'">Lansetter</xsl:when>
			<xsl:when test="@V='5110201'">Lansetter for stikkeapparat</xsl:when>
			<xsl:when test="@V='5110202'">Selvutløsende lansetter</xsl:when>
			<xsl:when test="@V='51103'">Urintester</xsl:when>
			<xsl:when test="@V='5110301'">Glukose - og ketontester for urin</xsl:when>
			<xsl:when test="@V='512'">Forbruksmateriell ved tuberkulosebehandling</xsl:when>
			<xsl:when test="@V='51201'">Forbruksmateriell ved tuberkulosebehandling</xsl:when>
			<xsl:when test="@V='5120101'">Forbruksmateriell ved tuberkulosebehandling</xsl:when>
			<xsl:when test="@V='513'">Forbruksmateriell ved epidermolysis bullosa</xsl:when>
			<xsl:when test="@V='51301'">Forbruksmateriell ved epidermolysis bullosa</xsl:when>
			<xsl:when test="@V='5130101'">Forbruksmateriell ved epidermolysis bullosa</xsl:when>
			<xsl:when test="@V='51401'">Sprøyter</xsl:when>
			<xsl:when test="@V='5140101'">Sprøyter</xsl:when>
			<xsl:when test="@V='5140102'">Perorale sprøyter</xsl:when>
			<xsl:when test="@V='51402'">Kanyler</xsl:when>
			<xsl:when test="@V='5140201'">Kanyler</xsl:when>
			<xsl:when test="@V='5140202'">Pennekanyler</xsl:when>
			<xsl:when test="@V='51403'">Annet måle- og administrasjonsutstyr</xsl:when>
			<xsl:when test="@V='5140301'">Annet måle- og administrasjonsutstyr</xsl:when>
			<xsl:when test="@V='6'">Næringsmidler</xsl:when>
			<xsl:when test="@V='601'">Næringsmidler ved diverse tilstander</xsl:when>
			<xsl:when test="@V='60101'">Næringsdrikker</xsl:when>
			<xsl:when test="@V='6010101'">Næringsdrikker</xsl:when>
			<xsl:when test="@V='60102'">Næringsdrikker, barn</xsl:when>
			<xsl:when test="@V='6010201'">Næringsdrikker, barn</xsl:when>
			<xsl:when test="@V='60103'">Næringstilskudd - pulver, pudding</xsl:when>
			<xsl:when test="@V='6010301'">Næringstilskudd -  pulver, pudding, suppe</xsl:when>
			<xsl:when test="@V='60104'">Sondenæring</xsl:when>
			<xsl:when test="@V='6010401'">Sondenæring</xsl:when>
			<xsl:when test="@V='60105'">Sondenæring, barn</xsl:when>
			<xsl:when test="@V='6010501'">Sondenæring, barn</xsl:when>
			<xsl:when test="@V='60106'">Spesialløsninger</xsl:when>
			<xsl:when test="@V='6010601'">Spesialløsninger</xsl:when>
			<xsl:when test="@V='602'">Næringsmidler ved laktoseintoleranse med mer</xsl:when>
			<xsl:when test="@V='60201'">Næringsdrikker</xsl:when>
			<xsl:when test="@V='6020101'">Næringsdrikker</xsl:when>
			<xsl:when test="@V='60202'">Næringsdrikker, barn</xsl:when>
			<xsl:when test="@V='6020201'">Næringsdrikker, barn</xsl:when>
			<xsl:when test="@V='60203'">Næringstilskudd - pulver, pudding</xsl:when>
			<xsl:when test="@V='6020301'">Næringstilskudd -  pulver, pudding</xsl:when>
			<xsl:when test="@V='60204'">Sondenæring</xsl:when>
			<xsl:when test="@V='6020401'">Sondenæring</xsl:when>
			<xsl:when test="@V='60205'">Spesialløsninger</xsl:when>
			<xsl:when test="@V='6020501'">Spesialløsninger</xsl:when>
			<xsl:when test="@V='603'">Næringsmidler ved Fenylketonuri (Føllings sykdom)</xsl:when>
			<xsl:when test="@V='60301'">Næringsmidler ved Fenylketonuri (Føllings sykdom)</xsl:when>
			<xsl:when test="@V='6030101'">Næringsmidler ved Fenylketonuri (Føllings sykdom)</xsl:when>
			<xsl:when test="@V='604'">Næringsmidler ved kreft/immunsvikt/sykdom som krever næringstilskudd</xsl:when>
			<xsl:when test="@V='60401'">Næringsdrikker</xsl:when>
			<xsl:when test="@V='6040101'">Næringsdrikker</xsl:when>
			<xsl:when test="@V='60402'">Næringsdrikker, barn</xsl:when>
			<xsl:when test="@V='6040201'">Næringsdrikker, barn</xsl:when>
			<xsl:when test="@V='60403'">Næringstilskudd - pulver, pudding</xsl:when>
			<xsl:when test="@V='6040301'">Næringstilskudd -  pulver, pudding, suppe</xsl:when>
			<xsl:when test="@V='60404'">Sondenæring</xsl:when>
			<xsl:when test="@V='6040401'">Sondenæring</xsl:when>
			<xsl:when test="@V='60405'">Sondenæring, barn</xsl:when>
			<xsl:when test="@V='6040501'">Sondenæring, barn</xsl:when>
			<xsl:when test="@V='60406'">Spesialløsninger</xsl:when>
			<xsl:when test="@V='6040601'">Spesialløsninger</xsl:when>
			<xsl:when test="@V='9'">Brystproteser</xsl:when>
			<xsl:when test="@V='900'">Brystproteser</xsl:when>
			<xsl:when test="@V='90001'">Brystproteser</xsl:when>
			<xsl:when test="@V='9000101'">Amoena</xsl:when>
			<xsl:when test="@V='9000102'">Anita</xsl:when>
			<xsl:when test="@V='9000103'">Harmonie</xsl:when>
			<xsl:when test="@V='9000104'">Serena</xsl:when>
			<xsl:when test="@V='9000105'">Silima</xsl:when>
			<xsl:when test="@V='9000106'">Trulife</xsl:when>
			<xsl:when test="@V='9000107'">ABC</xsl:when>
			<xsl:when test="@V='90002'">Brystvorter</xsl:when>
			<xsl:when test="@V='9000201'">Brystvorter</xsl:when>
			<xsl:when test="@V='90003'">Festeplater</xsl:when>
			<xsl:when test="@V='9000301'">Festeplater</xsl:when>
			<xsl:when test="@V='90004'">Interim/vattprotese</xsl:when>
			<xsl:when test="@V='9000401'">Interim/vattprotese</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7426">
		<xsl:choose>
			<xsl:when test="@V='1'">Allmennmedisin</xsl:when>
			<xsl:when test="@V='2'">Anestesiologi</xsl:when>
			<xsl:when test="@V='3'">Barnesykdommer</xsl:when>
			<xsl:when test="@V='4'">Barne- og ungdomspsykiatri</xsl:when>
			<xsl:when test="@V='5'">Arbeidsmedisin</xsl:when>
			<xsl:when test="@V='6'">Fysikalsk med. og rehabil.</xsl:when>
			<xsl:when test="@V='7'">Fødselshjelp og kvinnesykdom.</xsl:when>
			<xsl:when test="@V='16'">Hud og veneriske sykdommer</xsl:when>
			<xsl:when test="@V='18'">Immunologi og transfusjonsmed.</xsl:when>
			<xsl:when test="@V='28'">Kjevekirurgi og munnhulesykd.</xsl:when>
			<xsl:when test="@V='31'">Medisinsk biokjemi</xsl:when>
			<xsl:when test="@V='32'">Klinisk nevrofysiologi</xsl:when>
			<xsl:when test="@V='33'">Medisinsk genetikk</xsl:when>
			<xsl:when test="@V='34'">Medisinsk mikrobiologi</xsl:when>
			<xsl:when test="@V='35'">Radiologi</xsl:when>
			<xsl:when test="@V='36'">Nevrokirurgi</xsl:when>
			<xsl:when test="@V='37'">Nevrologi</xsl:when>
			<xsl:when test="@V='38'">Patologi</xsl:when>
			<xsl:when test="@V='39'">Plastikkirurgi</xsl:when>
			<xsl:when test="@V='40'">Psykiatri</xsl:when>
			<xsl:when test="@V='41'">Revmatologi</xsl:when>
			<xsl:when test="@V='42'">Samfunnsmedisin</xsl:when>
			<xsl:when test="@V='43'">Onkologi</xsl:when>
			<xsl:when test="@V='45'">Øre-nese-halssykdommer</xsl:when>
			<xsl:when test="@V='46'">Øyesykdommer</xsl:when>
			<xsl:when test="@V='57'">Klinisk farmakologi</xsl:when>
			<xsl:when test="@V='80'">Generell Kirurgi</xsl:when>
			<xsl:when test="@V='81'">Barnekirurgi</xsl:when>
			<xsl:when test="@V='82'">Gastroenterologisk kirurgi</xsl:when>
			<xsl:when test="@V='83'">Karkirurgi</xsl:when>
			<xsl:when test="@V='85'">Thoraxkirurgi</xsl:when>
			<xsl:when test="@V='86'">Urologisk kirurgi</xsl:when>
			<xsl:when test="@V='87'">Bryst- og endokrinkirurgi</xsl:when>
			<xsl:when test="@V='152'">Ortopedisk kirurgi</xsl:when>
			<xsl:when test="@V='151'">Nukleærmedisin</xsl:when>
			<xsl:when test="@V='190'">Indremedisin</xsl:when>
			<xsl:when test="@V='191'">Blodsykdommer</xsl:when>
			<xsl:when test="@V='192'">Endokrinologi</xsl:when>
			<xsl:when test="@V='193'">Fordøyelsessykdommer</xsl:when>
			<xsl:when test="@V='194'">Geriatri</xsl:when>
			<xsl:when test="@V='195'">Hjertesykdommer</xsl:when>
			<xsl:when test="@V='196'">Infeksjonssykdommer</xsl:when>
			<xsl:when test="@V='197'">Lungesykdommer</xsl:when>
			<xsl:when test="@V='198'">Nyresykdommer</xsl:when>
			<xsl:when test="@V='199'">Rus- og avhengighetsmedisin</xsl:when>
			<xsl:when test="@V='515'">Kjeveortopedi</xsl:when>
			<xsl:when test="@V='523'">Pedodonti</xsl:when>
			<xsl:when test="@V='531'">Periodonti</xsl:when>
			<xsl:when test="@V='558'">Oral-kirurgi og oralmedisin</xsl:when>
			<xsl:when test="@V='559'">Kjeve- og ansiktsradiologi</xsl:when>
			<xsl:when test="@V='560'">Endodonti</xsl:when>
			<xsl:when test="@V='561'">Oral protetikk</xsl:when>
			<xsl:when test="@V='575'">Kontaktlinsekompetanse</xsl:when>
			<xsl:when test="@V='17'">Idrettsmedisin</xsl:when>
			<xsl:when test="@V='29'">Klinisk sosialmedisin</xsl:when>
			<xsl:when test="@V='30'">Klinisk fysiologi</xsl:when>
			<xsl:when test="@V='44'">Yrkesmedisin</xsl:when>
			<xsl:when test="@V='49'">Almenpraktiker Dnlf</xsl:when>
			<xsl:when test="@V='50'">Bedriftslege Dnlf</xsl:when>
			<xsl:when test="@V='51'">Tropesykdommer</xsl:when>
			<xsl:when test="@V='52'">Tub. ben- og leddlid./skroful.</xsl:when>
			<xsl:when test="@V='53'">Epidemiske sykdommer</xsl:when>
			<xsl:when test="@V='54'">Ikke relatert til fagområdet</xsl:when>
			<xsl:when test="@V='58'">Psykoterapiveileder psykiatri</xsl:when>
			<xsl:when test="@V='59'">Psykoterapiveileder - B.U.P.</xsl:when>
			<xsl:when test="@V='65'">Anatomi</xsl:when>
			<xsl:when test="@V='66'">Biokjemi</xsl:when>
			<xsl:when test="@V='67'">Fysiologi</xsl:when>
			<xsl:when test="@V='84'">Ortopedisk kirurgi (gren)</xsl:when>
			<xsl:when test="@V='97'">Nevroradiologi</xsl:when>
			<xsl:when test="@V='98'">Militærmedisin</xsl:when>
			<xsl:when test="@V='99'">Trygdemedisin</xsl:when>
			<xsl:when test="@V='56'">Almenpraktiker  utland</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7427">
		<xsl:choose>
			<xsl:when test="@V='100'">§5-14</xsl:when>
			<xsl:when test="@V='200'">§5-14 §2</xsl:when>
			<xsl:when test="@V='300'">§5-14 §3</xsl:when>
			<xsl:when test="@V='301'">§5-14 §3a</xsl:when>
			<xsl:when test="@V='302'">§5-14 §3b</xsl:when>
			<xsl:when test="@V='400'">§5-14 §4</xsl:when>
			<xsl:when test="@V='500'">§5-14 §5</xsl:when>
			<xsl:when test="@V='501'">§5-14 §5.1</xsl:when>
			<xsl:when test="@V='502'">§5-14 §5.2</xsl:when>
			<xsl:when test="@V='503'">§5-14 §5.3</xsl:when>
			<xsl:when test="@V='504'">§5-14 §5.4</xsl:when>
			<xsl:when test="@V='505'">§5-14 §5.5</xsl:when>
			<xsl:when test="@V='506'">§5-14 §5.6</xsl:when>
			<xsl:when test="@V='507'">§5-14 §5.7</xsl:when>
			<xsl:when test="@V='508'">§5-14 §5.8</xsl:when>
			<xsl:when test="@V='509'">§5-14 §5.9</xsl:when>
			<xsl:when test="@V='510'">§5-14 §5.10</xsl:when>
			<xsl:when test="@V='511'">§5-14 §5.11</xsl:when>
			<xsl:when test="@V='512'">§5-14 §5.12</xsl:when>
			<xsl:when test="@V='513'">§5-14 §5.13</xsl:when>
			<xsl:when test="@V='514'">§5-14 §5.14</xsl:when>
			<xsl:when test="@V='600'">§5-14 §6</xsl:when>
			<xsl:when test="@V='601'">§5-14 §6.1</xsl:when>
			<xsl:when test="@V='602'">§5-14 §6.2</xsl:when>
			<xsl:when test="@V='603'">§5-14 §6.3</xsl:when>
			<xsl:when test="@V='604'">§5-14 §6.4</xsl:when>
			<xsl:when test="@V='700'">§5-22</xsl:when>
			<xsl:when test="@V='703'">§5-22P</xsl:when>
			<xsl:when test="@V='800'">§5-25</xsl:when>
			<xsl:when test="@V='900'">§10-7i</xsl:when>
			<xsl:when test="@V='950'">H-resept</xsl:when>
			<xsl:when test="@V='990'">Inhalasjonsveiledning</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7434">
		<xsl:choose>
			<xsl:when test="@V='-04'">Allmennfarlige smittsomme sykdommer</xsl:when>
			<xsl:when test="@V='-11'">Antikoagulasjon - teknisk bruk</xsl:when>
			<xsl:when test="@V='-20'">Tromboseprofylakse ved kirurgi</xsl:when>
			<xsl:when test="@V='-22'">Sekundærprofylakse etter hjerteinfarkt</xsl:when>
			<xsl:when test="@V='-26'">Etablert aterosklerotisk sykdom (sekundærprevensjon)</xsl:when>
			<xsl:when test="@V='-27'">Betydelig forhøyet risiko for å utvikle aterosklerotisk sykdom (primærprevensjon)</xsl:when>
			<xsl:when test="@V='-40'">Behandlingskrevende tørre øyne</xsl:when>
			<xsl:when test="@V='-50'">Ondartet kreftsykdom</xsl:when>
			<xsl:when test="@V='-51'">Organtransplantasjon</xsl:when>
			<xsl:when test="@V='-52'">Palliativ behandling for svulst med metastaser</xsl:when>
			<xsl:when test="@V='-53'">Kvalme, forstoppelse eller diaré ved kreftsykdom</xsl:when>
			<xsl:when test="@V='-54'">Risiko for tilbakefall av ondartet kreftsykdom</xsl:when>
			<xsl:when test="@V='-61'">Forebygging av legemiddelinduserte mage- og duodenalsår hos risikopasienter</xsl:when>
			<xsl:when test="@V='-62'">Forebygging av kortikosteroidindusert osteoporose</xsl:when>
			<xsl:when test="@V='-70'">Betydelige atferdsproblemer som krever behandling</xsl:when>
			<xsl:when test="@V='-71'">Kroniske, sterke smerter</xsl:when>
			<xsl:when test="@V='-72'">Behandlingskrevende psykotiske eller psykosenære symptomer ved psykisk lidelse</xsl:when>
			<xsl:when test="@V='-73'">Behandlingskrevende forstyrrelse i stemningsleie ved psykisk lidelse</xsl:when>
			<xsl:when test="@V='-74'">Behandlingskrevende angstsymptomer ved psykisk lidelse</xsl:when>
			<xsl:when test="@V='-81'">Bivirkninger ved tuberkulosebehandling</xsl:when>
			<xsl:when test="@V='-90'">Palliativ behandling i livets sluttfase</xsl:when>
			<xsl:when test="@V='-91'">Oppløsnings-/fortynningsvæsker og tilleggslegemidler</xsl:when>
			<xsl:when test="@V='-97'">Ind. refusjon §2 (vedtak før 3.3.2008)</xsl:when>
			<xsl:when test="@V='-98'">Ind. refusjon §10a (vedtak før 3.3.2008)</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7435">
		<xsl:choose>
			<xsl:when test="@V='-04'">Allmennfarlige smittsomme sykdommer</xsl:when>
			<xsl:when test="@V='-11'">Antikoagulasjon - teknisk bruk</xsl:when>
			<xsl:when test="@V='-20'">Tromboseprofylakse ved kirurgi</xsl:when>
			<xsl:when test="@V='-22'">Sekundærprofylakse etter hjerteinfarkt</xsl:when>
			<xsl:when test="@V='-26'">Etablert aterosklerotisk sykdom (sekundærprevensjon)</xsl:when>
			<xsl:when test="@V='-27'">Betydelig forhøyet risiko for å utvikle aterosklerotisk sykdom (primærprevensjon)</xsl:when>
			<xsl:when test="@V='-30'">Annen langvarig og alvorlig hudsykdom</xsl:when>
			<xsl:when test="@V='-40'">Behandlingskrevende tørre øyne</xsl:when>
			<xsl:when test="@V='-50'">Ondartet kreftsykdom</xsl:when>
			<xsl:when test="@V='-52'">Palliativ behandling for svulst med metastaser</xsl:when>
			<xsl:when test="@V='-53'">Kvalme, forstoppelse eller diaré ved kreftsykdom</xsl:when>
			<xsl:when test="@V='-54'">Risiko for tilbakefall av ondartet kreftsykdom</xsl:when>
			<xsl:when test="@V='-61'">Forebygging av legemiddelinduserte mage- og duodenalsår hos risikopasienter</xsl:when>
			<xsl:when test="@V='-62'">Forebygging av kortikosteroidindusert osteoporose</xsl:when>
			<xsl:when test="@V='-70'">Betydelige atferdsproblemer som krever behandling</xsl:when>
			<xsl:when test="@V='-71'">Kroniske, sterke smerter</xsl:when>
			<xsl:when test="@V='-81'">Bivirkninger ved tuberkulosebehandling</xsl:when>
			<xsl:when test="@V='-90'">Palliativ behandling i livets sluttfase</xsl:when>
			<xsl:when test="@V='-91'">Oppløsnings-/fortynningsvæsker og tilleggslegemidler</xsl:when>
			<xsl:when test="@V='-97'">Ind. refusjon §2 (vedtak før 3.3.2008)</xsl:when>
			<xsl:when test="@V='-98'">Ind. refusjon §10a (vedtak før 3.3.2008)</xsl:when>
			<xsl:when test="@V='-99'">Studiemedisin godkjent for forskrivning på folketrygdens regning av Helsedirektoratet</xsl:when>
			<xsl:when test="@V='-F2'">Behandlingskrevende psykotiske eller psykosenære symptomer ved psykisk lidelse</xsl:when>
			<xsl:when test="@V='-F3'">Behandlingskrevende forstyrrelse i stemningsleie ved psykisk lidelse</xsl:when>
			<xsl:when test="@V='-F4'">Behandlingskrevende angstsymptomer ved psykisk lidelse</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7480">
		<xsl:choose>
			<xsl:when test="@V='0'">(Ingen)</xsl:when>
			<xsl:when test="@V='1'">ampulle</xsl:when>
			<xsl:when test="@V='3'">dråpe</xsl:when>
			<xsl:when test="@V='4'">dusj</xsl:when>
			<xsl:when test="@V='6'">kapsel</xsl:when>
			<xsl:when test="@V='7'">klyster</xsl:when>
			<xsl:when test="@V='8'">ml</xsl:when>
			<xsl:when test="@V='9'">pose</xsl:when>
			<xsl:when test="@V='11'">sprøyte</xsl:when>
			<xsl:when test="@V='12'">stikkpille</xsl:when>
			<xsl:when test="@V='13'">tablett</xsl:when>
			<xsl:when test="@V='14'">tampong</xsl:when>
			<xsl:when test="@V='15'">kule</xsl:when>
			<xsl:when test="@V='16'">plaster</xsl:when>
			<xsl:when test="@V='17'">IE</xsl:when>
			<xsl:when test="@V='18'">tyggetablett</xsl:when>
			<xsl:when test="@V='19'">dose</xsl:when>
			<xsl:when test="@V='20'">vagitorie</xsl:when>
			<xsl:when test="@V='21'">vaginaltablett</xsl:when>
			<xsl:when test="@V='60'">vaginalring</xsl:when>
			<xsl:when test="@V='64'">g</xsl:when>
			<xsl:when test="@V='65'">tyggegummi</xsl:when>
			<xsl:when test="@V='66'">pipette</xsl:when>
			<xsl:when test="@V='67'">pumpetrykk</xsl:when>
			<xsl:when test="@V='68'">spray</xsl:when>
			<xsl:when test="@V='69'">instillasjon</xsl:when>
			<xsl:when test="@V='70'">mg</xsl:when>
			<xsl:when test="@V='71'">bukkalfilm</xsl:when>
			<xsl:when test="@V='72'">øyelamell</xsl:when>
			<xsl:when test="@V='74'">mikrog</xsl:when>
			<xsl:when test="@V='75'">innlegg</xsl:when>
			<xsl:when test="@V='76'">implantat</xsl:when>
			<xsl:when test="@V='77'">kompress</xsl:when>
			<xsl:when test="@V='78'">tråd</xsl:when>
			<xsl:when test="@V='79'">E</xsl:when>
			<xsl:when test="@V='80'">penn</xsl:when>
			<xsl:when test="@V='81'">hgl</xsl:when>
			<xsl:when test="@V='82'">KIU</xsl:when>
			<xsl:when test="@V='83'">sublingvalfilm</xsl:when>
			<xsl:when test="@V='84'">bukkaltablett</xsl:when>
			<xsl:when test="@V='85'">pute</xsl:when>
			<xsl:when test="@V='86'">Orale morfinekvivalenter</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7481">
		<xsl:choose>
			<xsl:when test="@V='1'">Det er utilstrekkelig med vitenskapelig dokumentasjon</xsl:when>
			<xsl:when test="@V='2'">Det er ikke forsøkt tilstrekkelig forhåndsgodkjente preparater</xsl:when>
			<xsl:when test="@V='3'">Det fremgår ikke hvilke særlige grunner som gjør at forhåndsgodkjente ikke kan benyttes</xsl:when>
			<xsl:when test="@V='4'">Det er ikke forsøkt relevante markedsførte preparater</xsl:when>
			<xsl:when test="@V='5'">Preparatet er ikke klassifisert som legemiddel</xsl:when>
			<xsl:when test="@V='6'">Preparatet det er søkt om er et reseptfritt legemiddel. Foruten enkelte angitte unntak dekkes ikke reseptfrie legemidler.</xsl:when>
			<xsl:when test="@V='7'">Behandlingen er ikke instituert av relevant spesialist</xsl:when>
			<xsl:when test="@V='8'">Søknaden kommer ikke fra relevant spesialist</xsl:when>
			<xsl:when test="@V='9'">Diagnosen omfattes hverken av en refusjonskode i §§ 2 og 3a, eller av unntaksreglene i § 3b</xsl:when>
			<xsl:when test="@V='10'">Kravet til langvarig behandling er ikke oppfylt</xsl:when>
			<xsl:when test="@V='11'">Kravet til behandling utenfor sykehus er ikke oppfylt</xsl:when>
			<xsl:when test="@V='12'">Kravet til kronisk sykdom er ikke oppfylt</xsl:when>
			<xsl:when test="@V='13'">Manglende opplysninger</xsl:when>
			<xsl:when test="@V='14'">Annet</xsl:when>
			<xsl:when test="@V='15'">Behandlingen er ikke dokumentert kostnadseffektiv</xsl:when>
			<xsl:when test="@V='16'">Vilkår for unntaksvis bruk er ikke oppfylt</xsl:when>
			<xsl:when test="@V='17'">Bruker ikke identifisert</xsl:when>
			<xsl:when test="@V='18'">Duplikat</xsl:when>
			<xsl:when test="@V='19'">Manglende medlemskap i Folketrygden</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7482">
		<xsl:choose>
			<xsl:when test="@V='J'">Søknad innvilget</xsl:when>
			<xsl:when test="@V='N'">Søknad avslått</xsl:when>
			<xsl:when test="@V='A'">Søknad er avvist (ikke behandlet av HELFO)</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7490">
		<xsl:choose>
			<xsl:when test="@V='A'">Ansvarlig farmasøyt</xsl:when>
			<xsl:when test="@V='F'">Fastlege</xsl:when>
			<xsl:when test="@V='P'">PLO-kontakt</xsl:when>
			<xsl:when test="@V='L'">LIB-ansvarlig lege</xsl:when>
			<xsl:when test="@V='R'">Rekvirent</xsl:when>
			<xsl:when test="@V='I'">Instituert av</xsl:when>
			<xsl:when test="@V='S'">Seponert av</xsl:when>
			<xsl:when test="@V='M'">Multidoseansvarlig lege</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7493">
		<xsl:choose>
			<xsl:when test="@V='1'">Varen seponeres</xsl:when>
			<xsl:when test="@V='2'">Varen seponeres ikke</xsl:when>
			<xsl:when test="@V='3'">Varen inkluderes i Legemidler i bruk (LIB)</xsl:when>
			<xsl:when test="@V='4'">Varen inkluderes ikke i Legemidler i bruk (LIB)</xsl:when>
			<xsl:when test="@V='5'">Resept er fornyet</xsl:when>
			<xsl:when test="@V='6'">Resept skal ikke fornyes</xsl:when>
			<xsl:when test="@V='7'">Svar på annet spørsmål</xsl:when>
			<xsl:when test="@V='8'">Beskjed mottatt</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7494">
		<xsl:choose>
			<xsl:when test="@V='A'">Avsluttet behandling</xsl:when>
			<xsl:when test="@V='M'">Manglende effekt</xsl:when>
			<xsl:when test="@V='L'">Legemiddelreaksjon</xsl:when>
			<xsl:when test="@V='I'">Interaksjon med annet legemiddel</xsl:when>
			<xsl:when test="@V='X'">Annen årsak</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7495">
		<xsl:choose>
			<xsl:when test="@V='1'">Skal varen seponeres</xsl:when>
			<xsl:when test="@V='2'">Skal varen inkluderes i Legemidler i bruk (LIB)</xsl:when>
			<xsl:when test="@V='3'">Skal resepten fornyes</xsl:when>
			<xsl:when test="@V='4'">Annet spørsmål</xsl:when>
			<xsl:when test="@V='5'">Beskjed fra lege</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7499">
		<xsl:choose>
			<xsl:when test="@V='1'">Finnes ikke forhåndsgodkjent legemiddel ved denne diagnosen</xsl:when>
			<xsl:when test="@V='2'">Forhåndsgodkjente preparater er ikke relevante ved denne diagnosen</xsl:when>
			<xsl:when test="@V='3'">Pasienten kan ikke benytte forhåndsgodkjente preparater på grunn av annen alvorlig diagnose</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7507">
		<xsl:choose>
			<xsl:when test="@V='1'">Finnes ikke forhåndsgodkjent eller markedsført legemiddel ved denne diagnosen  </xsl:when>
			<xsl:when test="@V='2'">Forhåndsgodkjente eller markedsførte legemidler er ikke relevante ved denne diagnosen  </xsl:when>
			<xsl:when test="@V='3'">Forhåndsgodkjent eller markedsført legemiddel er kontraindisert på grunn av annen sykdom eller annen behandling</xsl:when>
			<xsl:when test="@V='4'">Kostnadseffektivt legemiddel er kontraindisert på grunn av annen sykdom eller annen behandling</xsl:when>
			<xsl:when test="@V='5'">Forhåndsgodkjent eller markedsført legemiddel kan ikke benyttes på grunn av tungtveiende forsiktighetsregler som følge av annen sykdom eller annen behandling</xsl:when>
			<xsl:when test="@V='6'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7508">
		<xsl:choose>
			<xsl:when test="@V='1'">Genotype 1</xsl:when>
			<xsl:when test="@V='2'">Genotype 2</xsl:when>
			<xsl:when test="@V='3'">Genotype 3</xsl:when>
			<xsl:when test="@V='4'">Genotype 4</xsl:when>
			<xsl:when test="@V='5'">Genotype 5</xsl:when>
			<xsl:when test="@V='6'">Genotype 6 </xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7509">
		<xsl:choose>
			<xsl:when test="@V='1'">Risiko for leverskade </xsl:when>
			<xsl:when test="@V='2'">Moderat leverskade </xsl:when>
			<xsl:when test="@V='3'">Alvorlig leverskade i form av brodannende fibrose </xsl:when>
			<xsl:when test="@V='4'">Alvorlig leverskade i form av chirrose </xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8114">
		<xsl:choose>
			<xsl:when test="@V='A'">Vedlegg</xsl:when>
			<xsl:when test="@V='XML'">XML-instans</xsl:when>
			<xsl:when test="@V='REF'">Referanse</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8115">
		<xsl:choose>
			<xsl:when test="@V='L'">Lav</xsl:when>
			<xsl:when test="@V='N'">Normal</xsl:when>
			<xsl:when test="@V='H'">Høy</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8116">
		<xsl:choose>
			<xsl:when test="@V='FNR'">Fødselsnummer</xsl:when>
			<xsl:when test="@V='DNR'">D-nummer</xsl:when>
			<xsl:when test="@V='HNR'">H-nummer</xsl:when>
			<xsl:when test="@V='HPR'">HPR-nummer</xsl:when>
			<xsl:when test="@V='HER'">HER-id</xsl:when>
			<xsl:when test="@V='PNR'">Passnummer</xsl:when>
			<xsl:when test="@V='SEF'">Svensk 'personnummer'</xsl:when>
			<xsl:when test="@V='DKF'">Dansk 'personnummer'</xsl:when>
			<xsl:when test="@V='SSN'">Sosial security number</xsl:when>
			<xsl:when test="@V='FPN'">Forsikringspolise nummer</xsl:when>
			<xsl:when test="@V='UID'">Utenlandsk identifikasjon</xsl:when>
			<xsl:when test="@V='DUF'">DUF-nummer</xsl:when>
			<xsl:when test="@V='FHN'">Felles hjelpenummer</xsl:when>
			<xsl:when test="@V='XXX'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8117">
		<xsl:choose>
			<xsl:when test="@V='1'">Feil adressat</xsl:when>
			<xsl:when test="@V='2'">Mangelfulle opplysninger</xsl:when>
			<xsl:when test="@V='9'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8202">
		<xsl:choose>
			<xsl:when test="@V='CLIN'">Medisinsk biokjemi</xsl:when>
			<xsl:when test="@V='CT'">Computertomografi</xsl:when>
			<xsl:when test="@V='CYTO'">Cytologi</xsl:when>
			<xsl:when test="@V='HIST'">Histologi</xsl:when>
			<xsl:when test="@V='LAB'">Laboratoriemedisin</xsl:when>
			<xsl:when test="@V='MA'">Mammografi</xsl:when>
			<xsl:when test="@V='MBIO'">Mikrobiologi</xsl:when>
			<xsl:when test="@V='MR'">Magnettomografi</xsl:when>
			<xsl:when test="@V='OBD'">Obduksjon</xsl:when>
			<xsl:when test="@V='RTG'">Røntgen</xsl:when>
			<xsl:when test="@V='SCI'">Scintigrafi</xsl:when>
			<xsl:when test="@V='UL'">Ultralyd</xsl:when>
			<xsl:when test="@V='AN'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8209">
		<xsl:choose>
			<xsl:when test="@V='PRY'">Pasienten kan ikke ligge på ryggen</xsl:when>
			<xsl:when test="@V='KOM'">Kommunikasjons-problemer</xsl:when>
			<xsl:when test="@V='KLA'">Klaustrofobi</xsl:when>
			<xsl:when test="@V='AMM'">Amming</xsl:when>
			<xsl:when test="@V='GR23'">Graviditet 2. eller 3. trimester</xsl:when>
			<xsl:when test="@V='IVK'">Intravenøs kanyle med metall</xsl:when>
			<xsl:when test="@V='MFJ'">Metall som kan fjernes (klips, proteser, høreapparat, sminke, piercing, gebiss)</xsl:when>
			<xsl:when test="@V='INS'">Insulin-/morfinpumpe</xsl:when>
			<xsl:when test="@V='MPR'">Metallprotese etter kirurgi</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8210">
		<xsl:choose>
			<xsl:when test="@V='COC'">Cochleaimplantat (øre)</xsl:when>
			<xsl:when test="@V='GR1'">Graviditet 1. trimester</xsl:when>
			<xsl:when test="@V='IVK'">Intrakranielle vaskulære klips</xsl:when>
			<xsl:when test="@V='MEY'">Metallfremmedlegeme i øye</xsl:when>
			<xsl:when test="@V='NEV'">Nevrostimulator</xsl:when>
			<xsl:when test="@V='PAC'">Pacemaker elektrode</xsl:when>
			<xsl:when test="@V='NOCOC'">Ikke Cochleaimplantat (øre)</xsl:when>
			<xsl:when test="@V='NOGR1'">Ikke Graviditet 1. trimester</xsl:when>
			<xsl:when test="@V='NOIVK'">Ikke Intrakranielle vaskulære klips</xsl:when>
			<xsl:when test="@V='NOMEY'">Ikke Metallfremmedlegeme i øye</xsl:when>
			<xsl:when test="@V='NONEV'">Ikke Nevrostimulator</xsl:when>
			<xsl:when test="@V='NOPAC'">Ikke Pacemaker elektrode</xsl:when>
			<xsl:when test="@V='ANN'">Annet implantat av magnetisk materiale</xsl:when>
			<xsl:when test="@V='XXX'">Ingen kjente kontraindikasjoner</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8216">
		<xsl:choose>
			<xsl:when test="@V='VAG'">Vagina</xsl:when>
			<xsl:when test="@V='VUL'">Vulva</xsl:when>
			<xsl:when test="@V='ASC'">Ascites</xsl:when>
			<xsl:when test="@V='CVX'">Cervix</xsl:when>
			<xsl:when test="@V='ENDM'">Endometrium</xsl:when>
			<xsl:when test="@V='AN'">Annet materiale</xsl:when>
			<xsl:when test="@V='FIN'">Finnålsaspirasjon</xsl:when>
			<xsl:when test="@V='BRO'">Bronchialutstryk</xsl:when>
			<xsl:when test="@V='PLR'">Plevravæske</xsl:when>
			<xsl:when test="@V='PLRH'">Plevravæske Høyre</xsl:when>
			<xsl:when test="@V='PLRV'">Plevravæske Venstre</xsl:when>
			<xsl:when test="@V='UR'">Urin (spontan)</xsl:when>
			<xsl:when test="@V='UR1'">Urin Prøve 1</xsl:when>
			<xsl:when test="@V='UR2'">Urin Prøve 2</xsl:when>
			<xsl:when test="@V='UR3'">Urin Prøve 3</xsl:when>
			<xsl:when test="@V='EKSP'">Ekspektorat</xsl:when>
			<xsl:when test="@V='EKSP1'">Ekspektorat Prøve 1</xsl:when>
			<xsl:when test="@V='EKSP2'">Ekspektorat Prøve 2</xsl:when>
			<xsl:when test="@V='EKSP3'">Ekspektorat Prøve 3</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8217">
		<xsl:choose>
			<xsl:when test="@V='MENS'">Siste menstruasjon</xsl:when>
			<xsl:when test="@V='GRAVID'">Er gravid</xsl:when>
			<xsl:when test="@V='NOGR'">Ikke gravid</xsl:when>
			<xsl:when test="@V='DIG'">Digitalis/Vagitorier/Hormoner</xsl:when>
			<xsl:when test="@V='DESC'">Descens/Prolaps</xsl:when>
			<xsl:when test="@V='MENO'">Menopause inntrådt</xsl:when>
			<xsl:when test="@V='PPART'">Post partum</xsl:when>
			<xsl:when test="@V='PP'">P-Pille</xsl:when>
			<xsl:when test="@V='IUD'">IUD/Spiral</xsl:when>
			<xsl:when test="@V='TERMIN_EST'">Beregnet termindato</xsl:when>
			<xsl:when test="@V='TERMIN_UL'">Ultralydsatt termindato</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8218">
		<xsl:choose>
			<xsl:when test="@V='UNIO'">Unilateral oophorectomi</xsl:when>
			<xsl:when test="@V='BIO'">Bilateral oophorectomi</xsl:when>
			<xsl:when test="@V='HYST'">Hysterektomi</xsl:when>
			<xsl:when test="@V='SUP'">Supravaginal uterusamputasjon</xsl:when>
			<xsl:when test="@V='KON'">Konisering/Cervixamputasjon</xsl:when>
			<xsl:when test="@V='EL'">El.Koag./Kryo/Laser</xsl:when>
			<xsl:when test="@V='AN'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8219">
		<xsl:choose>
			<xsl:when test="@V='K'">Kromosomundersøkelse</xsl:when>
			<xsl:when test="@V='EM'">Ultrastrukturell diagnostikk</xsl:when>
			<xsl:when test="@V='FLW'">Flowcytometri</xsl:when>
			<xsl:when test="@V='PCR'">PCR-analyse</xsl:when>
			<xsl:when test="@V='H'">Hormonreseptoranalyse</xsl:when>
			<xsl:when test="@V='PL'">Ploidianalyse</xsl:when>
			<xsl:when test="@V='M'">Molekylærgenetisk undersøkelse</xsl:when>
			<xsl:when test="@V='MI'">Mikroskopisk undersøkelse</xsl:when>
			<xsl:when test="@V='A'">Histologisk undersøkelse</xsl:when>
			<xsl:when test="@V='MA'">Makroskopisk undersøkelse</xsl:when>
			<xsl:when test="@V='MAMI'">Makro- og mikroskopisk undersøkelse</xsl:when>
			<xsl:when test="@V='G'">Histologi relatert til genetisk us</xsl:when>
			<xsl:when test="@V='H1'">Vanlig obduksjon</xsl:when>
			<xsl:when test="@V='H2'">Nevropatologisk us</xsl:when>
			<xsl:when test="@V='H3'">Obduksjon + Nevropatologisk us</xsl:when>
			<xsl:when test="@V='F'">Frysesnitt - hurtigdiagnostikk</xsl:when>
			<xsl:when test="@V='BL'">Blodprøve</xsl:when>
			<xsl:when test="@V='HPV'">HPV-test</xsl:when>
			<xsl:when test="@V='C'">Cytologisk undersøkelse</xsl:when>
			<xsl:when test="@V='VC'">Væskebasert cytologi</xsl:when>
			<xsl:when test="@V='D'">Vaginal - Cervix cytologi</xsl:when>
			<xsl:when test="@V='E'">Cytologisk us (non-gyn)</xsl:when>
			<xsl:when test="@V='FNA'">Finnålsaspirasjon</xsl:when>
			<xsl:when test="@V='P'">Punksjonscytologi</xsl:when>
			<xsl:when test="@V='R'">Rescreening/Us av restmateriale</xsl:when>
			<xsl:when test="@V='RM'">Rettsmedisinsk obduksjon</xsl:when>
			<xsl:when test="@V='T'">Telepatologi</xsl:when>
			<xsl:when test="@V='GO'">Gammel obduksjon</xsl:when>
			<xsl:when test="@V='EMI'">Elektronmikroskopi</xsl:when>
			<xsl:when test="@V='MP'">Molekylærpatologisk us</xsl:when>
			<xsl:when test="@V='FISH'">FISH-analyse</xsl:when>
			<xsl:when test="@V='LKP'">Likkjellerprotokoll</xsl:when>
			<xsl:when test="@V='LP'">Likprotokoll</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8220">
		<xsl:choose>
			<xsl:when test="@V='AB'">Amphotericin B</xsl:when>
			<xsl:when test="@V='AK'">Amikacin</xsl:when>
			<xsl:when test="@V='AZ'">Azitromycin</xsl:when>
			<xsl:when test="@V='CH'">Klaritromycin</xsl:when>
			<xsl:when test="@V='CL'">Kloramfenikol</xsl:when>
			<xsl:when test="@V='CM'">Klindamycin</xsl:when>
			<xsl:when test="@V='CO'">Colistin</xsl:when>
			<xsl:when test="@V='CR'">Cefpirome</xsl:when>
			<xsl:when test="@V='EM'">Erytromycin</xsl:when>
			<xsl:when test="@V='FC'">Flucytocin</xsl:when>
			<xsl:when test="@V='FU'">Fusidin</xsl:when>
			<xsl:when test="@V='FZ'">Fluconazole</xsl:when>
			<xsl:when test="@V='MZ'">Metronidazol</xsl:when>
			<xsl:when test="@V='NA'">Nalidixin</xsl:when>
			<xsl:when test="@V='NI'">Nitrofurantoin</xsl:when>
			<xsl:when test="@V='RI'">Rifampicin</xsl:when>
			<xsl:when test="@V='SC'">Spectinomycin</xsl:when>
			<xsl:when test="@V='SU'">Sulpha</xsl:when>
			<xsl:when test="@V='TP'">Teikoplanin</xsl:when>
			<xsl:when test="@V='TR'">Trimetoprim</xsl:when>
			<xsl:when test="@V='TS'">Co-Trimoxazol</xsl:when>
			<xsl:when test="@V='VA'">Vankomycin</xsl:when>
			<xsl:when test="@V='XL'">Amoxicillin/clavulanic</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8230">
		<xsl:choose>
			<xsl:when test="@V='1'">Foreslått</xsl:when>
			<xsl:when test="@V='2'">Bestilt</xsl:when>
			<xsl:when test="@V='3'">Avtalt</xsl:when>
			<xsl:when test="@V='4'">Utsatt</xsl:when>
			<xsl:when test="@V='5'">Kansellert</xsl:when>
			<xsl:when test="@V='6'">Aktiv</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8231">
		<xsl:choose>
			<xsl:when test="@V='BG'">Begrunnelse</xsl:when>
			<xsl:when test="@V='BUP-BM'">Henvisningsgrunn barnets miljø</xsl:when>
			<xsl:when test="@V='BUP-HG'">Henvisningsgrunn barnet</xsl:when>
			<xsl:when test="@V='DIAG'">Diagnose</xsl:when>
			<xsl:when test="@V='FA'">Familie/sosialt</xsl:when>
			<xsl:when test="@V='FO'">Forløp og behandling</xsl:when>
			<xsl:when test="@V='FU'">Funn og undersøkelsesresultater</xsl:when>
			<xsl:when test="@V='HJ'">Funksjonsnivå/hjelpetiltak</xsl:when>
			<xsl:when test="@V='IP'">Informasjon til pasient/pårørende</xsl:when>
			<xsl:when test="@V='KF'">Kontroll pga. tidligere funn</xsl:when>
			<xsl:when test="@V='MAAL'">Mål for oppholdet</xsl:when>
			<xsl:when test="@V='MU'">Innkalt til masseundersøkelse</xsl:when>
			<xsl:when test="@V='PROB'">Problemstilling</xsl:when>
			<xsl:when test="@V='RU'">Rutineundersøkelse utenom masseundersøkelse</xsl:when>
			<xsl:when test="@V='SVU'">Spesialistvurdering</xsl:when>
			<xsl:when test="@V='UP'">Ubesvarte prøver</xsl:when>
			<xsl:when test="@V='UTRED'">Forventet utredning/behandling</xsl:when>
			<xsl:when test="@V='VU'">Vurdering</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8232">
		<xsl:choose>
			<xsl:when test="@V='PFP'">Profylaktisk prosedyre</xsl:when>
			<xsl:when test="@V='DI'">Diett</xsl:when>
			<xsl:when test="@V='FA'">Faste</xsl:when>
			<xsl:when test="@V='MEDB'">Medikamentell behandling</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8233">
		<xsl:choose>
			<xsl:when test="@V='H'">Hoveddiagnose</xsl:when>
			<xsl:when test="@V='B'">Bidiagnose</xsl:when>
			<xsl:when test="@V='MEDB'">Legemiddelopplysning</xsl:when>
			<xsl:when test="@V='OPIN'">Operasjon/inngrep</xsl:when>
			<xsl:when test="@V='MPRS'">Medisinsk prosedyre</xsl:when>
			<xsl:when test="@V='PRS'">Andre prosedyrer</xsl:when>
			<xsl:when test="@V='PROG'">Prognose</xsl:when>
			<xsl:when test="@V='ANAM'">Sykehistorie</xsl:when>
			<xsl:when test="@V='CAVE'">Cave-opplysninger</xsl:when>
			<xsl:when test="@V='NB'">NB-opplysninger</xsl:when>
			<xsl:when test="@V='GBEH'">Tidligere gynekologisk behandling</xsl:when>
			<xsl:when test="@V='GOPL'">Gynekologiske opplysninger</xsl:when>
			<xsl:when test="@V='OPPL'">Klinisk opplysning</xsl:when>
			<xsl:when test="@V='SYKM'">Opplysninger om sykemelding</xsl:when>
			<xsl:when test="@V='SYMP'">Symptom</xsl:when>
			<xsl:when test="@V='TB'">Tidligere behandling</xsl:when>
			<xsl:when test="@V='US'">Tidligere undersøkelse</xsl:when>
			<xsl:when test="@V='SM'">Smitte</xsl:when>
			<xsl:when test="@V='FUNN'">Funn/undersøkelsesresultat</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8234">
		<xsl:choose>
			<xsl:when test="@V='ADM'">Økonomisk/administrativ kommentar</xsl:when>
			<xsl:when test="@V='BUP-O'">Omsorgssituasjon</xsl:when>
			<xsl:when test="@V='BUP-S'">Saksbehandler for denne saken</xsl:when>
			<xsl:when test="@V='EHK'">Europeisk helsetrygdkortnummer</xsl:when>
			<xsl:when test="@V='SH'">Spesielle hensyn</xsl:when>
			<xsl:when test="@V='TEL'">Telefonnummer</xsl:when>
			<xsl:when test="@V='DIAG'">Diagnose</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8236">
		<xsl:choose>
			<xsl:when test="@V='B'">Booking</xsl:when>
			<xsl:when test="@V='R'">Rekvisisjon</xsl:when>
			<xsl:when test="@V='S'">Svar</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8238">
		<xsl:choose>
			<xsl:when test="@V='FO'">Foster</xsl:when>
			<xsl:when test="@V='DO'">Donor</xsl:when>
			<xsl:when test="@V='MO'">Mor</xsl:when>
			<xsl:when test="@V='XX'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8239">
		<xsl:choose>
			<xsl:when test="@V='EQ'">&#61;</xsl:when>
			<xsl:when test="@V='GE'">&#8805;</xsl:when>
			<xsl:when test="@V='GT'">&#62;</xsl:when>
			<xsl:when test="@V='LE'">&#8804;</xsl:when>
			<xsl:when test="@V='LT'">&#60;</xsl:when>
			<xsl:when test="@V='MG'">&#8811;</xsl:when>
			<xsl:when test="@V='ML'">&#8810;</xsl:when>
			<xsl:when test="@V='NE'">&#8800;</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8240">
		<xsl:choose>
			<xsl:when test="@V='1'">Heldøgnsopphold</xsl:when>
			<xsl:when test="@V='2'">Dagbehandling</xsl:when>
			<xsl:when test="@V='3'">Poliklinisk omsorg</xsl:when>
			<xsl:when test="@V='4'">Telemedisinsk kontakt</xsl:when>
			<xsl:when test="@V='5'">Konsultasjon</xsl:when>
			<xsl:when test="@V='6'">Telefonkontakt</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8242">
		<xsl:choose>
			<xsl:when test="@V='1'">Seksjon</xsl:when>
			<xsl:when test="@V='2'">Sengepost</xsl:when>
			<xsl:when test="@V='3'">Rom</xsl:when>
			<xsl:when test="@V='4'">Seng</xsl:when>
			<xsl:when test="@V='5'">Operasjonsstue</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8243">
		<xsl:choose>
			<xsl:when test="@V='AN'">Analyse</xsl:when>
			<xsl:when test="@V='FU'">Funn og undersøkelsesresultater</xsl:when>
			<xsl:when test="@V='GR'">Gruppe</xsl:when>
			<xsl:when test="@V='LR'">Laboratorieresultat</xsl:when>
			<xsl:when test="@V='RSB'">Resistensbestemmelse</xsl:when>
			<xsl:when test="@V='SY'">Sykmelding</xsl:when>
			<xsl:when test="@V='UP'">Ubesvarte prøver</xsl:when>
			<xsl:when test="@V='VU'">Vurdering</xsl:when>
			<xsl:when test="@V='XX'">Uspesifisert</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8244">
		<xsl:choose>
			<xsl:when test="@V='1'">Høy</xsl:when>
			<xsl:when test="@V='2'">Lav</xsl:when>
			<xsl:when test="@V='3'">Utenfor</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8245">
		<xsl:choose>
			<xsl:when test="@V='1'">Revidert</xsl:when>
			<xsl:when test="@V='2'">Foreløpig</xsl:when>
			<xsl:when test="@V='3'">Endelig</xsl:when>
			<xsl:when test="@V='4'">Tillegg</xsl:when>
			<xsl:when test="@V='5'">Henvisning registrert</xsl:when>
			<xsl:when test="@V='6'">Prosedyrer registrert/planlagt</xsl:when>
			<xsl:when test="@V='7'">Tildelt time</xsl:when>
			<xsl:when test="@V='8'">Undersøkelse gjennomført</xsl:when>
			<xsl:when test="@V='9'">Diktert</xsl:when>
			<xsl:when test="@V='10'">Skrevet (usignert svar foreligger)</xsl:when>
			<xsl:when test="@V='11'">Signert</xsl:when>
			<xsl:when test="@V='12'">Korrigert (usignert tilleggsbeskrivelse foreligger)</xsl:when>
			<xsl:when test="@V='13'">Signert korrigert/tilleggsbeskrivelse foreligger</xsl:when>
			<xsl:when test="@V='14'">Undersøkelse slettet</xsl:when>
			<xsl:when test="@V='15'">I prosess</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8246">
		<xsl:choose>
			<xsl:when test="@V='1'">Folketrygdmedlem</xsl:when>
			<xsl:when test="@V='2'">EU-borger</xsl:when>
			<xsl:when test="@V='3'">Bilateral avtale</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8247">
		<xsl:choose>
			<xsl:when test="@V='1'">Trenger ledsagelse</xsl:when>
			<xsl:when test="@V='2'">Blir ledsaget</xsl:when>
			<xsl:when test="@V='3'">Klarer seg alene</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8248">
		<xsl:choose>
			<xsl:when test="@V='1'">Utredning</xsl:when>
			<xsl:when test="@V='2'">Behandling</xsl:when>
			<xsl:when test="@V='3'">Kontroll</xsl:when>
			<xsl:when test="@V='4'">Second opinion</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8250">
		<xsl:choose>
			<xsl:when test="@V='1'">Pasienten selv</xsl:when>
			<xsl:when test="@V='2'">Pasienten og pårørende</xsl:when>
			<xsl:when test="@V='3'">Pasient og barn</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8251">
		<xsl:choose>
			<xsl:when test="@V='1'">Oppholdssted</xsl:when>
			<xsl:when test="@V='2'">Innlagt fra</xsl:when>
			<xsl:when test="@V='3'">Utskrevet til</xsl:when>
			<xsl:when test="@V='4'">Sted for hendelse</xsl:when>
			<xsl:when test="@V='5'">Skadested</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8254">
		<xsl:choose>
			<xsl:when test="@V='AHP'">Ansvarlig helsepersonell</xsl:when>
			<xsl:when test="@V='ALE'">Ansvarlig lege</xsl:when>
			<xsl:when test="@V='AMO'">Ansvarlig for medisinskfaglige opplysninger</xsl:when>
			<xsl:when test="@V='ARP'">Ansvarlig for rapport</xsl:when>
			<xsl:when test="@V='ASO'">Ansvarlig for sykepleieopplysninger</xsl:when>
			<xsl:when test="@V='AUT'">Dokumentgodkjenner</xsl:when>
			<xsl:when test="@V='BIO'">Utførende bioingeniør</xsl:when>
			<xsl:when test="@V='DLE'">Beskrivende lege</xsl:when>
			<xsl:when test="@V='FLE'">Fastlege</xsl:when>
			<xsl:when test="@V='LAB'">Utførende laboratorium</xsl:when>
			<xsl:when test="@V='OPL'">Operatør</xsl:when>
			<xsl:when test="@V='PRT'">Prøvetaker</xsl:when>
			<xsl:when test="@V='REK'">Rekvirent</xsl:when>
			<xsl:when test="@V='RSC'">Rescreener</xsl:when>
			<xsl:when test="@V='SCR'">Screener</xsl:when>
			<xsl:when test="@V='SEK'">Sekretær</xsl:when>
			<xsl:when test="@V='SLE'">Signerende lege</xsl:when>
			<xsl:when test="@V='UTF'">Utførende (uspesifisert)</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8263">
		<xsl:choose>
			<xsl:when test="@V='B'">Booking</xsl:when>
			<xsl:when test="@V='H'">Henvisning</xsl:when>
			<xsl:when test="@V='H_REHAB'">Henvisning til rehabiliteringsinstitusjon</xsl:when>
			<xsl:when test="@V='T'">Tilbakemelding på henvisning</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8264">
		<xsl:choose>
			<xsl:when test="@V='000'">Svangerskapskontroll uke 18</xsl:when>
			<xsl:when test="@V='001'">Svangerskap vurdering leie</xsl:when>
			<xsl:when test="@V='002'">Svangerskap overtidskontroll</xsl:when>
			<xsl:when test="@V='003'">CIN utredning</xsl:when>
			<xsl:when test="@V='004'">Gastroskopi</xsl:when>
			<xsl:when test="@V='005'">Utredning lyskebrokk</xsl:when>
			<xsl:when test="@V='006'">Utredning gallestein</xsl:when>
			<xsl:when test="@V='007'">Sterilisering kvinner</xsl:when>
			<xsl:when test="@V='008'">Gynekologisk spesialistvurdering</xsl:when>
			<xsl:when test="@V='009'">Vurdering eksem</xsl:when>
			<xsl:when test="@V='010'">Vurdering psoriasis</xsl:when>
			<xsl:when test="@V='011'">Utredning/behandling hudtumor</xsl:when>
			<xsl:when test="@V='012'">Coloskopi</xsl:when>
			<xsl:when test="@V='013'">Arbeids-EKG</xsl:when>
			<xsl:when test="@V='014'">Ekkokardiografi</xsl:when>
			<xsl:when test="@V='015'">Operasjon fimose</xsl:when>
			<xsl:when test="@V='016'">Operasjon hallux valgus</xsl:when>
			<xsl:when test="@V='017'">Artroskopi meniskruptur</xsl:when>
			<xsl:when test="@V='018'">Operasjon canalis carpi</xsl:when>
			<xsl:when test="@V='019'">Operasjon varicer</xsl:when>
			<xsl:when test="@V='020'">Tilpasning høreapparat</xsl:when>
			<xsl:when test="@V='021'">Vurdering sekretorisk otitt barn</xsl:when>
			<xsl:when test="@V='022'">Vurdering av nattlig enurese hos barn</xsl:when>
			<xsl:when test="@V='023'">Vurdering av bilyd på hjertet hos barn</xsl:when>
			<xsl:when test="@V='024'">Vurdering av atopisk eksem hos barn</xsl:when>
			<xsl:when test="@V='025'">Røntgen thorax</xsl:when>
			<xsl:when test="@V='026'">Røntgen over- og underekstremiteter</xsl:when>
			<xsl:when test="@V='027'">Psykiatrisk vurdering barn og ungdom</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8268">
		<xsl:choose>
			<xsl:when test="@V='ENH'">Organisasjonsnummeret i Enhetsregister</xsl:when>
			<xsl:when test="@V='RSH'">Nasjonalt register over enheter i spesialisthelsetjenesten (RESH-ID)</xsl:when>
			<xsl:when test="@V='HER'">HER-id</xsl:when>
			<xsl:when test="@V='NPR'">NPR avdelingsnummer</xsl:when>
			<xsl:when test="@V='SYS'">SYSVAK institusjonsnummer</xsl:when>
			<xsl:when test="@V='AVD'">Off. identifikator for avdelinger</xsl:when>
			<xsl:when test="@V='APO'">Apotekenes identifikasjonsnummer</xsl:when>
			<xsl:when test="@V='AKO'">Apotekenes konsesjonsnummer</xsl:when>
			<xsl:when test="@V='LIN'">Lokal identifikator for institusjoner</xsl:when>
			<xsl:when test="@V='LAV'">Lokal identifikator for avdelinger</xsl:when>
			<xsl:when test="@V='LOK'">Lokal identifikator uten nærmere angivelse</xsl:when>
			<xsl:when test="@V='HPR'">Helsepersonellnummer</xsl:when>
			<xsl:when test="@V='LOP'">Lokal identifikator for helsepersonell</xsl:when>
			<xsl:when test="@V='FHN'">Felles hjelpenummer (FH-nummer)</xsl:when>
			<xsl:when test="@V='FNR'">Norsk fødselsnummer</xsl:when>
			<xsl:when test="@V='DNR'">D-nummer</xsl:when>
			<xsl:when test="@V='HNR'">H-nummer</xsl:when>
			<xsl:when test="@V='PNR'">Passnummer</xsl:when>
			<xsl:when test="@V='SEF'">Svensk 'personnummer'</xsl:when>
			<xsl:when test="@V='DKF'">Dansk  'personnummer'</xsl:when>
			<xsl:when test="@V='SSN'">Sosial security number</xsl:when>
			<xsl:when test="@V='EHK'">Europeisk helsetrygdkortnummer</xsl:when>
			<xsl:when test="@V='FPN'">Forsikringspolise nummer</xsl:when>
			<xsl:when test="@V='DUF'">DUF-nummer</xsl:when>
			<xsl:when test="@V='XXX'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8269">
		<xsl:choose>
			<xsl:when test="@V='TA'">Telefonsvar avgitt</xsl:when>
			<xsl:when test="@V='MSIS-N'">Nominativ MSIS-melding</xsl:when>
			<xsl:when test="@V='MSIS-A'"> Anonym MSIS-melding</xsl:when>
			<xsl:when test="@V='VA'">Vesentlig avvik fra tidligere svar</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8271">
		<xsl:choose>
			<xsl:when test="@V='S'">Sensitiv</xsl:when>
			<xsl:when test="@V='I'">Intermediært følsom</xsl:when>
			<xsl:when test="@V='R'">Resistent</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8272">
		<xsl:choose>
			<xsl:when test="@V='CYT'">Cytologiprøve</xsl:when>
			<xsl:when test="@V='HIST'">Histologisk undersøkelse</xsl:when>
			<xsl:when test="@V='HPV'">HPV-test</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8273">
		<xsl:choose>
			<xsl:when test="@V='S'">Snarest</xsl:when>
			<xsl:when test="@V='B'">Etter behandling</xsl:when>
			<xsl:when test="@V='M01'">Etter 1 måned</xsl:when>
			<xsl:when test="@V='M03'">Etter 3 måneder</xsl:when>
			<xsl:when test="@V='M06'">Etter 6 måneder</xsl:when>
			<xsl:when test="@V='M12'">Etter 12 måneder</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8274">
		<xsl:choose>
			<xsl:when test="@V='1'">Tillatelse</xsl:when>
			<xsl:when test="@V='2'">Reservasjon</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8275">
		<xsl:choose>
			<xsl:when test="@V='BS'">Børste og spatel</xsl:when>
			<xsl:when test="@V='S'">Spatel</xsl:when>
			<xsl:when test="@V='A'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8278">
		<xsl:choose>
			<xsl:when test="@V='B'">Booking</xsl:when>
			<xsl:when test="@V='R'">Rekvisisjon</xsl:when>
			<xsl:when test="@V='S'">Svar</xsl:when>
			<xsl:when test="@V='RF'">Filnavn til rekvisisjon</xsl:when>
			<xsl:when test="@V='RF-DEL'">Filnavn til del av rekvisisjon</xsl:when>
			<xsl:when test="@V='RF-VED'">Filnavn til vedlegg til rekvisisjon</xsl:when>
			<xsl:when test="@V='SF'">Filnavn til svarrapport</xsl:when>
			<xsl:when test="@V='SF-DEL'">Filnavn til del av svarrapport</xsl:when>
			<xsl:when test="@V='SF-VED'">Filnavn til vedlegg til svarrapport</xsl:when>
			<xsl:when test="@V='A'">Vedlegg</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8279">
		<xsl:choose>
			<xsl:when test="@V='ADM_KOMM_KJERNEJOURNAL'">Administrativ kommunikasjon med kjernejournal</xsl:when>
			<xsl:when test="@V='APM'">Audiopedagogoppgjørsmelding</xsl:when>
			<xsl:when test="@V='APOK'">Apotek-oppgjørsmelding</xsl:when>
			<xsl:when test="@V='APPREC'">Applikasjonskvittering</xsl:when>
			<xsl:when test="@V='BEKREFT_REKVISISJON'">Bekreftelse på rekvirert tjeneste</xsl:when>
			<xsl:when test="@V='BIVIRKNING'">Melding om bivirkning</xsl:when>
			<xsl:when test="@V='CANCER_BR'">Meldeskjema brystkreft</xsl:when>
			<xsl:when test="@V='CANCER_NS'">Meldeskjema non-solide svulster</xsl:when>
			<xsl:when test="@V='CANCER_S'">Meldeskjema solide svulster</xsl:when>
			<xsl:when test="@V='DIALOG_FORESPORSEL'">Forespørsel</xsl:when>
			<xsl:when test="@V='DIALOG_AVVIK'">Avviksmelding</xsl:when>
			<xsl:when test="@V='DIALOG_NOTAT'">Notat</xsl:when>
			<xsl:when test="@V='DIALOG_OVERFORING_JOURNAL'">Overføring av journal</xsl:when>
			<xsl:when test="@V='DIALOG_SVAR'">Svar på forespørsel</xsl:when>
			<xsl:when test="@V='DIALOG_INNBYGGER_DIGITALBRUKER'">Dialog med innbygger – digital bruker</xsl:when>
			<xsl:when test="@V='DIALOG_INNBYGGER_EKONSULTASJON'">Dialog med innbygger – eKonsultasjon</xsl:when>
			<xsl:when test="@V='DIALOG_INNBYGGER_EKONTAKT'">Dialog med innbygger – eKontakt</xsl:when>
			<xsl:when test="@V='DIALOG_INNBYGGER_RESEPTFORNYELSE'">Dialog med innbygger – reseptfornyelse</xsl:when>
			<xsl:when test="@V='DIALOG_INNBYGGER_TEST'">Dialog med innbygger – test</xsl:when>
			<xsl:when test="@V='DIALOG_INNBYGGER_TIMEONSKE'">Dialog med innbygger – timeønske</xsl:when>
			<xsl:when test="@V='DIALOG_INNBYGGER_TIMERESERVASJON'">Dialog med innbygger – timereservasjon</xsl:when>
			<xsl:when test="@V='DIALOG_INNBYGGER_HL7_DOKUMENTNOTIFIKASJON'">Dialog med innbygger – dokumentnotifikasjon</xsl:when>
			<xsl:when test="@V='DIALOG_INNBYGGER_FINN_DOKUMENTER'">Dialog med innbygger – finn dokument</xsl:when>
			<xsl:when test="@V='DIALOG_INNBYGGER_HENT_DOKUMENTER'">Dialog med innbygger – hent dokument</xsl:when>
			<xsl:when test="@V='DIALOG_INNBYGGER_TIMER'">Dialog med innbygger om timer</xsl:when>
			<xsl:when test="@V='DIALOG_INNBYGGER_KOORDINATOR'">Dialog mellom innbygger og koordinator</xsl:when>
			<xsl:when test="@V='EBREV'">Elektronisk brev</xsl:when>
			<xsl:when test="@V='EbrevAbonnementStatus'">Status om abonnement</xsl:when>
			<xsl:when test="@V='EbrevForesporsel'">Forespørsel om elektronisk brev</xsl:when>
			<xsl:when test="@V='EbrevSamhandlerAdresser'">Informasjon om samhandlers adresser</xsl:when>
			<xsl:when test="@V='EgenandelForesporsel'">Forespørsel om egenandel</xsl:when>
			<xsl:when test="@V='EgenandelSvar'">Svar på forespørsel om egenandel</xsl:when>
			<xsl:when test="@V='EMOKAM'">Avslutningsmelding</xsl:when>
			<xsl:when test="@V='EMOKASK'">Automatisk saksbehandlerkvittering</xsl:when>
			<xsl:when test="@V='EMOKBM'">Basismelding</xsl:when>
			<xsl:when test="@V='EMOKE'">Ettersporring</xsl:when>
			<xsl:when test="@V='EMOKKT'">Kunnskapstilbakemelding</xsl:when>
			<xsl:when test="@V='EMOKLM'">Laringsmelding</xsl:when>
			<xsl:when test="@V='EMOKMVA'">MVAvslutningsmelding</xsl:when>
			<xsl:when test="@V='EMOKPM'">Pafyllingsmelding</xsl:when>
			<xsl:when test="@V='EPIKRISE'">Epikrise</xsl:when>
			<xsl:when test="@V='EPJ-EKSTRAKT'">Kommunikasjon av EPJ-innhold</xsl:when>
			<xsl:when test="@V='ERM1'">Resept</xsl:when>
			<xsl:when test="@V='ERM2'">Individuell søknad om refusjon til HELFO</xsl:when>
			<xsl:when test="@V='ERM3'">Grunnlag for søknad Legemiddelverket</xsl:when>
			<xsl:when test="@V='ERM41'">Forespørsel om referansenummere</xsl:when>
			<xsl:when test="@V='ERM42'">Referansenummer</xsl:when>
			<xsl:when test="@V='ERM5'">Tilbakekalling av resept</xsl:when>
			<xsl:when test="@V='ERM6'">Utleveringsrapport rekvirent</xsl:when>
			<xsl:when test="@V='ERM7'">Slettet resept i RF</xsl:when>
			<xsl:when test="@V='ERM8'">Utleveringsrapport fastlege</xsl:when>
			<xsl:when test="@V='ERM81'">Utleveringsrapport kjernejournal</xsl:when>
			<xsl:when test="@V='ERM91'">Forespørsel om tilgjengelige resepter på pasient (utleverer)</xsl:when>
			<xsl:when test="@V='ERM92'">Reseptliste (utleverer)</xsl:when>
			<xsl:when test="@V='ERM93'">Forespørsel om nedlasting av resept</xsl:when>
			<xsl:when test="@V='ERM94'">Nedlasting av resept</xsl:when>
			<xsl:when test="@V='ERM95'">Forespørsel om tilgjengelige resepter på pasient (rekvirent)</xsl:when>
			<xsl:when test="@V='ERM96'">Reseptliste (rekvirent)</xsl:when>
			<xsl:when test="@V='ERM97'">Forespørsel om utleveringer på resept</xsl:when>
			<xsl:when test="@V='ERM98'">Utleveringer på resept</xsl:when>
			<xsl:when test="@V='ERM9NA1'">Forespørsel om reseptliste fra nettkunde</xsl:when>
			<xsl:when test="@V='ERM9NA2'">Reseptliste nettkunde</xsl:when>
			<xsl:when test="@V='ERM9NA3'">Forespørsel om utvidet informasjon på resept fra nettkunde</xsl:when>
			<xsl:when test="@V='ERM9NA4'">Utvidet informasjon om resept nettkunde</xsl:when>
			<xsl:when test="@V='ERM10'">Utleveringsrapport reseptbanken</xsl:when>
			<xsl:when test="@V='ERM12'">Søknadssvar - Individuell søknad om refusjon til HELFO</xsl:when>
			<xsl:when test="@V='ERM14'">Søknad til Legemiddelverket</xsl:when>
			<xsl:when test="@V='ERM15'">Søknadssvar fra Legemiddelverket</xsl:when>
			<xsl:when test="@V='ERM18'">Oppgjørskrav</xsl:when>
			<xsl:when test="@V='ERM20'">Notifiseringsmelding</xsl:when>
			<xsl:when test="@V='ERM21'">Ekspederingsanmodning</xsl:when>
			<xsl:when test="@V='ERM22'">Oppgjørsresultat</xsl:when>
			<xsl:when test="@V='ERM23'">Utbetaling</xsl:when>
			<xsl:when test="@V='ERM241'">Samtykkeregistrering</xsl:when>
			<xsl:when test="@V='ERM242'">Svar samtykke</xsl:when>
			<xsl:when test="@V='ERM243'">Flytting av samtykker</xsl:when>
			<xsl:when test="@V='ERM244'">Endringer av samtykke i RF</xsl:when>
			<xsl:when test="@V='ERM245'">Informasjon om flytting av samtykker</xsl:when>
			<xsl:when test="@V='ERM251'">Varer i bruk</xsl:when>
			<xsl:when test="@V='ERM252'">Varer i bruk</xsl:when>
			<xsl:when test="@V='ERM253'">Varer i bruk</xsl:when>
			<xsl:when test="@V='ERM261'">Oppslag i fastlegeregister</xsl:when>
			<xsl:when test="@V='ERM262'">Svar fra fastlegeregister</xsl:when>
			<xsl:when test="@V='ERM271'">Registrering av multidoseansvarlig</xsl:when>
			<xsl:when test="@V='ERM272'">Svar på registrering av multidoseansvarlig</xsl:when>
			<xsl:when test="@V='ERM273'">Registrering av multidoseansvarlig gruppe</xsl:when>
			<xsl:when test="@V='ERM274'">Svar på registrering av multidoseansvarlig gruppe</xsl:when>
			<xsl:when test="@V='ERM28'">Endring av multidoseansvarlig lege</xsl:when>
			<xsl:when test="@V='ERM30'">FEST-meldingen</xsl:when>
			<xsl:when test="@V='ERM911'">Forespørsel om varer i bruk</xsl:when>
			<xsl:when test="@V='ERM912'">Nedlasting av varer i bruk</xsl:when>
			<xsl:when test="@V='FastlegeForesporsel'">Forespørsel om pasientens fastlege</xsl:when>
			<xsl:when test="@V='FastlegeSvar'">Svar på forespørsel om pasientens fastlege</xsl:when>
			<xsl:when test="@V='FODSELS_EPIKRISE'">Fødselsepikrise</xsl:when>
			<xsl:when test="@V='FOM'">Fysioterapeutoppgjørsmelding</xsl:when>
			<xsl:when test="@V='FRAVARSMELDING'">Fraværsmelding</xsl:when>
			<xsl:when test="@V='HELSEOPPL_SOKNAD'">Helseopplysninger</xsl:when>
			<xsl:when test="@V='HELSEOPPLYSNINGER_LEGE'">Helseopplysninger til lege</xsl:when>
			<xsl:when test="@V='HENVISNING'">Henvisning</xsl:when>
			<xsl:when test="@V='HENVISNING_BUP'">Henvisning til BUP</xsl:when>
			<xsl:when test="@V='HENVISNING_REHAB'">Henvisning til rehabiliteringsinstitusjon</xsl:when>
			<xsl:when test="@V='HODE_FOLGEBREV'">Hodemeldingen benyttet som følgebrev</xsl:when>
			<xsl:when test="@V='HOM'">Helsestasjonoppgjørsmelding</xsl:when>
			<xsl:when test="@V='INNLEGGELSESRAPPORT'">Innleggelsesrapport</xsl:when>
			<xsl:when test="@V='INNRAPPORTERING_TREKK'">Innrapportering av trekk til NAV</xsl:when>
			<xsl:when test="@V='INNRAPPORTERING_TREKK_RETUR'">Innrapportering av trekk til NAV retur</xsl:when>
			<xsl:when test="@V='IPLOS_TILBAKEMELDING'">Tilbakemelding ved IPLOS-rapportering</xsl:when>
			<xsl:when test="@V='KOM'">Kiropraktoroppgjørsmelding</xsl:when>
			<xsl:when test="@V='LEGEERKL'">Legeerklæring ved arbeidsuførhet</xsl:when>
			<xsl:when test="@V='LEGEMIDDELHANDTERING'">Legemiddelhåndtering</xsl:when>
			<xsl:when test="@V='LGM'">Logopedoppgjørsmelding</xsl:when>
			<xsl:when test="@V='LOG_INNLAGT'">Melding om innlagt pasient</xsl:when>
			<xsl:when test="@V='LOG_AVMELDING'">Avmelding av utskrivningsklar pasient</xsl:when>
			<xsl:when test="@V='LOG_DOD'">Orientering om dødsfall</xsl:when>
			<xsl:when test="@V='LOG_UTSKREVET'">Melding om utskrevet pasient</xsl:when>
			<xsl:when test="@V='LOG_UTSKRIVNINGSKLAR'">Melding om utskrivningsklar pasient</xsl:when>
			<xsl:when test="@V='LOM'">Legeoppgjørsmelding</xsl:when>
			<xsl:when test="@V='LROM'">Laboratorie- og røntgenoppgjørsmelding</xsl:when>
			<xsl:when test="@V='MEDISINSKE_OPPLYSNINGER'">Medisinske opplysninger</xsl:when>
			<xsl:when test="@V='NPR_AMK'">NPR Prehospital melding fra AMK-sentraler</xsl:when>
			<xsl:when test="@V='NPR_HKR'">NPR Melding til Hjerte-kar kvalitetsregister</xsl:when>
			<xsl:when test="@V='NPR_KJERNEMELDING'">NPR Kjernemelding</xsl:when>
			<xsl:when test="@V='NPR_KRG'">NPR Melding til Kreftregisteret</xsl:when>
			<xsl:when test="@V='NPR_PID'">NPR Personidentifikasjon</xsl:when>
			<xsl:when test="@V='NPR_PSKADE'">NPR Personskade</xsl:when>
			<xsl:when test="@V='NPR_PSKADE_ARBEID'">NPR Personskade arbeidsulykke</xsl:when>
			<xsl:when test="@V='NPR_PSKADE_PRODUKT '">NPR Personskade produktrelatert</xsl:when>
			<xsl:when test="@V='NPR_PSKADE_TRAFIKK'">NPR Personskade trafikkrelatert</xsl:when>
			<xsl:when test="@V='NPR_TSB'">NPR Tverrfaglig spesialisert behandling</xsl:when>
			<xsl:when test="@V='OOM'">Ortoptistoppgjørsmelding</xsl:when>
			<xsl:when test="@V='ORIENTERING_TJENESTETILBUD'">Orientering om tjenestetilbud</xsl:when>
			<xsl:when test="@V='Pasientliste'">Pasientliste</xsl:when>
			<xsl:when test="@V='PasientlisteAbonnementStatus'">Status på pasientliste-abonnement</xsl:when>
			<xsl:when test="@V='PasientlisteForesporsel'">Forespørsel om pasientliste</xsl:when>
			<xsl:when test="@V='PasientlisteStartAbonnement'">Start av pasientliste-abonnement</xsl:when>
			<xsl:when test="@V='PasientlisteStoppAbonnement'">Stopp av pasientliste-abonnement</xsl:when>
			<xsl:when test="@V='PASIENTREISE'">Melding om pasientreise</xsl:when>
			<xsl:when test="@V='PATIENT_FROM'">Melding fra pasient</xsl:when>
			<xsl:when test="@V='PATIENT_TO'">Melding til pasient</xsl:when>
			<xsl:when test="@V='PJM'">Privat jordmoroppgjørsmelding</xsl:when>
			<xsl:when test="@V='POM'">Poliklinisk oppgjørsmelding</xsl:when>
			<xsl:when test="@V='PROM'">Pasientreiseoppgjørsmelding</xsl:when>
			<xsl:when test="@V='PSOM'">Psykologoppgjørsmelding</xsl:when>
			<xsl:when test="@V='REQ_CYT'">Rekvisisjon-Cytologi</xsl:when>
			<xsl:when test="@V='REQ_HIST'">Rekvisisjon-Histologi</xsl:when>
			<xsl:when test="@V='REQ_KKL'">Rekvisisjon-KKL</xsl:when>
			<xsl:when test="@V='REQ_LAB'">Rekvisisjon-Laboratoriemedisin</xsl:when>
			<xsl:when test="@V='REQ_MBIO'">Rekvisisjon-Mikrobiologi</xsl:when>
			<xsl:when test="@V='REQ_RTG'">Rekvisisjon-Radiologi</xsl:when>
			<xsl:when test="@V='STATUS_REKVISISJON'">Status på rekvirert tjeneste</xsl:when>
			<xsl:when test="@V='SVAR_CYT'">Svarrapport-Cytologi</xsl:when>
			<xsl:when test="@V='SVAR_HIST'">Svarrapport-Histologi</xsl:when>
			<xsl:when test="@V='SVAR_KKL'">Svarrapport-KKL</xsl:when>
			<xsl:when test="@V='SVAR_LAB'">Svarrapport-Laboratoriemedisin</xsl:when>
			<xsl:when test="@V='SVAR_MBIO'">Svarrapport-Mikrobiologi</xsl:when>
			<xsl:when test="@V='SVAR_RTG'">Svarrapport-Radiologi</xsl:when>
			<xsl:when test="@V='SYKMELD'">Medisinsk vurdering av arbeidsmulighet ved sykdom, sykmelding</xsl:when>
			<xsl:when test="@V='TILBAKEMELD'">Tilbakemelding på henvisning</xsl:when>
			<xsl:when test="@V='TOM'">Tannlegeoppgjørsmelding</xsl:when>
			<xsl:when test="@V='TPM'">Tannpleieroppgjørsmelding</xsl:when>
			<xsl:when test="@V='TVERRFAGLIG_EPIKRISE'">Tverrfaglig epikrise</xsl:when>
			<xsl:when test="@V='VEDTAKSKJEMA_TVANG'">Vedtak om helsehjelp til person uten samtykkekompetanse som motsetter seg helsehjelpen</xsl:when>
			<xsl:when test="@V='UTSKRIVNINGSRAPPORT'">Utskrivningsrapport</xsl:when>
			<xsl:when test="@V='HENDELSEREQUEST'">Hendelse</xsl:when>
			<xsl:when test="@V='KODEVERKREQUEST'">Kodeverk</xsl:when>
			<xsl:when test="@V='SOKREQUEST'">Søk</xsl:when>
			<xsl:when test="@V='HENDELESERESPONSE'">Hendelsessvar</xsl:when>
			<xsl:when test="@V='KODEVERKRESPONSE'">Kodeverkssvar</xsl:when>
			<xsl:when test="@V='SOKRESPONSE'">Søkesvar</xsl:when>
			<xsl:when test="@V='DIALOG'">EPJhode-dialog</xsl:when>
			<xsl:when test="@V='KONSULTASJON'">Konsultasjon hos lege</xsl:when>
			<xsl:when test="@V='PASIENTLOGISTIKK'">Pasientlogistikk</xsl:when>
			<xsl:when test="@V='AMQP_SOAP_FAULT'">AMQP SOAP Fault</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8304">
		<xsl:choose>
			<xsl:when test="@V='0'">Øyeblikkelig hjelp</xsl:when>
			<xsl:when test="@V='3'">Haster</xsl:when>
			<xsl:when test="@V='PK'">Pakkeforløp kreft</xsl:when>
			<xsl:when test="@V='N'">Elektiv/normal</xsl:when>
			<xsl:when test="@V='1H'">Innen en time</xsl:when>
			<xsl:when test="@V='2H'">Innen to timer</xsl:when>
			<xsl:when test="@V='4H'">Innen fire timer</xsl:when>
			<xsl:when test="@V='8H'">Innen åtte timer</xsl:when>
			<xsl:when test="@V='1'">Innen tjuefire timer</xsl:when>
			<xsl:when test="@V='2'">Innen to døgn</xsl:when>
			<xsl:when test="@V='7'">Innen en uke</xsl:when>
			<xsl:when test="@V='14'">Innen to uker</xsl:when>
			<xsl:when test="@V='21'">Innen tre uker</xsl:when>
			<xsl:when test="@V='30'">Innen en måned</xsl:when>
			<xsl:when test="@V='90'">Innen tre måneder</xsl:when>
			<xsl:when test="@V='180'">Innen seks måneder</xsl:when>
			<xsl:when test="@V='360'">Innen tolv måneder</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8325">
		<xsl:choose>
			<xsl:when test="@V='1'">Morgen</xsl:when>
			<xsl:when test="@V='2'">Formiddag</xsl:when>
			<xsl:when test="@V='3'">Midt på dagen</xsl:when>
			<xsl:when test="@V='4'">Ettermiddag</xsl:when>
			<xsl:when test="@V='5'">Kveld</xsl:when>
			<xsl:when test="@V='6'">Natt</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8329">
		<xsl:choose>
			<xsl:when test="@V='1'">Egensøknad</xsl:when>
			<xsl:when test="@V='2'">Tidligmelding</xsl:when>
			<xsl:when test="@V='3'">Resept</xsl:when>
			<xsl:when test="@V='4'">Epikrise</xsl:when>
			<xsl:when test="@V='5'">Tverrfaglig epikrise</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8330">
		<xsl:choose>
			<xsl:when test="@V='1'">Pasient</xsl:when>
			<xsl:when test="@V='2'">Fastlege</xsl:when>
			<xsl:when test="@V='3'">Tilsynslege</xsl:when>
			<xsl:when test="@V='4'">Apotek</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8331">
		<xsl:choose>
			<xsl:when test="@V='5'">Fritekst</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8403">
		<xsl:choose>
			<xsl:when test="@V='1'">Arbeider ikke med saken</xsl:when>
			<xsl:when test="@V='2'">Rollen ikke fastlagt</xsl:when>
			<xsl:when test="@V='3'">Undersøkelser §4.3</xsl:when>
			<xsl:when test="@V='4'">Hjelpetiltak §4.4</xsl:when>
			<xsl:when test="@V='5'">Frivillig plassering §4.4</xsl:when>
			<xsl:when test="@V='6'">Undersøkelse / behandling §4.10/4.11</xsl:when>
			<xsl:when test="@V='7'">Omsorgsovertak §4.12/4.8</xsl:when>
			<xsl:when test="@V='8'">Akuttvedtak §4.6</xsl:when>
			<xsl:when test="@V='9'">Tatt foreldreansvar §4.20</xsl:when>
			<xsl:when test="@V='10'">Vet ikke</xsl:when>
			<xsl:when test="@V='11'">I helseinstitusjon uten samtykke §4.24</xsl:when>
			<xsl:when test="@V='12'">I helseinstitusjon med samtykke §4.26</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8406">
		<xsl:choose>
			<xsl:when test="@V='1'">Døgnopphold</xsl:when>
			<xsl:when test="@V='2'">Dagbehandling</xsl:when>
			<xsl:when test="@V='3'">Poliklinisk konsultasjon/kontakt</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8408">
		<xsl:choose>
			<xsl:when test="@V='1'">Bosted/arbeidssted</xsl:when>
			<xsl:when test="@V='2'">Skade- eller funnsted</xsl:when>
			<xsl:when test="@V='11'">Sykehjem/aldershjem</xsl:when>
			<xsl:when test="@V='21'">Kommunal akutt døgnenhet (KAD)</xsl:when>
			<xsl:when test="@V='99'">Sted identifisert ved rapportering av attributt 'Fra institusjon'</xsl:when>
			<xsl:when test="@V='7'">Annen (somatisk) enhet ved egen helseinstitusjon</xsl:when>
			<xsl:when test="@V='8'">Annen enhet (ikke somatikk) ved egen helseinstitusjon</xsl:when>
			<xsl:when test="@V='3'">Annen helseinstitusjon innen spesialisthelsetjenesten</xsl:when>
			<xsl:when test="@V='10'">Pasienthotell</xsl:when>
			<xsl:when test="@V='5'">Institusjon i utlandet</xsl:when>
			<xsl:when test="@V='6'">Annet/ukjent</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8417">
		<xsl:choose>
			<xsl:when test="@V='1'">Norsk</xsl:when>
			<xsl:when test="@V='2'">Annet hjemmespråk</xsl:when>
			<xsl:when test="@V='3'">To-språklig</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8419">
		<xsl:choose>
			<xsl:when test="@V='1'">Bor hos begge foreldrene</xsl:when>
			<xsl:when test="@V='2'">Pendler mellom mor og far</xsl:when>
			<xsl:when test="@V='3'">Bor hos en av foreldrene</xsl:when>
			<xsl:when test="@V='4'">En av foreldrene og samboer/ektefelle</xsl:when>
			<xsl:when test="@V='5'">Hos besteforeldre eller annen familie</xsl:when>
			<xsl:when test="@V='6'">Bor i fosterhjem</xsl:when>
			<xsl:when test="@V='7'">Bor på institusjon</xsl:when>
			<xsl:when test="@V='8'">Bor alene</xsl:when>
			<xsl:when test="@V='9'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8422">
		<xsl:choose>
			<xsl:when test="@V='1'">Biologisk mor</xsl:when>
			<xsl:when test="@V='2'">Biologisk far</xsl:when>
			<xsl:when test="@V='3'">Adoptivmor</xsl:when>
			<xsl:when test="@V='4'">Adoptivfar</xsl:when>
			<xsl:when test="@V='5'">Stemor</xsl:when>
			<xsl:when test="@V='6'">Stefar</xsl:when>
			<xsl:when test="@V='7'">Fostermor</xsl:when>
			<xsl:when test="@V='8'">Fosterfar</xsl:when>
			<xsl:when test="@V='9'">Annet, f. eks. barn av pasient</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8423">
		<xsl:choose>
			<xsl:when test="@V='1'">Norsk</xsl:when>
			<xsl:when test="@V='2'">Samisk</xsl:when>
			<xsl:when test="@V='3'">Nordisk</xsl:when>
			<xsl:when test="@V='4'">Europeisk</xsl:when>
			<xsl:when test="@V='5'">Asiatisk</xsl:when>
			<xsl:when test="@V='6'">Afrikansk</xsl:when>
			<xsl:when test="@V='7'">Latin-Amerikansk</xsl:when>
			<xsl:when test="@V='8'">Nord-Amerikansk</xsl:when>
			<xsl:when test="@V='9'">Australsk</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8431">
		<xsl:choose>
			<xsl:when test="@V='1'">Som levende</xsl:when>
			<xsl:when test="@V='2'">Som død</xsl:when>
			<xsl:when test="@V='3'">Suicid</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8432">
		<xsl:choose>
			<xsl:when test="@V='1'">Utredning</xsl:when>
			<xsl:when test="@V='2'">Behandling</xsl:when>
			<xsl:when test="@V='3'">Kontroll</xsl:when>
			<xsl:when test="@V='5'">Indirekte pasientkontakt</xsl:when>
			<xsl:when test="@V='12'">Pasientadministrert behandling</xsl:when>
			<xsl:when test="@V='13'">Opplæring</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8434">
		<xsl:choose>
			<xsl:when test="@V='1'">På egen helseinstitusjon</xsl:when>
			<xsl:when test="@V='2'">Hos ekstern instans</xsl:when>
			<xsl:when test="@V='3'">Telemedisinsk behandling (der behandlende lege er)</xsl:when>
			<xsl:when test="@V='5'">Annet ambulant sted</xsl:when>
			<xsl:when test="@V='6'">Telemedisinsk behandling (der pasienten er)</xsl:when>
			<xsl:when test="@V='4'">Hjemme hos pasienten</xsl:when>
			<xsl:when test="@V='9'">Annet sted</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8445">
		<xsl:choose>
			<xsl:when test="@V='1'">Helsehjelp er påbegynt</xsl:when>
			<xsl:when test="@V='2'">Pasienten ønsker ikke helsehjelp</xsl:when>
			<xsl:when test="@V='3'">Pasienten er henvist til et annet sykehus/institusjon (unntatt fritt sykehusvalg)</xsl:when>
			<xsl:when test="@V='4'">Pasienten har valgt annet sykehus/institusjon. Fritt sykehusvalg.</xsl:when>
			<xsl:when test="@V='5'">Pasienten mottar helsehjelp ved annet sykehus/institusjon rekvirert av HELFO</xsl:when>
			<xsl:when test="@V='9'">Annen årsak til ventetid slutt/helsehjelp uaktuelt</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8451">
		<xsl:choose>
			<xsl:when test="@V='010'">Generell kirurgi</xsl:when>
			<xsl:when test="@V='020'">Barnekirurgi (under 15 år)</xsl:when>
			<xsl:when test="@V='030'">Gastroenterologisk kirurgi</xsl:when>
			<xsl:when test="@V='040'">Karkirurgi</xsl:when>
			<xsl:when test="@V='050'">Ortopedisk kirurgi (inklusiv revmakirurgi)</xsl:when>
			<xsl:when test="@V='060'">Thoraxkirurgi (inklusiv hjertekirurgi)</xsl:when>
			<xsl:when test="@V='070'">Urologi</xsl:when>
			<xsl:when test="@V='080'">Kjevekirurgi og munnhulesykdom</xsl:when>
			<xsl:when test="@V='090'">Plastikk-kirurgi</xsl:when>
			<xsl:when test="@V='100'">Nevrokirurgi</xsl:when>
			<xsl:when test="@V='105'">Mamma- og para-/tyreoideakirurgi</xsl:when>
			<xsl:when test="@V='110'">Generell indremedisin</xsl:when>
			<xsl:when test="@V='120'">Blodsykdommer (hematologi)</xsl:when>
			<xsl:when test="@V='130'">Endokrinologi</xsl:when>
			<xsl:when test="@V='140'">Fordøyelsessykdommer</xsl:when>
			<xsl:when test="@V='150'">Hjertesykdommer</xsl:when>
			<xsl:when test="@V='160'">Infeksjonssykdommer</xsl:when>
			<xsl:when test="@V='170'">Lungesykdommer</xsl:when>
			<xsl:when test="@V='180'">Nyresykdommer</xsl:when>
			<xsl:when test="@V='190'">Revmatiske sykdommer (revmatologi)</xsl:when>
			<xsl:when test="@V='200'">Kvinnesykdommer og elektiv fødselshjelp</xsl:when>
			<xsl:when test="@V='210'">Anestesiologi</xsl:when>
			<xsl:when test="@V='220'">Barnesykdommer</xsl:when>
			<xsl:when test="@V='230'">Fysikalsk medisin og rehabilitering</xsl:when>
			<xsl:when test="@V='233'">Habilitering barn og unge</xsl:when>
			<xsl:when test="@V='234'">Habilitering voksne</xsl:when>
			<xsl:when test="@V='240'">Hud og veneriske sykdommer</xsl:when>
			<xsl:when test="@V='250'">Nevrologi</xsl:when>
			<xsl:when test="@V='260'">Klinisk nevrofysiologi</xsl:when>
			<xsl:when test="@V='290'">Øre-nese-hals sykdommer</xsl:when>
			<xsl:when test="@V='300'">Øyesykdommer</xsl:when>
			<xsl:when test="@V='310'">Psykisk helsevern barn og unge</xsl:when>
			<xsl:when test="@V='320'">Psykisk helsevern voksne</xsl:when>
			<xsl:when test="@V='330'">Yrkes- og arbeidsmedisin</xsl:when>
			<xsl:when test="@V='340'">Transplantasjon, utredning og kirurgi</xsl:when>
			<xsl:when test="@V='350'">Geriatri</xsl:when>
			<xsl:when test="@V='360'">Rus</xsl:when>
			<xsl:when test="@V='365'">LAR - Legemiddelassistert rehabilitering</xsl:when>
			<xsl:when test="@V='370'">Spillavhengighet</xsl:when>
			<xsl:when test="@V='380'">Palliativ medisin</xsl:when>
			<xsl:when test="@V='410'">Allergologi</xsl:when>
			<xsl:when test="@V='420'">Sykelig overvekt</xsl:when>
			<xsl:when test="@V='430'">Smertetilstander</xsl:when>
			<xsl:when test="@V='821'">Klinisk farmakologi</xsl:when>
			<xsl:when test="@V='822'">Medisinsk biokjemi</xsl:when>
			<xsl:when test="@V='823'">Medisinsk mikrobiologi</xsl:when>
			<xsl:when test="@V='830'">Immunologi og transfusjonsmedisin</xsl:when>
			<xsl:when test="@V='840'">Medisinsk genetikk</xsl:when>
			<xsl:when test="@V='851'">Nukleærmedisin</xsl:when>
			<xsl:when test="@V='852'">Radiologi</xsl:when>
			<xsl:when test="@V='853'">Onkologi</xsl:when>
			<xsl:when test="@V='860'">Patologi</xsl:when>
			<xsl:when test="@V='900'">Annet</xsl:when>
			<xsl:when test="@V='999'">Ukjent</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8455">
		<xsl:choose>
			<xsl:when test="@V='1'">Utredning</xsl:when>
			<xsl:when test="@V='2'">Behandling (eventuelt også inkludert videre utredning)</xsl:when>
			<xsl:when test="@V='3'">Kontroll</xsl:when>
			<xsl:when test="@V='4'">Generert for Ø-hjelpspasient</xsl:when>
			<xsl:when test="@V='5'">Friskt nyfødt barn</xsl:when>
			<xsl:when test="@V='6'">Graviditet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8522">
		<xsl:choose>
			<xsl:when test="@V='1'">Født levende</xsl:when>
			<xsl:when test="@V='2'">Dødfødt</xsl:when>
			<xsl:when test="@V='3'">Levendefødt, død etter fødsel</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8523">
		<xsl:choose>
			<xsl:when test="@V='1'">Morsmelk</xsl:when>
			<xsl:when test="@V='2'">Kombinert morsmelk/melketillegg</xsl:when>
			<xsl:when test="@V='3'">Tillegg</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8524">
		<xsl:choose>
			<xsl:when test="@V='1'">Fullamming</xsl:when>
			<xsl:when test="@V='2'">Delvis amming</xsl:when>
			<xsl:when test="@V='3'">Ammer ikke</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8525">
		<xsl:choose>
			<xsl:when test="@V='1'">Brystskjold</xsl:when>
			<xsl:when test="@V='2'">Hjelpebryst</xsl:when>
			<xsl:when test="@V='99'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8526">
		<xsl:choose>
			<xsl:when test="@V='1'">Spontan</xsl:when>
			<xsl:when test="@V='2'">Indusert</xsl:when>
			<xsl:when test="@V='3'">Sectio</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8527">
		<xsl:choose>
			<xsl:when test="@V='01'">Ingen</xsl:when>
			<xsl:when test="@V='02'">Utskjæringstang  hodeleie</xsl:when>
			<xsl:when test="@V='03'">Annen tang – hodeleie</xsl:when>
			<xsl:when test="@V='04'">Vakuumekstraktor</xsl:when>
			<xsl:when test="@V='05'">Vanlig fremhjelp – setefødsel</xsl:when>
			<xsl:when test="@V='06'">Uttrekning – setefødsel</xsl:when>
			<xsl:when test="@V='07'">Tang på etterkommende hode – setefødsel</xsl:when>
			<xsl:when test="@V='08'">Elektiv sectio</xsl:when>
			<xsl:when test="@V='09'">Akutt sectio</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8528">
		<xsl:choose>
			<xsl:when test="@V='1'">Enkeltfødsel</xsl:when>
			<xsl:when test="@V='2'">Flerfødsel</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8529">
		<xsl:choose>
			<xsl:when test="@V='PR'">Perinealrift</xsl:when>
			<xsl:when test="@V='PR1'">Perinealrift (grad 1)</xsl:when>
			<xsl:when test="@V='PR2'">Perinealrift (grad 2)</xsl:when>
			<xsl:when test="@V='PR3'">Perinealrift (grad 3)</xsl:when>
			<xsl:when test="@V='PR3a'">Perinealrift (grad 3a)</xsl:when>
			<xsl:when test="@V='PR3b'">Perinealrift (grad 3b)</xsl:when>
			<xsl:when test="@V='PR3c'">Perinealrift (grad 3c)</xsl:when>
			<xsl:when test="@V='PR4'">Perinealrift (grad 4)</xsl:when>
			<xsl:when test="@V='FR'">Fortilrift</xsl:when>
			<xsl:when test="@V='VR'">Dyp vaginalrift</xsl:when>
			<xsl:when test="@V='CR'">Cervixrift</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8530">
		<xsl:choose>
			<xsl:when test="@V='1'">Urinretensjon</xsl:when>
			<xsl:when test="@V='2'">Plager med sting/rifter</xsl:when>
			<xsl:when test="@V='3'">Plager med hemorroider</xsl:when>
			<xsl:when test="@V='9'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8531">
		<xsl:choose>
			<xsl:when test="@V='1'">Normal bakhode</xsl:when>
			<xsl:when test="@V='2'">Sete</xsl:when>
			<xsl:when test="@V='3'">Tverrleie</xsl:when>
			<xsl:when test="@V='4'">Avvikende hodefødsel</xsl:when>
			<xsl:when test="@V='9'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8624">
		<xsl:choose>
			<xsl:when test="@V='01'">Sykehus</xsl:when>
			<xsl:when test="@V='02'">Klinikk</xsl:when>
			<xsl:when test="@V='03'">Senter</xsl:when>
			<xsl:when test="@V='04'">Divisjon</xsl:when>
			<xsl:when test="@V='05'">Avdeling</xsl:when>
			<xsl:when test="@V='06'">Seksjon</xsl:when>
			<xsl:when test="@V='07'">Fagenhet</xsl:when>
			<xsl:when test="@V='08'">Post</xsl:when>
			<xsl:when test="@V='09'">Team</xsl:when>
			<xsl:when test="@V='10'">Avsnitt</xsl:when>
			<xsl:when test="@V='11'">Poliklinikk</xsl:when>
			<xsl:when test="@V='12'">Institusjon</xsl:when>
			<xsl:when test="@V='13'">Område</xsl:when>
			<xsl:when test="@V='14'">Laboratorium</xsl:when>
			<xsl:when test="@V='21'">Hotell</xsl:when>
			<xsl:when test="@V='31'">DPS</xsl:when>
			<xsl:when test="@V='41'">Tun</xsl:when>
			<xsl:when test="@V='51'">Skole</xsl:when>
			<xsl:when test="@V='61'">Privat avtalespesialist</xsl:when>
			<xsl:when test="@V='71'">Kontor</xsl:when>
			<xsl:when test="@V='72'">Ressurspool</xsl:when>
			<xsl:when test="@V='73'">Stab</xsl:when>
			<xsl:when test="@V='88'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8724">
		<xsl:choose>
			<xsl:when test="@V='1'">Ugift</xsl:when>
			<xsl:when test="@V='2'">Gift</xsl:when>
			<xsl:when test="@V='3'">Registrert partnerskap</xsl:when>
			<xsl:when test="@V='4'">Separert</xsl:when>
			<xsl:when test="@V='5'">Skilt</xsl:when>
			<xsl:when test="@V='6'">Enke/enkemann</xsl:when>
			<xsl:when test="@V='9'">Ukjent</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9033">
		<xsl:choose>
			<xsl:when test="@V='MO'">Mor</xsl:when>
			<xsl:when test="@V='FA'">Far</xsl:when>
			<xsl:when test="@V='SM '">Stemor </xsl:when>
			<xsl:when test="@V='SF '">Stefar </xsl:when>
			<xsl:when test="@V='FM '">Fostermor </xsl:when>
			<xsl:when test="@V='FF '">Fosterfar </xsl:when>
			<xsl:when test="@V='MM '">Medmor </xsl:when>
			<xsl:when test="@V='EF '">Ektefelle </xsl:when>
			<xsl:when test="@V='SA '">Samboer </xsl:when>
			<xsl:when test="@V='SI '">Søster </xsl:when>
			<xsl:when test="@V='BR '">Bror </xsl:when>
			<xsl:when test="@V='SS '">Stesøster </xsl:when>
			<xsl:when test="@V='SB '">Stebror </xsl:when>
			<xsl:when test="@V='DA '">Datter </xsl:when>
			<xsl:when test="@V='SO '">Sønn </xsl:when>
			<xsl:when test="@V='SD '">Stedatter </xsl:when>
			<xsl:when test="@V='SN '">Stesønn </xsl:when>
			<xsl:when test="@V='GM '">Bestemor </xsl:when>
			<xsl:when test="@V='GF '">Bestefar </xsl:when>
			<xsl:when test="@V='BB '">Barnebarn </xsl:when>
			<xsl:when test="@V='TO '">Foreldres søsken </xsl:when>
			<xsl:when test="@V='AS '">Annen slektning </xsl:when>
			<xsl:when test="@V='AN '">Annen foresatt </xsl:when>
			<xsl:when test="@V='AP '">Annen personlig relasjon </xsl:when>
			<xsl:when test="@V='BM  '">Biologisk mor  </xsl:when>
			<xsl:when test="@V='BF '">Biologisk far </xsl:when>
			<xsl:when test="@V='AM '">Adoptivmor </xsl:when>
			<xsl:when test="@V='AF '">Adoptivfar </xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9034">
		<xsl:choose>
			<xsl:when test="@V='3'">Behandlingsansvarlig lege</xsl:when>
			<xsl:when test="@V='4'">Journalansvarlig</xsl:when>
			<xsl:when test="@V='5'">Informasjonsansvarlig</xsl:when>
			<xsl:when test="@V='6'">Fastlege</xsl:when>
			<xsl:when test="@V='7'">Faglig ansvarlig for vedtak i psykisk helsevern</xsl:when>
			<xsl:when test="@V='8'">Koordinator Individuell plan</xsl:when>
			<xsl:when test="@V='9'">Primærkontakt</xsl:when>
			<xsl:when test="@V='10'">Utskrivende lege</xsl:when>
			<xsl:when test="@V='11'">Utskrivende sykepleier</xsl:when>
			<xsl:when test="@V='12'">Instituerende lege</xsl:when>
			<xsl:when test="@V='13'">Innleggende lege</xsl:when>
			<xsl:when test="@V='14'">Ansvarlig jordmor</xsl:when>
			<xsl:when test="@V='15'">Vikar for fastlege</xsl:when>
			<xsl:when test="@V='16'">Turnuslege</xsl:when>
			<xsl:when test="@V='17'">Forløpskoordinator kreft</xsl:when>
			<xsl:when test="@V='18'">Koordinator (spesialisthelsetjenesteloven)</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9043">
		<xsl:choose>
			<xsl:when test="@V='AD'">Andorra</xsl:when>
			<xsl:when test="@V='AE'">De forente arabiske emiratene</xsl:when>
			<xsl:when test="@V='AF'">Afghanistan</xsl:when>
			<xsl:when test="@V='AG'">Antigua og Barbuda</xsl:when>
			<xsl:when test="@V='AI'">Anguilla</xsl:when>
			<xsl:when test="@V='AL'">Albania</xsl:when>
			<xsl:when test="@V='AM'">Armenia</xsl:when>
			<xsl:when test="@V='AN'">De nederlandske Antillene</xsl:when>
			<xsl:when test="@V='AO'">Angola</xsl:when>
			<xsl:when test="@V='AQ'">Antarktis</xsl:when>
			<xsl:when test="@V='AR'">Argentina</xsl:when>
			<xsl:when test="@V='AS'">Amerikansk Samoa</xsl:when>
			<xsl:when test="@V='AT'">Østerrike</xsl:when>
			<xsl:when test="@V='AU'">Australia</xsl:when>
			<xsl:when test="@V='AW'">Aruba</xsl:when>
			<xsl:when test="@V='AX'">Åland</xsl:when>
			<xsl:when test="@V='AZ'">Aserbajdsjan</xsl:when>
			<xsl:when test="@V='BA'">Bosnia-Hercegovina</xsl:when>
			<xsl:when test="@V='BB'">Barbados</xsl:when>
			<xsl:when test="@V='BD'">Bangladesh</xsl:when>
			<xsl:when test="@V='BE'">Belgia</xsl:when>
			<xsl:when test="@V='BF'">Burkina Faso</xsl:when>
			<xsl:when test="@V='BG'">Bulgaria</xsl:when>
			<xsl:when test="@V='BH'">Bahrain</xsl:when>
			<xsl:when test="@V='BI'">Burundi</xsl:when>
			<xsl:when test="@V='BJ'">Benin</xsl:when>
			<xsl:when test="@V='BL'">Saint-Barthélemy</xsl:when>
			<xsl:when test="@V='BM'">Bermuda</xsl:when>
			<xsl:when test="@V='BN'">Brunei Darussalam</xsl:when>
			<xsl:when test="@V='BO'">Bolivia</xsl:when>
			<xsl:when test="@V='BQ'">Bonaire, Sint Eustatius og Saba</xsl:when>
			<xsl:when test="@V='BR'">Brasil</xsl:when>
			<xsl:when test="@V='BS'">Bahamas</xsl:when>
			<xsl:when test="@V='BT'">Bhutan</xsl:when>
			<xsl:when test="@V='BV'">Bouvetøya</xsl:when>
			<xsl:when test="@V='BW'">Botswana</xsl:when>
			<xsl:when test="@V='BY'">Hviterussland</xsl:when>
			<xsl:when test="@V='BZ'">Belize</xsl:when>
			<xsl:when test="@V='CA'">Canada</xsl:when>
			<xsl:when test="@V='CC'">Kokosøyene</xsl:when>
			<xsl:when test="@V='CD'">Kongo</xsl:when>
			<xsl:when test="@V='CF'">Den sentralafrikanske republikken</xsl:when>
			<xsl:when test="@V='CG'">Kongo-Brazzaville</xsl:when>
			<xsl:when test="@V='CH'">Sveits</xsl:when>
			<xsl:when test="@V='CI'">Elfenbe(i)nskysten</xsl:when>
			<xsl:when test="@V='CK'">Cookøyene</xsl:when>
			<xsl:when test="@V='CL'">Chile</xsl:when>
			<xsl:when test="@V='CM'">Kamerun</xsl:when>
			<xsl:when test="@V='CN'">Kina</xsl:when>
			<xsl:when test="@V='CO'">Colombia</xsl:when>
			<xsl:when test="@V='CR'">Costa Rica</xsl:when>
			<xsl:when test="@V='CS'">Serbia og Montenegro</xsl:when>
			<xsl:when test="@V='CU'">Cuba</xsl:when>
			<xsl:when test="@V='CV'">Kapp Verde</xsl:when>
			<xsl:when test="@V='CW'">Curaçao</xsl:when>
			<xsl:when test="@V='CX'">Christmasøya</xsl:when>
			<xsl:when test="@V='CY'">Kypros</xsl:when>
			<xsl:when test="@V='CZ'">Tsjekkia</xsl:when>
			<xsl:when test="@V='DE'">Tyskland</xsl:when>
			<xsl:when test="@V='DJ'">Djibouti</xsl:when>
			<xsl:when test="@V='DK'">Danmark</xsl:when>
			<xsl:when test="@V='DM'">Dominica</xsl:when>
			<xsl:when test="@V='DO'">Den dominikanske republikken</xsl:when>
			<xsl:when test="@V='DZ'">Algerie</xsl:when>
			<xsl:when test="@V='EC'">Ecuador</xsl:when>
			<xsl:when test="@V='EE'">Estland</xsl:when>
			<xsl:when test="@V='EG'">Egypt</xsl:when>
			<xsl:when test="@V='EH'">Vest-Sahara</xsl:when>
			<xsl:when test="@V='ER'">Eritrea</xsl:when>
			<xsl:when test="@V='ES'">Spania</xsl:when>
			<xsl:when test="@V='ET'">Etiopia</xsl:when>
			<xsl:when test="@V='FI'">Finland</xsl:when>
			<xsl:when test="@V='FJ'">Fiji</xsl:when>
			<xsl:when test="@V='FK'">Falklandsøyene</xsl:when>
			<xsl:when test="@V='FM'">Mikronesiaføderasjonen</xsl:when>
			<xsl:when test="@V='FO'">Færøyene</xsl:when>
			<xsl:when test="@V='FR'">Frankrike</xsl:when>
			<xsl:when test="@V='GA'">Gabon</xsl:when>
			<xsl:when test="@V='GB'">Storbritannia</xsl:when>
			<xsl:when test="@V='GD'">Grenada</xsl:when>
			<xsl:when test="@V='GE'">Georgia</xsl:when>
			<xsl:when test="@V='GF'">Fransk Guyana</xsl:when>
			<xsl:when test="@V='GG'">Guernsey</xsl:when>
			<xsl:when test="@V='GH'">Ghana</xsl:when>
			<xsl:when test="@V='GI'">Gibraltar</xsl:when>
			<xsl:when test="@V='GL'">Grønland</xsl:when>
			<xsl:when test="@V='GM'">Gambia</xsl:when>
			<xsl:when test="@V='GN'">Guinea</xsl:when>
			<xsl:when test="@V='GP'">Guadeloupe</xsl:when>
			<xsl:when test="@V='GQ'">Ekvatorial-Guinea</xsl:when>
			<xsl:when test="@V='GR'">Hellas</xsl:when>
			<xsl:when test="@V='GS'">Sør-Georgia og de søndre Sandwichøyene</xsl:when>
			<xsl:when test="@V='GT'">Guatemala</xsl:when>
			<xsl:when test="@V='GU'">Guam</xsl:when>
			<xsl:when test="@V='GW'">Guinea-Bissau</xsl:when>
			<xsl:when test="@V='GY'">Guyana</xsl:when>
			<xsl:when test="@V='HK'">Hong Kong</xsl:when>
			<xsl:when test="@V='HM'">Heard- og McDonaldøyene</xsl:when>
			<xsl:when test="@V='HN'">Honduras</xsl:when>
			<xsl:when test="@V='HR'">Kroatia</xsl:when>
			<xsl:when test="@V='HT'">Haiti</xsl:when>
			<xsl:when test="@V='HU'">Ungarn</xsl:when>
			<xsl:when test="@V='ID'">Indonesia</xsl:when>
			<xsl:when test="@V='IE'">Irland</xsl:when>
			<xsl:when test="@V='IL'">Israel</xsl:when>
			<xsl:when test="@V='IM'">Man</xsl:when>
			<xsl:when test="@V='IN'">India</xsl:when>
			<xsl:when test="@V='IO'">Det britiske territoriet i Indiahavet</xsl:when>
			<xsl:when test="@V='IQ'">Irak</xsl:when>
			<xsl:when test="@V='IR'">Iran</xsl:when>
			<xsl:when test="@V='IS'">Island</xsl:when>
			<xsl:when test="@V='IT'">Italia</xsl:when>
			<xsl:when test="@V='JE'">Jersey</xsl:when>
			<xsl:when test="@V='JM'">Jamaica</xsl:when>
			<xsl:when test="@V='JO'">Jordan</xsl:when>
			<xsl:when test="@V='JP'">Japan</xsl:when>
			<xsl:when test="@V='KE'">Kenya</xsl:when>
			<xsl:when test="@V='KG'">Kirgisistan</xsl:when>
			<xsl:when test="@V='KH'">Kambodsja</xsl:when>
			<xsl:when test="@V='KI'">Kiribati</xsl:when>
			<xsl:when test="@V='KM'">Komorene</xsl:when>
			<xsl:when test="@V='KN'">Saint Kitts og Nevis</xsl:when>
			<xsl:when test="@V='KP'">Nord-Korea</xsl:when>
			<xsl:when test="@V='KR'">Sør-Korea</xsl:when>
			<xsl:when test="@V='KW'">Kuwait</xsl:when>
			<xsl:when test="@V='KY'">Caymanøyene</xsl:when>
			<xsl:when test="@V='KZ'">Kasakhstan</xsl:when>
			<xsl:when test="@V='LA'">Laos</xsl:when>
			<xsl:when test="@V='LB'">Libanon</xsl:when>
			<xsl:when test="@V='LC'">Saint Lucia</xsl:when>
			<xsl:when test="@V='LI'">Liechtenstein</xsl:when>
			<xsl:when test="@V='LK'">Sri Lanka</xsl:when>
			<xsl:when test="@V='LR'">Liberia</xsl:when>
			<xsl:when test="@V='LS'">Lesotho</xsl:when>
			<xsl:when test="@V='LT'">Litauen</xsl:when>
			<xsl:when test="@V='LU'">Luxemb(o)urg</xsl:when>
			<xsl:when test="@V='LV'">Latvia</xsl:when>
			<xsl:when test="@V='LY'">Libya</xsl:when>
			<xsl:when test="@V='MA'">Marokko</xsl:when>
			<xsl:when test="@V='MC'">Monaco</xsl:when>
			<xsl:when test="@V='MD'">Moldova</xsl:when>
			<xsl:when test="@V='ME'">Montenegro</xsl:when>
			<xsl:when test="@V='MF'">Saint-Martin</xsl:when>
			<xsl:when test="@V='MG'">Madagaskar</xsl:when>
			<xsl:when test="@V='MH'">Marshalløyene</xsl:when>
			<xsl:when test="@V='MK'">Makedonia</xsl:when>
			<xsl:when test="@V='ML'">Mali</xsl:when>
			<xsl:when test="@V='MM'">Myanmar/Burma</xsl:when>
			<xsl:when test="@V='MN'">Mongolia</xsl:when>
			<xsl:when test="@V='MO'">Macao</xsl:when>
			<xsl:when test="@V='MP'">Nord-Marianene</xsl:when>
			<xsl:when test="@V='MQ'">Martinique</xsl:when>
			<xsl:when test="@V='MR'">Mauritania</xsl:when>
			<xsl:when test="@V='MS'">Montserrat</xsl:when>
			<xsl:when test="@V='MT'">Malta</xsl:when>
			<xsl:when test="@V='MU'">Mauritius</xsl:when>
			<xsl:when test="@V='MV'">Maldivene</xsl:when>
			<xsl:when test="@V='MW'">Malawi</xsl:when>
			<xsl:when test="@V='MX'">Mexico</xsl:when>
			<xsl:when test="@V='MY'">Malaysia</xsl:when>
			<xsl:when test="@V='MZ'">Mosambik</xsl:when>
			<xsl:when test="@V='NA'">Namibia</xsl:when>
			<xsl:when test="@V='NC'">Ny-Caledonia</xsl:when>
			<xsl:when test="@V='NE'">Niger</xsl:when>
			<xsl:when test="@V='NF'">Norfolkøya</xsl:when>
			<xsl:when test="@V='NG'">Nigeria</xsl:when>
			<xsl:when test="@V='NI'">Nicaragua</xsl:when>
			<xsl:when test="@V='NL'">Nederland</xsl:when>
			<xsl:when test="@V='NO'">Norge</xsl:when>
			<xsl:when test="@V='NP'">Nepal</xsl:when>
			<xsl:when test="@V='NR'">Nauru</xsl:when>
			<xsl:when test="@V='NU'">Niue</xsl:when>
			<xsl:when test="@V='NZ'">New Zealand</xsl:when>
			<xsl:when test="@V='OM'">Oman</xsl:when>
			<xsl:when test="@V='PA'">Panama</xsl:when>
			<xsl:when test="@V='PE'">Peru</xsl:when>
			<xsl:when test="@V='PF'">Fransk Polynesia</xsl:when>
			<xsl:when test="@V='PG'">Papua Ny-Guinea</xsl:when>
			<xsl:when test="@V='PH'">Filippinene</xsl:when>
			<xsl:when test="@V='PK'">Pakistan</xsl:when>
			<xsl:when test="@V='PL'">Polen</xsl:when>
			<xsl:when test="@V='PM'">Saint-Pierre og Miquelon</xsl:when>
			<xsl:when test="@V='PN'">Pitcairn</xsl:when>
			<xsl:when test="@V='PR'">Puerto Rico</xsl:when>
			<xsl:when test="@V='PS'">Det palestinske området</xsl:when>
			<xsl:when test="@V='PT'">Portugal</xsl:when>
			<xsl:when test="@V='PW'">Palau</xsl:when>
			<xsl:when test="@V='PY'">Paraguay</xsl:when>
			<xsl:when test="@V='QA'">Qatar</xsl:when>
			<xsl:when test="@V='RE'">Réunion</xsl:when>
			<xsl:when test="@V='RO'">Romania</xsl:when>
			<xsl:when test="@V='RS'">Serbia</xsl:when>
			<xsl:when test="@V='RU'">Russland</xsl:when>
			<xsl:when test="@V='RW'">Rwanda</xsl:when>
			<xsl:when test="@V='SA'">Saudi-Arabia</xsl:when>
			<xsl:when test="@V='SB'">Salomonøyene</xsl:when>
			<xsl:when test="@V='SC'">Seychellene</xsl:when>
			<xsl:when test="@V='SD'">Sudan</xsl:when>
			<xsl:when test="@V='SE'">Sverige</xsl:when>
			<xsl:when test="@V='SG'">Singapore</xsl:when>
			<xsl:when test="@V='SH'">Saint Helena</xsl:when>
			<xsl:when test="@V='SI'">Slovenia</xsl:when>
			<xsl:when test="@V='SJ'">Svalbard og Jan Mayen</xsl:when>
			<xsl:when test="@V='SK'">Slovakia</xsl:when>
			<xsl:when test="@V='SL'">Sierra Leone</xsl:when>
			<xsl:when test="@V='SM'">San Marino</xsl:when>
			<xsl:when test="@V='SN'">Senegal</xsl:when>
			<xsl:when test="@V='SO'">Somalia</xsl:when>
			<xsl:when test="@V='SR'">Surinam</xsl:when>
			<xsl:when test="@V='SS'">Sør-Sudan</xsl:when>
			<xsl:when test="@V='ST'">São Tomé og Príncipe</xsl:when>
			<xsl:when test="@V='SV'">El Salvador</xsl:when>
			<xsl:when test="@V='SX'">Sint Maarten</xsl:when>
			<xsl:when test="@V='SY'">Syria</xsl:when>
			<xsl:when test="@V='SZ'">Swaziland</xsl:when>
			<xsl:when test="@V='TC'">Turks- og Caicosøyene</xsl:when>
			<xsl:when test="@V='TD'">Tsjad</xsl:when>
			<xsl:when test="@V='TF'">De franske territoriene i sør</xsl:when>
			<xsl:when test="@V='TG'">Togo</xsl:when>
			<xsl:when test="@V='TH'">Thailand</xsl:when>
			<xsl:when test="@V='TJ'">Tadsjikistan</xsl:when>
			<xsl:when test="@V='TK'">Tokelau</xsl:when>
			<xsl:when test="@V='TL'">Øst-Timor</xsl:when>
			<xsl:when test="@V='TM'">Turkmenistan</xsl:when>
			<xsl:when test="@V='TN'">Tunisia</xsl:when>
			<xsl:when test="@V='TO'">Tonga</xsl:when>
			<xsl:when test="@V='TR'">Tyrkia</xsl:when>
			<xsl:when test="@V='TT'">Trinidad og Tobago</xsl:when>
			<xsl:when test="@V='TV'">Tuvalu</xsl:when>
			<xsl:when test="@V='TW'">Taiwan</xsl:when>
			<xsl:when test="@V='TZ'">Tanzania</xsl:when>
			<xsl:when test="@V='UA'">Ukraina</xsl:when>
			<xsl:when test="@V='UG'">Uganda</xsl:when>
			<xsl:when test="@V='UM'">De forente stater, mindre, avsidesliggende øyer</xsl:when>
			<xsl:when test="@V='US'">De forente stater (USA)</xsl:when>
			<xsl:when test="@V='UY'">Uruguay</xsl:when>
			<xsl:when test="@V='UZ'">Usbekistan</xsl:when>
			<xsl:when test="@V='VA'">Vatikanstaten</xsl:when>
			<xsl:when test="@V='VC'">Saint Vincent og Grenadinene</xsl:when>
			<xsl:when test="@V='VE'">Venezuela</xsl:when>
			<xsl:when test="@V='VG'">Jomfruøyene (Britisk)</xsl:when>
			<xsl:when test="@V='VI'">Jomfruøyene (USA)</xsl:when>
			<xsl:when test="@V='VN'">Vietnam</xsl:when>
			<xsl:when test="@V='VU'">Vanuatu</xsl:when>
			<xsl:when test="@V='WF'">Wallis- og Futunaøyene</xsl:when>
			<xsl:when test="@V='WS'">Samoa</xsl:when>
			<xsl:when test="@V='XK'">Kosovo</xsl:when>
			<xsl:when test="@V='XX'">Ukjent nasjon</xsl:when>
			<xsl:when test="@V='YE'">Jemen</xsl:when>
			<xsl:when test="@V='YT'">Mayotte</xsl:when>
			<xsl:when test="@V='YU'">Jugoslavia</xsl:when>
			<xsl:when test="@V='ZA'">Sør-Afrika</xsl:when>
			<xsl:when test="@V='ZM'">Zambia</xsl:when>
			<xsl:when test="@V='ZW'">Zimbabwe</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9050">
		<xsl:choose>
			<xsl:when test="@V='1'">Forelder/foresatt</xsl:when>
			<xsl:when test="@V='2'">Verge</xsl:when>
			<xsl:when test="@V='4'">Tilsynsfører</xsl:when>
			<xsl:when test="@V='5'">Støttekontakt</xsl:when>
			<xsl:when test="@V='6'">Fremtidsfullmektig</xsl:when>
			<xsl:when test="@V='3'">Hjelpeverge</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9051">
		<xsl:choose>
			<xsl:when test="@V='ENH'">Org. nummer</xsl:when>
			<xsl:when test="@V='RSH'">RESH-id</xsl:when>
			<xsl:when test="@V='HER'">HER-id</xsl:when>
			<xsl:when test="@V='NPR'">NPR avdelingsnummer</xsl:when>
			<xsl:when test="@V='AVD'">Off. avd. id</xsl:when>
			<xsl:when test="@V='SYS'">SYSVAK institusjonsnummer</xsl:when>
			<xsl:when test="@V='APO'">Apotekets identifikasjonsnummer</xsl:when>
			<xsl:when test="@V='AKO'">Apotekets konsesjonsnummer</xsl:when>
			<xsl:when test="@V='LIN'">Lokal inst. id</xsl:when>
			<xsl:when test="@V='LAV'">Lokal avd. id</xsl:when>
			<xsl:when test="@V='LOK'">Lokal id</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9057">
		<xsl:choose>
			<xsl:when test="@V='1'">Forfatter</xsl:when>
			<xsl:when test="@V='2'">Medforfatter</xsl:when>
			<xsl:when test="@V='3'">Godkjent av</xsl:when>
			<xsl:when test="@V='4'">Forelagt</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9060">
		<xsl:choose>
			<xsl:when test="@V='AA'">Ambulansearbeider</xsl:when>
			<xsl:when test="@V='AT'">Apotektekniker</xsl:when>
			<xsl:when test="@V='AU'">Audiograf</xsl:when>
			<xsl:when test="@V='BI'">Bioingeniør</xsl:when>
			<xsl:when test="@V='ET'">Ergoterapeut</xsl:when>
			<xsl:when test="@V='FA1'">Provisorfarmasøyt</xsl:when>
			<xsl:when test="@V='FA2'">Reseptarfarmasøyt</xsl:when>
			<xsl:when test="@V='FO'">Fotterapeut</xsl:when>
			<xsl:when test="@V='FT'">Fysioterapeut</xsl:when>
			<xsl:when test="@V='HE'">Helsesekretær</xsl:when>
			<xsl:when test="@V='HF'">Helsefagarbeider</xsl:when>
			<xsl:when test="@V='HP'">Hjelpepleier</xsl:when>
			<xsl:when test="@V='JO'">Jordmor</xsl:when>
			<xsl:when test="@V='KE'">Klinisk ernæringsfysiolog</xsl:when>
			<xsl:when test="@V='KI'">Kiropraktor</xsl:when>
			<xsl:when test="@V='LE'">Lege</xsl:when>
			<xsl:when test="@V='OA'">Omsorgsarbeider</xsl:when>
			<xsl:when test="@V='OI'">Ortopedingeniør</xsl:when>
			<xsl:when test="@V='OP'">Optiker</xsl:when>
			<xsl:when test="@V='OR'">Ortoptist</xsl:when>
			<xsl:when test="@V='PE'">Perfusjonist</xsl:when>
			<xsl:when test="@V='PS'">Psykolog</xsl:when>
			<xsl:when test="@V='RA'">Radiograf</xsl:when>
			<xsl:when test="@V='SP'">Sykepleier</xsl:when>
			<xsl:when test="@V='TH'">Tannhelsesekretær</xsl:when>
			<xsl:when test="@V='TL'">Tannlege</xsl:when>
			<xsl:when test="@V='TP'">Tannpleier</xsl:when>
			<xsl:when test="@V='TT'">Tanntekniker</xsl:when>
			<xsl:when test="@V='VP'">Vernepleier</xsl:when>
			<xsl:when test="@V='XX'">Ukjent/uspesifisert</xsl:when>
			<xsl:when test="@V='MT'">Manuellterapeut</xsl:when>
			<xsl:when test="@V='VE'">Veterinær</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9061">
		<xsl:choose>
			<xsl:when test="@V='HP'">Hovedtelefon</xsl:when>
			<xsl:when test="@V='MC'">Mobiltelefon</xsl:when>
			<xsl:when test="@V='HV'">Ferietelefon</xsl:when>
			<xsl:when test="@V='F'">Fax</xsl:when>
			<xsl:when test="@V='PG'">Personsøker</xsl:when>
			<xsl:when test="@V='AS'">Telefonsvarer</xsl:when>
			<xsl:when test="@V='WC'">Arbeidsplass, sentralbord</xsl:when>
			<xsl:when test="@V='WP'">Arbeidsplass</xsl:when>
			<xsl:when test="@V='WD'">Arbeidsplass, direktenummer</xsl:when>
			<xsl:when test="@V='EC'">Nødnummer</xsl:when>
			<xsl:when test="@V='H'">Hjemme eller ukjent</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9065">
		<xsl:choose>
			<xsl:when test="@V='1'">Spørsmål om å få oversendt hele journalen</xsl:when>
			<xsl:when test="@V='2'">Spørsmål om å få overført en eller flere kategorier opplysninger i journalen</xsl:when>
			<xsl:when test="@V='3'">Spørsmål om mottaker har ønske om å få tilsendt hele journalen eller flere opplysninger enn det det er spurt om</xsl:when>
			<xsl:when test="@V='4'">Spørsmål om mottaker kan motta et sett av journaler for deponering</xsl:when>
			<xsl:when test="@V='5'">Fritekst</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9066">
		<xsl:choose>
			<xsl:when test="@V='B1.99'">Annet</xsl:when>
			<xsl:when test="@V='B1.01.4'">Sammendrag</xsl:when>
			<xsl:when test="@V='J2.03'">Melding ved venerisk sykdom</xsl:when>
			<xsl:when test="@V='J2.02'">Tuberkulosemelding</xsl:when>
			<xsl:when test="@V='I9'">Annet</xsl:when>
			<xsl:when test="@V='B1.03'">Sluttnotat</xsl:when>
			<xsl:when test="@V='B1.01.3'">Somatisk undersøkelse (status presens)</xsl:when>
			<xsl:when test="@V='J1.01'">Sykemeldinger</xsl:when>
			<xsl:when test="@V='A9'">Annet</xsl:when>
			<xsl:when test="@V='C5'">Mikrobiologi</xsl:when>
			<xsl:when test="@V='B1.04'">Operasjonsbeskrivelser</xsl:when>
			<xsl:when test="@V='J5.01'">Egenerklæring/krav om utskriving, og lignende</xsl:when>
			<xsl:when test="@V='A0.03'">Reservasjoner, ønsker</xsl:when>
			<xsl:when test="@V='B1'">Løpende journal</xsl:when>
			<xsl:when test="@V='J7.02'">Obduksjonsrapport</xsl:when>
			<xsl:when test="@V='J7.01'">Dødsattest, melding til dødsårsaksregisteret</xsl:when>
			<xsl:when test="@V='J5.05'">Steriliseringserklæring</xsl:when>
			<xsl:when test="@V='B1.01.1'">Anamnese</xsl:when>
			<xsl:when test="@V='J2.01'">Melding til kreftregisteret</xsl:when>
			<xsl:when test="@V='C6'">Hematologi</xsl:when>
			<xsl:when test="@V='C7'">Fertilitet og arv</xsl:when>
			<xsl:when test="@V='A0.02'">Blodtype - vevstype</xsl:when>
			<xsl:when test="@V='C9'">Diverse</xsl:when>
			<xsl:when test="@V='C2'">Patologiske/anatomiske us.</xsl:when>
			<xsl:when test="@V='A1'">Personalia</xsl:when>
			<xsl:when test="@V='C3'">Immunologi</xsl:when>
			<xsl:when test="@V='J5.04'">Abortskjema</xsl:when>
			<xsl:when test="@V='J1.02'">Legeerklæring ved arbeidsuførhet</xsl:when>
			<xsl:when test="@V='B1.01'">Innkomstjournal</xsl:when>
			<xsl:when test="@V='C4'">Klinisk farmakologi</xsl:when>
			<xsl:when test="@V='J7'">Melding om dødsfall</xsl:when>
			<xsl:when test="@V='E1'">Røntgenopptak og liknende</xsl:when>
			<xsl:when test="@V='B1.02'">Kontinuasjonsark</xsl:when>
			<xsl:when test="@V='A0.01'">Cave</xsl:when>
			<xsl:when test="@V='J1.99'">Andre meldinger til NAV</xsl:when>
			<xsl:when test="@V='C1'">Klinisk kjemi</xsl:when>
			<xsl:when test="@V='A3'">Egne epikriser</xsl:when>
			<xsl:when test="@V='A0'">Kritisk informasjon</xsl:when>
			<xsl:when test="@V='F3'">Undersøkelsesplan</xsl:when>
			<xsl:when test="@V='F2'">Særskilte obs.skjemaer</xsl:when>
			<xsl:when test="@V='F1'">Kurveark</xsl:when>
			<xsl:when test="@V='E4'">Fotografier</xsl:when>
			<xsl:when test="@V='E3'">Scintigrafi</xsl:when>
			<xsl:when test="@V='I3'">Annenhåndsvurderinger</xsl:when>
			<xsl:when test="@V='E2'">Ultralyd</xsl:when>
			<xsl:when test="@V='I2'">Eksterne henvisninger</xsl:when>
			<xsl:when test="@V='A6'">Pasientorientering</xsl:when>
			<xsl:when test="@V='J3.02'">Fylkeslegen (ved personskade)</xsl:when>
			<xsl:when test="@V='A2'">Kontaktoversikt</xsl:when>
			<xsl:when test="@V='J5.03'">Krav om journalutlevering/innsyn</xsl:when>
			<xsl:when test="@V='J2.04'">Melding til folkehelsa (MSIS/SYSVAK)</xsl:when>
			<xsl:when test="@V='J3.01'">Bivirkningsnemda</xsl:when>
			<xsl:when test="@V='J3.04'">Norsk pasientskadeerstatning</xsl:when>
			<xsl:when test="@V='B2'">Resultat av/svar på interne henvisninger</xsl:when>
			<xsl:when test="@V='J5.02'">Samtykke til avvik fra taushetsplikt</xsl:when>
			<xsl:when test="@V='B1.01.2'">Medikamenter</xsl:when>
			<xsl:when test="@V='A4'">Andres epikriser</xsl:when>
			<xsl:when test="@V='I4'">Div. brev og brevkopier</xsl:when>
			<xsl:when test="@V='J1'">Offentlige blanketter</xsl:when>
			<xsl:when test="@V='J2'">Tilpliktede meldinger ved sykdom</xsl:when>
			<xsl:when test="@V='J3.99'">Annet</xsl:when>
			<xsl:when test="@V='J3'">Melding om uhell/skader/bivirkninger</xsl:when>
			<xsl:when test="@V='J6'">Komparentopplysninger</xsl:when>
			<xsl:when test="@V='J4'">Melding til frivillige registre i forbindelse med fødsel</xsl:when>
			<xsl:when test="@V='J5'">Pasientsamtykker/erklæringer/krav</xsl:when>
			<xsl:when test="@V='I1'">Innleggelsessøknader</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9067">
		<xsl:choose>
			<xsl:when test="@V='1'">Øyeblikkelig hjelp</xsl:when>
			<xsl:when test="@V='2'">Gjelder pågående helsehjelp</xsl:when>
			<xsl:when test="@V='3'">Innen 24 timer</xsl:when>
			<xsl:when test="@V='9'">Ubestemt</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9068">
		<xsl:choose>
			<xsl:when test="@V='1'">Ny pasient, journal skal opprettes</xsl:when>
			<xsl:when test="@V='2'">Helsehjelp til pasient som har journal</xsl:when>
			<xsl:when test="@V='9'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9069">
		<xsl:choose>
			<xsl:when test="@V='1'">De etterspurte opplysningene er inkludert i meldingen</xsl:when>
			<xsl:when test="@V='2'">Forespørselen avvist uten begrunnelse</xsl:when>
			<xsl:when test="@V='3'">Har ikke ønskede opplysninger</xsl:when>
			<xsl:when test="@V='4'">Kan ikke besvares. Krever pasientens samtykke</xsl:when>
			<xsl:when test="@V='5'">Svar på forespørsel</xsl:when>
			<xsl:when test="@V='9'">Annet, svar angitt i fritekst</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9080">
		<xsl:choose>
			<xsl:when test="@V='1'">Vekt</xsl:when>
			<xsl:when test="@V='2'">Alder</xsl:when>
			<xsl:when test="@V='3'">Kroppsoverflate</xsl:when>
			<xsl:when test="@V='9'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9082">
		<xsl:choose>
			<xsl:when test="@V='1'">Mandag</xsl:when>
			<xsl:when test="@V='2'">Tirsdag</xsl:when>
			<xsl:when test="@V='3'">Onsdag</xsl:when>
			<xsl:when test="@V='4'">Torsdag</xsl:when>
			<xsl:when test="@V='5'">Fredag</xsl:when>
			<xsl:when test="@V='6'">Lørdag</xsl:when>
			<xsl:when test="@V='7'">Søndag</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9083">
		<xsl:choose>
			<xsl:when test="@V='1'">Inntatt i sin helhet</xsl:when>
			<xsl:when test="@V='2'">Delvis inntatt</xsl:when>
			<xsl:when test="@V='3'">Nektet inntatt</xsl:when>
			<xsl:when test="@V='4'">Ikke gitt</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9090">
		<xsl:choose>
			<xsl:when test="@V='%'">prosent</xsl:when>
			<xsl:when test="@V='% w/v'">prosent gitt som vekt per volum</xsl:when>
			<xsl:when test="@V='% w/w'">prosent gitt som vekt per vekt</xsl:when>
			<xsl:when test="@V='(ikke angitt)'">ikke angitt</xsl:when>
			<xsl:when test="@V='10E10 bakterier'">10 opphøyd i 10'ende bakterier </xsl:when>
			<xsl:when test="@V='10E9 bakterier '">10 opphøyd i 9'ende bakterier </xsl:when>
			<xsl:when test="@V='antigen enheter'">antigen enheter</xsl:when>
			<xsl:when test="@V='anti-heparin IE'">anti-heparin internasjonale enheter</xsl:when>
			<xsl:when test="@V='CCID50'">Cell Culture Infective Dose 50% </xsl:when>
			<xsl:when test="@V='cfu'">colony forming units</xsl:when>
			<xsl:when test="@V='D-antigen enheter'">Enheter av smittsomme poliovirus </xsl:when>
			<xsl:when test="@V='E'">enheter</xsl:when>
			<xsl:when test="@V='ELISA E'">ELISA-enheter</xsl:when>
			<xsl:when test="@V='ELISA RU'">relative ELISA-enheter </xsl:when>
			<xsl:when test="@V='g'">gram</xsl:when>
			<xsl:when test="@V='g Ca'">gram kalsium</xsl:when>
			<xsl:when test="@V='g N'">gram nitrogen</xsl:when>
			<xsl:when test="@V='GBq'">gigabequerel</xsl:when>
			<xsl:when test="@V='HEP'">Histaminekvivalenter basert på prikktesting</xsl:when>
			<xsl:when test="@V='IE'">internasjonale enheter</xsl:when>
			<xsl:when test="@V='IE anti-Xa'">internasjonale enheter antistoff</xsl:when>
			<xsl:when test="@V='IU'">international units</xsl:when>
			<xsl:when test="@V='kBq'">kilobequerel</xsl:when>
			<xsl:when test="@V='kg'">kilogram</xsl:when>
			<xsl:when test="@V='KIU'">kallidinogenase inactivator unit </xsl:when>
			<xsl:when test="@V='kJ'">kilojoule</xsl:when>
			<xsl:when test="@V='LD50 enheter'">den statistisk bestemte dødelige dosen hos 50 % av dyrene </xsl:when>
			<xsl:when test="@V='MBq'">megabequerel</xsl:when>
			<xsl:when test="@V='mg'">milligram</xsl:when>
			<xsl:when test="@V='mg Ca'">milligram kalsium</xsl:when>
			<xsl:when test="@V='mg F'">milligram fluor</xsl:when>
			<xsl:when test="@V='mg Fe'">milligram jern</xsl:when>
			<xsl:when test="@V='mg FNE'">milligram fenytoinnatriumekvivalenter </xsl:when>
			<xsl:when test="@V='mg I'">milligram iod</xsl:when>
			<xsl:when test="@V='mg K'">milligram kalium</xsl:when>
			<xsl:when test="@V='mg Mg'">milligram magnesium (ion)</xsl:when>
			<xsl:when test="@V='mg Zn'">milligram sink</xsl:when>
			<xsl:when test="@V='mikrog'">mikrogram</xsl:when>
			<xsl:when test="@V='mikrog HA'">mikrogram haemagglutinin</xsl:when>
			<xsl:when test="@V='mikroliter'">mikroliter</xsl:when>
			<xsl:when test="@V='mikromol'">mikromol</xsl:when>
			<xsl:when test="@V='mill E'">millioner enheter</xsl:when>
			<xsl:when test="@V='mill IE'">millioner internasjonale enheter</xsl:when>
			<xsl:when test="@V='ml'">milliliter</xsl:when>
			<xsl:when test="@V='mmol'">millimol</xsl:when>
			<xsl:when test="@V='mmol Li'">millimol Litium</xsl:when>
			<xsl:when test="@V='mol'">mol</xsl:when>
			<xsl:when test="@V='PFU'">plaque forming units</xsl:when>
			<xsl:when test="@V='PhEur. enheter'">enheter etter standard i den europeiske farmakope</xsl:when>
			<xsl:when test="@V='ppm (mol pr. mol)'">parts per million beregnet som mol/mol</xsl:when>
			<xsl:when test="@V='SA.U'">tilstrekkelig mengde til å oppnå et titer av agglutinerende antistoff på 1 log10 i marsvin</xsl:when>
			<xsl:when test="@V='SN.U'">titer av serumnøytraliserende antistoff fra vaksinasjon av marsvin</xsl:when>
			<xsl:when test="@V='SQ-E'">standardiserte kvalitetsenheter</xsl:when>
			<xsl:when test="@V='SQ-T'">standardiserte kvalitetsenheter for tablett</xsl:when>
			<xsl:when test="@V='IC'">konsentrasjonsindeks</xsl:when>
			<xsl:when test="@V='Normal'">normal</xsl:when>
			<xsl:when test="@V='IR'">reaktivitetsindeks</xsl:when>
			<xsl:when test="@V='OMEQ'">Orale morfinekvivalenter</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9101">
		<xsl:choose>
			<xsl:when test="@V='1'">Fast</xsl:when>
			<xsl:when test="@V='2'">Kur</xsl:when>
			<xsl:when test="@V='3'">Ved behov</xsl:when>
			<xsl:when test="@V='4'">Vaksine</xsl:when>
			<xsl:when test="@V='5'">Næringsmiddel/vitaminer</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9103">
		<xsl:choose>
			<xsl:when test="@V='1'">Legemiddeldosering inngår ikke i en multidose</xsl:when>
			<xsl:when test="@V='2'">Legemiddeldosering inngår i multidose og informasjon er sendt til leverandør</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9104">
		<xsl:choose>
			<xsl:when test="@V='1'">Originalforskrivning</xsl:when>
			<xsl:when test="@V='2'">Seponering</xsl:when>
			<xsl:when test="@V='3'">Utlevert legemiddel</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9111">
		<xsl:choose>
			<xsl:when test="@V='1'">Sosial deltakelse</xsl:when>
			<xsl:when test="@V='2'">Skaffe seg varer og tjenester</xsl:when>
			<xsl:when test="@V='3'">Beslutninger i dagliglivet</xsl:when>
			<xsl:when test="@V='4'">Ivareta egen helse</xsl:when>
			<xsl:when test="@V='5'">Bevege seg innendørs</xsl:when>
			<xsl:when test="@V='6'">Alminnelig husarbeid</xsl:when>
			<xsl:when test="@V='7'">Personlig hygiene</xsl:when>
			<xsl:when test="@V='8'">På- og avkledning</xsl:when>
			<xsl:when test="@V='9'">Lage mat</xsl:when>
			<xsl:when test="@V='10'">Spise</xsl:when>
			<xsl:when test="@V='11'">Toalett</xsl:when>
			<xsl:when test="@V='12'">Bevege seg utendørs</xsl:when>
			<xsl:when test="@V='13'">Syn</xsl:when>
			<xsl:when test="@V='14'">Hørsel</xsl:when>
			<xsl:when test="@V='15'">Hukommelse</xsl:when>
			<xsl:when test="@V='16'">Kommunikasjon</xsl:when>
			<xsl:when test="@V='17'">Styre atferd</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9113">
		<xsl:choose>
			<xsl:when test="@V='1'">Lesebriller</xsl:when>
			<xsl:when test="@V='2'">Avstandsbriller</xsl:when>
			<xsl:when test="@V='3'">Databriller</xsl:when>
			<xsl:when test="@V='4'">Progressive briller</xsl:when>
			<xsl:when test="@V='5'">Lupebriller</xsl:when>
			<xsl:when test="@V='6'">Kikkertbriller</xsl:when>
			<xsl:when test="@V='7'">Filterbriller</xsl:when>
			<xsl:when test="@V='8'">Kontaktlinser</xsl:when>
			<xsl:when test="@V='99'">Uspesifisert hjelpemiddel for syn</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9114">
		<xsl:choose>
			<xsl:when test="@V='1'">Høreapparat</xsl:when>
			<xsl:when test="@V='2'">Implantat</xsl:when>
			<xsl:when test="@V='9'">Uspesifisert hjelpemiddel for hørsel</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9121">
		<xsl:choose>
			<xsl:when test="@V='1'">Pasient innlagt</xsl:when>
			<xsl:when test="@V='2'">Pasient utskrevet</xsl:when>
			<xsl:when test="@V='3'">Pasient utskrivningsklar</xsl:when>
			<xsl:when test="@V='4'">Avmelding av utskrivningsklar pasient</xsl:when>
			<xsl:when test="@V='13'">Pasienten er død</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9131">
		<xsl:choose>
			<xsl:when test="@V='1'">Vurdering av funksjonsnivå</xsl:when>
			<xsl:when test="@V='2'">Forskrivning av legemiddel</xsl:when>
			<xsl:when test="@V='3'">Utarbeiding av sykepleiesammenfatning</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9132">
		<xsl:choose>
			<xsl:when test="@V='1'">Fornyelse av resept hos fastlege</xsl:when>
			<xsl:when test="@V='2'">Innkjøp/henting av legemiddel på apotek</xsl:when>
			<xsl:when test="@V='3'">Oppbevaring av legemiddel</xsl:when>
			<xsl:when test="@V='4'">Vurdering av når legemiddel skal tas</xsl:when>
			<xsl:when test="@V='5'">Istandgjøring og kontroll av legemiddel</xsl:when>
			<xsl:when test="@V='6'">Overlevering av legemiddel</xsl:when>
			<xsl:when test="@V='7'">Overlevering og kontroll av at legemiddel blir anvendt</xsl:when>
			<xsl:when test="@V='8'">Hyppighet av sykepleiefaglig gjennomgang av legemiddelbruk</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9135">
		<xsl:choose>
			<xsl:when test="@V='1'">Enkeltdose</xsl:when>
			<xsl:when test="@V='2'">Dosett</xsl:when>
			<xsl:when test="@V='3'">Multidose</xsl:when>
			<xsl:when test="@V='8'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9136">
		<xsl:choose>
			<xsl:when test="@V='1'">Forberedelser til insulininjeksjon</xsl:when>
			<xsl:when test="@V='2'">Injeksjon av insulin</xsl:when>
			<xsl:when test="@V='3'">Oppfølging av marevanbehandling</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9137">
		<xsl:choose>
			<xsl:when test="@V='2'">Statusrapport</xsl:when>
			<xsl:when test="@V='3'">Ønske om legevurdering</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9138">
		<xsl:choose>
			<xsl:when test="@V='1'">Rapport etter konsultasjon</xsl:when>
			<xsl:when test="@V='4'">Svar på forespørsel</xsl:when>
			<xsl:when test="@V='5'">Opplysninger til søknad</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9139">
		<xsl:choose>
			<xsl:when test="@V='11'">Utskrivningsrapport</xsl:when>
			<xsl:when test="@V='12'">Fødselsepikrise</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9140">
		<xsl:choose>
			<xsl:when test="@V='1'"> Varsel om innlagt pasient</xsl:when>
			<xsl:when test="@V='2'"> Oppdaterte opplysninger</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9141">
		<xsl:choose>
			<xsl:when test="@V='1'">Innkomststatus</xsl:when>
			<xsl:when test="@V='7'">Sykepleiediagnose</xsl:when>
			<xsl:when test="@V='8'">Sykepleiesammenfatning</xsl:when>
			<xsl:when test="@V='12'">Status ved utskrivning</xsl:when>
			<xsl:when test="@V='13'">Pasientens egne vurderinger</xsl:when>
			<xsl:when test="@V='14'">Praktiske opplysninger</xsl:when>
			<xsl:when test="@V='88'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9142">
		<xsl:choose>
			<xsl:when test="@V='PROB'">Aktuell problemstilling</xsl:when>
			<xsl:when test="@V='FO'">Forløp og behandling</xsl:when>
			<xsl:when test="@V='FU'">Funn og undersøkelsesresultat</xsl:when>
			<xsl:when test="@V='FA'">Familie/sosialt</xsl:when>
			<xsl:when test="@V='SYKM'">Sykmelding</xsl:when>
			<xsl:when test="@V='VU'">Vurdering</xsl:when>
			<xsl:when test="@V='UTRED'">Forventet/ønsket undersøkelser/behandling</xsl:when>
			<xsl:when test="@V='HJ'">Funksjonsnivå/hjelpetiltak</xsl:when>
			<xsl:when test="@V='IP'">Informasjon til pasient/pårørende</xsl:when>
			<xsl:when test="@V='TS'">Tidligere sykdommer</xsl:when>
			<xsl:when test="@V='OP'">Planer for videre oppfølging</xsl:when>
			<xsl:when test="@V='AAI'">Årsak til innleggelse</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9146">
		<xsl:choose>
			<xsl:when test="@V='1'">Henvisning til utredning/behandling</xsl:when>
			<xsl:when test="@V='2'">Viderehenvisning før rettighetsvurdering</xsl:when>
			<xsl:when test="@V='3'">Viderehenvisning etter rettighetsvurdering</xsl:when>
			<xsl:when test="@V='4'">Henvisning til videre behandling i forløp</xsl:when>
			<xsl:when test="@V='5'">Intern henvisning i forløp</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9147">
		<xsl:choose>
			<xsl:when test="@V='1'">Ansiennitetsdato</xsl:when>
			<xsl:when test="@V='2'">Vurderingsdato</xsl:when>
			<xsl:when test="@V='3'">Frist for nødvendig helsehjelp</xsl:when>
			<xsl:when test="@V='4'">Ventetid sluttdato</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9151">
		<xsl:choose>
			<xsl:when test="@V='1'">[Hjemmetjenester:] Praktisk bistand: daglige gjøremål</xsl:when>
			<xsl:when test="@V='2'">[Hjemmetjenester:] Praktisk bistand - opplæring - daglige gjøremål</xsl:when>
			<xsl:when test="@V='3'">[Hjemmetjenester:] Praktisk bistand: brukerstyrt - personlig assistanse</xsl:when>
			<xsl:when test="@V='4'">[Hjemmetjenester:] Dagaktivitetstilbud</xsl:when>
			<xsl:when test="@V='5'">[Hjemmetjenester:] Matombringing</xsl:when>
			<xsl:when test="@V='6'">[Hjemmetjenester:] Trygghetsalarm</xsl:when>
			<xsl:when test="@V='15'">[Hjemmetjenester:] Helsetjenester i hjemmet</xsl:when>
			<xsl:when test="@V='7'">[Hjemmetjenester:] Avlastning - utenfor institusjon</xsl:when>
			<xsl:when test="@V='9'">[Hjemmetjenester:] Støttekontakt</xsl:when>
			<xsl:when test="@V='11'">[Hjemmetjenester:] Omsorgslønn</xsl:when>
			<xsl:when test="@V='16'">[Hjemmetjenester:] Re-/habilitering utenfor institusjon</xsl:when>
			<xsl:when test="@V='26'">[Hjemmetjenester:] Varslings- og lokaliseringsteknologi (GPS)</xsl:when>
			<xsl:when test="@V='12'">[Bolig:] Omsorgsbolig</xsl:when>
			<xsl:when test="@V='13'">[Bolig:] Annen bolig</xsl:when>
			<xsl:when test="@V='18'">[Institusjonstjenester:] Tidsbegrenset opphold - utredning/behandling</xsl:when>
			<xsl:when test="@V='19'">[Institusjonstjenester:] Tidsbegrenset opphold - habilitering/rehabilitering</xsl:when>
			<xsl:when test="@V='20'">[Institusjonstjenester:] Tidsbegrenset opphold - annet</xsl:when>
			<xsl:when test="@V='8'">[Institusjonstjenester:] Avlastning - i institusjon</xsl:when>
			<xsl:when test="@V='17'">[Institusjonstjenester:] Dagopphold i institusjon</xsl:when>
			<xsl:when test="@V='22'">[Institusjonstjenester:] Nattopphold i institusjon</xsl:when>
			<xsl:when test="@V='21'">[Institusjonstjenester:] Langtidsopphold i institusjon</xsl:when>
			<xsl:when test="@V='25'">[Institusjonstjenester:]Kommunal øyeblikkelig hjelp - døgnopphold</xsl:when>
			<xsl:when test="@V='23'">[Bruk av tvang:] Skadeavvergende tiltak i nødssituasjoner</xsl:when>
			<xsl:when test="@V='14'">[Bruk av tvang:] Planlagte tiltak</xsl:when>
			<xsl:when test="@V='24'">[Bruk av tvang:] Helsehjelp med tvang</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9152">
		<xsl:choose>
			<xsl:when test="@V='1'">Helseopplysninger</xsl:when>
			<xsl:when test="@V='4'">Legemiddelopplysninger</xsl:when>
			<xsl:when test="@V='6'">Fornye resept(er).</xsl:when>
			<xsl:when test="@V='7'">Time til undersøkelse/behandling</xsl:when>
			<xsl:when test="@V='8'">Status/plan for utskrivning</xsl:when>
			<xsl:when test="@V='99'">Annen henvendelse</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9153">
		<xsl:choose>
			<xsl:when test="@V='3'">Tjenestetilbud</xsl:when>
			<xsl:when test="@V='5'">Tilstandsvurdering</xsl:when>
			<xsl:when test="@V='99'">Annen henvendelse</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9154">
		<xsl:choose>
			<xsl:when test="@V='1'">Helseopplysninger</xsl:when>
			<xsl:when test="@V='4'">Legemiddelopplysninger</xsl:when>
			<xsl:when test="@V='8'">Status/plan om utskrivning</xsl:when>
			<xsl:when test="@V='99'">Annen henvendelse</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9205">
		<xsl:choose>
			<xsl:when test="@V='01'">Erstatter tidligere versjon</xsl:when>
			<xsl:when test="@V='11'">Se også</xsl:when>
			<xsl:when test="@V='L1'">Erstatter referert forskrivning (doseendring)</xsl:when>
			<xsl:when test="@V='L2'">Erstatter referert forskrivning (annet legemiddel)</xsl:when>
			<xsl:when test="@V='L3'">Referert forskrivning seponeres</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9206">
		<xsl:choose>
			<xsl:when test="@V='1'">Tidligere versjon uten relevans for framtidig helsehjelp</xsl:when>
			<xsl:when test="@V='2'">Tilleggsopplysninger uten særlig relevans for framtidig helsehjelp</xsl:when>
			<xsl:when test="@V='5'">Tilleggsopplysninger som kan være relevante i forbindelse framtidig helsehjelp</xsl:when>
			<xsl:when test="@V='9'">Tilleggsopplysninger som er helt nødvendige for forståelsen av dokumentasjonen</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9502">
		<xsl:choose>
			<xsl:when test="@V='I'">Innsynsrett i journal</xsl:when>
			<xsl:when test="@V='O'">Rutiner for overføring av journalinformasjon</xsl:when>
			<xsl:when test="@V='V'">Vaksinasjonsprogram og Sysvak</xsl:when>
			<xsl:when test="@V='R'">Retten til å motsette seg at helsepersonell får tilgang til informasjon i journalen uten eksplisitt samtykke</xsl:when>
			<xsl:when test="@V='K'">Klageadgang</xsl:when>
			<xsl:when test="@V='G'">Generelt om samtykke (til behandling)</xsl:when>
			<xsl:when test="@V='A'">Annet</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9513">
		<xsl:choose>
			<xsl:when test="@V='D'">Delt</xsl:when>
			<xsl:when test="@V='M'">Mor</xsl:when>
			<xsl:when test="@V='F'">Far</xsl:when>
			<xsl:when test="@V='A'">Andre</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9536">
		<xsl:choose>
			<xsl:when test="@V='1'">Smerte</xsl:when>
			<xsl:when test="@V='2'">Bevegelsesevne</xsl:when>
			<xsl:when test="@V='3'">Naturlige funksjoner</xsl:when>
			<xsl:when test="@V='4'">Daglige gjøremål</xsl:when>
			<xsl:when test="@V='5'">Angst/depresjon</xsl:when>
			<xsl:when test="@V='6'">Pleie og omsorg</xsl:when>
			<xsl:when test="@V='7'">Barns vekst og utvikling</xsl:when>
			<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>