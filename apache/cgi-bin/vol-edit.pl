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
read(STDIN, $buffer,$ENV{'CONTENT_LENGTH'});
$buffer =~ tr/+/ /;
$buffer =~ s/\r/ /g;
$buffer =~ s/\n/ /g;
$buffer =~ s/%(..)/pack("C", hex($1))/eg;

# Splitting information into name/value pairs:
@pairs = split(/&/,$buffer);
foreach $pair(@pairs){
($key,$value)=split(/=/,$pair);
$formdata{$key}.="$value";
}

# Defining fields - part 1:
$db=$formdata{'db'};
$lang=$formdata{'lang'};

# HTML TITLES:
if ($lang eq 'bg'){
$label_html_title = $label_bg_html_title;
$label_changes_saved = $label_bg_changes_saved;
$label_error_open = $label_bg_error_open;
$label_back = $label_bg_back;
}

if ($lang eq 'en'){
$label_html_title = $label_en_html_title;
$label_changes_saved = $label_en_changes_saved;
$label_error_open = $label_en_error_open;
$label_back = $label_en_back;
}

# Defining fields - part 2:
$act=$formdata{'act'};
$db=$formdata{'db'};
$rp=$formdata{'rp'};
$sp=$formdata{'sp'};
$case=$formdata{'case'};
$start=$formdata{'start'};
$rn=$formdata{'rn'};
$script=$formdata{'script'};

$FIND_AUTHOR=$formdata{'FIND_AUTHOR'};
$FIND_TITLE=$formdata{'FIND_TITLE'};
$FIND_PLACE=$formdata{'FIND_PLACE'};
$FIND_JOURNAL=$formdata{'FIND_JOURNAL'};
$FIND_YEAR1=$formdata{'FIND_YEAR1'};
$FIND_YEAR2=$formdata{'FIND_YEAR2'};

$sort1=$formdata{'sort1'};
$sort2=$formdata{'sort2'};
$sort3=$formdata{'sort3'};
$sort4=$formdata{'sort4'};

$OLD_AUCTOR=$formdata{'OLD_AUCTOR'};
$OLD_ALIAS=$formdata{'OLD_ALIAS'};
$OLD_TITLE=$formdata{'OLD_TITLE'};
$OLD_PLACE=$formdata{'OLD_PLACE'};
$OLD_JOURNAL=$formdata{'OLD_JOURNAL'};
$OLD_VOLUME=$formdata{'OLD_VOLUME'};
$OLD_YEAR=$formdata{'OLD_YEAR'};
$OLD_PAGES=$formdata{'OLD_PAGES'};

$AUCTOR=$formdata{'AUCTOR'};
$ALIAS=$formdata{'ALIAS'};
$TITLE=$formdata{'TITLE'};
$PLACE=$formdata{'PLACE'};
$JOURNAL=$formdata{'JOURNAL'};
$VOLUME=$formdata{'VOLUME'};
$YEAR=$formdata{'YEAR'};
$PAGES=$formdata{'PAGES'};

# Opening and closing database for input:

####################################################################
open (INPUT, "/ramdisk/home/knoppix/apache/db/$db") or nodatabase();
####################################################################

# Defining array:
@array=<INPUT>;
close (INPUT);

foreach $line (@array){
($FIELD_AUTHOR,$FIELD_TITLE,$FIELD_PLACE,$FIELD_JOURNAL,$FIELD_VOLUME,$FIELD_YEAR,$FIELD_PAGES)=split(/$delimiter/,$line);
($FIELD_AUCTOR,$FIELD_ALIAS)=split(/\<!--/,$FIELD_AUTHOR);
$FIELD_ALIAS =~ s/--\>//;
unless ($FIELD_AUCTOR == $OLD_AUCTOR &&
$FIELD_ALIAS == $OLD_ALIAS &&
$FIELD_TITLE == $OLD_TITLE &&
$FIELD_PLACE == $OLD_PLACE &&
$FIELD_JOURNAL == $OLD_JOURNAL &&
$FIELD_VOLUME == $OLD_VOLUME &&
$FIELD_YEAR == $OLD_YEAR &&
$FIELD_PAGES == $OLD_PAGES){
push (@save, $line)
}}

# Opening and closing database for output:

######################################################################
open (OUTPUT, ">/ramdisk/home/knoppix/apache/db/$db") or nodatabase();
######################################################################

foreach $line (@save){
print OUTPUT "$line";
}
close (OUTPUT);

# Opening and closing database for appending:

#######################################################################
open (APPEND, ">>/ramdisk/home/knoppix/apache/db/$db") or nodatabase();
#######################################################################

print APPEND "$AUCTOR\<!--$ALIAS--\>|$TITLE|$PLACE|$JOURNAL|$VOLUME|$YEAR|$PAGES\n";
close (APPEND);

# CHANGES SAVED MESSAGE:
print "Content-type: text/html; charset=utf-8\n\n";
print "<html><head><title>$label_html_title</title>\n";

brownButton ();

print "</head>\n";

print "$dialog_css\n";
print "$dialog_body\n";

print "<center>\n";
print "<font face='Verdana' size='4'>\n";
print "$label_changes_saved</font>\n";

print "<br><br>\n";
print "<hr width='95%'>\n";
print "<DIV class=menu>\n";
print "<a class=menu href='/cgi-bin/$script?\n";
print "lang=$formdata{'lang'}&db=$formdata{'db'}&rp=$formdata{'rp'}&\n";
print "sp=$formdata{'sp'}&\n";
print "AUTHOR=$formdata{'FIND_AUTHOR'}&TITLE=$formdata{'FIND_TITLE'}&\n";
print "PLACE=$formdata{'FIND_PLACE'}&JOURNAL=$formdata{'FIND_JOURNAL'}&\n";
print "YEAR1=$formdata{'FIND_YEAR1'}&\n";
print "YEAR2=$formdata{'FIND_YEAR2'}&\n";
print "case=$formdata{'case'}&act=$formdata{'act'}&\n";
print "sort1=$formdata{'sort1'}&sort2=$formdata{'sort2'}&\n";
print "sort3=$formdata{'sort3'}&sort4=$formdata{'sort4'}&\n";
print "start=$last_hit_per_page'>$label_back</a>\n";
print "</DIV>\n";
print "<hr width='95%'>\n";

print "</center>\n";
print "</body></html>\n";

# MISSING DATABASE FILE SUBROUTINE:
sub nodatabase {
print "Content-type: text/html; charset=utf-8\n\n";
print "<html><head><title>$label_html_title</title>\n";

brownButton ();

print "</head>\n";

print "$dialog_css\n";
print "$dialog_body\n";

print "<center><font face='Verdana' size='4'>\n";
print "<b>$label_error_open</b></font>\n";

print "<br><br>\n";
print "<hr width='95%'>\n";
print "<DIV class=menu>\n";
print "<A class=menu href='../index_$lang.htm'>$label_back</A>\n";
print "</DIV>\n";
print "<hr width='95%'>\n";

print "</center>\n";
print "</body></html>\n";
exit}
