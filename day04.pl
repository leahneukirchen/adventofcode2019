#!/usr/bin/perl -w
use v5.16;

my $d = "171309-643603";

my ($a, $b) = split "-", $d;

my $p1 = 0;
my $p2 = 0;

PASS: for ($a..$b) {
    my @ds = split('');

    if (join('',@ds) eq join('',sort(@ds))) {
        $p1++ if /(\d)\1/;
        while (/(\d)\1+/g) { $p2++, next PASS  if length($&) == 2; }
    }
}

say $p1;  # 1625
say $p2;  # 1111
