#!/usr/bin/perl -w

use strict;

my $lib = $ARGV[0];

my %PHIX;
my %SOLEXA;
my %QUAL;

while (my $f = <TRIM_assembly/TRIM_d_tmp/TRIM_int_clippings*.txt>) {
   open F, $f;
   warn $f,"\n";
   while (my $l = <F>) {
     if ($l=~/phix174 in (\S+)/) {
        $PHIX{$1}++;
        next;
     }
     if ($l=~/Solexa adaptor: .* in (\S+) changed right clip from \d+ to (\d+)/) {
       $SOLEXA{$1}=$2;
       next;
     }
     next if ($l=~/bad solexa end/);
     next if ($l=~/poly-base/);
     if ($l=~/ (\S+)\: min qual threshold/) {
       $QUAL{$1}++;
       next;
     }
     die "Unclear line: $l\n";
  }
}

open F1,"reads_F.fastq";
open F2,"reads_R.fastq";

open R1,">$lib.clipped.R1.fastq";
open R2,">$lib.clipped.R2.fastq";
open SE,">$lib.clipped.SE.fastq";
open PH,">$lib.phix.fastq";

my $phix = 0;
my $qual = 0;
my $solexa = 0;
my $pe = 0;
my $se = 0;

while (my $h1 = <F1>) {
  my $seq1 = <F1>;
  <F1>;
  my $qual1 = <F1>;
  my $h2 = <F2>;
  my $seq2 = <F2>;
  <F2>;
  my $qual2 = <F2>;
  $h1=~s/\n//; my $id1 = $h1; $id1=~s/\@//; $h1=~s/r/$lib\_/;
  $h2=~s/\n//; my $id2 = $h2; $id2=~s/\@//; $h2=~s/r/$lib\_/;
  if (defined $PHIX{$id1} || defined $PHIX{$id2}) {
    print PH "$h1\n$seq1\+\n$qual1$h2\n$seq2\+\n$qual2";
    $phix++;
    next;
  }
  if (defined $SOLEXA{$id1}) {
     $seq1=substr($seq1,0,$SOLEXA{$id1})."\n";
     $qual1=substr($qual1,0,$SOLEXA{$id1})."\n";
     $solexa++;
  }
  if (defined $SOLEXA{$id2}) {
     $seq2=substr($seq2,0,$SOLEXA{$id2})."\n";
     $qual2=substr($qual2,0,$SOLEXA{$id2})."\n";
     $solexa++;
  }
  my ($first,$second) = (1,1);
  $QUAL{$id1}++ if $seq1=~/[nN]/;
  $QUAL{$id2}++ if $seq2=~/[nN]/;
  if (length($seq1) < 65 || defined $QUAL{$id1}) { $first = 0; $qual++;  }
  if (length($seq2) < 65 || defined $QUAL{$id2}) { $second = 0; $qual++; }
  if ($first > 0 && $second > 0) {
     print R1 "$h1\n$seq1\+\n$qual1";
     print R2 "$h2\n$seq2\+\n$qual2";
     $pe++;
  }
  else {
     if ($first > 0) { print SE "$h1\n$seq1\+\n$qual1"; $se++ }
     if ($second > 0) { print SE "$h2\n$seq2\+\n$qual2"; $se++ }
  }
}


open OUT, ">$lib.trim_stats.txt";
print OUT "Good pairs: $pe\n";
print OUT "Good single reads: $se\n";
print OUT "Trimmed adapter: $solexa\n";
print OUT "Low quality or short: $qual\n";
print OUT "PhiX pairs: $phix\n";
