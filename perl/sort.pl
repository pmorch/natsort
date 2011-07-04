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

my ($begin, $end);

$begin = time;
my @sorted = sort sortSub @array;
$end = time;
printf "%d elements, %d comparisons took %fs\n",
    $numElements, $numCmp, ($end-$begin);


# Schwartzian transform:
$begin = time;
@sorted = map  { $_->[0] }
          sort { alphanum_compare_chunks($a->[1], $b->[1]) }
          map  { [$_, chunkify($_)] }
               @array;
$end = time;
printf "Schwartzian: %d elements, %d comparisons took %fs\n",
    $numElements, $numCmp, ($end-$begin);
