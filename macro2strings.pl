#!/usr/bin/perl -w 


# @filename           :  macro2strings.pl
# @author             :  Copyright (C) drunkwater
# @date               :  Mon Jan 15 12:43:38 HKT 2018
# @function           :  
# @see                :  
# @require            :  



# require here
#require v5.6.1;


# use standard library/use warnings
use strict;
use warnings;

#use File::Copy;


# use other library/perl modules, writed by drunkwater

my $OS_DATE;

sub getCurrentTime
{
	my $time = time();
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);

	$sec  = ($sec<10)?"0$sec":$sec;
	$min  = ($min<10)?"0$min":$min;
	$hour = ($hour<10)?"0$hour":$hour;
	$mday = ($mday<10)?"0$mday":$mday;
	$mon  = ($mon<9)?"0".($mon+1):$mon;
	$year+=1900;
	my $weekday = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat')[$wday];
	return { 'second' => $sec,
			'minute' => $min,
			'hour'   => $hour,
			'day'    => $mday,
			'month'  => $mon,
			'year'   => $year,
			'weekNo' => $wday,
			'wday'   => $weekday,
			'yday'   => $yday,
			'date'   => "$year$mon$mday"
			};
}

sub ltrim { my $s = shift; $s =~ s/^\s+//;       return $s };
sub rtrim { my $s = shift; $s =~ s/\s+$//;       return $s };
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

sub open_filehandle_for_output
{
    my $filename = $_[0];
    my $overWriteFilename = ">" . $filename;
    local *FH;

    open (FH, $overWriteFilename) || die "Could not open $filename";

    return *FH;
}

sub open_filehandle_for_input
{
    my $filename = $_[0];
    local *FH;

    open (FH, $filename) || die "Could not open $filename";

    return *FH;
}


sub main
{
	my $destFileName = "./" . "WinUserHeader_new.cpp";
	my $destFileRef = open_filehandle_for_output($destFileName);

	my $srcFileName = "./" . "WinUserHeader_old.cpp";
	my $srcFileRef = open_filehandle_for_input($srcFileName);

while_label:while (<$srcFileRef>)
	{
		my $line = $_;
		my $quoted = quotemeta( q{// #define WM} );
		if (($_ =~ /^$quoted/) and ($_ =~ /0x/))
		{
			$line =~ /\/\/ \#define(.*)0x/;
			my $macro = trim($1);
			print $destFileRef "\tcase " . $macro . " :\r\n";
			print $destFileRef "\t\t_MACRO_2_STRINGS_" . $OS_DATE . "(" . $macro . ");\r\n";
			print $destFileRef "\t\tbreak;\r\n";
		}
		else
		{
			print $destFileRef $line;
		}
	}
	close($srcFileRef);
	close($destFileRef);

	return 0;
}

################################################################################
my $date = &getCurrentTime();
$OS_DATE = $date->{date};
chomp($OS_DATE);

main();

exit 0;
################################################################################