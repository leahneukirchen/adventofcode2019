#!/usr/bin/perl -w
use v5.16;

use File::Slurper 'read_lines';
use List::Util qw'reduce';

my @d = unpack "(A150)*", (read_lines('day08'))[0];

my $p1 = reduce { (()=$a =~ /0/g) > (()=$b =~ /0/g) ? $b : $a } @d;
say((()=$p1 =~ /1/g)*(()=$p1 =~ /2/g));

my $p2 = "";
INDEX: for my $i (0..149) {
    for (@d) {
        if ((my $c = substr($_, $i, 1)) ne "2") {
            $p2 .= $c;
            next INDEX;
        }
    }
} 
$p2 =~ tr/01/ #/;
say join "\n", unpack("(A25)*", $p2)
