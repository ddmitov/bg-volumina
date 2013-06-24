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

# Defining fields - part 1:
$lang=$formdata{'lang'};

# TITLES:
if ($lang eq 'bg'){
$label_html_title = $label_bg_html_title;
$label_read_form_title = $label_bg_read_form_title;
$label_author = $label_bg_author;
$label_title = $label_bg_title;
$label_place = $label_bg_place;
$label_journal = $label_bg_journal;
$label_results_per_page = $label_bg_results_per_page;
$label_up = $label_bg_up;
$label_down = $label_bg_down;
$label_start_page = $label_bg_start_page;
$label_cyr_titles = $label_bg_cyr_titles;
$label_lat_titles = $label_bg_lat_titles;
$label_edit_off = $label_bg_edit_off;
$label_edit_on = $label_bg_edit_on;
$label_help = $label_bg_help;
$label_range = $label_bg_range;
$label_first_year = $label_bg_first_year;
$label_last_year = $label_bg_last_year;
$label_sort_criteria = $label_bg_sort_criteria;
$label_year = $label_bg_year;
$label_volume = $label_bg_volume;
$label_off = $label_bg_off;
$label_start_form = $label_bg_start_form;
$label_reset = $label_bg_reset;
$label_back = $label_bg_back;
}

if ($lang eq 'en'){
$label_html_title = $label_en_html_title;
$label_read_form_title = $label_en_read_form_title;
$label_author = $label_en_author;
$label_title = $label_en_title;
$label_place = $label_en_place;
$label_journal = $label_en_journal;
$label_results_per_page = $label_en_results_per_page;
$label_up = $label_en_up;
$label_down = $label_en_down;
$label_start_page = $label_en_start_page;
$label_cyr_titles = $label_en_cyr_titles;
$label_lat_titles = $label_en_lat_titles;
$label_edit_off = $label_en_edit_off;
$label_edit_on = $label_en_edit_on;
$label_help = $label_en_help;
$label_range = $label_en_range;
$label_first_year = $label_en_first_year;
$label_last_year = $label_en_last_year;
$label_sort_criteria = $label_en_sort_criteria;
$label_year = $label_en_year;
$label_volume = $label_en_volume;
$label_off = $label_en_off;
$label_start_form = $label_en_start_form;
$label_reset = $label_en_reset;
$label_back = $label_en_back;
}

# Help files:
if($lang eq 'bg'){
$help = $help_bg;
}

if($lang eq 'en'){
$help = $help_en;
}

# DEFAULT FORM SETTINGS:
# VALUES:
if ($lang eq 'bg'){$value_db = 'cyr.txt'}
if ($lang eq 'en'){$value_db = 'lat.txt'}

$default_value_act = 'off';
$default_value_rp = '8';
$default_value_sp = '1';
$default_value_sort1 = '6';
$default_value_sort2 = '1';
$default_value_sort3 = '2';
$default_value_sort4 = '4';

# LABELS:
if ($lang eq 'bg'){$label_db = $label_cyr_titles};
if ($lang eq 'en'){$label_db = $label_lat_titles};

$default_label_act = $label_edit_off;
$default_label_sort1 = $label_year;
$default_label_sort2 = $label_author;
$default_label_sort3 = $label_title;
$default_label_sort4 = $label_journal;

# Defining fields - part 2:
$act=$formdata{'act'};
$db=$formdata{'db'};
$rp=$formdata{'rp'};
$sp=$formdata{'sp'};
$YEAR1=$formdata{'YEAR1'};
$YEAR2=$formdata{'YEAR2'};
$sort1=$formdata{'sort1'};
$sort2=$formdata{'sort2'};
$sort3=$formdata{'sort3'};
$sort4=$formdata{'sort4'};
$out=$formdata{'out'};

# Choosing which search script to call:
if ($out eq 'file'){$program_name = 'vol-dump.pl'};
if ($out eq 'screen'){$program_name = 'vol-read.pl'};

# Defining form values:
if ($act eq ''){$value_act = $default_value_act}else{$value_act = $act}
if ($rp eq ''){$value_rp = $default_value_rp}else{$value_rp = $rp}
if ($sp eq ''){$value_sp = $default_value_sp}else{$value_sp = $sp}
if ($sort1 eq ''){$value_sort1 = $default_value_sort1}else{$value_sort1 = $sort1}
if ($sort2 eq ''){$value_sort2 = $default_value_sort2}else{$value_sort2 = $sort2}
if ($sort3 eq ''){$value_sort3 = $default_value_sort3}else{$value_sort3 = $sort3}
if ($sort4 eq ''){$value_sort4 = $default_value_sort4}else{$value_sort4 = $sort4}

