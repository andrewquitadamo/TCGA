#!/usr/bin/perl
use strict;
use warnings;

my $output="id\tchr\tpos\n";

my $filename = "jhu-usc.edu_TCGA_HumanMethylation27.v2.adf.txt";
open(FILE,$filename) || die "Can't open file $filename";
while (<FILE>)
{
	if ($_=~/^cg/)
	{
		my @temp = split("\t",$_);
		my $id = $temp[0];
		my $chr = $temp[4];
		my $pos = $temp[5];
		$output.="$id\t$chr\t$pos\n";
	}
}
close FILE;

open FILE,">"."MethylationPosition" or die $!;
print FILE $output;
close FILE;
