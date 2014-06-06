#!/usr/bin/perl
use strict;
use warnings;

sub parse
{
	my $filename = shift(@_);
	print "$filename\n";
	`R --no-save <<RSCRIPT
	source('~/Development/repos/ZebraFish/expression_sd_filter.r')
	expr<-expression_filter(0.01,"$ENV{PWD}\/$filename")`;
	`sed '1d' $filename.filter > $filename.filter.noh`;
	`sed '/NA/d' $filename.filter.noh > $filename.filter.noh.narm`;
	`cut -f 2- $filename.filter.noh.narm > $filename.final`;
}

my $i=0;
for($i=1; $i<=22; $i++)
{
	print "$i\n";
	`perl meth_pos_extract.pl $i`;
	`perl gene_pos_extract.pl $i`;
	my $meth_file = "chr" . $i . "_meth_pos";
	my $expr_file = "chr" . $i . "_expr_pos";
	`perl overlap.pl $meth_file $expr_file`;
	$meth_file.=".out";
	$expr_file.=".out";
	parse($meth_file);
	parse($expr_file);
}
