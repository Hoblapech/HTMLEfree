rem generuje HTMLE pro SilniceKT na stejnem disku
rem pro testování prechodu na EDGE oh.
rem VERZE ???? PRO DMD s dvema adresari HTMLV a HTMLE
call BuildHTMLE
echo off
del  /F /S /q ..\_CASSES\SilniceKT\MIRROR\DoRes\HTMLE\* 1>nul
rem rd /S /Q ..\_CASSES\SilniceKT\MIRROR-474Chrome\DoRes\HTMLE\*
rem zkopirovat vysledek
xcopy HTMLE\*.* ..\_CASSES\SilniceKT\MIRROR\DoRes\HTMLE\*.* /C /R /q  /Y /E
rem pause
