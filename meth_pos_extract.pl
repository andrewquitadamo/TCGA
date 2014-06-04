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
my $pos_filename = "MethylationPosition";
open(FILE,$pos_filename) || die "Can't open file $pos_filename";
while (<FILE>)
{
	if ($_=~/^cg/)
	{
		my @temp = split("\t",$_);
		if ($temp[1]=~/^\d/ && $temp[1]==$chr)
		{
			push(@ids, $temp[0]);
		}
	}
}
close FILE;

my %chrom_id;
my $methylation_file = "Methylation";
open(FILE,$methylation_file) || die "Can't open file $methylation_file";
while (<FILE>)
{
	if ($_=~/^ID/)
	{
		$output.=$_;
	}
	elsif ($_=~/^cg/)
	{
		my @temp = split("\t",$_);
		my $id = shift(@temp);

		$chrom_id{$id}=$_;
	}
}
close FILE;

foreach(@ids)
{
	$output.=$chrom_id{$_};
}

open FILE,">"."chr" . $chr ."_meth_pos" or die $!;
print FILE $output;
close FILE;
