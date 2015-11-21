#!/opt/local/bin/perl
use strict;
use warnings;

my $cutoff = $ARGV[0];

$_=<STDIN>;
print;
while (<STDIN>) {
    m/\s(\d+)$/;
#    my @fields = split(" ");
#    ($fields[9] > $cutoff) || next;
    ($1 >= $cutoff) || next;
    print;
}
