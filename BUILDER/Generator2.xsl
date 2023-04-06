<?xml version="1.0" encoding="Windows-1250"  ?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Generátor stránek verze 2 -->
  <!-- oh.:06.01.2022 Kopie podle verze 1

-->

  <xsl:output
     method="html"
     doctype-system="about:legacy-compat"
     encoding="windows-1250"
     indent="yes" />
  <!-- verze a build a lokalizace xsl -->
  <xsl:variable name="astatus" select="document('.\astatus.xml')" />

  <!-- texty pouzite rovnou zde v xsl -->
  <xsl:variable name="globals" select="document('.\globals.xml')" />

  <!-- adresar pro vlastni sestavy dane stranky -->
  <xsl:variable name="aa" select="//sestavyvlastni/@adresar" />
  <xsl:variable name="adr">
    <xsl:value-of select="$astatus//ZMENAADR/Z[@typ = $aa]"/>
  </xsl:variable>
  <!-- adresar pro vlastni exporty dane stranky -->
  <xsl:variable name="aaexp" select="//exportyvlastni/@adresar" />
  <xsl:variable name="adrexp">
    <xsl:value-of select="$astatus//ZMENAADR/Z[@typ = $aaexp]"/>
  </xsl:variable>


  <!-- priznak pro lokalizaci desetinneho oddelovace: 0=tecka 1=carka -->
  <xsl:variable name="local" select="//ORIGIN/LOKALIZACE" />

  <!--                 nezobrazovane udaje                 -->
  <xsl:template match="text()"/>


  <!--           zacatek         -->
  <xsl:template match="/">
    <html lang="cs">
      <head>
        <title>
          <xsl:value-of select="//head/@title"/>:<xsl:value-of select="$astatus//verse/text"/>
          <!-- xsl:value-of select="$astatus//verse/build"/  -->
        </title>
        <xsl:if test="not(kostra/head/@nostyle)">          <!-- head bez stylu  -->
          <link type="text/css" rel="stylesheet" href="./styly/base.css" title="BASE" />
        </xsl:if>

        <!-- některé globály pro skripty, které se překládají nebo jsou závislé na verzi -->
        <xsl:text>
        </xsl:text>
        <script type="text/javascript">//
      var lok = ['<xsl:value-of select="$globals//Lok0/@nazev"/>','        <xsl:value-of select="$globals//Lok1/@nazev"/>']; 
      </script>
      <xsl:text>
      </xsl:text>

      <!-- *********** Vlozit další pozadovane skripty ******************  -->
      <xsl:for-each select="kostra/head/script">
        <!-- FILE:<xsl:value-of select="@file" />:FILE -->
        <xsl:choose>
        <xsl:when test="@file">
          <xsl:variable name="ssc" select="document(@file)"/>
          <xsl:text>
          </xsl:text>
          <script type="text/javascript">
            <!-- prekladane promenne z uvodni casti sc*****.xml -->
            <xsl:for-each select="$ssc/SC/text">
              <xsl:text>var </xsl:text>
              <xsl:value-of select="./@variable"/>
              <xsl:text> = "</xsl:text>
              <xsl:value-of select="."/>
              <xsl:text>";
              </xsl:text>
            </xsl:for-each>

            <xsl:copy-of select="$ssc/SC/script/text()"/>
          </script>
        </xsl:when>
        <xsl:when test="@src">
          <script type="text/javascript" src="{@src}"></script>
        </xsl:when>
        <xsl:otherwise>
            <script type="text/javascript">
              <xsl:copy-of select="*|text()"/>
            </script>
        </xsl:otherwise>
      </xsl:choose>

      </xsl:for-each>

      <!-- ***********   Vlozit styly  vlastni  ******************  -->
      <xsl:for-each select="kostra/head/style">
        <!-- FILE:<xsl:value-of select="@file" />:FILE -->
        <xsl:if test="@file">
          <xsl:copy-of select="document(@file)/style"/>
        </xsl:if>
        <xsl:if test="not(@file)">
          <style>
            <xsl:copy-of select="*|text()"/>
          </style>
        </xsl:if>
      </xsl:for-each>

      
    </head>
    <!--  -->
    <xsl:apply-templates/>
    <!--  -->
  </html>
</xsl:template>


<!-- NADPIS UVODNI STRANKY -->
<xsl:template match="uvodnistr">
  <div class="maindiv">
    <div class="leftcol">
      <a href="http://www.hoblapech.com/firemnik">
        <img src="loga/logo_intranet.gif" alt="Logo" title 
	   ="Firma HOBL &amp; PECH s.r.o. dodavatel Vašeho programu a řešitel Vašich problémů "/>
      </a>
    </div>
    <div class="dmd">
      Doprava DMD <xsl:value-of select="$astatus//verse/text"/>
    </div>
    <div class="rightcol">
      <div id="datum">
        <div id="datumtx">31.01.2022</div>
        <div id="svatek"></div>
      </div>
      <a href="Document/pomoc.htm" title="Nápověda, pomoc, popis programu.  " style="font-size:150%;">?</a>
      <div id="oblasttx" title="Zvolena oblast "> <xsl:value-of select="$globals//oblastneuvedena/@nazev"/> </div>

    </div>
  </div>
