#!/usr/bin/perl -w

use strict;

open OUT1, ">reads_F.fastq";
open OUT2, ">reads_R.fastq";

my $n = 0;

while (my $f1 = <*_R1_*.gz>) {
  my $f2=$f1;
  $f2=~s/_R1_/_R2_/;
  open F1,"gzip -dc $f1 |";
  open F2,"gzip -dc $f2 |";
  warn "$n: $f1 / $f2\n";
  while (my $h1 = <F1>) {
    my $seq1 = <F1>;
    <F1>;
    my $qual1 = <F1>;
    my $h2 = <F2>;
    my $seq2 = <F2>;
    <F2>;
    my $qual2 = <F2>;
    $n++;
    print OUT1 '@r',$n,'/1',"\n",$seq1,'+',"\n",$qual1;
    print OUT2 '@r',$n,'/2',"\n",$seq2,'+',"\n",$qual2;
  }
}