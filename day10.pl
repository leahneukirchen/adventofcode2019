#!/usr/bin/perl -w
use v5.16;

use File::Slurper 'read_lines';
use List::Util qw'max uniq';
use Math::Complex;

my @as;
my @l = read_lines('day10t');
while (my ($x, $l) = each(@l)) {
    my @c = split('', $l);
    while (my ($y, $c) = each(@c)) {
        push @as, cplx($x, $y)  if $c eq "#";
    }
}

say max map { my $a = $_; scalar uniq map { arg($a - $_) } @as } @as;
# 288

# Part 2 TBD
# 616
