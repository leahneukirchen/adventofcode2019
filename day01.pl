#!/usr/bin/perl -w
use v5.16;

use File::Slurper 'read_lines';
use List::Util 'sum';
use integer;

my @d = read_lines "day01";

say sum map { $_/3-2 } @d;

my $p2 = 0;
map { $p2 += $_ while ($_ = $_/3-2) > 0} @d;
say $p2;
