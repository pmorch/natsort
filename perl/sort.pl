#!/usr/bin/perl -w
use strict;
use Time::HiRes qw(time);

do "alphanum.pl";

scalar @ARGV == 1
    or die "Usage: $0 <number of array elements>";

my $numElements = $ARGV[0];
my @array = map { 'a' . int(rand($numElements)) } (1..$numElements);

my $numCmp = 0;
sub sortSub {
    $numCmp++;
    return alphanum($a, $b);
}

my $begin = time;
my @b = sort sortSub @array;
my $end = time;
printf "%d elements, %d comparisons took %fs\n",
    $numElements, $numCmp, ($end-$begin);
