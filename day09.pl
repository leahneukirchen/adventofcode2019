#!/usr/bin/perl -w
use v5.16;

say IntCode->new('day09')->run(1);  # 3063082071
say IntCode->new('day09')->run(2);  # 81348


package IntCode;

use Class::Tiny qw( input output code ip base );
use File::Slurper 'read_text';

sub BUILDARGS {
    my $class = shift;
    return { input => [],
             output => [],
             code => [ split ",", read_text(shift) ],
             ip => 0,
             base => 0 };
};

sub done {
    my $self = shift;
    $self->code->[$self->ip] == 99;
}

sub pipe {
    my ($self, $other) = @_;
    $self->{output} = $other->{input};
    $self;
}

sub push {
    my $self = shift;
    push @{$self->{input}}, @_;
    $self;
}

sub run {
    my $self = shift;
    $self->{input} = [ @_ ];
    until ($self->done) {
        $self->step;
    }
    @{$self->output};
}

sub step {
    my $self = shift;

    no warnings 'uninitialized';
 
    my ($pm3, $pm2, $pm1, $op1, $op2) =
        split '', sprintf("%05d", $self->code->[$self->ip]);
    my $op = $op1 . $op2;
    my $p1 = $pm1 == 0 ? $self->code->[$self->code->[$self->ip + 1]]
           : $pm1 == 1 ? $self->code->[$self->ip + 1]
           : $pm1 == 2 ? $self->code->[$self->code->[$self->ip + 1] +
                                       $self->base]
           : undef;
    my $p2 = $pm2 == 0 ? $self->code->[$self->code->[$self->ip + 2]]
           : $pm2 == 1 ? $self->code->[$self->ip + 2]
           : $pm2 == 2 ? $self->code->[$self->code->[$self->ip + 2] +
                                       $self->base]
           : undef;
    my $p3 = $pm3 == 0 ? $self->code->[$self->code->[$self->ip + 3]]
           : $pm3 == 1 ? $self->code->[$self->ip + 3]
           : $pm3 == 2 ? $self->code->[$self->code->[$self->ip + 3] +
                                       $self->base]
           : undef;
    my $w3 = $self->code->[$self->ip+3] + ($pm3 == 2 ? $self->base : 0);
    if    ($op == 1) { $self->code->[$w3] = $p1 + $p2;      $self->{ip} += 4; }
    elsif ($op == 2) { $self->code->[$w3] = $p1 * $p2;      $self->{ip} += 4; }
    elsif ($op == 3) { return unless (@{$self->{input}});  # stall
                       $self->code->[$self->code->[$self->ip+1] +
                                     ($pm1 == 2 ? $self->base : 0)] =
                           shift @{$self->{input}};
                       $self->{ip} += 2; }
    elsif ($op == 4) { CORE::push @{$self->{output}}, $p1;  $self->{ip} += 2; }
    elsif ($op == 5) { $self->{ip} =  $p1 ? $p2 :           $self->ip   +  3; }
    elsif ($op == 6) { $self->{ip} = !$p1 ? $p2 :           $self->ip   +  3; }
    elsif ($op == 7) { $self->code->[$w3] = $p1 < $p2;      $self->{ip} += 4; }
    elsif ($op == 8) { $self->code->[$w3] = $p1 == $p2;     $self->{ip} += 4; }
    elsif ($op == 9) { $self->{base} += $p1;                $self->{ip} += 2; }
    else { say "INVALID OP"; }

    $self;
}

1;
