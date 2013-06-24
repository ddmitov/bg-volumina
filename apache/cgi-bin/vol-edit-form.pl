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
# This script is in Unicode (UTF-8) code page!
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
$act=$formdata{'act'};
$db=$formdata{'db'};
$rp=$formdata{'rp'};
$sp=$formdata{'sp'};
$AUTHOR=$formdata{'AUTHOR'};
$TITLE=$formdata{'TITLE'};
$PLACE=$formdata{'PLACE'};
$JOURNAL=$formdata{'JOURNAL'};
$YEAR1=$formdata{'YEAR1'};
$YEAR2=$formdata{'YEAR2'};
$sort1=$formdata{'sort1'};
$sort2=$formdata{'sort2'};
$sort3=$formdata{'sort3'};
$sort4=$formdata{'sort4'};
$case=$formdata{'case'};
$start=$formdata{'start'};
$rn=$formdata{'rn'};
$script=$formdata{'script'};

# Language settings - Bulgarian:
if ($lang eq 'bg'){
$label_html_title = $label_bg_html_title;
$label_edit_form_title = $label_bg_edit_form_title;
$label_author = $label_bg_author;
$label_alias = $label_bg_alias;
$label_title = $label_bg_title;
$label_place = $label_bg_place;
$label_journal = $label_bg_journal;
$label_volume = $label_bg_volume;
$label_year = $label_bg_year;
$label_pages = $label_bg_pages;
$label_add = $label_bg_add;
$label_back = $label_bg_back;
$label_error_open = $label_bg_error_open;
}

# Language settings - English:
if ($lang eq 'en'){
$label_html_title = $label_en_html_title;
$label_edit_form_title = $label_en_edit_form_title;
$label_author = $label_en_author;
$label_alias = $label_en_alias;
$label_title = $label_en_title;
$label_place = $label_en_place;
$label_journal = $label_en_journal;
$label_volume = $label_en_volume;
$label_year = $label_en_year;
$label_pages = $label_en_pages;
$label_add = $label_en_add;
$label_back = $label_en_back;
$label_error_open = $label_en_error_open;
}

# Database location:

###################################################################
open (INFO, "/ramdisk/home/knoppix/apache/db/$db") or nodatabase();
###################################################################

# Defining array:
@array=<INFO>;
close (INFO);

# Defining ANY STRING operator:
$AUTHOR =~ s/\*/\.*/;
$TITLE =~ s/\*/\.*/;
$PLACE =~ s/\*/\.*/;
$JOURNAL =~ s/\*/\.*/;

# Starting search.
# Splitting fields - necessary for the subsequent operations:
foreach $line (@array){
($FIELD_AUTHOR,$FIELD_TITLE,$FIELD_PLACE,$FIELD_JOURNAL,$FIELD_VOLUME,$FIELD_YEAR,$FIELD_PAGES)=split(/$delimiter/,$line);

# Defining WHOLE WORDS operator (using the spacebar):
if($AUTHOR =~ '\s$' || $TITLE =~ '\s$' || $PLACE =~ '\s$' || $JOURNAL =~ '\s$'){
$FIELD_AUTHOR =~ tr/,|.|-/ /;
$FIELD_TITLE =~ tr/,|.|!|)|\// /;
$FIELD_PLACE =~ tr/,|.|!|)|\// /;
$FIELD_JOURNAL =~ tr/,|.|!|)|\// /;
}

