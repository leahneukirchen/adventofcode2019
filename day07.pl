#!/usr/bin/perl -w
use v5.16;

use File::Slurper 'read_text';
use List::Util qw'all max reduce';

# https://stackoverflow.com/a/637914
sub permute (&@) {
    my $code = shift;
    my @idx = 0..$#_;
    while ( $code->(@_[@idx]) ) {
        my $p = $#idx;
        --$p while $idx[$p-1] > $idx[$p];
        my $q = $p or return;
        push @idx, reverse splice @idx, $p;
        ++$q while $idx[$p-1] > $idx[$q];
        @idx[$p-1,$q]=@idx[$q,$p-1];
    }
}

sub permutemap (&@) {
  my $code = shift;
  my @a;
  permute { push @a, $code->(@_) } @_;
  @a;
}


say max permutemap {
    reduce {
        my $c = IntCode->new('day07');
        $c->input([$b, $a]);
        until ($c->done) {
            $c->step;
        }
        $c->output->[-1];
    } 0, @_;
} (0..4);

say max permutemap {
    my @cs = map { IntCode->new('day07')->push($_) } @_;
    
    $cs[$_]->pipe($cs[$_+1])  for (0..$#cs - 1);
    $cs[-1]->pipe($cs[0]);

    $cs[0]->push(0);

    until (all { $_->done } @cs) {
        $_->step  for @cs;
    }

    $cs[-1]->output->[-1];
} (5..9);


package IntCode;

use Class::Tiny qw( input output code ip );
use File::Slurper 'read_text';

sub BUILDARGS {
    my $class = shift;
    return { input => [],
             output => [],
             code => [ split ",", read_text(shift) ],
             ip => 0 };
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

sub step {
    my $self = shift;

    no warnings 'uninitialized';
 
    my ($pm3, $pm2, $pm1, $op1, $op2) =
        split '', sprintf("%05d", $self->code->[$self->ip]);
    my $op = $op1 . $op2;
    my $p1 = $pm1 ? $self->code->[$self->ip + 1] :
        $self->code->[$self->code->[$self->ip + 1]];
    my $p2 = $pm2 ? $self->code->[$self->ip+2] :
        $self->code->[$self->code->[$self->ip + 2]];
    my $p3 = $pm3 ? $self->code->[$self->ip+3] :
        $self->code->[$self->code->[$self->ip + 3]];

    if    ($op == 1) { $self->code->[$self->code->[$self->ip+3]] = $p1 + $p2;
                       $self->{ip} += 4; }
    elsif ($op == 2) { $self->code->[$self->code->[$self->ip+3]] = $p1 * $p2;
                       $self->{ip} += 4; }
    elsif ($op == 3) { return unless (@{$self->{input}});  # stall
                       $self->code->[$self->code->[$self->ip+1]] =
                           shift @{$self->{input}};
                       $self->{ip} += 2; }
    elsif ($op == 4) { CORE::push @{$self->{output}}, $p1;
                       $self->{ip} += 2; }
    elsif ($op == 5) { $self->{ip} =  $p1 ? $p2 : $self->ip +  3; }
    elsif ($op == 6) { $self->{ip} = !$p1 ? $p2 : $self->ip +  3; }
    elsif ($op == 7) { $self->code->[$self->code->[$self->ip+3]] = $p1 < $p2;
                       $self->{ip} += 4; }
    elsif ($op == 8) { $self->code->[$self->code->[$self->ip+3]] = $p1 == $p2;
                       $self->{ip} += 4; }

    $self;
}

1;
