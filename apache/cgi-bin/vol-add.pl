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
$label_added = $label_bg_added;
$label_error_open = $label_bg_error_open;
$label_back = $label_bg_back;
}

if ($lang eq 'en'){
$label_html_title = $label_en_html_title;
$label_added = $label_en_added;
$label_error_open = $label_en_error_open;
$label_back = $label_en_back;
}

# Defining fields - part 2:
$AUCTOR=$formdata{'AUCTOR'};
$ALIAS=$formdata{'ALIAS'};
$TITLE=$formdata{'TITLE'};
$PLACE=$formdata{'PLACE'};
$JOURNAL=$formdata{'JOURNAL'};
$VOLUME=$formdata{'VOLUME'};
$YEAR=$formdata{'YEAR'};
$PAGES=$formdata{'PAGES'};

# Removing end-of-line characters:
$AUCTOR =~ s/\r\n/ /;
$ALIAS =~ s/\r\n/ /;
$TITLE =~ s/\r\n/ /g;
$PLACE =~ s/\r\n/ /g;
$JOURNAL =~ s/\r\n/ /g;

# Opening and closing database for appending:

###########################################################################
open (APPEND, ">>/ramdisk/home/knoppix/apache/db/new.txt") or nodatabase();
###########################################################################

print APPEND "$AUCTOR\<!--$ALIAS--\>|$TITLE|$PLACE|$JOURNAL|$VOLUME|$YEAR|$PAGES\n";
close (APPEND);

# Records added message:
print "Content-type: text/html; charset=utf-8\n\n";
print "<html><head><title>$label_html_title</title>\n";

brownButton ();

print "</head>\n";

print "$dialog_css\n";
print "$dialog_body\n";

print "<center>\n";
print "<font face='Verdana' size='4'>\n";
print "<b>$label_added</b></font>\n";

print "<br><br>\n";
print "<hr width='95%'>\n";
print "<DIV class=menu>\n";
print "<A class=menu href='javascript:history.go(-1)'>$label_back</A>\n";
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
