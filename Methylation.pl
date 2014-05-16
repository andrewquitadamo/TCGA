#!/usr/bin/perl
use strict;
use warnings;

my %fileID;
my %cpgID;
my $output="ID\t";
my @files;
@files=glob("*jhu*");


foreach(@files)
{
	my @temp=split("-",$_);
	my $indID=$temp[4];
	$output.="$indID\t";
	open(FILE,$_) || die "Can't open file $_";
	while (<FILE>)
	{       
		chomp;	
		if(($_=~/^Hy/) || ($_=~/^Comp/))
		{
			next;
		}
		my @temp=split("\t",$_);
		my $cpgID = $temp[0];
		my $BethaValue = $temp[1];
		#print "$temp[1]\n";
		$cpgID{$cpgID}.="$BethaValue\t";
		
		#print $_;
		#my @temp=split("\t",$_);
		#print "$temp[0]\n";
		#$output.= "$temp[1]\n";
	}
	close FILE;
}
	#print $output;
	my @keys=keys %cpgID;
	foreach (@keys)
{
	$output.="\n$_\t$cpgID{$_}";
}
open FILE,">"."Methylation" or die $!;
print FILE $output;
close FILE;
