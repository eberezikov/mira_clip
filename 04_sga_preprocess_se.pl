#!/usr/bin/perl -w

use strict;

my $lib = $ARGV[0];

`sga preprocess --pe-mode=0 --quality-trim=15 --quality-filter=3 --min-len=64 $lib.clipped.SE.fastq >$lib.clipped.filtered.SE.fastq 2>$lib.ppstat.se`;

`cat $lib.clipped.filtered.SE.fastq $lib.clipped.filtered.orphans.fastq | gzip -c >$lib.pp.orphans.fastq.gz`;
