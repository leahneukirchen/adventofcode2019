#!/usr/bin/perl -w
use v5.16;

use File::Slurper 'read_lines';
use List::Util qw'min sum';

my @c = read_lines "day03";

my %f;
my @dur;

while (my ($i, $c) = each @c) {
    my ($x,$y) = (0,0);

    my %d;
    push @dur, \%d;
    my $d = 0;

    for (split ",", $c) {
        for my $n (1..substr($_, 1)) {
            if (/R/) { $x++ }
            if (/L/) { $x-- }
            if (/U/) { $y++ }
            if (/D/) { $y-- }
            
            $f{$x,$y} |= $i+1;
            $d{$x,$y} = ++$d;
        }
    }
}

my @dup = grep { $f{$_} == 1+2 } keys %f;
say min map { my ($x,$y) = split($;, $_); abs($x)+abs($y) } @dup;
say min map { my $c = $_; sum(map { $_->{$c} } @dur) } @dup;

__END__
258
12304
