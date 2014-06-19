#!/usr/bin/perl
use strict;
use warnings;

my $methylation_file = $ARGV[0];
my $expression_file = $ARGV[1];

my %meth_id;
my %expr_id;

my @meth_id=(0);
my @expr_id=(0);

my $i;
open(FILE,$methylation_file) || die "Can't open file $methylation_file.\n";
while(<FILE>)
{
	chomp;
	if ($_=~/^ID/)
	{
		my @temp = split("\t",$_);
		$i=0;
		foreach(@temp)
		{
			if ($_=~/^\d/)
			{
				$meth_id{$_}=$i;
			}
			$i++;
		}
	}
}
close FILE;

open(FILE,$expression_file) || die "Can't open file $expression_file.\n";
while(<FILE>)
{
        chomp;
        if ($_=~/^ID/)
        {
                my @temp = split("\t",$_);
                $i=0;
                foreach(@temp)
                {
                        if ($_=~/^\d/)
			{
				$expr_id{$_}=$i;
                        }
			$i++;
                }
        }
}
close FILE;

my @keys = keys %meth_id;
foreach(@keys)
{
	push (@meth_id,$meth_id{$_});
	push (@expr_id,$expr_id{$_});
}

my $meth_output;
open(FILE,$methylation_file) || die "Can't open file $methylation_file.\n";
while(<FILE>)
{
	chomp;
	my @temp = split("\t",$_);
	$meth_output.=join("\t",@temp[@meth_id]) . "\n";
}
close FILE;

my $expr_output;
open(FILE,$expression_file) || die "Can't open file $expression_file.\n";
while(<FILE>)
{
        chomp;
        my @temp = split("\t",$_);
        $expr_output.=join("\t",@temp[@expr_id]) . "\n";
}
close FILE;

open FILE, ">". $methylation_file . ".out" or die $!;
print FILE $meth_output;
close FILE;

open FILE, ">". $expression_file . ".out" or die $!;
print FILE $expr_output;
close FILE;
