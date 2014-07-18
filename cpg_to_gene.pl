#!/usr/bin/perl
use strict;
use warnings;

my %cpg_gene;

my $filename = "cpg_gene";
open(FILE,$filename) || die "can't open that $filename";
while (<FILE>)
{
	chomp;
	my @temp = split("\t",$_);
	my $cpg = shift(@temp);
	my $gene = shift(@temp);

	$cpg_gene{$cpg}=$gene;
}
close FILE;

$filename=shift(@ARGV);
open(FILE,$filename) || die "can't open that $filename";
while (<FILE>)
{
	chomp;
	#print "$_\n";
	if ($cpg_gene{$_})
	{
		print "$cpg_gene{$_}\n";
	}
}
close FILE;
