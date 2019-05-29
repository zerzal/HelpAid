#!/afs/isis/pkg/perl/bin/perl

# Help Ticket Aid

# Set Variables
#######################
#use strict;
#use warnings;
$cgiurl = "http://help-aid-dcayers.cloudapps.unc.edu/";
$ver = "1.0";  # SCRIPT VERSION NUMBER
$techtbl = "techs.txt";
    
# Get the input
########################
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});


#if no form data go to system start
   if (!$buffer) { 
         &begin;
   }

# Split the name-value pairs
@pairs = split(/&/, $buffer);

foreach $pair (@pairs) {
   ($name, $value) = split(/=/, $pair);

# Un-Webify plus signs and %-encoding
   $value =~ tr/+/ /;
   $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
   $value =~ s/<!--(.|\n)*-->//g;
   $value =~ s/<([^>]|\n)*>//g;

   $FORM{$name} = $value;  
}

if (!$FORM{'tel'}) {
$err = "Telephone number";
&error;
}
if (!$FORM{'loc'}) {
$err = "Location";
&error;
}
if (!$FORM{'con'}) {
$err = "Contact Name";
&error;
}
#if (!$FORM{'ctel'}) {
#$err = "Contact Phone";
#&error;
#}

&output;

#######################
# Subroutines

#Required field not filled in
sub error {
print "Content-type: text/html\n\n";
print "<html><head><title>REQUIRED FIELD MISSING</title></head>\n";
print "<body><FONT SIZE = 5><b>Click go back button<BR>below and fill in $err\!</b></FONT><br><br>\n";
print "<button onclick='goBack()'>Go Back</button><script>function goBack() {\n";
print "window.history.back();\n";
print "}\n";
print "</script>\n";
print "<br><br>";
print "</ul></body></html>\n";
exit;
}
# Main Form Page
sub begin {
print "Content-type: text/html\n\n";
print "<html><head><title>Help Ticket Aid $ver</title></head>\n";
print "<body><FONT SIZE = 5><b>LIFE SAFETY SYSTEMS<br>HELP TICKET AID</b></FONT><FONT SIZE = 2 color = red>\&nbsp\;\&nbsp\;<b>$ver</b><br><br>\n";
print "* </font><i> = Required fields</i><br><br>\n";
print "<form method=POST action= $cgiurl>\n";
print "<FONT SIZE = 2 color = red>* </font>Telephone number(s) with the problem\:\&nbsp\;\&nbsp\;<br>";
print "<input id=tel name=tel type=text><br><br>";
print "<FONT SIZE = 2 color = red>* </font>Please provide the location where you are having this problem (building name/room #/etc)\:\&nbsp\;\&nbsp\;<br>";
print  "<input id=loc name=loc type=text size=55><br><br>";
print "<FONT SIZE = 2 color = red>* </font>Contact name\:\&nbsp\;\&nbsp\;<br>";
print  "<select name=con>\n";
print  "<option></option>\n";
open my $data, '<', $techtbl;
my @lines = <$data>;
close $data;
 
 foreach my $lines (@lines) {
   my ($contact, $phone) = split(/=/, $lines);
   print  "<option value='$contact*$phone'>$contact\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$phone</option>\n";
   }
   
print  "</select>\n";
print "<br><br><input type=submit> * <input type=reset><br><br>\n";
print "</form>";
print "<br><br>";
print "</ul></body></html>\n";
exit;
}

sub output {
#my ($con, $ctel) = split(/*/, $FORM{'con'});
print "Content-type: text/html\n\n";
print "<html><head><title>HELP TICKET AIR OUTPUT</title></head>\n";
print "<body><FONT SIZE = 5><b>LIFE SAFETY SYSTEMS<br>HELP TICKET AIR OUTPUT</b></FONT><FONT SIZE = 2 color = red>\&nbsp\;\&nbsp\;<b>$ver</b></font><br><br>\n";
print "<body><FONT SIZE = 4 COLOR=RED><b>COPY AND PASTE BELOW TEXT FOR TICKET ENTRY</b></FONT><br><br>\n";
print "Please provide the following information\:<br><br>";
print "Telephone number(s) with the problem (required)\:<br><br>";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$FORM{'tel'}<br><br>";
print "Department/Customer Name\:<br><br>";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;LIFE SAFETY AND ACCESS CONTROL<br><br>";
print "Please provide the location where you are having this problem (building name/room #/etc) (required):<br><br>";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$FORM{'loc'}<br><br>";
print "Contact name if different from the person submitting the request\:<br><br>";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$FORM{'con'}<br><br>";
print "Contact phone number (required)\:<br><br>";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;Ralph<br><br>";
print "In case a technician needs access to the phone, please provide a suggested date and time (M-F, 8a-5p)\:<br><br>";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;ASAP<br><br>";
print "General description of the problem (required)\:<br><br>";
print "FIRE ALARM DIALER LINE(S) NOT SHOWING DIAL TONE AT THE DIALER.<br><br>";
print "</body></html>\n";

exit;
}
