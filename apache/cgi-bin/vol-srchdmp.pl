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
# This script is in Unicode (UTF-8) code page!
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
$label_search_request = $label_bg_search_request;
$label_author = $label_bg_author;
$label_title = $label_bg_title;
$label_place = $label_bg_place;
$label_journal = $label_bg_journal;
$label_start = $label_bg_start;
$label_end = $label_bg_end;
$label_results_big = $label_bg_results_big;
$label_file = $label_bg_file;
$label_records = $label_bg_records;
$label_results = $label_bg_results;
$label_error_open = $label_bg_error_open;
$label_back = $label_bg_back;
$label_no_request = $label_bg_no_request;
$label_wrong_request = $label_bg_wrong_request;
$label_wrong_range = $label_bg_wrong_range;
$label_enter_four_digits = $label_bg_enter_four_digits;
$label_success = $label_bg_success;
$label_open = $label_bg_open;
$label_end_dump = $label_bg_end_dump;
$label_no_results = $label_bg_no_results;
}

if ($lang eq 'en'){
$label_html_title = $label_en_html_title;
$label_search_request = $label_en_search_request;
$label_author = $label_en_author;
$label_title = $label_en_title;
$label_place = $label_en_place;
$label_journal = $label_en_journal;
$label_start = $label_en_start;
$label_end = $label_en_end;
$label_results_big = $label_en_results_big;
$label_file = $label_en_file;
$label_records = $label_en_records;
$label_results = $label_en_results;
$label_error_open = $label_en_error_open;
$label_back = $label_en_back;
$label_no_request = $label_en_no_request;
$label_wrong_request = $label_en_wrong_request;
$label_wrong_range = $label_en_wrong_range;
$label_enter_four_digits = $label_en_enter_four_digits;
$label_success = $label_en_success;
$label_open = $label_en_open;
$label_end_dump = $label_en_end_dump;
$label_no_results = $label_en_no_results;
}

# Defining fields (except language - already defined):
$act=$formdata{'act'};
$db=$formdata{'db'};
$rp=$formdata{'rp'};
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

# No request:
if($AUTHOR =~ '^$' &&
$TITLE =~ '^$' &&
$PLACE =~ '^$' &&
$JOURNAL =~ '^$'){
norequest()}
if($AUTHOR =~ '^\s$' &&
$TITLE =~ '^\s$' &&
$PLACE =~ '^\s$' &&
$JOURNAL =~ '^\s$'){
norequest()}

# Wrong request:
if($AUTHOR =~ '^\S$' || $AUTHOR =~ '^\S\S$' ||
$TITLE =~ '^\S$' || $TITLE =~ '^\S\S$' ||
$PLACE =~ '^\S$' || $PLACE =~ '^\S\S$' ||
$JOURNAL =~ '^\S$' || $JOURNAL =~ '^\S\S$' ||
$YEAR1 =~ '^\S$' || $YEAR1 =~ '^\S\S$' ||
$YEAR2 =~ '^\S$' || $YEAR2 =~ '^\S\S$'){
wrong_request()}

# Wrong range:
if($YEAR1 =~ '^\W$' ||
$YEAR2 =~ '^\W$' ||
$YEAR1 =~ '^\d\d$' ||
$YEAR1 =~ '^\d\d\d$' ||
$YEAR2 =~ '^\d\d$' ||
$YEAR2 =~ '^\d\d\d$'){
wrong_range()}

# Database location:

###################################################################
open (INFO, "/ramdisk/home/knoppix/apache/db/$db") or nodatabase();
###################################################################

# Defining array:
@array=<INFO>;
close (INFO);

# Counting all records in the database:
$records = @array;
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

# Counting results:
$results = @results;

# No results:
if ($results == 0){
noresults()}

# Sorting results - Schwartzian transform:
@sorted_results = map{$_->[0]}
sort multisort map {[$_, split /$delimiter/]} @results;

###############################################################
open (DUMP,">/ramdisk/home/knoppix/apache/db/search_dump.htm");
###############################################################

# Results header:
print DUMP "<html>\n";
print DUMP "<head>\n";
print DUMP "<title>$label_html_title</title>\n";
print DUMP "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>\n";
print DUMP "</head>\n";

print DUMP "$read_only_css\n";
print DUMP "$read_only_body\n";

print DUMP "<font size='2' face='Verdana'><b>$label_search_request</b><br><br>\n";

print DUMP "<table border='0' cellspacing='0' cellpadding='0'>\n";

