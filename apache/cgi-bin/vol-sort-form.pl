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

# TITLES:
if ($lang eq 'bg'){
$label_html_title = $label_bg_html_title;
$label_sort_form_title = $label_bg_sort_form_title;
$label_cyr_titles = $label_bg_cyr_titles;
$label_lat_titles = $label_bg_lat_titles;
$label_sort_criteria = $label_bg_sort_criteria;
$label_author = $label_bg_author;
$label_title = $label_bg_title;
$label_place = $label_bg_place;
$label_journal = $label_bg_journal;
$label_volume = $label_bg_volume;
$label_year = $label_bg_year;
$label_off = $label_bg_off;
$label_start_form = $label_bg_start_form;
$label_reset = $label_bg_reset;
$label_back = $label_bg_back;
}

if ($lang eq 'en'){
$label_html_title = $label_en_html_title;
$label_sort_form_title = $label_en_sort_form_title;
$label_cyr_titles = $label_en_cyr_titles;
$label_lat_titles = $label_en_lat_titles;
$label_sort_criteria = $label_en_sort_criteria;
$label_author = $label_en_author;
$label_title = $label_en_title;
$label_place = $label_en_place;
$label_journal = $label_en_journal;
$label_volume = $label_en_volume;
$label_year = $label_en_year;
$label_off = $label_en_off;
$label_start_form = $label_en_start_form;
$label_reset = $label_en_reset;
$label_back = $label_en_back;
}

# HTML Form:
print "Content-type: text/html; charset=utf-8\n\n";

print "<html>\n";

print "<head>\n";

print "<title>$label_html_title</title>\n";
print "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>\n";

form_css();
aceTextField();
aceButton ();
brownButton ();

print "</head>\n";

print "<body text=#000000 bgcolor='#ffffb8' link='#a03830' vlink='#a03830' alink='#ff3830'>\n";

print "<center>\n";

print "<form name='form' method='GET' action='/cgi-bin/$sort_script'>\n";

print "<input type='hidden' name='lang' value='$lang'>\n";

print "<table  width='75%' border='0' cellspacing='4' cellpadding='0'>\n";

print "    <tr>\n";
print "      <!-- Row 1 -->\n";
print "      <td align='center' colspan=2>\n";
print "        <font face='Times New Roman' size=4><b>$label_sort_form_title</b></font>\n";
print "      </td>\n";
print "    </tr>\n";

print "    <tr>\n";
print "      <!-- Row 2 -->\n";
print "      <td align='center' colspan=2>\n";
print "        <br>\n";
print "        <select name='db' size=1>\n";
if($lang eq 'bg'){
print "        <option value='cyr.txt'>&nbsp $label_cyr_titles &nbsp</option>\n";
print "        <option value='lat.txt'>&nbsp $label_lat_titles &nbsp</option>\n";
}

if($lang eq 'en'){
print "        <option value='lat.txt'>&nbsp $label_lat_titles &nbsp</option>\n";
print "        <option value='cyr.txt'>&nbsp $label_cyr_titles &nbsp</option>\n";
}
print "        </select>\n";
print "      </td>\n";
print "    </tr>\n";

print "</table>\n";

print "<table  width='80%' border='0' cellspacing='4' cellpadding='0'>\n";

print "      <tr>\n";
print "        <!-- Row 1 -->\n";
print "        <td align='center'>\n";
print "          <br>\n";
print "          <font face='Times New Roman' size=3><b>$label_sort_criteria</b></font>\n";
print "        </td>\n";
print "      </tr>\n";

print "      <tr>\n";
print "        <!-- Row 2 -->\n";
print "        <td align='center'>\n";

print "          <select name='sort1' size=1>\n";
print "          <option value='1'>&nbsp $label_author &nbsp</option>\n";
print "          <option value='2'>&nbsp $label_title &nbsp</option>\n";
print "          <option value='4'>&nbsp $label_journal &nbsp</option>\n";
print "          <option value='5'>&nbsp $label_volume &nbsp</option>\n";
print "          <option value='6'>&nbsp $label_year &nbsp</option>\n";
print "          <option value=''>&nbsp $label_off &nbsp</option>\n";
print "          </select>&nbsp\n";

print "          <select name='sort2' size=1>\n";
print "          <option value='2'>&nbsp $label_title &nbsp</option>\n";
print "          <option value='1'>&nbsp $label_author &nbsp</option>\n";
print "          <option value='4'>&nbsp $label_journal &nbsp</option>\n";
print "          <option value='5'>&nbsp $label_volume &nbsp</option>\n";
print "          <option value='6'>&nbsp $label_year &nbsp</option>\n";
print "          <option value=''>&nbsp $label_off &nbsp</option>\n";
print "          </select>&nbsp\n";

print "          <select name='sort3' size=1>\n";
print "          <option value='4'>&nbsp $label_journal &nbsp</option>\n";
print "          <option value='1'>&nbsp $label_author &nbsp</option>\n";
print "          <option value='2'>&nbsp $label_title &nbsp</option>\n";
print "          <option value='5'>&nbsp $label_volume &nbsp</option>\n";
print "          <option value='6'>&nbsp $label_year &nbsp</option>\n";
print "          <option value=''>&nbsp $label_off &nbsp</option>\n";
print "          </select>&nbsp\n";

print "          <select name='sort4' size=1>\n";
print "          <option value='6'>&nbsp $label_year &nbsp</option>\n";
print "          <option value='1'>&nbsp $label_author &nbsp</option>\n";
print "          <option value='2'>&nbsp $label_title &nbsp</option>\n";
print "          <option value='4'>&nbsp $label_journal &nbsp</option>\n";
print "          <option value='5'>&nbsp $label_volume &nbsp</option>\n";
print "          <option value=''>&nbsp $label_off &nbsp</option>\n";
print "          </select>\n";

print "        </td>\n";
print "      </tr>\n";

print "    <tr>\n";
print "      <!-- Row 3 -->\n";
print "      <td align='center'>\n";
print "        <br>\n";
print "          <input class=aceButton type='submit' value='$label_start_form'>\n";
print "          &nbsp\n";
print "          <input class=aceButton type='reset' value='$label_reset'>\n";
print "      </td>\n";
print "    </tr>\n";

print "</table>\n";

print "</form>\n";

print "<DIV class=menu>\n";
print "<A class=menu href='../index_$lang.htm#sort'>&nbsp $label_back &nbsp</A>\n";
print "</DIV>\n";

print "<br>\n";

print "</body>\n";

print "</html>\n";
