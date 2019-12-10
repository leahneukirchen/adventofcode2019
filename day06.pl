#!/usr/bin/perl -w
use v5.16;

use File::Slurper 'read_lines';

my %orbits = map { reverse split /\)/ } read_lines("day06");

my $p1 = 0;
for (keys %orbits) {
    while ($_ ne "COM") {
        $p1++;
        $_ = $orbits{$_};
    }
}
say $p1;  # 147223

my (@path1, @path2);
$_ = "YOU"; push @path1, $_ = $orbits{$_} while ($_ ne "COM");
$_ = "SAN"; push @path2, $_ = $orbits{$_} while ($_ ne "COM");

while ($path1[-1] eq $path2[-1]) {
    pop @path1;
    pop @path2;
}

say @path1 + @path2;  # 340