# Defining form labels:
if ($act eq ''){$label_act = $default_label_act}
if ($rp eq ''){$label_rp = $default_label_rp}
if ($sort1 eq ''){$label_sort1 = $default_label_sort1}
if ($sort2 eq ''){$label_sort2 = $default_label_sort2}
if ($sort3 eq ''){$label_sort3 = $default_label_sort3}
if ($sort4 eq ''){$label_sort4 = $default_label_sort4}

if ($act eq 'off'){$label_act = $label_edit_off}
if ($act eq 'edit'){$label_act = $label_edit_on}

if ($sort1 eq '1'){$label_sort1 = $label_author}
if ($sort1 eq '2'){$label_sort1 = $label_title}
if ($sort1 eq '4'){$label_sort1 = $label_journal}
if ($sort1 eq '5'){$label_sort1 = $label_volume}
if ($sort1 eq '6'){$label_sort1 = $label_year}
if ($sort1 eq 'off'){$label_sort1 = $label_off}

if ($sort2 eq '1'){$label_sort2 = $label_author}
if ($sort2 eq '2'){$label_sort2 = $label_title}
if ($sort2 eq '4'){$label_sort2 = $label_journal}
if ($sort2 eq '5'){$label_sort2 = $label_volume}
if ($sort2 eq '6'){$label_sort2 = $label_year}
if ($sort2 eq 'off'){$label_sort2 = $label_off}

if ($sort3 eq '1'){$label_sort3 = $label_author}
if ($sort3 eq '2'){$label_sort3 = $label_title}
if ($sort3 eq '4'){$label_sort3 = $label_journal}
if ($sort3 eq '5'){$label_sort3 = $label_volume}
if ($sort3 eq '6'){$label_sort3 = $label_year}
if ($sort3 eq 'off'){$label_sort3 = $label_off}

if ($sort4 eq '1'){$label_sort4 = $label_author}
if ($sort4 eq '2'){$label_sort4 = $label_title}
if ($sort4 eq '4'){$label_sort4 = $label_journal}
if ($sort4 eq '5'){$label_sort4 = $label_volume}
if ($sort4 eq '6'){$label_sort4 = $label_year}
if ($sort4 eq 'off'){$label_sort4 = $label_off}

# HTML Form:
print "Content-type: text/html; charset=utf-8\n\n";

print "<html>\n";

print "<head>\n";

print "<title>$label_html_title</title>\n";
print "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>\n";

form_css ();
aceTextField ();
aceButton ();
brownButton ();
field_focus ();

print "</head>\n";

print "<body text=#000000 bgcolor='#ffffb8' link='#a03830' vlink='#a03830' alink='#ff3830' onLoad=\"putFocus(0,9);\">\n";

print "<center>\n";

print "<form name='form' method='GET' action='/cgi-bin/$program_name'>\n";

print "<input type='hidden' name='lang' value='$lang'>\n";

print "<table width='85%' border='0' cellspacing='3' cellpadding='1'>\n";

print "    <tr>\n";
print "      <!-- Row 1 -->\n";
print "      <td align='center' colspan=2>\n";
print "        <font face='Times New Roman' size=4><b>$label_read_form_title</b></font>\n";
print "      </td>\n";
print "    </tr>\n";

print "    <tr>\n";
print "      <!-- Row 2 -->\n";
print "      <td align='center' colspan=2>\n";
print "        <font face='Verdana' size=2>\n";
print "        <select name='db' size=1>\n";
print "        <option value='$value_db'>&nbsp $label_db &nbsp</option>\n";
if ($label_db ne $label_cyr_titles){print "<option value='cyr.txt'>&nbsp $label_cyr_titles &nbsp</option>\n"}
if ($label_db ne $label_lat_titles){print "<option value='lat.txt'>&nbsp $label_lat_titles &nbsp</option>\n"}
print "        </select>\n";
print "      </td>\n";
print "    </tr>\n";