# Case insensitivity:
if($case eq 'off'){

$AUTHOR =~ tr/A-Z/a-z/;
$AUTHOR =~ tr/А|Б|В|Г|Д|Е|Ж|З|И|Й|К|Л|М|Н|О|П/а|б|в|г|д|е|ж|з|и|й|к|л|м|н|о|п/;
$AUTHOR =~ tr/Р|С|Т|У|Ф|Х|Ц|Ч|Ш|Щ|Ъ|Ю|Я/р|с|т|у|ф|х|ц|ч|ш|щ|ъ|ю|я/;

$FIELD_AUTHOR =~ tr/A-Z/a-z/;
$FIELD_AUTHOR =~ tr/А|Б|В|Г|Д|Е|Ж|З|И|Й|К|Л|М|Н|О|П/а|б|в|г|д|е|ж|з|и|й|к|л|м|н|о|п/;
$FIELD_AUTHOR =~ tr/Р|С|Т|У|Ф|Х|Ц|Ч|Ш|Щ|Ъ|Ю|Я/р|с|т|у|ф|х|ц|ч|ш|щ|ъ|ю|я/;

$TITLE =~ tr/A-Z/a-z/;
$TITLE =~ tr/А|Б|В|Г|Д|Е|Ж|З|И|Й|К|Л|М|Н|О|П/а|б|в|г|д|е|ж|з|и|й|к|л|м|н|о|п/;
$TITLE =~ tr/Р|С|Т|У|Ф|Х|Ц|Ч|Ш|Щ|Ъ|Ю|Я/р|с|т|у|ф|х|ц|ч|ш|щ|ъ|ю|я/;

$FIELD_TITLE =~ tr/A-Z/a-z/;
$FIELD_TITLE =~ tr/А|Б|В|Г|Д|Е|Ж|З|И|Й|К|Л|М|Н|О|П/а|б|в|г|д|е|ж|з|и|й|к|л|м|н|о|п/;
$FIELD_TITLE =~ tr/Р|С|Т|У|Ф|Х|Ц|Ч|Ш|Щ|Ъ|Ю|Я/р|с|т|у|ф|х|ц|ч|ш|щ|ъ|ю|я/;

$PLACE =~ tr/A-Z/a-z/;
$PLACE =~ tr/А|Б|В|Г|Д|Е|Ж|З|И|Й|К|Л|М|Н|О|П/а|б|в|г|д|е|ж|з|и|й|к|л|м|н|о|п/;
$PLACE =~ tr/Р|С|Т|У|Ф|Х|Ц|Ч|Ш|Щ|Ъ|Ю|Я/р|с|т|у|ф|х|ц|ч|ш|щ|ъ|ю|я/;

$FIELD_PLACE =~ tr/A-Z/a-z/;
$FIELD_PLACE =~ tr/А|Б|В|Г|Д|Е|Ж|З|И|Й|К|Л|М|Н|О|П/а|б|в|г|д|е|ж|з|и|й|к|л|м|н|о|п/;
$FIELD_PLACE =~ tr/Р|С|Т|У|Ф|Х|Ц|Ч|Ш|Щ|Ъ|Ю|Я/р|с|т|у|ф|х|ц|ч|ш|щ|ъ|ю|я/;

$JOURNAL =~ tr/A-Z/a-z/;
$JOURNAL =~ tr/А|Б|В|Г|Д|Е|Ж|З|И|Й|К|Л|М|Н|О|П/а|б|в|г|д|е|ж|з|и|й|к|л|м|н|о|п/;
$JOURNAL =~ tr/Р|С|Т|У|Ф|Х|Ц|Ч|Ш|Щ|Ъ|Ю|Я/р|с|т|у|ф|х|ц|ч|ш|щ|ъ|ю|я/;

$FIELD_JOURNAL =~ tr/A-Z/a-z/;
$FIELD_JOURNAL =~ tr/А|Б|В|Г|Д|Е|Ж|З|И|Й|К|Л|М|Н|О|П/а|б|в|г|д|е|ж|з|и|й|к|л|м|н|о|п/;
$FIELD_JOURNAL =~ tr/Р|С|Т|У|Ф|Х|Ц|Ч|Ш|Щ|Ъ|Ю|Я/р|с|т|у|ф|х|ц|ч|ш|щ|ъ|ю|я/}

# Searching:
if($AUTHOR eq ''){$c1 = 1; $d1 = 1}
else{$c1=$FIELD_AUTHOR; $d1=$AUTHOR}
if($TITLE eq ''){$c2 = 1; $d2 = 1}
else{$c2=$FIELD_TITLE; $d2=$TITLE}
if($PLACE eq ''){$c3 = 1; $d3 = 1}
else{$c3=$FIELD_PLACE; $d3=$PLACE}
if($JOURNAL eq ''){$c4 = 1; $d4 = 1}
else{$c4=$FIELD_JOURNAL; $d4=$JOURNAL}
if($YEAR1 eq ''){$c5 = 2; $d5 = 1}
else{$c5=$FIELD_YEAR; $d5=$YEAR1}
if($YEAR2 eq ''){$c6 = 1; $d6 = 2}
else{$c6=$FIELD_YEAR; $d6=$YEAR2}
if($c5 >= $d5){
if($c6 <= $d6){
if($c1 =~ $d1 & $c2 =~ $d2 & $c3 =~ $d3 & $c4 =~ $d4){
push(@results, $line)}}}

