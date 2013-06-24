#!/usr/bin/perl
use settings;

##############################################################
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
##############################################################

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

# Defining language:
$lang=$formdata{'lang'};

# TITLES:
if ($lang eq 'bg'){
$label_html_title = $label_bg_html_title;
$label_dump_request = $label_bg_dump_request;
$label_start = $label_bg_start;
$label_end = $label_bg_end;
$label_results_big = $label_bg_results_big;
$label_results = $label_bg_results;
$label_file = $label_bg_file;
$label_records = $label_bg_records;
$label_error_open = $label_bg_error_open;
$label_back = $label_bg_back;
$label_wrong_range = $label_bg_wrong_range;
$label_enter_four_digits = $label_bg_enter_four_digits;
$label_success = $label_bg_success;
$label_open = $label_bg_open;
$label_end_dump = $label_bg_end_dump;
}

if ($lang eq 'en'){
$label_html_title = $label_en_html_title;
$label_dump_request = $label_en_dump_request;
$label_start = $label_en_start;
$label_end = $label_en_end;
$label_results_big = $label_en_results_big;
$label_results = $label_en_results;
$label_file = $label_en_file;
$label_records = $label_en_records;
$label_error_open = $label_en_error_open;
$label_back = $label_en_back;
$label_wrong_range = $label_en_wrong_range;
$label_enter_four_digits = $label_en_enter_four_digits;
$label_success = $label_en_success;
$label_open = $label_en_open;
$label_end_dump = $label_en_end_dump;
}

# Wrong range:
if($query =~ 'YEAR1=\d\d&' ||
$query =~ 'YEAR1=\d\d\d&' ||
$query =~ 'YEAR2=\d\d&' ||
$query =~ 'YEAR2=\d\d\d&' ||
$query =~ 'YEAR1=\W&' ||
$query =~ 'YEAR2=\W&'){
wrong_range()}

# Defining fields (except language - already defined):
$db=$formdata{'db'};
$YEAR1=$formdata{'YEAR1'};
$YEAR2=$formdata{'YEAR2'};
$sort1=$formdata{'sort1'};
$sort2=$formdata{'sort2'};
$sort3=$formdata{'sort3'};
$sort4=$formdata{'sort4'};

# Database location:

###################################################################
open (INFO, "/ramdisk/home/knoppix/apache/db/$db") or nodatabase();
###################################################################

# Defining array:
@array=<INFO>;
close (INFO);

# Defining real year range:
$one = 1;
$YEAR_01=$YEAR1 -= $one;
$YEAR_02=$YEAR2 += $one;

# Counting all records in the database:
$records = @array;

# Splitting fields - necessary for the subsequent operations:
foreach $line (@array){
($FIELD_AUTHOR,$FIELD_TITLE,$FIELD_PLACE,$FIELD_JOURNAL,$FIELD_VOLUME,$FIELD_YEAR,$FIELD_PAGES)=split(/$delimiter/,$line);

# Searching:
if($query =~ 'YEAR1=&'){$c5 = 2; $d5 = 1}
else{$c5=$FIELD_YEAR; $d5=$YEAR_01}

if($query =~ 'YEAR2=&'){$c6 = 1; $d6 = 2}
else{$c6=$FIELD_YEAR; $d6=$YEAR_02}

if($c5 > $d5){
if($c6 < $d6){
push(@results, $line)}}}

# Counting results:
$results = @results;

# Sorting results - Schwartzian transform:
@sorted_results = map{$_->[0]}
sort multisort map {[$_, split /$delimiter/]} @results;

# Opening results file:

########################################################
open (DUMP,">/ramdisk/home/knoppix/apache/db/dump.htm");
########################################################

# Results header:
print DUMP "<html>\n";
print DUMP "<head>\n";
print DUMP "<title>$label_html_title</title>\n";
print DUMP "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>\n";
print DUMP "</head>\n";

print DUMP "$read_only_css\n";
print DUMP "$read_only_body\n";

print DUMP "<font size='2' face='Verdana'><b>$label_dump_request</b><br><br>\n";

print DUMP "<table border='0' cellspacing='0' cellpadding='0'>\n";

print DUMP "<tr>\n";
print DUMP "<td align='right'>\n";
print DUMP "<font size='2' face='Verdana'><b>$label_start</b></font>\n";
print DUMP "</td>\n";
print DUMP "<td align='center'>&nbsp\n";
print DUMP "</td>\n";
print DUMP "<td align='left'>\n";
print DUMP "<font size='3' face='Times New Roman'>$formdata{'YEAR1'}</font>\n";
print DUMP "</td>\n";
print DUMP "</tr>\n";

