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
$label_error_open = $label_bg_error_open;
$label_back = $label_bg_back;
$label_sorted = $label_bg_sorted;
}

if ($lang eq 'en'){
$label_html_title = $label_en_html_title;
$label_error_open = $label_en_error_open;
$label_back = $label_en_back;
$label_sorted = $label_en_sorted;
}

# Defining fields (except language - already defined):
$db=$formdata{'db'};
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

# Splitting fields - necessary for the subsequent operations:
foreach $line (@array){
($FIELD_AUTHOR,$FIELD_TITLE,$FIELD_PLACE,$FIELD_JOURNAL,$FIELD_VOLUME,$FIELD_YEAR,$FIELD_PAGES)=split(/$delimiter/,$line);
push(@records, $line)}

# Sorting results - Schwartzian transform:
@sorted_records = map{$_->[0]}
sort multisort map {[$_, split /$delimiter/]} @records;

# Opening output file:

#####################################################
open (OUTPUT,">/ramdisk/home/knoppix/apache/db/$db");
#####################################################

foreach $line (@sorted_records){
print OUTPUT "$line";
}
close (OUTPUT);

print "Content-type: text/html; charset=utf-8\n\n";
print "<html>\n";
print "<head>\n";
print "<title>$label_html_title</title>\n";

brownButton ();

print "</head>\n";

print "$dialog_css\n";
print "$dialog_body\n";

print "<center><font face='Verdana' size='4'>\n";
print "$label_sorted\n";

print "<br><br>\n";
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

# MULTISORT SUBROUTINE:
sub multisort {
lc($a->[$sort1]) cmp lc($b->[$sort1]) ||
lc($a->[$sort2]) cmp lc($b->[$sort2]) ||
lc($a->[$sort3]) cmp lc($b->[$sort3]) ||
lc($a->[$sort4]) cmp lc($b->[$sort4]) }