# Searching (ANY ORDER OF WORDS operator):
if($AUTHOR =~ '~' || $TITLE =~ '~' || $PLACE =~ '~' || $JOURNAL =~ '~'){
($AUTHOR_01,$AUTHOR_02,$AUTHOR_03,$AUTHOR_04,$AUTHOR_05)=split(/~/,$AUTHOR);
($TITLE_01,$TITLE_02,$TITLE_03,$TITLE_04,$TITLE_05)=split(/~/,$TITLE);
($PLACE_01,$PLACE_02,$PLACE_03,$PLACE_04,$PLACE_05)=split(/~/,$PLACE);
($JOURNAL_01,$JOURNAL_02,$JOURNAL_03,$JOURNAL_04,$JOURNAL_05)=split(/~/,$JOURNAL);

if($AUTHOR eq ''){$c1 = 1;
$d1_01 = 1; $d1_02 = 1; $d1_03 = 1; $d1_04 = 1; $d1_05 = 1;}
else{$c1=$FIELD_AUTHOR;
$d1_01=$AUTHOR_01; $d1_02=$AUTHOR_02; $d1_03=$AUTHOR_03; $d1_04=$AUTHOR_04; $d1_05=$AUTHOR_05;}

if($TITLE eq ''){$c2 = 1;
$d2_01 = 1; $d2_02 = 1; $d2_03 = 1; $d2_04 = 1; $d2_05 = 1;}
else{$c2=$FIELD_TITLE;
$d2_01=$TITLE_01; $d2_02=$TITLE_02; $d2_03=$TITLE_03; $d2_04=$TITLE_04; $d2_05=$TITLE_05;}

if($PLACE eq ''){$c3 = 1;
$d3_01 = 1; $d3_02 = 1; $d3_03 = 1; $d3_04 = 1; $d3_05 = 1;}
else{$c3=$FIELD_PLACE;
$d3_01=$PLACE_01; $d3_02=$PLACE_02; $d3_03=$PLACE_03; $d3_04=$PLACE_04; $d3_05=$PLACE_05;}

if($JOURNAL eq ''){$c4 = 1;
$d4_01 = 1; $d4_02 = 1; $d4_03 = 1; $d4_04 = 1; $d4_05 = 1;}
else{$c4=$FIELD_JOURNAL;
$d4_01=$JOURNAL_01; $d4_02=$JOURNAL_02; $d4_03=$JOURNAL_03; $d4_04=$JOURNAL_04; $d4_05=$JOURNAL_05;}

if($YEAR1 eq ''){$c5=2; $d5=1}
else{$c5=$FIELD_YEAR; $d5=$YEAR_01}

if($YEAR2 eq ''){$c6=1; $d6=2}
else{$c6=$FIELD_YEAR; $d6=$YEAR_02}

if($c5 >= $d5){
if($c6 <= $d6){
if($c1 =~ $d1_01 && $c1 =~ $d1_02 && $c1 =~ $d1_03 && $c1 =~ $d1_04 && $c1 =~ $d1_05){
if($c2 =~ $d2_01 && $c2 =~ $d2_02 && $c2 =~ $d2_03 && $c2 =~ $d2_04 && $c2 =~ $d2_05){
if($c3 =~ $d3_01 && $c3 =~ $d3_02 && $c3 =~ $d3_03 && $c3 =~ $d3_04 && $c3 =~ $d3_05){
if($c4 =~ $d4_01 && $c4 =~ $d4_02 && $c4 =~ $d4_03 && $c4 =~ $d4_04 && $c4 =~ $d4_05){
push(@results, $line)}}}}}}}
}

# Sorting results - Schwartzian transform:
@sorted_results = map{$_->[0]}
sort multisort map {[$_, split /$delimiter/]} @results;

foreach $line (@sorted_results){
$number++;
if($number == $rn){
push(@edit, $line)}}

foreach $line (@edit){
($FIELD_AUTHOR_2,$FIELD_TITLE_2,$FIELD_PLACE_2,$FIELD_JOURNAL_2,$FIELD_VOLUME_2,$FIELD_YEAR_2,$FIELD_PAGES_2)=split(/$delimiter/,$line);
($FIELD_AUCTOR_2,$FIELD_ALIAS_2)=split(/\<!--/,$FIELD_AUTHOR_2);
$FIELD_ALIAS_2 =~ s/--\>//;
}

