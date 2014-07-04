#!/usr/bin/perl
use strict;
use warnings;

my $filename = "all.sort.dapple";

my %genes;

open(FILE,$filename) || die "can't open that $filename";
while (<FILE>)
{
	chomp;
	my @temp = split("\t",$_);
	my $raw_gene = $temp[1];
	my @gene = split(/\|/, $raw_gene);
	my $gene = $gene[0];
	$genes{$gene}="";
	if ( (keys(%genes))  == 2000)
	{
		last;
	}
}
close FILE;

my @keys = keys %genes;

foreach(@keys)
{
	print "$_\n";
}
