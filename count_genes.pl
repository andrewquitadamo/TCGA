#!/usr/bin/perl
use strict;
use warnings;

#my $filename = "all.sort.dapple";
my $filename = shift(@ARGV);

my %gene_count;

open(FILE,$filename) || die "Can't open file: $filename";
while (<FILE>)
{
	chomp;
	my @temp = split("\t",$_);
	my $raw_gene = $temp[1];
	my @gene = split(/\|/, $raw_gene);
	my $gene = $gene[0];
	$gene_count{$gene}++;
}
close FILE;

#$filename = "genes.2000.new";
$filename = shift(@ARGV);

my $total;

open(FILE,$filename) || die "Can't open file: $filename";
while (<FILE>)
{
	chomp;
	if (exists $gene_count{$_})
	{
		$total+=$gene_count{$_};
	}
}
close FILE;

print "$total\n";