if ($out eq 'screen'){
print "    <tr>\n";
print "      <!-- Row 3 Column 1 -->\n";
print "      <td align='center'>\n";
print "        <font face='Verdana' size='2'><b>$label_start_page &nbsp</b></font>\n";
print "      </td>\n";

print "      <!-- Row 3 Column 2 -->\n";
print "      <td align='center'>\n";
print "        <font face='Verdana' size='2'><b>$label_results_per_page &nbsp</b></font>\n";
print "      </td>\n";
print "    </tr>\n";

print "    <tr>\n";
print "      <!-- Row 8 Column 1 -->\n";
print "      <td align='center'>\n";
print "        <input class='aceButton' type='button' value='$label_down' onClick=\"javascript:this.form.sp.value--;\">\n";
print "        <input class='aceTextField' type='text' name='sp' size='2' value=$value_sp>\n";
print "        <input class='aceButton' type='button' value='$label_up' onClick=\"javascript:this.form.sp.value++;\">\n";
print "      </td>\n";

print "      <!-- Row 8 Column 2 -->\n";
print "      <td align='center'>\n";
print "        <input class='aceButton' type='button' value='$label_down' onClick=\"javascript:this.form.rp.value--;\">\n";
print "        <input class='aceTextField' type='text' name='rp' size='2' value=$value_rp>\n";
print "        <input class='aceButton' type='button' value='$label_up' onClick=\"javascript:this.form.rp.value++;\">\n";
print "      </td>\n";
print "    </tr>\n";

print "    <tr>\n";
print "      <!-- Row 8 Column 1 -->\n";
print "      <td align='center' colspan='2'>\n";
print "        <select name='act' size=1>\n";
print "        <option value='$value_act'>&nbsp $label_act &nbsp</option>\n";
if ($label_act ne $label_edit_off){print "<option value='off'>&nbsp $label_edit_off &nbsp</option>\n"}
if ($label_act ne $label_edit_on){print "<option value='edit'>&nbsp $label_edit_on &nbsp</option>\n"}
print "        </select>\n";
print "      </td>\n";
print "    </tr>\n";
}

print "</table>\n";

print "<table width='50%' border='0' cellspacing='4' cellpadding='0'>\n";

print "    <tr>\n";
print "      <!-- Row 1 -->\n";
print "      <td align='center' colspan=2>\n";
print "      <font face='Times New Roman' size=3><b>$label_range</b></font>\n";
print "      </td>\n";
print "    </tr>\n";

print "    <tr>\n";
print "      <!-- Row 2 Column 1 -->\n";
print "      <td align='center'>\n";
print "        <font face='Verdana' size='2'><b>$label_first_year</b></font>\n";
print "      </td>\n";

print "      <!-- Row 2 Column 2 -->\n";
print "      <td align='center'>\n";
print "        <font face='Verdana' size='2'><b>$label_last_year</b></font>\n";
print "      </td>\n";
print "    </tr>\n";

print "    <tr>\n";
print "      <!-- Row 3 Column 1 -->\n";
print "      <td align='center'>\n";
print "        <input class='aceTextField' type='text' name='YEAR1' size='20' maxlength='15' value='$YEAR1'>\n";
print "      </td>\n";

print "      <!-- Row 3 Column 2 -->\n";
print "      <td align='center'>\n";
print "        <input class='aceTextField' type='text' name='YEAR2' size='20' maxlength='15' value='$YEAR2'>\n";
print "        </td>\n";
print "      </tr>\n";

print "</table>\n";

print "<table width='75%' border='0' cellspacing='4' cellpadding='0'>\n";

print "      <tr>\n";
print "        <!-- Row 1 -->\n";
print "        <td align='center'>\n";
print "          <font face='Times New Roman' size=3><b>$label_sort_criteria</b></font>\n";
print "        </td>\n";
print "      </tr>\n";

print "      <tr>\n";
print "        <!-- Row 2 -->\n";
print "        <td align='center'>\n";

print "          <select name='sort1' size=1>\n";
print "          <option value='$value_sort1'>&nbsp $label_sort1 &nbsp</option>\n";
if ($label_sort1 ne $label_year){print "<option value='6'>&nbsp $label_year &nbsp</option>\n"}
if ($label_sort1 ne $label_author){print "<option value='1'>&nbsp $label_author &nbsp</option>\n"}
if ($label_sort1 ne $label_title){print "<option value='2'>&nbsp $label_title &nbsp</option>\n"}
if ($label_sort1 ne $label_journal){print "<option value='4'>&nbsp $label_journal &nbsp</option>\n"}
if ($label_sort1 ne $label_volume){print "<option value='5'>&nbsp $label_volume &nbsp</option>\n"}
if ($label_sort1 ne $label_off){print "<option value='off'>&nbsp $label_off &nbsp</option>\n"}
print "          </select>&nbsp\n";

