#!/usr/bin/perl -w

use strict;

my $lib = $ARGV[0];

my $f1 = "$lib.clipped.R1.fastq";
my $f2 = "$lib.clipped.R2.fastq";
my $out1 = "$lib.pp.R1.fastq.gz";
my $out2 = "$lib.pp.R2.fastq.gz";
open R1,"| gzip -c >$out1";
open R2,"| gzip -c >$out2";
open (SGA,"sga preprocess --pe-mode=1 --quality-trim=15 --quality-filter=3 --min-len=64 --pe-orphans=$lib.clipped.filtered.orphans.fastq $f1 $f2 2>$lib.ppstat.pe |");
while (my $h1 = <SGA>) {
       my $seq1 = <SGA>;
       my $hq1 = <SGA>;
       my $qual1 = <SGA>;
       my $h2 = <SGA>;
       my $seq2 = <SGA>;
       my $hq2 = <SGA>;
       my $qual2 = <SGA>;
       print R1 $h1,$seq1,$hq1,$qual1;
       print R2 $h2,$seq2,$hq2,$qual2;
}