print DUMP "<tr>\n";
print DUMP "<td align='right'>\n";
print DUMP "<font size='2' face='Verdana'><b>$label_end</b></font>\n";
print DUMP "</td>\n";
print DUMP "<td align='center'>&nbsp\n";
print DUMP "</td>\n";
print DUMP "<td align='left'>\n";
print DUMP "<font size='3' face='Times New Roman'>$formdata{'YEAR2'}</font>\n";
print DUMP "</td>\n";
print DUMP "</tr>\n";

print DUMP "</table><br>\n";

print DUMP "<font size='2' face='Verdana'><b>$label_results_big</b><br><br>\n";

print DUMP "<table border='0' cellspacing='0' cellpadding='0'>\n";

print DUMP "<tr>\n";
print DUMP "<td align='right'>\n";
print DUMP "<font size='2' face='Verdana'><b>$label_file</b></font>\n";
print DUMP "</td>\n";
print DUMP "<td align='center'>&nbsp\n";
print DUMP "</td>\n";
print DUMP "<td align='left'>\n";
print DUMP "<font size='3' face='Times New Roman'>$db</font>\n";
print DUMP "</td>\n";

print DUMP "<tr>\n";
print DUMP "<td align='right'>\n";
print DUMP "<font size='2' face='Verdana'><b>$label_records</b></font>\n";
print DUMP "</td>\n";
print DUMP "<td align='center'>&nbsp\n";
print DUMP "</td>\n";
print DUMP "<td align='left'>\n";
print DUMP "<font size='3' face='Times New Roman'>$records</font>\n";
print DUMP "</td>\n";

print DUMP "</tr>\n";
print DUMP "<tr>\n";
print DUMP "<td align='right'>\n";
print DUMP "<font size='2' face='Verdana'><b>$label_results</b></font>\n";
print DUMP "</td>\n";
print DUMP "<td align='center'>&nbsp\n";
print DUMP "</td>\n";
print DUMP "<td align='left'>\n";
print DUMP "<font size='3' face='Times New Roman'>$results</font>\n";
print DUMP "</td>\n";
print DUMP "</tr>\n";

print DUMP "</table><br><br>\n";

# Displaying results - results body:
foreach $line (@sorted_results){
($FIELD_AUTHOR,$FIELD_TITLE,$FIELD_PLACE,$FIELD_JOURNAL,$FIELD_VOLUME,$FIELD_YEAR,$FIELD_PAGES)=split(/$delimiter/,$line);
$number++;
print DUMP "<b>$number. $FIELD_AUTHOR</b> <i>$FIELD_TITLE</i> $FIELD_PLACE <b><i>$FIELD_JOURNAL</i></b> <b>$FIELD_VOLUME</b> $FIELD_YEAR $FIELD_PAGES<br><br>\n";
}

# Results footer:
print DUMP "<font size='3' face='Times New Roman'><b>$label_end_dump</b>\n";
print DUMP "</font></body></html>\n";

close (DUMP);

#DUMP SUCCESSFULL MESSAGE:
print "Content-type: text/html; charset=utf-8\n\n";
print "<html>\n";
print "<head>\n";
print "<title>$label_html_title</title>\n";

brownButton ();

print "</head>\n";

print "$dialog_css\n";
print "$dialog_body\n";

print "<center><font face='Verdana' size='4'>\n";
print "$label_success<br><br>\n";
print "<a href='$http_dump/dump.htm'>$label_open</a><br>\n";

print "<br>\n";
print "<hr width='95%'>\n";
print "<DIV class=menu>\n";
print "<A class=menu href='javascript:history.go(-1)'>$label_back</A>\n";
print "</DIV>\n";
print "<hr width='95%'>\n";

print "</font></body></html>\n";

# MISSING DATABASE FILE SUBROUTINE:
sub nodatabase {
print "Content-type: text/html; charset=utf-8\n\n";
print "<html>\n";
print "<head>\n";
print "<title>$label_html_title</title>\n";

brownButton ();

print "</head>\n";

print "$dialog_css\n";
print "$dialog_body\n";

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

# WRONG RANGE SUBROUTINE:
sub wrong_range {
print "Content-type: text/html; charset=utf-8\n\n";
print "<html>\n";
print "<head>\n";
print "<title>$label_html_title</title>\n";

brownButton ();

print "</head>\n";

print "$dialog_css\n";
print "$dialog_body\n";

print "<center><font face='Verdana' size='4'>\n";
print "$label_wrong_range<br>\n";
print "$label_enter_four_digits\n";

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