$EDIT_AUCTOR = $FIELD_AUCTOR_2;
$EDIT_ALIAS = $FIELD_ALIAS_2;
$EDIT_TITLE = $FIELD_TITLE_2;
$EDIT_PLACE = $FIELD_PLACE_2;
$EDIT_JOURNAL = $FIELD_JOURNAL_2;
$EDIT_VOLUME = $FIELD_VOLUME_2;
$EDIT_YEAR = $FIELD_YEAR_2;
$EDIT_PAGES = $FIELD_PAGES_2;

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

print "</head>\n";

print "<body>\n";

print "<!-- This script and many more are available free online at -->\n";
print "<!-- The JavaScript Source!! http://javascript.internet.com -->\n";
print "<!-- Original:  Jeremy Wollard (wollard@flash.net) -->\n";

print "<script>\n";
print "//verify for netscape/mozilla\n";
print "var isNS4 = (navigator.appName==\"Netscape\")?1:0;\n";
print "</script>\n";

print "<body bgcolor='#ffffb8' link='#a03830' vlink='#a03830' alink='#ff3830'>\n";

print "<center>\n";
print "<font face='Times New Roman' size=4><b>$label_edit_form_title</b></font>\n";

print "<FORM action=/cgi-bin/$edit_script method=POST>\n";
print "<font face='Verdana' size='2'>\n";

print "<input type='hidden' name='lang' value='$formdata{'lang'}'>\n";
print "<input type='hidden' name='act' value='$formdata{'act'}'>\n";
print "<input type='hidden' name='db' value='$formdata{'db'}'>\n";
print "<input type='hidden' name='rp' value='$formdata{'rp'}'>\n";
print "<input type='hidden' name='sp' value='$formdata{'sp'}'>\n";
print "<input type='hidden' name='case' value='$formdata{'case'}'>\n";
print "<input type='hidden' name='start' value='$formdata{'start'}'>\n";
print "<input type='hidden' name='rn' value='$formdata{'rn'}'>\n";
print "<input type='hidden' name='script' value='$formdata{'script'}'>\n";

print "<input type='hidden' name='FIND_AUTHOR' value='$formdata{'AUTHOR'}'>\n";
print "<input type='hidden' name='FIND_TITLE' value='$formdata{'TITLE'}'>\n";
print "<input type='hidden' name='FIND_PLACE' value='$formdata{'PLACE'}'>\n";
print "<input type='hidden' name='FIND_JOURNAL' value='$formdata{'JOURNAL'}'>\n";
print "<input type='hidden' name='FIND_YEAR1' value='$formdata{'YEAR1'}'>\n";
print "<input type='hidden' name='FIND_YEAR2' value='$formdata{'YEAR2'}'>\n";

print "<input type='hidden' name='sort1' value='$formdata{'sort1'}'>\n";
print "<input type='hidden' name='sort2' value='$formdata{'sort2'}'>\n";
print "<input type='hidden' name='sort3' value='$formdata{'sort3'}'>\n";
print "<input type='hidden' name='sort4' value='$formdata{'sort4'}'>\n";

print "<input type='hidden' name='OLD_AUCTOR' value='$EDIT_AUCTOR'>\n";
print "<input type='hidden' name='OLD_ALIAS' value='$EDIT_ALIAS'>\n";
print "<input type='hidden' name='OLD_TITLE' value='$EDIT_TITLE'>\n";
print "<input type='hidden' name='OLD_PLACE' value='$EDIT_PLACE'>\n";
print "<input type='hidden' name='OLD_JOURNAL' value='$EDIT_JOURNAL'>\n";
print "<input type='hidden' name='OLD_VOLUME' value='$EDIT_VOLUME'>\n";
print "<input type='hidden' name='OLD_YEAR' value='$EDIT_YEAR'>\n";
print "<input type='hidden' name='OLD_PAGES' value='$EDIT_PAGES'>\n";

print "<b>$label_author</b><br>\n";

print "<textarea class='aceTextArrea' name='AUCTOR' rows='2' cols='100'\n";
print "onKeypress=\"if(!isNS4){if\n";
print "((event.keyCode > 123 && event.keyCode < 125))\n";
print "event.returnValue = false;}else{if\n";
print "((event.which > 123 && event.which < 125)) return false;}\"\n";

print "onChange=\"javascript:this.value=this.value.toUpperCase();\">$EDIT_AUCTOR</textarea>\n";

print "<br>\n";

print "<b>$label_alias</b><br>\n";

