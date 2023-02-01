AC_PREREQ([2.60])
AC_INIT([Octave-Forge communications package], [0])

AC_CONFIG_HEADERS([config.h])

# Avoid warnings for redefining AH-generated preprocessor symbols of
# Octave.
AH_TOP([#include "undef-ah-octave.h"])

AC_CONFIG_MACRO_DIRS([m4])

AC_ARG_VAR([MKOCTFILE], [mkoctfile compiler helper command])
AC_ARG_VAR([OCTAVE], [Octave interpreter command])
AC_CHECK_PROG([MKOCTFILE], mkoctfile, mkoctfile, [])
AC_CHECK_PROG([OCTAVE], octave, octave, [])
AC_PROG_CXX
AC_PROG_SED

# Checks for octave depreciated symbols
## Simple symbol alternatives of different Octave versions.
AC_LANG(C++)
save_altsyms_CXX="$CXX"
save_altsyms_CXXFLAGS="$CXXFLAGS"
save_altsyms_CPPFLAGS="$CPPFLAGS"
save_altsyms_LDFLAGS="$LDFLAGS"
save_altsyms_LIBS="$LIBS"
OCTINCLUDEDIR=${OCTINCLUDEDIR:-`$MKOCTFILE -p INCFLAGS`}
OCTLIBDIR=${OCTLIBDIR:-`$MKOCTFILE -p OCTLIBDIR`}
CXX=`${MKOCTFILE} -p CXX`
CPPFLAGS="$OCTINCLUDEDIR $CPPFLAGS"
LDFLAGS="-L$OCTLIBDIR $LDFLAGS"
LIBS="-loctinterp $LIBS"

OF_OCTAVE_LIST_ALT_SYMS([
[dnl
  [gripe_nonconformant],
  [octave::err_nonconformant],
  [[octave::err_nonconformant ("a",0,0)]],
  [OCTAVE__ERR_NONCONFORMANT],
  [[#include <octave/gripes.h>]],
  [[#include <octave/errwarn.h>]]
],

[dnl
  [gripe_wrong_type_arg],
  [err_wrong_type_arg],
  [[err_wrong_type_arg ("a", "b")]],
  [OCTAVE__ERR_WRONG_TYPE_ARG],
  [[#include <octave/gripes.h>]],
  [[#include <octave/errwarn.h>]]
],

[dnl
  [gripe_square_matrix_required],
  [err_square_matrix_required],
  [[err_square_matrix_required ("a", "b")]],
  [DELOCTAVE__ERR_SQUARE_MATRIX_REQUIRED],
  [[#include <octave/gripes.h>]],
  [[#include <octave/errwarn.h>]]
],

[dnl
  [gripe_invalid_conversion],
  [err_invalid_conversion],
  [[err_invalid_conversion ("a", "b")]],
  [OCTAVE__ERR_INVALID_CONVERSION],
  [[#include <octave/gripes.h>]],
  [[#include <octave/errwarn.h>]]
],

[dnl
  [gripe_implicit_conversion],
  [warn_implicit_conversion],
  [[warn_implicit_conversion ("a", "b", "c")]],
  [OCTAVE__WARN_INVALID_CONVERSION],
  [[#include <octave/gripes.h>]],
  [[#include <octave/errwarn.h>]]
],

[dnl
  [flush_octave_stdout],
  [octave::flush_stdout],
  [[octave::flush_stdout ();]],
  [OCTAVE__FLUSH_STDOUT],
  [[]],
  [[]]
],

[dnl
  [is_complex_type],
  [iscomplex],
  [[octave_value ().iscomplex ();]],
  [OV_ISCOMPLEX],
  [],
  []
],

[dnl
  [is_real_type],
  [isreal],
  [[octave_value ().isreal ();]],
  [OV_ISREAL],
  [],
  []
],

[dnl
  [is_numeric_type],
  [isnumeric],
  [[octave_value ().isnumeric ();]],
  [OV_ISNUMERIC],
  [],
  []
],

[dnl
  [is_empty],
  [isempty],
  [[octave_value ().isempty ();]],
  [OV_ISEMPTY],
  [],
  []
],

[dnl
  [oct_mach_info::float_format],
  [octave::mach_info::float_format],
  [[octave::mach_info::float_format fmt;]],
  [OCTAVE_MACH_INFO_FLOAT_FORMAT],
  [],
  []
]

],[oct-alt-includes.h])

AC_CHECK_HEADERS([octave/oct.h])
AC_CHECK_HEADERS([octave/base-lu.h])
AC_CHECK_HEADERS([octave/lu.h])
AC_CHECK_HEADERS([octave/gripes.h])
AC_CHECK_HEADERS([octave/errwarn.h])
AC_CHECK_HEADERS([octave/ovl.h])
AC_CHECK_HEADERS([octave/oct-obj.h])
AC_CHECK_HEADERS([octave/ls-oct-ascii.h])
AC_CHECK_HEADERS([octave/ls-oct-text.h])
AC_CHECK_HEADERS([octave/oct-obj.h])
AC_CHECK_HEADERS([octave/interpreter.h])

CXX=$save_altsyms_CXX
CXXFLAGS=$save_altsyms_CXXFLAGS
CPPFLAGS=$save_altsyms_CPPFLAGS
LDFLAGS=$save_altsyms_LDFLAGS
LIBS=$save_altsyms_LIBS

have_hdf5=no
# check for HDF5 using pkg-config
PKG_CHECK_MODULES([HDF5],[hdf5],
 [have_hdf5=yes ],
 []
)
if test $have_hdf5 = no; then
  save_CPPFLAGS="$CPPFLAGS"
  save_LIBS="$LIBS"
  AC_CHECK_LIB(hdf5,H5Fopen,
    [
     have_hdf5=yes
     AC_CHECK_HEADERS([hdf5.h])
     HDF5_LIBS=-lhdf5
    ],
    [],
  )
  CPPFLAGS="$save_CPPFLAGS"
  LIBS="$save_LIBS"
fi
if test $have_hdf5 = no; then
  AC_MSG_ERROR([hdf5 not found])
fi

comm_OCT_EVAL="$OCTAVE --norc --no-history --silent --eval"
 
comm_CXXFLAGS=`$MKOCTFILE -p ALL_CXXFLAGS`

AC_CACHE_CHECK([for octave_hdf5_id type],
  [comm_cv_octave_hdf5_id_type],
  [comm_save_CPPFLAGS=$CPPFLAGS
   comm_save_CXXFLAGS=$CXXFLAGS
   CPPFLAGS="$CPPFLAGS $HDF5_CFLAGS"
   CXXFLAGS="$CXXFLAGS $comm_CXXFLAGS"
   AC_LANG_PUSH(C++)
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
       #include <octave/oct.h>
       #include <octave/ov-base.h>
       ]], [[
       octave_hdf5_id x;
       ]])],
     [comm_cv_octave_hdf5_id_type=yes],
     [comm_cv_octave_hdf5_id_type=no])
   AC_LANG_POP(C++)
   CPPFLAGS=$comm_save_CPPFLAGS
   CXXFLAGS=$comm_save_CXXFLAGS])
if test $comm_cv_octave_hdf5_id_type = yes; then
  AC_DEFINE([HAVE_OCTAVE_HDF5_ID_TYPE],[1],[Define if have octave_hdf5_id])
fi

AC_CACHE_CHECK([for octave_base_value::gripe_load and octave_base_value::gripe_save],
  [comm_cv_octave_base_value_gripe_load_save],
  [comm_save_CPPFLAGS=$CPPFLAGS
   comm_save_CXXFLAGS=$CXXFLAGS
   CPPFLAGS="$CPPFLAGS $HDF5_CFLAGS"
   CXXFLAGS="$CXXFLAGS $comm_CXXFLAGS"
   AC_LANG_PUSH(C++)
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
       #include <octave/oct.h>
       #include <octave/ov-base.h>
       class foo : public octave_base_value
       {
       public:
         foo () {}
         void func () { gripe_load ("func"); gripe_save ("func"); }
       };
       ]], [[
       foo x;
       ]])],
     [comm_cv_octave_base_value_gripe_load_save=yes],
     [comm_cv_octave_base_value_gripe_load_save=no])
   AC_LANG_POP(C++)
   CPPFLAGS=$comm_save_CPPFLAGS
   CXXFLAGS=$comm_save_CXXFLAGS])
if test $comm_cv_octave_base_value_gripe_load_save = yes; then
  AC_DEFINE([HAVE_OCTAVE_BASE_VALUE_GRIPE_LOAD_SAVE],[1],[Define if have gripe_load and gripe_save])
fi

AC_CACHE_CHECK([whether octave_base_value::print is const-qualified],
  [comm_cv_octave_base_value_print_const_qualified],
  [comm_save_CPPFLAGS=$CPPFLAGS
   comm_save_CXXFLAGS=$CXXFLAGS
   CPPFLAGS="$CPPFLAGS $HDF5_CFLAGS"
   CXXFLAGS="$CXXFLAGS $comm_CXXFLAGS"
   AC_LANG_PUSH(C++)
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
       #include <iostream>
       #include <octave/oct.h>
       #include <octave/ov-base.h>
       ]], [[
       const octave_base_value x; x.print (std::cout);
       ]])],
     [comm_cv_octave_base_value_print_const_qualified=yes],
     [comm_cv_octave_base_value_print_const_qualified=no])
   AC_LANG_POP(C++)
   CPPFLAGS=$comm_save_CPPFLAGS
   CXXFLAGS=$comm_save_CXXFLAGS])
if test $comm_cv_octave_base_value_print_const_qualified = yes; then
  AC_DEFINE([HAVE_OCTAVE_BASE_VALUE_PRINT_CONST],[1],[Define if octave_base_value::print is const-qualified])
fi

AC_CACHE_CHECK([whether first catop function argument is const-qualified],
  [comm_cv_octave_first_catop_fcn_arg_const_qualified],
  [comm_save_CPPFLAGS=$CPPFLAGS
   comm_save_CXXFLAGS=$CXXFLAGS
   CPPFLAGS="$CPPFLAGS $HDF5_CFLAGS"
   CXXFLAGS="$CXXFLAGS $comm_CXXFLAGS"
   AC_LANG_PUSH(C++)
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
       #include <octave/oct.h>
       #include <octave/ov-typeinfo.h>
       ]], [[
       octave_value foobar_fcn (const octave_base_value&,
                                const octave_base_value&,
                                const Array<octave_idx_type>& ra_idx);
       octave::type_info::cat_op_fcn fcn = foobar_fcn;
       ]])],
     [comm_cv_octave_first_catop_fcn_arg_const_qualified=yes],
     [comm_cv_octave_first_catop_fcn_arg_const_qualified=no])
   AC_LANG_POP(C++)
   CPPFLAGS=$comm_save_CPPFLAGS
   CXXFLAGS=$comm_save_CXXFLAGS])
if test $comm_cv_octave_first_catop_fcn_arg_const_qualified = yes; then
  AC_DEFINE([HAVE_OCTAVE_FIRST_CATOP_ARG_CONST],[1],[Define if first catop function argument is const-qualified])
fi

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
