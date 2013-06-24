#!/usr/bin/perl
use settings;

#############################################################
#
# BG Volumina v. 0.3
# Bibliographic Database Script Kit.
# NO WARRANTIES OR SUPPORT OF ANY KIND -
# USE AT YOUR OWN RISK!
# This script is not copyrighted and
# is in the public domain!
# You can use it for any legal purpose!
# You can modify it and redistibute it by any means!
# Author: Dimitar D. Mitov ddmitov@yahoo.com
# You need Perl 5.8.3 or higher to run the script!
#
#############################################################

# UTF-8 for the input:
binmode (STDIN, ":utf8");

# Reading input:
$query = $ENV{'QUERY_STRING'};
$query =~ tr/+/ /;
$query =~ s/%(..)/pack("C", hex($1))/eg;
$query =~ tr/\\|[|]|<|>|{|}|#|$/ /;

# Splitting information into name/value pairs:
@pairs = split(/&/,$query);
foreach $pair(@pairs){
($key,$value)=split(/=/,$pair);
$formdata{$key}.="$value";}

# Defining fields:
$lang=$formdata{'lang'};
$db=$formdata{'db'};
$AUCTOR=$formdata{'AUCTOR'};
$ALIAS=$formdata{'ALIAS'};
$TITLE=$formdata{'TITLE'};
$PLACE=$formdata{'PLACE'};
$JOURNAL=$formdata{'JOURNAL'};
$VOLUME=$formdata{'VOLUME'};
$YEAR=$formdata{'YEAR'};
$PAGES=$formdata{'PAGES'};

# Language settings - Bulgarian:
if ($lang eq 'bg'){
$label_html_title = $label_bg_html_title;
$label_add_form_title = $label_bg_add_form_title;
$label_author = $label_bg_author;
$label_alias = $label_bg_alias;
$label_title = $label_bg_title;
$label_place = $label_bg_place;
$label_journal = $label_bg_journal;
$label_volume = $label_bg_volume;
$label_year = $label_bg_year;
$label_pages = $label_bg_pages;
$label_add = $label_bg_add;
$label_reset = $label_bg_reset;
$label_back = $label_bg_back;
}

# Language settings - English:
if ($lang eq 'en'){
$label_html_title = $label_en_html_title;
$label_add_form_title = $label_en_add_form_title;
$label_author = $label_en_author;
$label_alias = $label_en_alias;
$label_title = $label_en_title;
$label_place = $label_en_place;
$label_journal = $label_en_journal;
$label_volume = $label_en_volume;
$label_year = $label_en_year;
$label_pages = $label_en_pages;
$label_add = $label_en_add;
$label_reset = $label_en_reset;
$label_back = $label_en_back;
}

print "Content-type: text/html; charset=utf-8\n\n";

print "<html>\n";

print "<head>\n";

print "<title>$label_HTML_TITLE</title>\n";
print "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>\n";

form_css ();
aceTextField ();
aceTextArrea ();
aceButton ();
brownButton ();
field_focus ();

print "</head>\n";

print "<body text=#000000 bgcolor='#ffffb8' link='#a03830' vlink='#a03830' alink='#ff3830' onLoad=\"putFocus(0,2);\">\n";

print "<!-- This script and many more are available free online at -->\n";
print "<!-- The JavaScript Source!! http://javascript.internet.com -->\n";
print "<!-- Original:  Jeremy Wollard (wollard@flash.net) -->\n";

print "<script>\n";
print "//verify for netscape/mozilla\n";
print "var isNS4 = (navigator.appName==\"Netscape\")?1:0;\n";
print "</script>\n";

print "<body bgcolor='#ffffb8' link='#a03830' vlink='#a03830' alink='#ff3830'>\n";

print "<center>\n";
print "<font face='Times New Roman' size=4><b>$label_add_form_title</b></font><br><br>\n";

print "<FORM action=/cgi-bin/$add_script method=POST>\n";
print "<font face='Verdana' size='2'>\n";

print "<input type='hidden' name='db' value='$formdata{'db'}'>\n";
print "<input type='hidden' name='lang' value='$formdata{'lang'}'>\n";

print "<b>$label_author</b><br>\n";

print "<textarea class='aceTextArrea' name='AUCTOR' rows='2' cols='100'\n";
print "onKeypress=\"if(!isNS4){if\n";
print "((event.keyCode > 123 && event.keyCode < 125))\n";
print "event.returnValue = false;}else{if\n";
print "((event.which > 123 && event.which < 125)) return false;}\"\n";

print "onChange=\"javascript:this.value=this.value.toUpperCase();\">$AUCTOR</textarea>\n";

