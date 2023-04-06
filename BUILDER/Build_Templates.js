// ************************************************************
// STAVBA adresáøe HTMLE z pøedepsaných vzorù    2022-01-11
// ************************************************************
//
var debug = true;
var pathTemplates = ".\\Templates";
var pathHTML = "..\\HTMLE\\";

var generatorXSL = "Generator2.XSL";

var prazdnych;
var vsechny;
var pocetsouboru;

var fso;
var xml;
var xsl;
var vysledek;

var msg;
var d;
var doc;       // = xml.documentElement;
var files;     // = xml.createElement('FILES');


// 
// Test verze MSXMLxx
//
   function openMSXML()
   {    var progIDs = [ 'Msxml2.DOMDocument.6.0', 'Msxml2.DOMDocument.4.0'];
        
        for (var i = 0; i < progIDs.length; i++) {
            try {
                var xmlDOM = new ActiveXObject(progIDs[i]);
                return xmlDOM;
            }
            catch (ex) {
            }
        }
	 WScript.Echo('not MSXML object 6.0');
        return null;
       }

function zpracujsoubory(fld,INDEX,podadr)
// fld = kolekce souboru
// INDEX = nazev souboru, ktery ma mit extension "html"
// podadr = nazev podadresare v HTMLV
{
var typses;
var FileName;
var txttypses;
// pres vsechny soubory v tomto adresari
var oFiles = new Enumerator(fld.Files);   // Files collection	
for (; !oFiles.atEnd(); oFiles.moveNext()) // pres vsechny soubory
{
  var oFile = oFiles.item();
  var ext = "";
  ext += fso.GetExtensionName(oFile.name);
  if (ext.toUpperCase() == 'XML') // jen XML soubory
  {
     FileName = fld.Path + "\\" + oFile.name;  
    // a ted si nacteme soubor TEMPLATE
	if (!xml.load(FileName)) {
	        WScript.Echo("Nelze naèíst file: " + FileName + "\n" + xml.parseError.reason + "\n øádka, pozice: "+
			xml.parseError.line + " , " +xml.parseError.linepos +"\n" +
			xml.parseError.srcText);
		//
		return;
    }
    var def =  xml.selectSingleNode("//kostra");
    if( def != null ){  //********* jen soubory s definici kostry *******************
      typses = null;
      pocetsouboru++;
      if (debug) {WScript.Echo(" selected file: " + FileName);}
 
	if (!xsl.load(generatorXSL)) {
	        WScript.Echo("Nelze naèíst xsl file: " + generatorXSL + "\n" + xsl.parseError.reason + "\n øádka, pozice: "+
			xsl.parseError.line + " , " +xsl.parseError.linepos +"\n" +
			xsl.parseError.srcText);
		//
		return;
    }
    if (debug) {WScript.Echo(" output file : " + pathHTML + podadr + fso.GetBaseName(oFile.name) + ".htm");}
    //
    // vyjímka pro index.html
    var extenze = '.htm'; 
    // vyjímka pro index.html ostatni se jmenuji htm

    if (fso.GetBaseName(oFile.name).toUpperCase() == INDEX) extenze = '.html';
    // pripadny podadresar je treba vytvorit
    if (podadr != '') fso.CreateFolder(pathHTML + podadr);
    	 
    
    WScript.Echo(pathHTML + podadr + fso.GetBaseName(oFile.name) + extenze);
    var MyFile = fso.CreateTextFile( pathHTML + podadr + fso.GetBaseName(oFile.name) + extenze, true);

    var Result;
    try
    {
      Result = xml.transformNode(xsl);
      MyFile.Write(Result);
    }
    catch ( e ) 
    {
    	    WScript.Echo("!! Chyba transformace souboru [" + oFile.Path + "] ::" + xml.parseError.reason +
    	    	         "\n øádka, pozice: " + xsl.parseError.line + " , " + xsl.parseError.linepos + "\n" +
			 "\n source: " + xsl.parseError.srcText +
    	    	         "\n xsl file: " + generatorXSL +
    	    	         " \n\n description: " + e.description +
    	    	         " \n\n message: " + e.message+
    	    	         " \n\n name: " + e.name
    	    	         
    	    	         
    	    	         );
    };
    
    MyFile.Close();
    
       
    /*
      // *** UKLADANI V XML presneji xhtml zatim nejde kvuli scriptum
      // kdybych ponechal scripty v souborech, tak by to mozna slo
    try
    {
      xml.transformNodeToObject(xsl, vysledek);
    }
    catch ( e ) 
    {
       WScript.Echo("Chyba transformace: " + xml.parseError.reason + "\n "+e.description );
    };
    vysledek.save(pathHTML + fso.GetBaseName(oFile.name) + extenze);

    */
    
    if (debug) WScript.Echo("Transformace: " + xml.parseError.reason);
 // 

    }
   }
  }
 }	


//*************************************************************************
//*
//*  START STAVBY HTML
//*
//*************************************************************************
//
//
if (debug) WScript.Echo('--- Build HTML : do : ' + pathHTML);

xml = openMSXML();
xsl = openMSXML();
vysledek = openMSXML();

xml.async = false;
xsl.async = false;
vysledek.async = false;
xsl.setProperty('AllowDocumentFunction', true);
 

if (debug) WScript.Echo('--- inicializace FileSystemObject -----');

// Create FileSystemObject object to access the file system.
fso = WScript.CreateObject("Scripting.FileSystemObject");

var wsh = WScript.CreateObject ("WScript.Shell");
vsechny = 0;
prazdnych = 0;
pocetsouboru = 0;
//
// 1. soubory v HTMLV
d = fso.GetFolder(wsh.ExpandEnvironmentStrings(pathTemplates));
// ************************************************************
if (debug) WScript.Echo('--- zpracovani adresare : ' + d);
                   zpracujsoubory(d,'INDEX','');
// ************************************************************
//
// 2. zpracuj podadresáøe v HTMLV
   fc = new Enumerator(d.SubFolders);
   s = "\n";
   for (;!fc.atEnd(); fc.moveNext())
      {
        d = fso.GetFolder(fc.item());
        // WScript.Echo('--- zpracovani adresare : ' + d + ' ** ' +fso.GetBaseName(d));
        zpracujsoubory(d,'xxxxxxx',fso.GetBaseName(d)+'\\');
      }


msg = "V adresari: " + pathHTML + " \n" +
      "vygenerováno celkem: " + pocetsouboru + ' souborù.';
if (debug) WScript.Echo(msg);
//
//               *****  konec  *****
//