print "<textarea class='aceTextArrea' name='ALIAS' rows='1' cols='100'\n";
print "onKeypress=\"if(!isNS4){if\n";
print "((event.keyCode > 123 && event.keyCode < 125))\n";
print "event.returnValue = false;}else{if\n";
print "((event.which > 123 && event.which < 125)) return false;}\"\n";

print "onChange=\"javascript:this.value=this.value.toUpperCase();\">$EDIT_ALIAS</textarea>\n";

print "<br>\n";

print "<b>$label_title</b><br>\n";

print "<textarea class='aceTextArrea' name='TITLE' rows='3' cols='100'\n";
print "onKeypress=\"if(!isNS4){if\n";
print "((event.keyCode > 123 && event.keyCode < 125))\n";
print "event.returnValue = false;}else{if\n";
print "((event.which > 123 && event.which < 125)) return false;}\">$EDIT_TITLE</textarea>\n";

print "<br>\n";

print "<b>$label_place</b><br>\n";

print "<textarea class='aceTextArrea' name='PLACE' rows='1' cols='100'\n";
print "onKeypress=\"if(!isNS4){if\n";
print "((event.keyCode > 123 && event.keyCode < 125))\n";
print "event.returnValue = false;}else{if\n";
print "((event.which > 123 && event.which < 125)) return false;}\">$EDIT_PLACE</textarea>\n";

print "<br>\n";

print "<b>$label_journal</b><br>\n";

print "<textarea class='aceTextArrea' name='JOURNAL' rows='3' cols='100'\n";
print "onKeypress=\"if(!isNS4){if\n";
print "((event.keyCode > 123 && event.keyCode < 125))\n";
print "event.returnValue = false;}else{if\n";
print "((event.which > 123 && event.which < 125)) return false;}\">$EDIT_JOURNAL</textarea>\n";

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

print "        <input class='aceTextField' type='text' name='VOLUME' size='12' value='$EDIT_VOLUME'\n";
print "        onKeypress=\"if(!isNS4){if\n";
print "        ((event.keyCode < 45 || event.keyCode > 57))\n";
print "        event.returnValue = false;}else{if\n";
print "        ((event.which < 45 || event.which > 57))\n";
print "        return false;}\">\n";

print "        </td>\n";

print "        <!-- Row 2 Column 2 -->\n";
print "        <td  align='center'>\n";

print "        <input class='aceTextField' type='text' name='YEAR' size='12' value='$EDIT_YEAR'\n";
print "        onKeypress=\"if(!isNS4){if\n";
print "        ((event.keyCode < 45 || event.keyCode > 57))\n";
print "        event.returnValue = false;}else{if\n";
print "        ((event.which < 45 || event.which > 57))\n";
print "        return false;}\">\n";

print "        </td>\n";

print "        <!-- Row 2 Column 3 -->\n";
print "        <td  align='center'>\n";

print "        <input class='aceTextField' type='text' name='PAGES' size='12' value='$EDIT_PAGES'\n";
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

print "</font>\n";
print "</form>\n";

print "<hr width='95%'>\n";
print "<DIV class=menu>\n";
print "<A class=menu href='javascript:history.go(-1)'>$label_back</A>\n";
print "</DIV>\n";
print "<hr width='95%'>\n";

print "</center>\n";

print "</body>\n";

print "</html>\n";

# MISSING DATABASE FILE SUBROUTINE:
sub nodatabase {
print "Content-type: text/html; charset=utf-8\n\n";
print "<html>\n";
print "<head>\n";
print "<title>$label_html_title</title>\n";

brownButton ();

print "</head>\n";

form_css ();

print "<body bgcolor='#ffffb8' link='#a03830' vlink='#a03830' alink='#ff3830'>\n";

print "<center><font face='Verdana' size='4'>\n";
print "$label_error_open\n";

print "<br><br>\n";
print "<hr width='95%'>\n";
print "<DIV class=menu>\n";
print "<A class=menu href='javascript:history.go(-1)'>$label_back</A>\n";
print "</DIV>\n";
print "<hr width='95%'>\n";

print "</font></body></html>\n";
exit}

# MULTISORT SUBROUTINE:
sub multisort {
lc($a->[$sort1]) cmp lc($b->[$sort1]) ||
lc($a->[$sort2]) cmp lc($b->[$sort2]) ||
lc($a->[$sort3]) cmp lc($b->[$sort3]) ||
lc($a->[$sort4]) cmp lc($b->[$sort4]) }
