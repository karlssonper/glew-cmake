#!/usr/bin/perl
##
## Copyright (C) 2002-2008, Marcelo E. Magallon <mmagallo[]debian org>
## Copyright (C) 2002-2008, Milan Ikits <milan ikits[]ieee org>
##
## This program is distributed under the terms and conditions of the GNU
## General Public License Version 2 as published by the Free Software
## Foundation or, at your option, any later version.

use strict;
use warnings;
use File::Basename;

do 'bin/make.pl';

my @extlist = ();
my %extensions = ();
my @temp = ();

if (@ARGV)
{
    @extlist = @ARGV;

	my $curexttype = "";

	foreach my $fullname (@extlist)
	{
		my $filename = basename($fullname);
		push(@temp, "$filename\t$fullname");
	}

	foreach my $val (sort(@temp))
	{
		my ($filename, $ext) = split(/\t/, $val);
		my ($extname, $exturl, $extstring, $types, $tokens, $functions, $exacts) = parse_ext($ext);
		my $exttype = $extname;
		$exttype =~ s/([E|W]*?)GL(X*?)_(.*?_)(.*)/$3/;
		my $extrem = $extname;
		$extrem =~ s/([E|W]*?)GL(X*?)_(.*?_)(.*)/$4/;
		my $extvar = $extname;
		$extvar =~ s/([E|W]*)GL(X*)_/$1GL$2EW_/;
		if(!($exttype =~ $curexttype))
		{
			if(length($curexttype) > 0)
			{
				print "      }\n";
			}
			print "      if (_glewStrSame2(&pos, &len, (const GLubyte*)\"$exttype\", " . length($exttype) . "))\n";
			print "      {\n";
			$curexttype = $exttype;
		}
		print "#ifdef $extname\n";
		print "        if (_glewStrSame3(&pos, &len, (const GLubyte*)\"$extrem\", ". length($extrem) . "))\n";
		#print "        return $extvar;\n";
		print "        {\n";
		print "          ret = $extvar;\n";
		print "          continue;\n";
		print "        }\n";
		print "#endif\n";
	}

	print "      }\n";
}
