#!/usr/bin/perl
use strict;
use warnings;

my %fileID;
my %cpgID;
my $output="ID\t";
my @files=glob("*jhu*");

sub id
{
    #print "$_[0]\n";
    my @temp=split("-",$_);
	my $indID=$temp[4];
	$output.="$indID\t";
}

sub parse
{
    $_=$_[0];
    my @temp=split("\t",$_);
    my $cpgID = $temp[0];
    my $BethaValue = $temp[1];
    $cpgID{$cpgID}.="$BethaValue\t";
}

foreach(@files)
{
    id($_);
	open(FILE,$_) || die "Can't open file $_";
	while (<FILE>)
	{
        chomp;
        if(($_=~/^Hy/) || ($_=~/^Comp/))
        {
            next;
        }
        parse($_);
	}
	close FILE;
}

my @keys=keys %cpgID;
foreach (@keys)
{
	$output.="\n$_\t$cpgID{$_}";
}

open FILE,">"."Methylation" or die $!;
print FILE $output;
close FILE;
