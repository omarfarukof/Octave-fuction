## Copyright (C) 2022 The Octave Project Developers
## Copyright (C) 2016 Òscar Monerris Belda <>
## Copyright (C) 2007 Sylvain Pelissier <sylvain.pelissier@gmail.com>
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
## @deftypefn {Function File} {} myqammod (@var{x}, @var{M})
## @deftypefnx {Function File} {} myqammod (@var{x}, @var{M},@var{symOrder})
## Create the QAM modulation of @var{x} with a size of alphabet @{M} using a given @var{symOrder}.
##
## @var{x} vector in the range 0 to M-1
##
## @var{M} modulation order
##
## @var{symOrder} 'bin', 'gray', user define array
##
## @example
## M = 4;
## sym = 0:M-1;
## qammod(sym, M)
##
## ans =
##
##  -1 + 1i
##  -1 - 1i
##   1 + 1i
##   1 - 1i
## @end example
##
##
## @seealso{qamdemod, pskmod, pskdemod}
## @end deftypefn

function y = qammod (x, M, symOrder)

  if (nargin < 1 || nargin > 3)
    print_usage ();
  elseif (nargin == 2)
    symOrder = 'gray';
  endif

  if (any (x >= M))
    error ("qammod: all elements of X must be in the range [0,M-1]");
  endif

  if (~all (x == fix (x)))
    error ("qammod: all elements of X must be integers");
  endif
  
  symOrder = lower (symOrder);
  if (~(isnumeric (symOrder) || strcmpi (symOrder,'gray') || strcmpi (symOrder,'bin')))
    error('qammod: symOrder %s is not valid options are bin and gray', symOrder);
  endif
  
  if (fix (sqrt(M)) ~= sqrt(M))
    error ("qammod: M must be a square of a power of 2");
  endif

  rng = sqrt (M);
  # Create the binary mapping table
  val = 2 * (0: rng - 1) - rng + 1;
  [Ii, Qi] = meshgrid (val);
  lookupTable = reshape (Ii - j * Qi, M, 1);
  
  # Build the symOrder lookup table to convert 
  # map from binary to gray or custom (if applicable)
  if ischar (symOrder)
    if strcmpi (symOrder, 'bin')
      % Do nothing
    elseif strcmpi (symOrder, 'gray')
      % bitxor(x,bitshift(x,-1));
      [x,~] = bin2gray (x, 'qam', M);
    endif
  elseif isvector (symOrder)
    x = symOrder (x + 1);
  endif
  
  # Map the input symbols to their IQ value
  y = lookupTable (x + 1);

endfunction

%% Test input validation
%!error qammod ()
%!error qammod (1)
%!error qammod (1, 16, 2)
%!error <symOrder> qammod(4,5,'grey')

%!test
%! M = 4;sym = 0:M-1;
%! assert (qammod(sym, M), [-1+1i; -1-1i; 1+1i; 1-1i]);

#https://github.com/kirlf/modulationPy
%!test
%! M = 16;sym = 0:M-1;
%! assert (qammod(sym, M, 'gray'), [-3+3i -3+1i -3-3i -3-1i -1+3i -1+1i -1-3i -1-1i 3+3i 3+1i 3-3i 3-1i 1+3i 1+1i 1-3i 1-1i].');
