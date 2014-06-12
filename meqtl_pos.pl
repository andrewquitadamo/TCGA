#!/usr/bin/perl
use strict;
use warnings;

my $meth_output = "id\tchr\tpos\n";
my $meth_pos_filename = "jhu-usc.edu_TCGA_HumanMethylation27.v2.adf.txt";
open(FILE,$meth_pos_filename) || die "Can't open file $meth_pos_filename";
while (<FILE>)
{
        if ($_=~/^cg/)
        {
                my @temp = split("\t",$_);
        	my $id = $temp[0];
		my $chr = $temp[4];
		my $pos = $temp[5];
		$meth_output.="$id\t$chr\t$pos\n";
	}
}
close FILE;

open FILE,">"."cpg_position" or die $!;
print FILE $meth_output;
close FILE;

my $gene_output = "id\tchr\tstart\tend\n";
my %gene_hash;

my $gene_pos_filename = "gene_loc";
open(FILE,$gene_pos_filename) || die "Can't open file $gene_pos_filename";
while (<FILE>)
{
	chomp;
	if ($_=~/^ENSG/)
	{
		my @temp = split("\t",$_);
		my $chr = $temp[1];
		my $start = $temp[2];
		my $end = $temp[3];
		my $id = $temp[4];
		my $pos = "$chr\t$start\t$end";
		#print "$id\n";
		$gene_hash{$id}=$pos;
	}
}
close FILE;

my $gene_file = "ExpressionMatrix.out";
open(FILE,$gene_file) || die "Can't open file $gene_file";
while (<FILE>)
{
	if ($_=~/^ID/)
	{
		next;
	}
	my @id = split(/\|/,$_);
	my @temp = split("\t",$_);
	my $id = $id[0];
	my $full_id = $temp[0];
	if (exists $gene_hash{$id})
	{
		$gene_output.= "$full_id\t$gene_hash{$id}\n"
	}
}

open FILE,">"."gene_position" or die $!;
print FILE $gene_output;
close FILE;
