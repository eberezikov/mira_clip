#!/usr/bin/perl -w

use strict;
use FindBin qw($Bin);

my $lib = $ARGV[0];

unless (defined $lib) {
   die "Please provide library name.\n";
}

`$Bin/00_unzip_merge_rename.pl`;
`$Bin/01_run_mira.pl $Bin/manifest`;
`$Bin/02_apply_filters.pl $lib`;
`$Bin/03_sga_preprocess_pe.pl $lib`;
`$Bin/04_sga_preprocess_se.pl $lib`;
