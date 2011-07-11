package Sort::Alphanum;

#
# The Alphanum Algorithm is an improved sorting algorithm for strings
# containing numbers.  Instead of sorting numbers in ASCII order like
# a standard sort, this algorithm sorts numbers in numeric order.
#
# The Alphanum Algorithm is discussed at http://www.DaveKoelle.com
#
# Peter V. Mørch (http://www.morch.com) took alphanum.pl from
# http://www.DaveKoelle.com and modified it into what you're seeing here.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#

# To make sorting faster, we only want to chunkify each element once. We do
# that by using the Schwartzian transform idiom:
# http://en.wikipedia.org/wiki/Schwartzian_transform
#
# @sorted = map  { $_->[0] }
#           sort { $a->[1] cmp $b->[1] }
#           map  { [$_, foo($_)] }
#                @unsorted;
#
#
# TODO: Make decimal points be considered in the same class as digits
#
#
# usage:
#
#     use Sort::Alphanum;
#     my @sorted = sort { Sort::Alphanum::cmp($a,$b) } @strings;

sub cmp {
  my ($a, $b) = @_;
  return alphanum_compare_chunks(chunkify($a), chunkify($b));
}

sub alphanum_compare_chunks {
  my ($a, $b) = @_;
  my $a_index = 0;
  my $b_index = 0;
  
  # while we have chunks to compare.
  while ($a->[$a_index] && $b->[$b_index]) {
    my $a_chunk = $a->[$a_index++];
    my $b_chunk = $b->[$b_index++];
    
    my $test =
        (($a_chunk =~ /\d/) && ($b_chunk =~ /\d/)) ? # if both are numeric
            $a_chunk <=> $b_chunk : # compare as numbers
            $a_chunk cmp $b_chunk ; # else compare as strings  
    
    # return comparison if not equal.
    return $test if $test != 0;
  }

  # return longer string.
  return @$a <=> @$b;
}

# split on numeric/non-numeric transitions
sub chunkify {
  my @chunks = split m{ # split on
    (?= # zero width
      (?<=\D)\d | # digit preceded by a non-digit OR
      (?<=\d)\D # non-digit preceded by a digit
    )
  }x, $_[0];
  return \@chunks;
}

sub chunkify_string {
  my $chunks = chunkify($_[0]);
  return join("", map {
    if (/\d/) {
        sprintf "%032.16f", $_;
    } else {
        $_;
    }
  } @$chunks);
}

1;
