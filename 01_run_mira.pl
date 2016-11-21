#!/usr/bin/perl -w

use strict;

my $manifest = $ARGV[0];

open (F,"mira $manifest 2>&1 |");;
while(my $l = <F>) {
  if ($l=~/^Sorting reads/) {
     warn "trimming part of mira complete\n";
     last;
  }
}
close F;

exit;

