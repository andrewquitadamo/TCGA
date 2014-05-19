#!/usr/bin/perl
use strict;
use warnings;

#ACJ 051514

my $filename = "fileID";
my %fileID;
my %geneID;
my $output="ID\t";
my @files=glob("*genes\.norm*");

sub id
{
    my @temp=split("\t",$_[0]);
	my $file = $temp[0];
	my @ID = split("-",$temp[1]);
	my $ID = $ID[2];
	$fileID{$file}=$ID;
}

sub parse
{
    my @temp=split("\t",$_[0]);
    my $geneID = $temp[0];
    my $normCount = $temp[1];
    my @ID = split(/\|/,$geneID);
    $geneID = "";
    $geneID = $ID[1];
    $geneID{$geneID}.="$normCount\t";
}

open(FILE,$filename) || die "Can't open file $filename";
while (<FILE>)
{       
    id($_);
}

foreach(@files)
{
	$output.="$fileID{$_}\t";
	open(FILE,$_) || die "Can't open file $_";
	while (<FILE>)
	{       
		chomp;	
		if($_=~/^gene/)
		{
			next;
		}
        parse($_);
	}
	close FILE;
}

my @keys=keys %geneID;
foreach (@keys)
{
	$output.="\n$_\t$geneID{$_}";
}

open FILE,">"."ExpressionMatrix" or die $!;
print FILE $output;
close FILE;