print "          <select name='sort2' size=1>\n";
print "          <option value='$value_sort2'>&nbsp $label_sort2 &nbsp</option>\n";
if ($label_sort2 ne $label_author){print "<option value='1'>&nbsp $label_author &nbsp</option>\n"}
if ($label_sort2 ne $label_title){print "<option value='2'>&nbsp $label_title &nbsp</option>\n"}
if ($label_sort2 ne $label_journal){print "<option value='4'>&nbsp $label_journal &nbsp</option>\n"}
if ($label_sort2 ne $label_volume){print "<option value='5'>&nbsp $label_volume &nbsp</option>\n"}
if ($label_sort2 ne $label_year){print "<option value='6'>&nbsp $label_year &nbsp</option>\n"}
if ($label_sort2 ne $label_off){print "<option value='off'>&nbsp $label_off &nbsp</option>\n"}
print "          </select>&nbsp\n";

print "          <select name='sort3' size=1>\n";
print "          <option value='$value_sort3'>&nbsp $label_sort3 &nbsp</option>\n";
if ($label_sort3 ne $label_title){print "<option value='2'>&nbsp $label_title &nbsp</option>\n"}
if ($label_sort3 ne $label_author){print "<option value='1'>&nbsp $label_author &nbsp</option>\n"}
if ($label_sort3 ne $label_journal){print "<option value='4'>&nbsp $label_journal &nbsp</option>\n"}
if ($label_sort3 ne $label_volume){print "<option value='5'>&nbsp $label_volume &nbsp</option>\n"}
if ($label_sort3 ne $label_year){print "<option value='6'>&nbsp $label_year &nbsp</option>\n"}
if ($label_sort3 ne $label_off){print "<option value='off'>&nbsp $label_off &nbsp</option>\n"}
print "          </select>&nbsp\n";

print "          <select name='sort4' size=1>\n";
print "          <option value='$value_sort4'>&nbsp $label_sort4 &nbsp</option>\n";
if ($label_sort4 ne $label_journal){print "<option value='4'>&nbsp $label_journal &nbsp</option>\n"}
if ($label_sort4 ne $label_author){print "<option value='1'>&nbsp $label_author &nbsp</option>\n"}
if ($label_sort4 ne $label_title){print "<option value='2'>&nbsp $label_title &nbsp</option>\n"}
if ($label_sort4 ne $label_volume){print "<option value='5'>&nbsp $label_volume &nbsp</option>\n"}
if ($label_sort4 ne $label_year){print "<option value='6'>&nbsp $label_year &nbsp</option>\n"}
if ($label_sort4 ne $label_off){print "<option value='off'>&nbsp $label_off &nbsp</option>\n"}
print "          </select>\n";

print "        </td>\n";
print "      </tr>\n";

print "</table>\n";

print "<table width='50%' border='0' cellspacing='4' cellpadding='0'>\n";

print "    <tr>\n";
print "      <!-- Row 1 -->\n";
print "      <td align='center'>\n";
print "          <a href='$help'><font face='Verdana' size='2'><b>$label_help</b></font></a>\n";
print "      </td>\n";
print "    </tr>\n";

print "      <!-- Row 2 -->\n";
print "      <td align='center'>\n";
print "          <input class='aceButton' type='submit' value='&nbsp &nbsp $label_start_form &nbsp &nbsp'>\n";
print "      </td>\n";
print "    </tr>\n";

print "      <!-- Row 3 -->\n";
print "      <td align='center'>\n";
print "          <DIV class=menu>\n";
print "          <A class=menu href='../index_$lang.htm#read'>&nbsp $label_back &nbsp</A>\n";
print "          &nbsp\n";
print "          <A class=menu href='/cgi-bin/$read_form_script?lang=$lang&out=$out'>&nbsp $label_reset &nbsp</A>\n";
print "          </DIV>\n";
print "      </td>\n";
print "    </tr>\n";

print "</table>\n";

print "</form>\n";

print "<br>\n";

print "</body>\n";

print "</html>\n";