print "<br>\n";

print "<b>$label_alias</b><br>\n";

print "<textarea class='aceTextArrea' name='ALIAS' rows='1' cols='100'\n";
print "onKeypress=\"if(!isNS4){if\n";
print "((event.keyCode > 123 && event.keyCode < 125))\n";
print "event.returnValue = false;}else{if\n";
print "((event.which > 123 && event.which < 125)) return false;}\"\n";

print "onChange=\"javascript:this.value=this.value.toUpperCase();\">$ALIAS</textarea>\n";

print "<br>\n";

print "<b>$label_title</b><br>\n";

print "<textarea class='aceTextArrea' name='TITLE' rows='3' cols='100'\n";
print "onKeypress=\"if(!isNS4){if\n";
print "((event.keyCode > 123 && event.keyCode < 125))\n";
print "event.returnValue = false;}else{if\n";
print "((event.which > 123 && event.which < 125)) return false;}\">$TITLE</textarea>\n";

print "<br>\n";

print "<b>$label_place</b><br>\n";

print "<textarea class='aceTextArrea' name='PLACE' rows='1' cols='100'\n";
print "onKeypress=\"if(!isNS4){if\n";
print "((event.keyCode > 123 && event.keyCode < 125))\n";
print "event.returnValue = false;}else{if\n";
print "((event.which > 123 && event.which < 125)) return false;}\">$PLACE</textarea>\n";

print "<br>\n";

print "<b>$label_journal</b><br>\n";

print "<textarea class='aceTextArrea' name='JOURNAL' rows='2' cols='100'\n";
print "onKeypress=\"if(!isNS4){if\n";
print "((event.keyCode > 123 && event.keyCode < 125))\n";
print "event.returnValue = false;}else{if\n";
print "((event.which > 123 && event.which < 125)) return false;}\">$JOURNAL</textarea>\n";

print "<br>\n";

print "<table width='35%' border='0' cellspacing='2' cellpadding='0'>\n";

print "    <tr>\n";

print "        <!-- Row 1 Column 1 -->\n";
print "        <td  align='center'>\n";
print "        <font face='Verdana' size='2'><b>$label_volume</b></font>\n";
print "        </td>\n";

print "        <!-- Row 1 Column 2 -->\n";
print "        <td  align='center'>\n";
print "        <font face='Verdana' size='2'><b>$label_year</b></font>\n";
print "        </td>\n";

print "        <!-- Row 1 Column 3 -->\n";
print "        <td  align='center'>\n";
print "        <font face='Verdana' size='2'><b>$label_pages</b></font>\n";
print "        </td>\n";

print "    </tr>\n";

print "    <tr>\n";

print "        <!-- Row 2 Column 1 -->\n";
print "        <td  align='center'>\n";

print "        <input class='aceTextField' type='text' name='VOLUME' size='12' value='$VOLUME'\n";
print "        onKeypress=\"if(!isNS4){if\n";
print "        ((event.keyCode < 45 || event.keyCode > 57))\n";
print "        event.returnValue = false;}else{if\n";
print "        ((event.which < 45 || event.which > 57))\n";
print "        return false;}\">\n";

print "        </td>\n";

print "        <!-- Row 2 Column 2 -->\n";
print "        <td  align='center'>\n";

print "        <input class='aceTextField' type='text' name='YEAR' size='12' value='$YEAR'\n";
print "        onKeypress=\"if(!isNS4){if\n";
print "        ((event.keyCode < 45 || event.keyCode > 57))\n";
print "        event.returnValue = false;}else{if\n";
print "        ((event.which < 45 || event.which > 57))\n";
print "        return false;}\">\n";

print "        </td>\n";

print "        <!-- Row 2 Column 3 -->\n";
print "        <td  align='center'>\n";

print "        <input class='aceTextField' type='text' name='PAGES' size='12' value='$PAGES'\n";
print "        onKeypress=\"if(!isNS4){if\n";
print "        ((event.keyCode < 45 || event.keyCode > 57))\n";
print "        event.returnValue = false;}else{if\n";
print "        ((event.which < 45 || event.which > 57))\n";
print "        return false;}\">\n";

print "        </td>\n";

print "    </tr>\n";

print "</table>\n";

print "<br>\n";

print "<input class=aceButton type='submit' value='   $label_add   '>\n";
print "<input class=aceButton type='reset' value='   $label_reset   '>\n";

print "</font>\n";
print "</form>\n";

print "<DIV class=menu>\n";
print "<A class=menu href='../index_$lang.htm#add'>$label_back</A>\n";
print "</DIV>\n";

print "</center>\n";

print "</body>\n";

print "</html>\n";
