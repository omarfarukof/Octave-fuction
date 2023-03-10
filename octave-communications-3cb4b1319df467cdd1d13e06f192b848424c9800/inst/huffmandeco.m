## Copyright (C) 2021 The Octave Project Developers
## Copyright (C) 2006 Muthiah Annamalai <muthiah.annamalai@uta.edu>
## Copyright (C) 2011 Ferran Mesas Garcia <ferran.mesas01@gmail.com>
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{sig} =} huffmandeco (@var{hcode}, @var{dict})
## Decode signal encoded by @code{huffmanenco}.
##
## This function uses a dict built from the
## @code{huffmandict} and uses it to decode a signal list into a Huffman
## list. A restriction is that @var{hcode} is expected to be a binary code
##
## The returned @var{sig} set that strictly belongs in the range @code{[1,N]}
## with @code{N = length (@var{dict})}. Also @var{dict} can only be from the
## @code{huffmandict} routine. Whenever decoding fails, those signal values a
## re indicated by @code{-1}, and we successively try to restart decoding
## from the next bit that hasn't failed in decoding, ad-infinitum. An example
## of the use of @code{huffmandeco} is:
##
## @example
## @group
## hd    = huffmandict (1:4, [0.5 0.25 0.15 0.10]);
## hcode = huffmanenco (1:4, hd);
## back  = huffmandeco (hcode, hd)
##     @result{} [1 2 3 4]
## @end group
## @end example
## @seealso{huffmandict, huffmanenco}
## @end deftypefn

function symbols = huffmandeco (hcode, dict)

  if (nargin != 2)
    print_usage ();
  elseif (!all ((hcode == 1) + (hcode == 0)) || !isvector (hcode))
    error ("huffmandeco: HCODE must be a binary vector");
  elseif (! iscell (dict))
    error ("huffmandeco: DICT must be a dictionary from huffmandict");
  endif

  ## Convert the Huffman Dictionary to a Huffman Tree represented by
  ## an array.
  tree = dict2tree (dict);

  ## Traverse the tree and store the symbols.
  symbols = [];
  pointer = 1; # a pointer to a node of the tree.
  for i = 1:length (hcode);
    if (tree(pointer) != -1)
      symbols = [symbols, tree(pointer)];
      pointer = 1;
    endif
    pointer = 2 * pointer + hcode(i);
  endfor

  ## Check if decodification was successful
  if (tree(pointer) == -1)
    warning ("huffmandeco: could not decode last symbol")
  endif
  symbols = [symbols, tree(pointer)];

endfunction

function tree = dict2tree (dict)

  L = length (dict);
  lengths = zeros (1, L);

  ## the depth of the tree is limited by the maximum word length.
  for i = 1:L
    lengths(i) = length (dict{i});
  endfor
  m = max (lengths);

  tree = zeros (1, 2^(m+1)-1)-1;

  for i = 1:L
    pointer = 1;
    word    = dict{i};
    for bit = word
      pointer = 2 * pointer + bit;
    endfor
    tree(pointer) = i;
  endfor

endfunction

%!test
%! dict = huffmandict (1:4, [0.5 0.25 0.15 0.10]);
%! hcode = huffmanenco (1:4, dict);
%! assert (huffmandeco (hcode, dict), [1:4], 0)
%! fail ("huffmandeco ([hcode 0], dict)", "warning")
%! fail ("huffmandeco ('this is not a code', dict)")


%!test
%! dict2 = huffmandict (1:100, ones (1, 100)/100);
%! hcode2 = huffmanenco ([1:100 100:-1:1], dict2);
%! assert (huffmandeco (hcode2, dict2), [1:100 100:-1:1], 0)

%!fail ("huffmandeco ([1 0 1 0], 'this is not a dictionary')")

%% Test input validation
%!error huffmandeco ()
%!error huffmandeco (1)
%!error huffmandeco (1, 2, 3)
%!error huffmandeco (1, 2)
%!error huffmandeco (2, {})
