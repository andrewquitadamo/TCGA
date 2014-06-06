#!/usr/bin/perl
use strict;
use warnings;

if ((@ARGV)!=1)
{
        print "Usage: perl meth_pos_extract.pl <chromosome>\n";
        exit;
}
my $chr=$ARGV[0];

my $output;
my @ids;

my $pos_filename = "gene_loc";
open(FILE,$pos_filename) || die "Can't open file $pos_filename";
while (<FILE>)
{
	chomp;
	if ($_=~/^ENSG/)
	{
		my @temp = split("\t",$_);
		if ($temp[1]=~/^\d/ && $temp[1]==$chr)
		{
			push(@ids,$temp[4]);
		}
	}
}
close FILE;

my %chrom_id;
my $expression_file = "ExpressionMatrix";
open(FILE,$expression_file) || die "Can't open file $expression_file";
while (<FILE>)
{
	if ($_=~/^ID/)
	{
		$output.=$_;
	}
	else
	{
		my @temp = split(/\|/,$_);
		$chrom_id{$temp[0]}=$_;
	}
}
close FILE;

foreach(@ids)
{
	if (exists $chrom_id{$_})
	{
		$output.=$chrom_id{$_};
	}
}

open FILE,">"."chr" . $chr ."_expr_pos" or die $!;
print FILE $output;
close FILE;