</xsl:template>



<!-- body -->
<xsl:template match="body">
  <body>
    <!-- init() volame pro nektere stranky s adresarem vlastnich sestav -->
    <xsl:if test="not(@nocont)">      <!-- stranka bez kontextoveho menu -->
      <xsl:attribute name="oncontextmenu">
        <xsl:text>ContextMenu(); return false;</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:attribute name="onload">

      <xsl:if test="not(@noinit)">        <!-- volani init nebo stranka bez init() -->
        <xsl:text>init('</xsl:text>
        <xsl:value-of select="$adr"/>
        <xsl:value-of select="$adrexp"/>
        <xsl:text>');</xsl:text>
      </xsl:if>
      <!-- nekdo potrebuje treba dalsi funkci pro inicializaci -->
      <xsl:if test="@onload">
        <xsl:value-of select="@onload"/>
      </xsl:if>
    </xsl:attribute>
    <!--  -->
    <xsl:if test="not(@nomaindiv)">      <!-- volani bez maindiv -->
      <div class="maindiv">
        <xsl:apply-templates/>
      </div>
    </xsl:if>

    <!--  -->
  </body>
</xsl:template>



<!-- Kontextove menu pokud je pozadovano, select SPZ, Chybove hlaseni -->
<xsl:template match="kontextmenu">
  <div id="oContextHTML" style="display:none; width:120px; position:absolute;" onmouseout="hideMenu(); return false;">
    <div onmouseover="this.style.background='gold';" onclick="gotoSestava('/index.html')" onmouseout="this.style.background='#e4e4e4'; window.event.cancelBubble = true;" style=" font-family:verdana; font-size:70%;height:15px; background:#e4e4e4;border:1px solid black; padding:4px;
     cursor:pointer;">Hlavní stránka</div>
    <div onmouseover="this.style.background='gold'" onmouseout="this.style.background='#e4e4e4'; window.event.cancelBubble = true;" onclick="parent.gotoobla('/Document/pomoc.htm')" style="font-family:verdana; font-size:70%; height:15px; background:#e4e4e4; border:1px solid black; padding:4px; cursor:pointer; border-top:0px solid black">
        Pomoc</div>
    <div onmouseover="this.style.background='gold'" onmouseout="this.style.background='#e4e4e4'; window.event.cancelBubble = true;" onclick="parent.gotoobla('/nastaveni.htm')" style="font-family:verdana; font-size:70%; height:15px; background:#e4e4e4; border:1px solid black; padding:4px; cursor:pointer; border-top:0px solid black">
        Nastavení</div>
  </div>

  <div id="popup1" class="overlay">
    <div class="popup">
      <h1>Chyba</h1>
      <a class="close" href="#">&#xD7;</a>
      <div id="messContent" class="content">
        Zadne chybove hlaseni.
      </div>
      <a id="closeBtn" href="#">OK</a>
    </div>
  </div>
</xsl:template>

<!-- *********** zbytek se vzdy zkopiruje jak lezi ******** -->
<xsl:template match="ZBYTEK">
  <xsl:copy-of select="*"/>
</xsl:template>

<!-- ************* blok zahlavi ***************** -->
<xsl:template match="zahlavi">
  <!-- ********************* zahlavi  ********************  -->
  <table class="maintab" border="0">
    <tr>
      <td align="center">
        <DIV class="zahlavi">
          <xsl:value-of select="@nadpis"/>
        </DIV>

        <!-- Vlozit pozadovane menu v hlavicce  -->
        <xsl:for-each select="menu/m">
          <a class="housebutton">
            <xsl:attribute name="href">
              <xsl:value-of select="@akce"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="@title"/>
            </xsl:attribute>
            <xsl:if test="@width">
              <xsl:attribute name="style">width:<xsl:value-of select="@width"/>
;</xsl:attribute>
            </xsl:if>

            <xsl:value-of select="@nadpis"/>
          </a>
        </xsl:for-each>

      </td>
      <td align="center">
        <div class="zahlavi2">
          <xsl:if test="$astatus//verse/kod = '46'">
            <a href="#">
              <xsl:value-of select="$globals//casvypoctu/@nazev"/>
              <br/>
              <span id="origdiv"></span>
            </a>
          </xsl:if>
          <xsl:if test="$astatus//verse/kod = '46old'">
            <a href="reinic.php" title="Klikni pro obnovu statistických dat">
              <xsl:value-of select="$globals//casvypoctu/@nazev"/>
              <br/>
              <span id="origdiv"></span>
            </a>
          </xsl:if>
          <div style="font-size:smaller;" title="Nastavení tečky nebo čárky v číselných výstupech">
            <xsl:value-of select="$globals//Lokalizace/@nazev"/>
: 
            <a href="javascript:zmenaloc()" id="lokalizace">x</a>
          </div>
        </div>
        <div id="oblasttx">&#160;<xsl:value-of select="$globals//oblastneuvedena/@nazev"/>
        </div>
      </td>
    </tr>
  </table>
  <!-- *********************  konec zahlavi  ********************  -->
</xsl:template>

<!-- ************* blok odstavec ***************** -->
<xsl:template match="odstavec">
  <!-- **  oddeleni jednoho odstavce zatim pro stranku nastaveni  -->
  <!--  -->
  <div class="odstavec">
    <h3>
      <xsl:value-of select="@nadpis"/>
    </h3>

    <xsl:apply-templates/>

  </div>
  <!--  -->
  <!-- *********************  konec odstavce  ********************  -->
</xsl:template>





<!--         *************** Blok filtry ****************     -->
<xsl:template match="filtry">
  <!--  -->
  <div class="filtry">
    <h3>
      <xsl:value-of select="$globals//nastavenifiltru/@nazev"/>
&#160;&#160;&#160;&#160;&#160;
      <input type="button" value="{$globals//uloznf/@nazev}" onclick="zapiscookies()" class="ulozbutton" title="Zapamatuj nastavení filtrů pro sestavy" />

      <span class="fvystupu">
       &#160;&#160;&#160;&#160;&#160;Formát výstupu:
                                       <!-- volba výstupního formátu XML, HTML PDF -->
        <input class="Ou" type="radio" name="Ou" value="H" title="Formát výstupu HTML (local coversion)" checked="checked" />
        <input class="Ou" type="radio" name="Ou" value="X" title="Formát výstupu DIRECT CALL" />
        <input class="Ou" type="radio" name="Ou" value="X" title="Formát výstupu XML" />
        <input class="Ou" type="radio" name="Ou" value="P" title="Formát výstupu PDF" disabled="disabled"/>
      </span>
    </h3>

    <xsl:apply-templates/>
  </div>
  <!--  -->
</xsl:template>

<xsl:template match="filtry2">
  <!--  -->
  <div class="filtry2">
    <xsl:apply-templates/>
  </div>
  <!--  -->
</xsl:template>

<xsl:template match="ffree">
  <!-- prazdny blok do stranek kde neni vyber ridice -->
  <span class="ffree">
    &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
  </span>
</xsl:template>

<xsl:template match="fvozidla">
  <!-- *** filter vozidel*** -->
  <span id="Vfilter" class="fvozidla">
    <fieldset class="fieldf">
      <legend>
        <xsl:value-of select="$globals//Vozidla/@nazev"/>
 : </legend>
      <div class="f">
        <span class="fl">
          <xsl:value-of select="$globals//VVozidla/@nazev"/>
: 
        </span>
        <span class="fs">
          <input type="radio" name="V" checked="checked" />
        </span>
        <div class="fp">&#160;</div>
      </div>
      <div class="f" id="skvozidel">
        <span class="fl">
          <xsl:value-of select="$globals//vybrskup/@nazev"/>
 :
        </span>
        <span class="fs">
          <input type="radio" name="V" checked="checked" />
        </span>
        <span class="fp">
          <select id="oskupiny" class="inputspz" >
            <option>
              <xsl:value-of select="$globals//nevybr/@nazev"/>
            </option>
          </select>
        </span>
      </div>
      <div class="f">
        <span class="fl">
          <a href="javascript:zobrazauto();" title="Zobrazit podrobnosti o vozidle">
           ?            <xsl:value-of select="$globals//jednovo/@nazev"/>
:</a>
        </span>
        <span class="fs">
          <input type="radio" name="V" checked="checked" />
        </span>
        <span class="fp">
          <input type="text" id="autospz" class="inputspz" ondblclick="vyberauto();" />
        </span>
      </div>
    </fieldset>
  </span>


      <div id="oSelectSpz">
      <div onmouseover="this.style.background='gold';"
        onmouseout="this.style.background='#e4e4e4'; window.event.cancelBubble = true;" 
        style=" font-family:verdana; font-size:70%;height:15px; background:#e4e4e4;border:1px solid black; padding:4px;
     cursor:pointer;">Vyber SPZ  <a class="closeoSelectSpz" href="#">&#xD7;</a></div>
      <div id="sspz">
        ?? ??
      </div>

      <div onmouseover="this.style.background='gold'" onmouseout="this.style.background='#e4e4e4';"
        onclick="selectedSpz(); window.event.cancelBubble=true;"
        style="font-family:verdana; font-size:70%; height:15px; background:#e4e4e4; border:1px solid black; padding:4px; cursor:pointer; border-top:0px solid black">
        Vybráno ?</div>
    </div>
    
</xsl:template>


<xsl:template match="fridici">
  <!-- *** filter RIDICU *** -->
  <span id="Rfilter" class="fvozidla">
    <fieldset class="fieldf">
      <legend>
        <xsl:value-of select="$globals//Ridici/@nazev"/>
 : </legend>
      <div class="f">
        <span class="fl">
          <xsl:value-of select="$globals//VRidici/@nazev"/>
: 
        </span>
        <span class="fs">
          <input type="radio" name="R" checked="checked" />
        </span>
        <div class="fp">&#160;</div>
      </div>
      <div class="f" id="skridicu">
        <span class="fl">
          <xsl:value-of select="$globals//vybrskuprid/@nazev"/>
 :
        </span>
        <span class="fs">
          <input type="radio" name="R" />
        </span>
        <span class="fp">
          <select id="oridskup" class="inputrid" >
            <option>
              <xsl:value-of select="$globals//nevybr/@nazev"/>
            </option>
          </select>
        </span>
      </div>
      <div class="f">
        <span class="fl">
          <a href="javascript:zobrazridice();" title="Zobrazit podrobnosti o řidiči">
           ?            <xsl:value-of select="$globals//jedenrid/@nazev"/>
:
          </a>
        </span>
        <span class="fs">
          <input type="radio" name="R" />
        </span>
        <span class="fp">
          <input type="text" id="oridici" class="inputrid" ondblclick="vyberridice();" />
        </span>
      </div>
    </fieldset>
  </span>
</xsl:template>




<xsl:template match="fcasy">
  <!-- *** filter casovy usek *** -->
  <fieldset class="fieldf" id="Cfilter">
    <legend>
      <xsl:value-of select="$globals//cusek/@nazev"/>
 :  </legend>
    <div>
      <label>
        <input type="radio" name="C"/>
        <xsl:value-of select="$globals//zmr/@nazev"/>
 :
      </label>
      <label class="fp">
        <small>
          <select id="vybrmes" name="vybrmes" size="1" onchange="JinyMes()" class="input">
            <option>1</option>
            <option>2</option>
            <option>3</option>
            <option>4</option>
            <option>5</option>
            <option>6</option>
            <option>7</option>
            <option>8</option>
            <option>9</option>
            <option>10</option>
            <option>11</option>
            <option>12</option>
          </select>
          <select id="vybrrok" name="vybrrok" size="1" onchange="JinyRok()" class="input">
            <option>1999</option>
            <option>2000</option>
            <option>2001</option>
            <option>2002</option>
            <option>2003</option>
            <option>2004</option>
            <option>2005</option>
            <option>2006</option>
            <option>2007</option>
            <option>2008</option>
            <option>2009</option>
            <option>2010</option>
            <option>2011</option>
            <option>2012</option>
            <option>2013</option>
          </select>
        </small>
      </label>
    </div>

    <!-- interval od do -->
    <div>
      <label>
        <input type="radio" name="C" />
        <!-- !!! xsl:value-of select="$globals//zdi/@nazev"/ -->
 Od do :
        <input type="date" id="ointerval" data-date-format="DD.MM.YYYY" class="inputinterval" title="Zacatek intervalu Od" />
        <input type="date" id="dinterval" data-date-format="DD.MM.YYYY" class="inputinterval" title="Konec intervalu Do" />
      </label>
    </div>

        <div>
        <label>
          <input type="radio" name="C" /><xsl:value-of select="$globals//jobd/@nazev"/><select id="opcas"
              class="inputinterval">
              <option><xsl:value-of select="$globals//nevybr/@nazev"/></option>
            </select>
          </label>
        </div>  
  </fieldset>

</xsl:template>

<xsl:template match="frok">
  <!-- *** filter casovy na rok *** -->
  <span class="fvozidla">
    <fieldset class="fieldf">
      <legend>
        <xsl:value-of select="$globals//vyber/@nazev"/>
  :XY </legend>
      <div class="f">
        <span class="fl">
          <xsl:value-of select="$globals//rok/@nazev"/>
 : 
        </span>
        <span class="fs">
        </span>
        <span class="fp">
          <small>
            <select id="vybrrok" name="vybrrok" size="1" onchange="JinyRok()" class="input">
              <option>2001</option>
              <option>2002</option>
              <option>2003</option>
              <option>2004</option>
              <option>2005</option>
              <option>2006</option>
              <option>2007</option>
              <option>2008</option>
              <option>2009</option>
              <option>2010</option>
              <option>2011</option>
              <option>2012</option>
              <option>2013</option>
              <option>2014</option>
              <option>2015</option>
              <option>2016</option>
              <option>2017</option>
              <option>2018</option>
              <option>2019</option>
              <option>2020</option>
              <option>2021</option>
              <option>2022</option>
              <option>2023</option>
              <option>2024</option>
              <option>2025</option>
              <option>2026</option>
              <option>2027</option>
              <option>2028</option>
            </select>
          </small>
        </span>
      </div>
    </fieldset>
  </span>
</xsl:template>



<xsl:template match="foblast">
  <!-- *** filter oblasti*** -->
  <span class="fvozidla">
    <fieldset class="fieldf">
      <legend>
        <xsl:value-of select="$globals//voblast/@nazev"/>
 : </legend>
      <div class="f">
        <span class="fp">
          <select id="ooblasti" class="inputoblast">
            <option>
              <xsl:value-of select="$globals//nevybr/@nazev"/>
            </option>
          </select>
        </span>
      </div>
    </fieldset>
  </span>

</xsl:template>


<xsl:template match="fviditelnost">
  <!-- *** filter viditelnosti prvků v sestavě *** -->
  <span class="fradio">
    <fieldset class="fieldf">
      <legend>
        <text>Viditelnost prvků v sestavě</text> : 
      </legend>
      <!-- nadpis -->
      <div class="rflon">
        <span class="flon">
          <text>prvky z</text> : 
        </span>
        <xsl:if test="@V">
          <span class="fpo" title="vozidla">V</span>
        </xsl:if>
        <xsl:if test="@P">
          <span class="fpo" title="přívěsy">P</span>
        </xsl:if>
        <xsl:if test="@R">
          <span class="fpo" title="řidiči">R</span>
        </xsl:if>
        <xsl:if test="@T">
          <span class="fpo" title="tankovací karty">T</span>
        </xsl:if>
        <xsl:if test="@O">
          <span class="fpo" title="Přepravci - objednatelé">O</span>
        </xsl:if>
      </div>
      <!-- radio button pro prvky v oblasti -->
      <div class="rflon">
        <span class="flon">
          <text>Nefiltrovat</text>:
        </span>
        <xsl:if test="@V">
          <span class="fpo">
            <input type="radio" name="rvv" value="0" title="Nefiltrovat" />
          </span>
        </xsl:if>
        <xsl:if test="@P">
          <span class="fpo">
            <input type="radio" name="rvp" value="0" title="Nefiltrovat" checked="checked" />
          </span>
        </xsl:if>
        <xsl:if test="@R">
          <span class="fpo">
            <input type="radio" name="rvr" value="0" title="Nefiltrovat" checked="checked" />
          </span>
        </xsl:if>
        <xsl:if test="@T">
          <span class="fpo">
            <input type="radio" name="rvt" value="0" title="Nefiltrovat" checked="checked" />
          </span>
        </xsl:if>
        <xsl:if test="@O">
          <span class="fpo">
            <input type="radio" name="rvo" value="0" title="Nefiltrovat" checked="checked" />
          </span>
        </xsl:if>
      </div>
      <div class="rflon">
        <span class="flon">
          <text>Patřil do oblasti v okamžiku tvorby sestavy</text>:
        </span>
        <xsl:if test="@V">
          <span class="fpo">
            <input type="radio" name="rvv" value="1" title="Volba je závislá na datu tvorby sestavy a proto nezaručuje vždy stejný obsah sestavy" />
          </span>
        </xsl:if>
        <xsl:if test="@P">
          <span class="fpo">
            <input type="radio" name="rvp" value="1" title="Volba je závislá na datu tvorby sestavy a proto nezaručuje vždy stejný obsah sestavy" />
          </span>
        </xsl:if>
        <xsl:if test="@R">
          <span class="fpo">
            <input type="radio" name="rvr" value="1" title="Volba je závislá na datu tvorby sestavy a proto nezaručuje vždy stejný obsah sestavy" />
          </span>
        </xsl:if>
        <xsl:if test="@T">
          <span class="fpo">
            <input type="radio" name="rvt" value="1" title="Volba je závislá na datu tvorby sestavy a proto nezaručuje vždy stejný obsah sestavy" />
          </span>
        </xsl:if>
        <xsl:if test="@O">
          <span class="fpo">
            <input type="radio" name="rvo" value="1" title="Volba je závislá na datu tvorby sestavy a proto nezaručuje vždy stejný obsah sestavy" />
          </span>
        </xsl:if>
      </div>
      <div class="rflon">

        <span class="flon">
          <text>Patřil do oblasti aspoň jeden den v období</text>:
        </span>
        <xsl:if test="@V">
          <span class="fpo">
            <input type="radio" name="rvv" value="2" title="Patřil do oblasti aspoň jeden den v období" checked="checked" />
          </span>
        </xsl:if>
        <xsl:if test="@P">
          <span class="fpo">
            <input type="radio" name="rvp" value="2" title="Patřil do oblasti aspoň jeden den v období" />
          </span>
        </xsl:if>
        <xsl:if test="@R">
          <span class="fpo">
            <input type="radio" name="rvr" value="2" title="Patřil do oblasti aspoň jeden den v období" />
          </span>
        </xsl:if>
        <xsl:if test="@T">
          <span class="fpo">
            <input type="radio" name="rvt" value="2" title="Patřil do oblasti aspoň jeden den v období" />
          </span>
        </xsl:if>
        <xsl:if test="@O">
          <span class="fpo">
            <input type="radio" name="rvo" value="2" title="Patřil do oblasti aspoň jeden den v období" />
          </span>
        </xsl:if>
      </div>
      <div class="rflon">

        <span class="flon">
          <text>Patřil do oblasti poslední den období</text>:
        </span>
        <xsl:if test="@V">
          <span class="fpo">
            <input type="radio" name="rvv" value="3" title="Patřil do oblasti poslední den období" />
          </span>
        </xsl:if>
        <xsl:if test="@P">
          <span class="fpo">
            <input type="radio" name="rvp" value="3" title="Patřil do oblasti poslední den období" />
          </span>
        </xsl:if>
        <xsl:if test="@R">
          <span class="fpo">
            <input type="radio" name="rvr" value="3" title="Patřil do oblasti poslední den období" />
          </span>
        </xsl:if>
        <xsl:if test="@T">
          <span class="fpo">
            <input type="radio" name="rvt" value="3" title="Patřil do oblasti poslední den období" />
          </span>
        </xsl:if>
        <xsl:if test="@O">
          <span class="fpo">
            <input type="radio" name="rvo" value="3" title="Patřil do oblasti poslední den období" />
          </span>
        </xsl:if>
      </div>
      <div class="rflon">

        <span class="flon">
          <text>Patřil do oblasti kdykoli v epoše DMD</text>:
        </span>
        <xsl:if test="@V">
          <span class="fpo">
            <input type="radio" name="rvv" value="4" title="Patřil do oblasti kdykoli v epoše DMD" />
          </span>
        </xsl:if>
        <xsl:if test="@P">
          <span class="fpo">
            <input type="radio" name="rvp" value="4" title="Patřil do oblasti kdykoli v epoše DMD" />
          </span>
        </xsl:if>
        <xsl:if test="@R">
          <span class="fpo">
            <input type="radio" name="rvr" value="4" title="Patřil do oblasti kdykoli v epoše DMD" />
          </span>
        </xsl:if>
        <xsl:if test="@T">
          <span class="fpo">
            <input type="radio" name="rvt" value="4" title="Patřil do oblasti kdykoli v epoše DMD" />
          </span>
        </xsl:if>
        <xsl:if test="@O">
          <span class="fpo">
            <input type="radio" name="rvo" value="4" title="Patřil do oblasti kdykoli v epoše DMD" />
          </span>
        </xsl:if>
      </div>

    </fieldset>
  </span>

</xsl:template>



<xsl:template match="fzarazeni">
  <!-- *** filter viditelnosti prvků v sestavě *** -->
  <span class="fradio">
    <fieldset class="fieldf">
      <legend>
        <text>Zařazení činností do sestavy</text> : 
      </legend>
      <!-- nadpis -->
      <div class="rflon">
        <span class="flon">
          <text>prvky z</text> : 
        </span>
        <xsl:if test="@V">
          <span class="fpo" title="vozidla"> V </span>
        </xsl:if>
        <xsl:if test="@P">
          <span class="fpo" title="přívěsy">P</span>
        </xsl:if>
        <xsl:if test="@R">
          <span class="fpo" title="řidiči">R</span>
        </xsl:if>
        <xsl:if test="@T">
          <span class="fpo" title="tankovací karty">T</span>
        </xsl:if>
        <xsl:if test="@O">
          <span class="fpo" title="přepravci - objednatelé">O</span>
        </xsl:if>
      </div>

      <!-- radio button pro prvky v oblasti -->
      <div class="rflon">
        <span class="flon">
          <text>Nefiltrovat</text>:
        </span>
        <xsl:if test="@V">
          <span class="fpo">
            <input type="radio" name="rzv" value="0" title="Nefiltrovat" />
          </span>
        </xsl:if>
        <xsl:if test="@P">
          <span class="fpo">
            <input type="radio" name="rzp" value="0" title="Nefiltrovat" checked="checked" />
          </span>
        </xsl:if>
        <xsl:if test="@R">
          <span class="fpo">
            <input type="radio" name="rzr" value="0" title="Nefiltrovat" checked="checked" />
          </span>
        </xsl:if>
        <xsl:if test="@T">
          <span class="fpo">
            <input type="radio" name="rzt" value="0" title="Nefiltrovat" checked="checked" />
          </span>
        </xsl:if>
        <xsl:if test="@O">
          <span class="fpo">
            <input type="radio" name="rzo" value="0" title="Nefiltrovat" checked="checked" />
          </span>
        </xsl:if>
      </div>
      <div class="rflon">
        <span class="flon">
          <text>Zařadit do sestavy jen ty činnosti, při jejichž ukončení prvek patřil do oblasti</text>:
        </span>
        <xsl:if test="@V">
          <span class="fpo">
            <input type="radio" name="rzv" value="1" checked="checked" />
          </span>
        </xsl:if>
        <xsl:if test="@P">
          <span class="fpo">
            <input type="radio" name="rzp" value="1" />
          </span>
        </xsl:if>
        <xsl:if test="@R">
          <span class="fpo">
            <input type="radio" name="rzr" value="1" />
          </span>
        </xsl:if>
        <xsl:if test="@T">
          <span class="fpo">
            <input type="radio" name="rzt" value="1" />
          </span>
        </xsl:if>
        <xsl:if test="@O">
          <span class="fpo">
            <input type="radio" name="rzo" value="1" />
          </span>
        </xsl:if>
      </div>
      <div class="rflon">
        <span class="flon">
          <text>Zařadit do sestavy jen ty činnosti, při jejichž ukončení prvek nepatřil do oblasti</text>:
        </span>
        <xsl:if test="@V">
          <span class="fpo">
            <input type="radio" name="rzv" value="2" />
          </span>
        </xsl:if>
        <xsl:if test="@P">
          <span class="fpo">
            <input type="radio" name="rzp" value="2" />
          </span>
        </xsl:if>
        <xsl:if test="@R">
          <span class="fpo">
            <input type="radio" name="rzr" value="2" />
          </span>
        </xsl:if>
        <xsl:if test="@T">
          <span class="fpo">
            <input type="radio" name="rzt" value="2" />
          </span>
        </xsl:if>
        <xsl:if test="@O">
          <span class="fpo">
            <input type="radio" name="rzo" value="2" />
          </span>
        </xsl:if>
      </div>
    </fieldset>
  </span>

</xsl:template>




<xsl:template match="fstred">
  <!--
   
   *** filter stredisek - zatim nepouzit *** 
   <span class="fvozidla">
         <span class="ffield">
       <span class="f">
         <span class="fl">
	 </span>
         <span class="fs">
	 </span>
         <span class="fp">
	 </span>
       </span>
     </span>
     </span>
  -->

</xsl:template>

<xsl:template match="fprepr">
  <!-- *** filter prepravce*** -->
        <label>
          <xsl:value-of select="$globals//prepr/@nazev"/> :
          <input type="text" name="kodp" value="" title="kodp:výběr přepravce např.:   X__:177*****   nebo  *:177" class="inputspz" />
        </label>
</xsl:template>

<xsl:template match="fsazba">
  <!-- *** filter sazeb*** -->
        <label>
          <xsl:value-of select="$globals//kods/@nazev"/> :
          <input type="text" name="kodr" value="" title="kodr: MTH,KM" class="inputspz" />
        </label>
</xsl:template>

<xsl:template match="foprav">
  <!-- *** filter oprav = stejný jako filter sazeb *** -->
  <label>
          <xsl:value-of select="$globals//kodopr/@nazev"/> :
          <input type="text" name="kodr" value="" title="kodr:příklad seznamu kódů: ZL**,NA" class="inputspz" />
  </label>
</xsl:template>

<xsl:template match="fkodrad">
  <!-- *** filter kodrad = stejný jako filter sazeb *** -->
  <label>
          <xsl:value-of select="'Kod radky'"/> :
          <input type="text" name="kodr" value="" title="kodr:příklad seznamu kódů: ZL**,NA" class="inputspz" />
  </label>
</xsl:template>

<xsl:template match="fsubstr">
  <!-- *** filter Substráty : *** -->
  <label>
          <xsl:value-of select="$globals//substr/@nazev"/> : 
          <input type="text" name="kods" value="" class="inputspz" title="kods:výběr substrátů např.: 177*****   nebo 177,250*** " />
  </label>
</xsl:template>

<xsl:template match="fpraczar">
  <!-- *** filter pracovniho zarazeni *** -->
  <label>
          <xsl:value-of select="$globals//przar/@nazev"/> :
          <input type="text" name="kodpr" value="" class="inputspz" title="kodpr:pracovni zarazeni" />
  </label>
</xsl:template>


<xsl:template match="fprovp">
  <!-- *** filter Prov.podmínky : *** -->
  <label>
          <xsl:value-of select="$globals//prpod/@nazev"/> : 
          <input type="text" name="kodpp" value="" class="inputspz" title="kodpp:výběr provozních podmínek např.: N*   nebo NK,VK*** " />
  </label>
</xsl:template>

<xsl:template match="fvlastpp">
  <!-- *** filter Vlastnosti PP:*** -->
  <label>
          <xsl:value-of select="$globals//vpp/@nazev"/> :
          <input type="text" name="kodpvp" value="" class="inputspz" title="kodpvp:Vlastnosti provozních podmínek" />
  </label>
  </xsl:template>


<!-- ******** blok sestavy předdefinované ********** -->
<xsl:template match="sestavyp">
  <div class="vybers">
    <xsl:variable name="nadpis">
      <xsl:choose>
        <xsl:when test="@nadpis">
          <xsl:value-of select="@nadpis"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$globals//vybses/@nazev"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <h3>
      <xsl:value-of select="$nadpis"/>
    </h3>
    <!--  -->
    <xsl:apply-templates/>
    <!--  -->
  </div>
</xsl:template>

<!-- ******** blok sestavy vlastni z adresare XML/xxxx ********** -->
<xsl:template match="sestavyvlastni">
  <div class="sestavyvlastni">
    <h3>
      <xsl:value-of select="$globals//vszadr/@nazev"/>
:      <xsl:value-of select="$adr"/>
      <xsl:value-of select="$adrexp"/>
      <xsl:attribute name="title">
        <xsl:value-of select="@title"/>
      </xsl:attribute>
    </h3>
    <div id="sdiv">
    </div>
    <!-- 
    <fieldset class="fieldset">
      <legend>
        <xsl:value-of select="$globals//sk1/@nazev"/>
 : </legend>
      <div id="sdiv">
      </div>
    </fieldset>
    <fieldset class="fieldset">
      <legend>
        <xsl:value-of select="$globals//sk2/@nazev"/>
 : </legend>
      <div id="sdiv2">
      </div>
    </fieldset>
   -->


    <hr/>
  </div>
</xsl:template>

<!-- ******** blok exporty vlastni  ********** -->
<xsl:template match="exportyvlastni">
  <div class="sestavyvlastni">
    <h3>
      <xsl:value-of select="$globals//vszadr/@nazev"/>
:      <xsl:value-of select="$adrexp"/>
      <xsl:attribute name="title">
        <xsl:value-of select="@title"/>
      </xsl:attribute>
    </h3>
    <!--  -->
    <fieldset class="fieldset">
      <legend>
        <xsl:value-of select="$globals//sk1/@nazev"/>
 :: </legend>
      <div id="sdiv">
      </div>
    </fieldset>
    <!--  -->
    <hr/>
  </div>
</xsl:template>



<!-- ******** blok sestav o vybavach ********** -->
<xsl:template match="sestavyvybavy">
  <div class="sestavyvlastni">
    <h3>
      <xsl:value-of select="$globals//sovyb/@nazev"/>
      <xsl:attribute name="title">
        <xsl:value-of select="@title"/>
      </xsl:attribute>
    </h3>
    <!-- zaškrtávací filter na kody výbavy  -->
    <fieldset class="fieldsetvyb">
      <legend>
        <xsl:value-of select="$globals//vyberkodu/@nazev"/>
  : </legend>
      <form id="formvyb">
      </form>
    </fieldset>
    <!--  -->
    <xsl:apply-templates/>
    <!--  -->

  </div>
</xsl:template>

<!-- ******** blok - field  *******  -->
<xsl:template match="field">
  <fieldset class="fieldset">
    <xsl:if test="@id">
      <xsl:attribute name="id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@title">
      <legend>
        <xsl:value-of select="@title"/>
  : </legend>
    </xsl:if>
    <!--  -->
    <xsl:apply-templates/>
    <!--  -->
  </fieldset>
</xsl:template>


<!-- blok - menu - umisteni je rizeno uvedenim class -->
<xsl:template match="menu">
  <span>
    <xsl:if test="@id">
      <xsl:attribute name="id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@class">
      <xsl:attribute name="class">
        <xsl:value-of select="@class"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@title">
      <xsl:attribute name="title">
        <xsl:value-of select="@title"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@width">
      <xsl:attribute name="style">width:<xsl:value-of select="@width"/>
;</xsl:attribute>
    </xsl:if>
    <!--  -->
    <xsl:value-of select="@nadpis"/>
    <xsl:apply-templates/>
    <!--  -->
  </span>
</xsl:template>

<!-- blok - m = tlacitko opraveno 2011/04/13 -->
<xsl:template match="m">
  <button type="button">
    <xsl:attribute name="onClick">
      <xsl:value-of select="@akce"/>
    </xsl:attribute>
    <xsl:attribute name="title">
      <xsl:value-of select="@title"/>
    </xsl:attribute>
    <xsl:if test="@width">
      <xsl:attribute name="style">width:<xsl:value-of select="@width"/>
;</xsl:attribute>
    </xsl:if>
    <xsl:value-of select="@nadpis"/>
  </button>
</xsl:template>

<!-- blok - ms = tlacitko svisle - pouze na hlavni strance  -->
<xsl:template match="ms">
  <xsl:variable name="adrms" select="$astatus//ZMENAADR/Z[@typ = 'vlastni']" />
  <xsl:variable name="uv">'</xsl:variable>
  <xsl:variable name="odkazms" select="concat('javascript:gotoobla(',$uv,$adrms,'vlastni.htm',$uv,')')" />
  <button class="mtopten">
    <xsl:attribute name="onClick">
      <xsl:value-of select="$odkazms"/>
    </xsl:attribute>
    <xsl:attribute name="title">
      <xsl:value-of select="@title"/>
    </xsl:attribute>
    <!-- xsl:value-of select="@nadpis"/>   -->
    <img src="img/kocka.gif" border="0" alt="Kočka" />
    <br/>
T<br/>
o<br/>
p<br/>
<br/>
T<br/>
e<br/>
n<br/>
<br/>
H<br/>
i<br/>
t<br/>
s<br/>
<br/>
</button>
</xsl:template>

<!-- blok na ladici informace-->
<xsl:template match="ladeni">
<!-- blocek s informacemi pro ladeni -->
<div >
<input class="clad" type="radio" name="rlad" value="X" title="Zobrazit kontrolní výpisy volání Herma" onClick="javascript:visilad();" />
<div class="dlad" id="dlad" style="display:none;">
<div class="ilad" id="txgurl" title="Příkazová řádka včetně parametrů." >x</div>
<div class="ilad" id="txxsl" title="Použitý soubor xsl." >x</div>
<div class="ilad" id="txtype" title="Způsob odeslání požadavku." >x</div>

<button onClick="javascript:vypisListShowses();">Seznam sestav</button>
<div id="dlist">

</div>
</div>
</div>
</xsl:template>

<!-- blok kecy obvykle na spodku stranky -->
<xsl:template match="kecy">
<xsl:if test="@nadpis">
<h3>
<xsl:value-of select="@nadpis"/>
</h3>
</xsl:if>

<xsl:copy-of select="*"/>

</xsl:template>



<!-- blok xxxx -->
<xsl:template match="OO">
<xsl:copy-of select="*"/>
</xsl:template>

<!-- blok xxxx -->
<xsl:template match="OO">
<xsl:copy-of select="*"/>
</xsl:template>

<!-- blok xxxx -->
<xsl:template match="OO">
<xsl:copy-of select="*"/>
</xsl:template>

<!-- blok xxxx -->
<xsl:template match="OO">
<xsl:copy-of select="*"/>
</xsl:template>


</xsl:stylesheet>
