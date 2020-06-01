<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="yes" method="text" indent="yes"/>
    <xsl:param name="baseurl"></xsl:param>
    <xsl:param name="commandprefix"></xsl:param>
    <xsl:param name="action"></xsl:param>
    <xsl:param name="stdout"></xsl:param>
    <xsl:param name="amp">&amp;</xsl:param>
    <xsl:param name="sq">'</xsl:param>
    <xsl:param name="cr" select="codepoints-to-string(13)"/>
    <xsl:param name="lf" select="codepoints-to-string(10)"/>
    <xsl:param name="crlf" select="concat($cr,$lf)"/>
    <xsl:param name="re">^(https?://)?([^/]+)?(/[^\?]*)(\?*.*)$</xsl:param>
    <xsl:param name="cookiefile">cookies.txt</xsl:param>
    <xsl:param name="wfpayload">python3 -c 'from wfuzz.wfuzz import main_filter; main_filter()'</xsl:param>
    <xsl:param name="wfencode">python3 -c 'from wfuzz.wfuzz import main_encoder; main_encoder()'</xsl:param>
    <xsl:param name="boundary">A-----------------------------------affe</xsl:param>

    <xsl:template match="/session[not(child::req[@tool!='raw'])]" priority="3">
        <xsl:apply-templates select="req"/>
    </xsl:template>

    <xsl:template match="/session" priority="2">
        <xsl:value-of select="concat('#!/bin/bash',$lf)"/>
        <xsl:if test="not(@newcookies=('false','no','off','0'))">
        <xsl:value-of select="
            concat('rm -f ',$cookiefile,'; touch ',$cookiefile,$lf)		[current()/child::req[@tool=('curl','wget')]]
            ,concat('rm -f ','WFUZZP?',$lf)					[current()/child::req[@tool=('wfuzz')]]
        "/>
        </xsl:if>
        <xsl:apply-templates select="req"/>
    </xsl:template>


    <xsl:template match="//req[@tool='raw']" priority="3">
        <xsl:variable name="verb" select="upper-case(form[1]/@method)"/>
        <xsl:variable name="url">
            <xsl:call-template name="action"><xsl:with-param name="formaction" select="form[1]/@action"/></xsl:call-template>
        </xsl:variable>
        <xsl:variable name="context" select="
            replace($url,$re,'$3$4')[$verb=('GET','HEAD')]
            ,replace($url,$re,'$3')[not($verb=('GET','HEAD'))]
        "/>
        <xsl:value-of select="concat($verb,' ',$context,' ',upper-case(@protocol),$crlf)"/>
        <xsl:apply-templates select="header"/>
        <xsl:apply-templates select="auth"/>
        <xsl:apply-templates select="self::*" mode="cookie"><xsl:with-param name="tool" select="@tool"/></xsl:apply-templates>
        <xsl:apply-templates select="form"/>
    </xsl:template>

    <xsl:template match="//req" priority="2">
        <xsl:variable name="verb" select="upper-case(form[1]/@method)"/>
        <xsl:variable name="tool" select="lower-case(@tool)"/>
        <xsl:variable name="url"><xsl:call-template name="action"><xsl:with-param name="formaction" select="form[1]/@action"/></xsl:call-template></xsl:variable>
	<xsl:value-of select="string-join(('echo ------------------------------------------------------------',$tool,$verb,concat($sq,$url,$sq),':',$lf),' ')"/>
        <xsl:if test="@confirm=('true','yes','on','1')"><xsl:call-template name="confirm"><xsl:with-param name="action" select="$tool"/></xsl:call-template></xsl:if>
        <xsl:value-of select="concat('http_proxy=',/session/@proxy,' ')     [current()/@useproxy=('true','yes','on','1')  and  not(starts-with($url,'https'))  and  $tool='wget']"/>
        <xsl:value-of select="concat('https_proxy=',/session/@proxy,' ')    [current()/@useproxy=('true','yes','on','1')  and      starts-with($url,'https')   and  $tool='wget']"/>
	<xsl:value-of select="concat($commandprefix,$tool,concat('_',@toolversion)[current()/attribute::toolversion],' \',$lf)"/>
        <xsl:apply-templates select="@useproxy"><xsl:with-param name="tool" select="$tool"/></xsl:apply-templates>
        <xsl:value-of select="
            concat('--include \',$lf)                       [$tool='curl']
            ,concat('-c \',$lf)                              [$tool='wfuzz']
            ,concat('--server-response \',$lf)              [$tool='wget']
        "/>
        <xsl:apply-templates select="self::*" mode="extraswitch"></xsl:apply-templates>
        <xsl:if test="@verbose=('true','yes','on','1')"><xsl:value-of select="concat('--verbose \',$lf)[$tool=('curl','wget')],concat('-v \',$lf)[$tool=('wfuzz')]"/></xsl:if>
        <xsl:value-of select="concat('-s ',@delay,' \',$lf) [current()/attribute::delay  and  $tool='wfuzz']"/>
        <xsl:if test="attribute::head  and  $tool='curl'"><xsl:value-of select="concat('--silent \',$lf)"/></xsl:if>
        <xsl:value-of select="
            concat('--trace - \',$lf) [current()/@debug=('true','yes','on','1')  and  $tool='curl']
            ,concat('--debug \',$lf)  [current()/@debug=('true','yes','on','1')  and  $tool='wget']
        "/>
        <xsl:value-of select="
            concat('--output-document ',$stdout,' 2&gt;&amp;1',' \',$lf)     [$tool='wget'  and  $stdout!='']
            ,concat('--output-document ',../@stdout,' 2&gt;&amp;1',' \',$lf)              [$tool='wget'  and  $stdout=''  and  current()/parent::*/attribute::stdout]
        "/>
        <xsl:apply-templates select="payload"><xsl:with-param name="tool" select="$tool"/></xsl:apply-templates>
        <xsl:apply-templates select="filter"><xsl:with-param name="tool" select="$tool"/></xsl:apply-templates>
        <xsl:value-of select="
            concat('--request ',$verb,' \',$lf) [$tool='curl']
            ,concat('--method ',$verb,' \',$lf) [$tool='wget'  and  not($verb=('GET','POST'))]
            ,concat('-X ',$verb,' \',$lf)       [$tool='wfuzz']
        "/>
        <xsl:value-of select="
            concat('--http1.0',' \',$lf)  [current()/@protocol='http/1.0'  and  $tool='curl']
            ,concat('--http1.1',' \',$lf) [current()/@protocol='http/1.1'  and  $tool='curl']
        "/>
        <xsl:apply-templates select="header"><xsl:with-param name="tool" select="$tool"/></xsl:apply-templates>
        <xsl:apply-templates select="auth"><xsl:with-param name="tool" select="$tool"/></xsl:apply-templates>
        <xsl:value-of select="
            concat('--cookie ',$cookiefile,' \',$lf)        [$tool='curl'  and  not(current()/@protocol=('ftp'))]
            ,concat('--load-cookies ',$cookiefile,' \',$lf) [$tool='wget'  and  not(current()/@protocol=('ftp'))]
        "/>
        <xsl:value-of select="
            concat('--cookie-jar ',$cookiefile,' \',$lf)                           [$tool='curl'  and  not(current()/@protocol=('ftp'))]
            ,concat('--oF WFUZZP',count(preceding-sibling::req)+1,' \',$lf)        [$tool='wfuzz'  and  current()/following-sibling::req[child::payload[@type='wfuzzp']]]
            ,concat('--save-cookies ',$cookiefile,' --keep-session-cookies \',$lf) [$tool='wget'  and  not(current()/@protocol=('ftp'))]
        "/>		<!-- write a session file named WFUZZP in case a following request will want to read from it -->
        <xsl:apply-templates select="self::*" mode="cookie"><xsl:with-param name="tool" select="$tool"/></xsl:apply-templates>
        <xsl:if test="starts-with($url,'https')"><xsl:apply-templates select="self::*" mode="tls"><xsl:with-param name="tool" select="$tool"/></xsl:apply-templates></xsl:if>
        <xsl:apply-templates select="form"/>
        <xsl:choose>
                <xsl:when test="$verb=('GET','FUZZ','HEAD')">
                        <xsl:variable name="querystring"><xsl:apply-templates select="form" mode="querystring"/></xsl:variable>
                        <xsl:value-of select="concat('$',$sq,string-join(($url,$querystring[$querystring!='']),'?'))"/>
                        <xsl:value-of select="concat($sq,' \',$lf)"/>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:value-of select="concat('$',$sq,$url,$sq,' \',$lf)"/>
                </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="attribute::head"><xsl:value-of select="concat('| head -n ',@head,' \',$lf)"/></xsl:if>
        <xsl:if test="attribute::grep"><xsl:value-of select="concat('| grep -E ',$sq,@grep,$sq,' \',$lf)"/></xsl:if>
        <xsl:if test="attribute::grepv"><xsl:value-of select="concat('| grep -vE ',$sq,@grepv,$sq,' \',$lf)"/></xsl:if>
        <xsl:value-of select="concat('',$lf)"/>
    </xsl:template>

    <xsl:template match="//req" mode="extraswitch" priority="2">
        <xsl:for-each select="extraswitch">
            <xsl:value-of select="concat(@name,' ',@value,' \',$lf)"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="//req" mode="cookie" priority="2">
        <xsl:param name="tool"/>
        <xsl:variable name="tmp">
            <xsl:for-each select="cookie">
                <xsl:value-of select="';'"/><xsl:value-of select="string-join((@name,@value),'=')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="cookies" select="string-join(tokenize($tmp,';')[.!=''],'; ')"/>
        <xsl:value-of select="
            concat('Cookie: ',$cookies,$crlf)                          [$cookies!=''  and  $tool=('raw')]
            ,concat('--header ',$sq,'Cookie: ',$cookies,$sq,' \',$lf)  [$cookies!=''  and  $tool=('wget')]
            ,concat('-b ',$sq,$cookies,$sq,' \',$lf)                   [$cookies!=''  and  $tool=('curl','wfuzz')]
        "/>
    </xsl:template>

    <xsl:template match="//req" mode="tls" priority="2">
        <xsl:param name="tool"/>
        <xsl:variable name="re">^(...)v(\d)([\._])?(\d)?$</xsl:variable>
        <xsl:variable name="protocol" select="
            lower-case(replace(@securityprotocol,$re,'$1'))      [current()/attribute::securityprotocol  and $tool='curl']
            ,upper-case(replace(@securityprotocol,$re,'$1'))     [current()/attribute::securityprotocol  and $tool='wget']
        "/>
        <xsl:variable name="version_up" select="replace(@securityprotocol,$re,'$2')"/>
        <xsl:variable name="version_separator" select="
            translate(replace(@securityprotocol,$re,'$3'),'_','.')                 [$tool='curl']
            ,translate(replace(@securityprotocol,$re,'$3'),'.','_')                [$tool='wget']
        "/>
        <xsl:variable name="version_low" select="replace(@securityprotocol,$re,'$4')"/>
        <xsl:variable name="securityprotocol">
            <xsl:value-of select="
                concat($protocol,'v',$version_up,$version_separator,$version_low)            [$protocol  and $tool='curl']
                ,concat($protocol,'v',$version_up,$version_separator,$version_low)           [$protocol  and $tool='wget' and not($version_low = '0')]
                ,concat($protocol,'v',$version_up)                                           [$protocol  and $tool='wget' and     $version_low = '0' ]
            "/>
        </xsl:variable>
        <xsl:value-of select="
            concat('--',$securityprotocol,' \',$lf)                                        [$securityprotocol!=''  and  $tool='curl']
            ,concat('--tls-max ',$version_up,$version_separator,$version_low,' \',$lf)     [$securityprotocol!=''  and  $tool='curl']
            ,concat('--secure-protocol=',$securityprotocol,' \',$lf)                       [$securityprotocol!=''  and  $tool='wget']
            ,concat('--ssl-no-revoke --insecure',' \',$lf)                                 [current()/@insecure=('true','yes','on','1')  and  $tool='curl']
            ,concat('--no-check-certificate',' \',$lf)                                     [current()/@insecure=('true','yes','on','1')  and  $tool='wget']
        "/>
    </xsl:template>


    <xsl:template match="header[parent::req[@tool='raw']]" priority="3">
        <xsl:value-of select="string-join((@name,@value),': ')"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>

    <xsl:template match="header" priority="2">
        <xsl:param name="tool"/>
        <xsl:value-of select="
            concat('--header ',$sq) [$tool=('curl','wget')]
            ,concat('-H ',$sq)      [$tool=('wfuzz')]
        "/>
        <xsl:value-of select="string-join((@name,@value),': ')"/>
        <xsl:value-of select="concat($sq,' \',$lf)"/>
    </xsl:template>

    <xsl:template match="@useproxy" priority="2">
        <xsl:param name="tool"/>
        <xsl:if test=".=('true','yes','on','1')">
            <xsl:value-of select="
                concat('--proxy ',/session/@proxy,' \',$lf)                                                    [$tool='curl']
                ,concat('-p ',replace(/session/@proxy,'^((https?)://)?([^/]+)(/[^\?]*)?$','$3'),' \',$lf)      [$tool='wfuzz']
            "/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="auth" priority="2">
        <xsl:param name="tool"/>
        <xsl:value-of select="
            concat('--',@type,' \',$lf)                            [$tool=('curl')   and  current()/@type=('basic','digest','ntlm')]
            ,concat('--',@type)                                    [$tool=('wfuzz')  and  current()/@type=('basic','digest','ntlm')]
            ,concat('--auth-no-challenge \',$lf)                   [$tool=('wget')   and  current()/@type=('basic')]
        "/>
        <xsl:value-of select="
            concat('--user ',$sq,@username,$sq)                    [$tool=('curl')]
            ,concat(' ',$sq,@username,$sq)                         [$tool=('wfuzz')]
            ,concat('--user=',$sq,@username,$sq,' \',$lf)          [$tool=('wget')]
        "/>
        <xsl:value-of select="
            concat(':',$sq,@password,$sq,' \',$lf)                 [$tool=('curl')]
            ,concat(':',$sq,@password,$sq,' \',$lf)                [$tool=('wfuzz')]
            ,concat('--password=',$sq,@password,$sq,' \',$lf)      [$tool=('wget')]
        "/>
    </xsl:template>

    <xsl:template match="filter" priority="2">
        <xsl:param name="tool"/>
        <xsl:if test="$tool='wfuzz'">
            <xsl:value-of select="
                '--h'         [current()/@type='hide']
                ,'--s'        [current()/@type='show']
                ,'--filter ' [current()/@type='formula']
            "/>
            <xsl:value-of select="
                'c '   [current()/@category='code']
                ,'h '  [current()/@category=('char','chars')]
                ,'l '  [current()/@category=('line','lines')]
                ,'s '  [current()/@category=('regex','regexp')]
                ,'w '  [current()/@category=('word','words')]
            "/>
            <xsl:value-of select="concat($sq,@value,$sq)"/>
            <xsl:value-of select="concat(' \',$lf)"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="payload" priority="2">
        <xsl:param name="tool"/>
        <xsl:if test="$tool='wfuzz'">
            <!--<xsl:variable name="switches" select="
                concat('-z ',@type)
                ,concat('- -zD ',$sq,@fn,$sq)
                ,concat('- -zE ',@encoder)   [current()/attribute::encoder]
                ,concat('-m ',@iterator)    [current()/attribute::iterator]
            "/>-->
            <xsl:variable name="switches" select="
                @type
                ,@fn
                ,@encoder               [current()/attribute::encoder]
            "/>
            <xsl:value-of select="'-z '"/>
            <xsl:choose>
                <xsl:when test="@type='wfuzzp'  and  attribute::field">
                    <xsl:value-of select="concat('file,`f=$(mktemp); ',$wfpayload,' -z ')"/>		<!-- backticks -->
                    <xsl:value-of select="concat($sq,@type,',',@fn,$sq)"/>
                    <xsl:value-of select="concat(' --field &quot;',@field,'&quot;')"/>
                    <xsl:value-of select="' | grep -vE &quot;^$|^Warning:&quot;'"/>
                    <xsl:value-of select="concat(' | xargs ',$wfencode,' -d ',@decoder)		[current()/attribute::decoder]"/>
                    <xsl:value-of select="' | grep -vE &quot;^$|^Warning:&quot;'		[current()/attribute::decoder]"/>
                    <xsl:value-of select="'>$f; echo -n $f`'"/>						<!-- /backticks -->
                    <xsl:value-of select="concat(',',@encoder)					[current()/attribute::encoder]"/>
                    <xsl:value-of select="concat(' --slice &quot;',@slice,'&quot;')    [current()/attribute::slice]"/>	<!-- slice code can contain single quotes -->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($sq,string-join($switches,','),$sq)"/>
                    <xsl:value-of select="concat(' --slice &quot;',@slice,'&quot;')    [current()/attribute::slice]"/>	<!-- slice code can contain single quotes -->
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="concat(' -m ',@iterator)    [current()/attribute::iterator  and  current()/preceding-sibling::payload]"/>
            <xsl:value-of select="concat(' \',$lf)"/>
        </xsl:if>
    </xsl:template>


    <xsl:template match="//form[parent::req[@tool='raw']]" priority="3">
        <xsl:variable name="verb" select="upper-case(@method)"/>
        <xsl:variable name="enctype" select="lower-case(@enctype)"/>
        <xsl:variable name="url">
            <xsl:call-template name="action"><xsl:with-param name="formaction" select="@action"/></xsl:call-template>
        </xsl:variable>
        <xsl:variable name="host" select="replace($url,$re,'$2')"/>
        <xsl:value-of select="concat('Host: ',$host,$crlf)"/>
        <xsl:value-of select="
            concat('Content-Type: ',@enctype,$crlf)                               [current()/attribute::enctype  and  not(current()/@enctype='multipart/form-data')]
            ,concat('Content-Type: ',@enctype,'; boundary=',$boundary,$crlf)      [current()/attribute::enctype  and      current()/@enctype='multipart/form-data']
        "/>
        <xsl:value-of select="$crlf"/>
        <xsl:if test="not($verb=('GET','HEAD'))">
            <xsl:variable name="body">
                <xsl:choose>
                    <xsl:when test="$enctype=('application/ipp','application/octet-stream')">
                    	<xsl:value-of select="text()"/>
                    </xsl:when>
                    <xsl:when test="$enctype=('application/xml','application/soap+xml','text/xml')">
                        <xsl:text><![CDATA[<?xml version="1.0" encoding="utf-8" standalone="yes"?>]]></xsl:text>
                        <xsl:value-of select="text()" disable-output-escaping="yes"/>
                    </xsl:when>
                    <xsl:when test="$enctype=('application/x-www-form-urlencoded')">
                        <xsl:apply-templates select="self::*" mode="querystring"/>
                    </xsl:when>
                    <xsl:when test="$enctype=('multipart/form-data')">
                        <xsl:apply-templates select="self::*" mode="multipart-formdata"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="self::*" mode="copybody"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="$body"/>
            <xsl:value-of select="$crlf"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="//form" priority="2">
        <xsl:variable name="verb" select="upper-case(@method)"/>
        <xsl:variable name="enctype" select="lower-case(@enctype)"/>
        <xsl:variable name="tool" select="lower-case(parent::req/@tool)"/>
        <xsl:variable name="url">
            <xsl:call-template name="action"><xsl:with-param name="formaction" select="@action"/></xsl:call-template>
        </xsl:variable>
        <xsl:variable name="host" select="replace($url,$re,'$2')"/>
        <xsl:if test="not(parent::req/child::header[@name='Host'])  and  not(parent::req/@protocol=('ftp'))">
            <xsl:variable name="hostheader" as="node()"><header name="Host" value="{$host}"/></xsl:variable>
            <xsl:apply-templates select="$hostheader"><xsl:with-param name="tool" select="$tool"/></xsl:apply-templates>
        </xsl:if>
        <xsl:if test="attribute::enctype">
            <xsl:variable name="enctypeheader" as="node()"><header name="Content-Type"><xsl:attribute name="value" select="
                $enctype                                   [not($enctype='multipart/form-data' and not($tool=('curl')))]
                ,concat($enctype,'; boundary=',$boundary)  [    $enctype='multipart/form-data' and not($tool=('curl')) ]
            "/></header></xsl:variable>
            <xsl:apply-templates select="$enctypeheader"><xsl:with-param name="tool" select="$tool"/></xsl:apply-templates>
        </xsl:if>
        <xsl:variable name="body">
            <xsl:choose>
                <xsl:when test="$enctype=('application/ipp','application/octet-stream')">
                    <xsl:value-of select="text()"/>
                </xsl:when>
                <xsl:when test="$enctype=('application/xml','application/soap+xml','text/xml')">
                    <xsl:text><![CDATA[<?xml version="1.0" encoding="utf-8" standalone="yes"?>]]></xsl:text>
                    <xsl:value-of select="text()" disable-output-escaping="yes"/>
                </xsl:when>
                <xsl:when test="$enctype=('application/x-www-form-urlencoded')">
                    <xsl:apply-templates select="self::*" mode="querystring"/>
                </xsl:when>
                <xsl:when test="$enctype=('multipart/form-data')">
                    <xsl:apply-templates select="self::*" mode="multipart-formdata"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="self::*" mode="copybody"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$enctype=('application/ipp','application/octet-stream')">
                <xsl:value-of select="
                    concat('--upload-file ',$sq,@filename,$sq,' \',$lf)                      [$tool='curl' and $verb=('POST','PROPFIND','PROPPATCH','PUT') and     current()/attribute::filename ]
                    ,concat('--data-binary @&lt;(echo -en ',$sq,$body,$sq,') \',$lf)         [$tool='curl' and $verb=('POST','PROPFIND','PROPPATCH','PUT') and not(current()/attribute::filename)]
                    ,concat('-d @&lt;(echo -en ',$sq,$body,$sq,') \',$lf)                                                 [$tool='wfuzz' and $verb=('POST','PROPFIND','PROPPATCH','PUT')]
                    ,concat('--post-file $(tmp=`mktemp --dry-run`; echo -en ',$sq,$body,$sq,'&gt;$tmp; echo $tmp) \',$lf) [$tool='wget' and $verb=('POST','PROPFIND','PROPPATCH','PUT')]
                "/>
            </xsl:when>
            <xsl:when test="$enctype=('multipart/form-data')">
                <xsl:if test="$tool='curl' and $verb=('POST','PROPFIND','PROPPATCH','PUT')">
                    <xsl:apply-templates select="self::*" mode="multipart-formdata-curl"/>
                </xsl:if>
                <xsl:value-of select="
                    concat('-d $',$sq,$body,$sq,' \',$lf)           [$tool='wfuzz' and $verb=('POST','PROPFIND','PROPPATCH','PUT')]
                    ,concat('--post-data $',$sq,$body,$sq,' \',$lf)  [$tool='wget' and $verb=('POST')]
                    ,concat('--body-data $',$sq,$body,$sq,' \',$lf)  [$tool='wget' and not($verb=('POST','GET','HEAD','OPTIONS'))]
                "/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="
                    concat('--data-binary $',$sq,$body,$sq,' \',$lf) [$tool='curl' and $verb=('POST','PROPFIND','PROPPATCH','PUT')]
                    ,concat('-d $',$sq,$body,$sq,' \',$lf)           [$tool='wfuzz' and $verb=('POST','PROPFIND','PROPPATCH','PUT')]
                    ,concat('--post-data $',$sq,$body,$sq,' \',$lf)  [$tool='wget' and $verb=('POST')]
                    ,concat('--body-data $',$sq,$body,$sq,' \',$lf)  [$tool='wget' and not($verb=('POST','GET','HEAD','OPTIONS'))]
                "/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="//form" mode="querystring" priority="2">
        <xsl:param name="re">^(FUZ[2-9]?Z)\{(.+)\}$</xsl:param>		<!-- support for wfuzz baselines (that can be used with filter value BBB -->
        <xsl:variable name="tmp">
            <xsl:for-each select=".//input[not(attribute::type and @type='submit')]">
                <xsl:variable name="value" select="
                    encode-for-uri(@value)    [not(matches(current()/@value,$re))] [not(current()/attribute::urlencode and current()/@urlencode=('false','no','off','0'))]
                    ,@value                   [not(matches(current()/@value,$re))] [    current()/attribute::urlencode and current()/@urlencode=('false','no','off','0') ]
                    ,@value                   [    matches(current()/@value,$re) ]
                "/>
                <!--,concat(replace(@value,$re,'$1'),'{',encode-for-uri(replace(@value,$re,'$2')),'}')     [    matches(current()/@value,$re) ]-->
                <xsl:value-of select="$amp"/><xsl:value-of select="string-join((@name,$value),'=')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="string-join(tokenize($tmp,$amp)[.!=''],$amp)"/>
    </xsl:template>

    <xsl:template match="//form" mode="multipart-formdata-curl" priority="2">
        <xsl:for-each select=".//input[not(attribute::type and @type='submit')]">
            <xsl:variable name="filespec" select="concat(';filename=',@filename)  [current()/attribute::filename]"/>
            <xsl:choose>
                <xsl:when test="starts-with(@value,'@')">
                    <xsl:value-of select="concat('--form ',$sq,@name,'=@&quot;',substring(@value,2),'&quot;',$filespec,$sq,' \',$lf)"/>
                </xsl:when>
                <xsl:when test="not(starts-with(@value,'@')) and attribute::filename">
                    <xsl:variable name="backticks" select="concat('&lt;(echo -en ',$sq,replace(@value,$sq,'\\x27'),$sq,')')"/>
                    <xsl:value-of select="concat('--form ',@name,'=@',$backticks,$sq,$filespec,$sq,' \',$lf)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="backticks" select="concat('&quot;`{echo,-en,$',$sq,replace(@value,$sq,'\\x27'),$sq,'}`&quot;')"/>
                    <!--<xsl:value-of select="concat('- -form ',$sq,@name,'=&quot;',$sq,$backticks,$sq,'&quot;',$filespec,$sq,' \',$lf)"/>-->
                    <xsl:value-of select="concat('--form ',$sq,@name,'=',$sq, $backticks, $sq,$filespec,$sq,' \',$lf)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="//form" mode="multipart-formdata" priority="2">
        <xsl:variable name="content-disposition">
            <xsl:value-of select="
                @content-disposition  [    current()/attribute::content-disposition ]
                ,'form-data'          [not(current()/attribute::content-disposition)]
            "/>
        </xsl:variable>
        <xsl:variable name="tmp">
            <xsl:for-each select=".//input[not(attribute::type and @type='submit')]">
                <xsl:value-of select="concat('--',$boundary,$crlf)"/>
                <xsl:value-of select="concat('Content-Disposition: ',$content-disposition,'; name=',@name,'; filename='[current()/attribute::filename],@filename[current()/attribute::filename],$crlf)"/>
                <xsl:value-of select="concat('Content-Type: ',@content-type,$crlf)                                [current()/attribute::content-type]"/>
                <xsl:value-of select="concat('Content-Transfer-Encoding: ',@content-transfer-encoding,$crlf)      [current()/attribute::content-transfer-encoding]"/>
                <xsl:value-of select="$crlf"/>
                <xsl:value-of select="concat(@value,$crlf)"/>
                <!--<xsl:value-of select="concat('- -',$boundary,'- -',$crlf) [not(current()/following-sibling::input)]"/>-->
                <xsl:value-of select="concat('--',$boundary,'--', $crlf) [not(current()/following-sibling::input[not(attribute::type and @type='submit')])]"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$tmp"/>
    </xsl:template>

    <xsl:template match="//form" mode="copybody" priority="2">
        <xsl:apply-templates select="node()" mode="copy"/>
    </xsl:template>

    <xsl:template name="action">
        <xsl:param name="formaction"></xsl:param>
        <xsl:variable name="action" select="
            $action     [$action!='']
            ,$formaction[$action='']
        "/>
        <xsl:variable name="context" select="replace($action,$re,'$3$4')"/>
        <xsl:variable name="base" select="replace($action,$re,'$1$2')"/>
        <xsl:variable name="base" select="$baseurl [not($base)],$base[$base]"/>
        <xsl:variable name="base" select="/session/@baseurl [not($base)],$base[$base]"/>
        <xsl:value-of select="concat($base,$context)"/>
    </xsl:template>

    <xsl:template name="confirm">
        <xsl:param name="action">?</xsl:param>
		<xsl:value-of select="concat('echo ',$sq,'0) QUIT!',$sq,$lf)"/>
		<xsl:value-of select="concat('select opt in ',$sq,'.........................................................CONTINUE...WITH...',$action,$sq,'; do',$lf)"/>
		<xsl:value-of select="concat(' case $REPLY in',$lf)"/>
		<xsl:value-of select="concat('  0) exit 0;;',$lf)"/>
		<xsl:value-of select="concat('  *) break;;',$lf)"/>
		<xsl:value-of select="concat(' esac',$lf)"/>
		<xsl:value-of select="concat('done',$lf)"/>
    </xsl:template>

    <xsl:template match="node() | @*" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="copy"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="node() | @*">
    </xsl:template>
</xsl:stylesheet>

