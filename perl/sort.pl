#!/usr/bin/perl -w
use strict;
use Time::HiRes qw(time);

use lib 'lib';
use Sort::Alphanum;

scalar @ARGV == 1
    or die "Usage: $0 <number of array elements>";

my $numElements = $ARGV[0];
my @array = map { 'a' . int(rand($numElements)) } (1..$numElements);

my $numCmp = 0;
sub sortSub {
    $numCmp++;
    return Sort::Alphanum::cmp($a, $b);
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
          sort { Sort::Alphanum::alphanum_compare_chunks($a->[1], $b->[1]) }
          map  { [$_, Sort::Alphanum::chunkify($_)] }
               @array;
$end = time;
printf "Schwartzian: %d elements, %d comparisons took %fs\n",
    $numElements, $numCmp, ($end-$begin);

$begin = time;
@sorted = map  { $_->[0] }
          sort { $a->[1] cmp $b->[1] }
          map  { [$_, Sort::Alphanum::chunkify_string($_)] }
               @array;
$end = time;
printf "Schwartzian (string cmp): %d elements, %d comparisons took %fs\n",
    $numElements, $numCmp, ($end-$begin);
