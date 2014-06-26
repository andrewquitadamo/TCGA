#!/usr/bin/perl
use strict;
use warnings;

my $meth_file = "Methylation";
my $expr_file = "ExpressionMatrix";

my $p_val=$ARGV[0];
my $cluster = $ARGV[1];
if ((@ARGV)<1)
{
	print "Usage: perl run.pl <p-value>\n";
	exit;
}

`perl overlap.pl Methylation ExpressionMatrix`;

`R --no-save <<RSCRIPT
source('$ENV{PWD}\/expression_sd_filter.r')
expr<-expression_filter($p_val,"$ENV{PWD}\/$meth_file.out")
expr<-expression_filter($p_val,"$ENV{PWD}\/$expr_file.out")
RSCRIPT`;

`sed '1d' $meth_file.out.filter > $meth_file.out.filter.noh`;
`sed '/NA/d' $meth_file.out.filter.noh >$meth_file.out.filter.noh.narm`;
`cut -f 2- $meth_file.out.filter.noh.narm > $meth_file.final`;
`cut -f 1 $meth_file.out.filter.noh.narm > $meth_file.colNames`;

`sed '1d' $expr_file.out.filter > $expr_file.out.filter.noh`;
`cut -f 2- $expr_file.out.filter.noh > $expr_file.final`;
`cut -f 1 $expr_file.out.filter.noh > $expr_file.colNames`;
