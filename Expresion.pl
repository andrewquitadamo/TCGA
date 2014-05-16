#!/usr/bin/perl
use strict;
use warnings;

#ACJ 051514


my $filename = "fileID";
my %fileID;
my %geneID;
my $output="ID\t";
my @files;
@files=glob("*genes*");

open(FILE,$filename) || die "Can't open file $filename";
while (<FILE>)
{       
	my @temp=split("\t",$_);
	my $file = $temp[0];
	my @ID = split("-",$temp[1]);
	my $ID = $ID[2];
	$fileID{$file}=$ID;
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
		my @temp=split("\t",$_);
		my $geneID = $temp[0];
		my $normCount = $temp[1];
		my @ID = split(/\|/,$geneID);
		$geneID = "";
		$geneID = $ID[1];
		$geneID{$geneID}.="$normCount\t";
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
