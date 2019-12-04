#!/usr/bin/perl -w
use v5.16;

use File::Slurper 'read_text';

my @od = split ",", read_text "day02";
my $p2 = 19690720;

for my $n (0..99) {
    for my $v(0..99) {
        my @d = @od;
        @d[1, 2] = ($n, $v);

        for (my $ip = 0; $d[$ip] != 99; $ip += 4) {
            if ($d[$ip] == 1) {
                $d[$d[$ip+3]] = $d[$d[$ip+1]] + $d[$d[$ip+2]];
            } elsif ($d[$ip] == 2) {
                $d[$d[$ip+3]] = $d[$d[$ip+1]] * $d[$d[$ip+2]];
            }
        }
        
        say $d[0]  if $n == 12 && $v == 2;
        say(100*$n+$v)  if $d[0] == 19690720;
    }
}