print DUMP "<tr>\n";
print DUMP "<td align='right'>\n";
print DUMP "<font size='2' face='Verdana'><b>$label_author</b></font>\n";
print DUMP "</td>\n";
print DUMP "<td align='center'>&nbsp\n";
print DUMP "</td>\n";
print DUMP "<td align='left'>\n";
print DUMP "<font size='3' face='Times New Roman'>$formdata{'AUTHOR'}</font>\n";
print DUMP "</td>\n";
print DUMP "</tr>\n";

print DUMP "<tr>\n";
print DUMP "<td align='right'>\n";
print DUMP "<font size='2' face='Verdana'><b>$label_title</b></font>\n";
print DUMP "</td>\n";
print DUMP "<td align='center'>&nbsp\n";
print DUMP "</td>\n";
print DUMP "<td align='left'>\n";
print DUMP "<font size='3' face='Times New Roman'>$formdata{'TITLE'}</font>\n";
print DUMP "</td>\n";
print DUMP "</tr>\n";

print DUMP "<tr>\n";
print DUMP "<td align='right'>\n";
print DUMP "<font size='2' face='Verdana'><b>$label_place</b></font>\n";
print DUMP "</td>\n";
print DUMP "<td align='center'>&nbsp\n";
print DUMP "</td>\n";
print DUMP "<td align='left'>\n";
print DUMP "<font size='3' face='Times New Roman'>$formdata{'PLACE'}</font>\n";
print DUMP "</td>\n";
print DUMP "</tr>\n";

print DUMP "<tr>\n";
print DUMP "<td align='right'>\n";
print DUMP "<font size='2' face='Verdana'><b>$label_journal</b></font>\n";
print DUMP "</td>\n";
print DUMP "<td align='center'>&nbsp\n";
print DUMP "</td>\n";
print DUMP "<td align='left'>\n";
print DUMP "<font size='3' face='Times New Roman'>$formdata{'JOURNAL'}</font>\n";
print DUMP "</td>\n";
print DUMP "</tr>\n";

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

print DUMP "<tr>\n";
print DUMP "<td align='right'>\n";
print DUMP "<font size='2' face='Verdana'><b>$label_page</b></font>\n";
print DUMP "</td>\n";
print DUMP "<td align='center'>&nbsp\n";
print DUMP "</td>\n";
print DUMP "<td align='left'>\n";
print DUMP "<font size='3' face='Times New Roman'>$pagenumber $label_from $pagecount</font>\n";
print DUMP "</td>\n";
print DUMP "</tr>\n";

print DUMP "</table><br>\n";

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
print "<a href='$http_dump/search_dump.htm'>$label_open</a><br>\n";

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

# NO RESULTS SUBROUTINE:
sub noresults {
print "Content-type: text/html; charset=utf-8\n\n";
print "<html>\n";
print "<head>\n";
print "<title>$label_html_title</title>\n";

brownButton ();

print "</head>\n";

print "$dialog_css\n";
print "$dialog_body\n";

print "<center><font face='Verdana' size='4'>\n";
print "$label_no_results</font>\n";

print "<br><br>\n";
print "<hr width='95%'>\n";
print "<DIV class=menu>\n";
print "<A class=menu href='javascript:history.go(-1)'>$label_back</A>&nbsp\n";
print "</DIV>\n";
print "<hr width='95%'>\n";

print "</body></html>\n";
exit}

# NO REQUEST SUBROUTINE:
sub norequest {
print "Content-type: text/html; charset=utf-8\n\n";
print "<html>\n";
print "<head>\n";
print "<title>$label_html_title</title>\n";

brownButton ();

print "</head>\n";

print "$dialog_css\n";
print "$dialog_body\n";

print "<center><font face='Verdana' size='4'>\n";
print "$label_no_request\n";

print "<br><br>\n";
print "<hr width='95%'>\n";
print "<DIV class=menu>\n";
print "<A class=menu href='javascript:history.go(-1)'>$label_back</A>\n";
print "</DIV>\n";
print "<hr width='95%'>\n";

print "</font></body></html>\n";
exit}

# WRONG REQUEST SUBROUTINE:
sub wrong_request {
print "Content-type: text/html; charset=utf-8\n\n";
print "<html>\n";
print "<head>\n";
print "<title>$label_html_title</title>\n";

brownButton ();

print "</head>\n";

print "$dialog_css\n";
print "$dialog_body\n";

print "<center><font face='Verdana' size='4'>\n";
print "$label_wrong_request\n";

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
