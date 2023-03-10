## Copyright (C) 2006 Charalampos C. Tsimenidis
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
## @deftypefn  {Function File} {@var{y} =} pskmod (@var{x}, @var{m})
## @deftypefnx {Function File} {@var{y} =} pskmod (@var{x}, @var{m}, @var{phi})
## @deftypefnx {Function File} {@var{y} =} pskmod (@var{x}, @var{m}, @var{phi}, @var{type})
##
## Modulates an information sequence of integers @var{x} in the range
## @code{[0 @dots{} M-1]} onto a complex baseband phase shift keying
## modulated signal @var{y}. @var{phi} controls the initial phase and
## @var{type} controls the constellation mapping. If @var{type} is set
## to "Bin" will result in binary encoding, in contrast, if set to "Gray"
## will give Gray encoding. An example of Gray-encoded QPSK is
##
## @example
## @group
## d = randint (1, 5e3, 4);
## y = pskmod (d, 4, 0, "gray");
## z = awgn (y, 30);
## plot (z, "rx")
## @end group
## @end example
##
## The output @var{y} will be the same shape as the input @var{x}.
##
## @seealso{pskdemod}
## @end deftypefn

function y = pskmod (x, M, phi, type)

  if (nargin < 2 || nargin > 4)
    print_usage ();
  endif

  m = 0:M-1;

  if (!isempty (find (ismember (x, m) == 0)))
    error ("pskmod: all elements of X must be integers in the range [0,M-1]");
  endif

  if (nargin < 3)
    phi = 0;
  endif

  if (nargin < 4)
    type = "Bin";
  endif

  constellation = exp (1j*2*pi*m/M + 1j*phi);

  if (strcmp (type, "Bin") || strcmp (type, "bin"))
    y = constellation(x+1);
  elseif (strcmp (type, "Gray") || strcmp (type, "gray"))
    [a, b] = sort (bitxor (m, bitshift (m, -1)));
    y = constellation(b(x+1));
  else
    print_usage ();
  endif

  if (iscolumn (x))
    ## Correct for vector input defaulting to row vector output
    y = y(:);
  end

endfunction

%!assert (round (pskmod ([0:3], 4, 0, "Bin")), [1 j -1 -j])
%!assert (round (pskmod ([0:3], 4, 0, "Gray")), [1 j -j -1])

##verify output size matches inputs size
%!assert <*51560> (size (pskmod ([0:3], 4, pi/4)), [1, 4])
%!assert <*51560> (size (pskmod ([0:3]', 4, pi/4)), [4, 1])
%!assert <*51560> (size (pskmod ([0:3; 0:3], 4, pi/4)), [2, 4])
%!assert <*51560> (size (pskmod (cat(3,[0:3],[0:3]), 4, pi/4)), [1, 4, 2])
%!assert <*51560> (size (pskmod (cat(3,[0:3]',[0:3]'), 4, pi/4)), [4, 1, 2])
%!assert <*51560> (size (pskmod (cat(3,[0:3;0:3],[0:3;0:3]), 4, pi/4)), [2, 4, 2])

## Test input validation
%!error pskmod ()
%!error pskmod (1)
%!error pskmod (1, 2, 3, 4, 5)
%!error pskmod (1, 2, 3, "invalid")
%!error pskmod (0:7, 4)
