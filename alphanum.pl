#
# The Alphanum Algorithm is an improved sorting algorithm for strings
# containing numbers.  Instead of sorting numbers in ASCII order like
# a standard sort, this algorithm sorts numbers in numeric order.
#
# The Alphanum Algorithm is discussed at http://www.DaveKoelle.com
#

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


#
# TODO: Make decimal points be considered in the same class as digits
#

# usage:
#my @sorted = sort { alphanum($a,$b) } @strings;

sub alphanum {
  # split strings into chunks
  my @a = chunkify($_[0]);
  my @b = chunkify($_[1]);
  
  # while we have chunks to compare.
  while (@a && @b) {
    my $a_chunk = shift @a;
    my $b_chunk = shift @b;
    
    my $test =
        (($a_chunk =~ /\d/) && ($b_chunk =~ /\d/)) ? # if both are numeric
            $a_chunk <=> $b_chunk : # compare as numbers
            $a_chunk cmp $b_chunk ; # else compare as strings  
    
    # return comparison if not equal.
    return $test if $test != 0;
  }

  # return longer string.
  return @a <=> @b;
}

# split on numeric/non-numeric transitions
sub chunkify {
  my @chunks = split m{ # split on
    (?= # zero width
      (?<=\D)\d | # digit preceded by a non-digit OR
      (?<=\d)\D # non-digit preceded by a digit
    )
  }x, $_[0];
  return @chunks;
}

