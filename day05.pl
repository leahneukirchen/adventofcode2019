#!/usr/bin/perl -w
use v5.16;

use File::Slurper 'read_text';

sub compute {
    my @in = @_;
    my @out = ();

    my @d = split ",", read_text "day05";
    
    for (my $ip = 0; $d[$ip] != 99; ) {
        my ($pm3, $pm2, $pm1, $op1, $op2) = split '', sprintf("%05d", $d[$ip]);
        my $op = $op1 . $op2;
        my $p1 = $pm1 ? $d[$ip+1] : $d[$d[$ip+1]];
        my $p2 = $pm2 ? $d[$ip+2] : $d[$d[$ip+2]];
        my $p3 = $pm3 ? $d[$ip+3] : $d[$d[$ip+3]];
        if    ($op == 1) { $d[$d[$ip+3]] = $p1 + $p2;  $ip += 4; }
        elsif ($op == 2) { $d[$d[$ip+3]] = $p1 * $p2;  $ip += 4; }
        elsif ($op == 3) { $d[$d[$ip+1]] = shift @in;  $ip += 2; }
        elsif ($op == 4) { push @out, $p1;             $ip += 2; }
        elsif ($op == 5) { $ip =  $p1 ? $p2 :          $ip +  3; }
        elsif ($op == 6) { $ip = !$p1 ? $p2 :          $ip +  3; }
        elsif ($op == 7) { $d[$d[$ip+3]] = $p1 < $p2;  $ip += 4; }
        elsif ($op == 8) { $d[$d[$ip+3]] = $p1 == $p2; $ip += 4; }
    }

    @out;
}

say((compute(1))[-1]);  # 13978427
say compute(5);  # 11189491
