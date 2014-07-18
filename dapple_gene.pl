#!/usr/bin/perl
use strict;
use warnings;

my $gene_file = "DAPPLE_genes.txt";
my $input_file = shift @ARGV;

my %dapple_genes;
my $output;

open(FILE,$gene_file) || die "can't open that $gene_file";
while (<FILE>)
{
	chomp;
	my @temp = split("\t",$_);
	my $gene = $temp[1];
	$dapple_genes{$gene}="";
}
close FILE;

open(FILE,$input_file) || die "can't open that $input_file";
while (<FILE>)
{
	chomp;
	if (exists $dapple_genes{$_})
	{
		print "$_\n";
	}
}
close FILE;
