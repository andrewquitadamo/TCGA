#!/usr/bin/perl
use strict;
use warnings;

#my $filename = $ARGV[0];
my $filename = "fileID";
my %fileID;
my %geneID;
my $output="ID\t";
my @files;
@files=glob("*genes*");

open(FILE,$filename) || die "Can't open file $filename";
  while (<FILE>)
  {       
	#print $_;
	my @temp=split("\t",$_);
	my $file = $temp[0];
	#print "$temp[1]\n";
	my @ID = split("-",$temp[1]);
	my $ID = $ID[2];
	$fileID{$file}=$ID;
	#print %fileID; 	  
	#print "$temp[0]\n";
	  #$output.= "$temp[1]\n";
 }
#my @keys=keys %fileID;
#foreach (@keys)
#{
#	print "$_\t$fileID{$_}\n";
#}
foreach(@files)
{
	#print "$_\t$fileID{$_}\n";
	$output.="$fileID{$_}\t";
	open(FILE,$_) || die "Can't open file $_";
	while (<FILE>)
	{       
		chomp;	
		if($_=~/^gene/)
		{
			next;
		}
		my @temp=split("\t",$_);
		my $geneID = $temp[0];
		my $normCount = $temp[1];
		#print "$temp[1]\n";
		my @ID = split(/\|/,$geneID);
		$geneID = "";
		$geneID = $ID[1];
		#print "$normCount";
		$geneID{$geneID}.="$normCount\t";
		
		#print $_;
		#my @temp=split("\t",$_);
		#print "$temp[0]\n";
		#$output.= "$temp[1]\n";
	}
	close FILE;
}
	#print $output;
	my @keys=keys %geneID;
	foreach (@keys)
{
	$output.="\n$_\t$geneID{$_}";
}
open FILE,">"."ExpressionMatrix" or die $!;
print FILE $output;
close FILE;
