#!/usr/bin/bash
#
# {{{ CDDL HEADER
#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source. A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
# }}}

# Copyright 2019 OmniOS Community Edition (OmniOSce) Association.

. ../../lib/build.sh

PROG=libpng
VER=1.6.37
PKG=ooce/library/libpng
SUMMARY="libpng"
DESC="libpng is the official PNG reference library"

SKIP_LICENCES=libpng

OPREFIX=$PREFIX
PREFIX+="/$PROG"

XFORM_ARGS="
    -DPREFIX=${PREFIX#/}
    -DOPREFIX=${OPREFIX#/}
    -DPROG=$PROG
"

CONFIGURE_OPTS="
    --disable-static
    --prefix=$PREFIX
    --includedir=$OPREFIX/include
"
CONFIGURE_OPTS_32="
    --bindir=$PREFIX/bin/$ISAPART
    --sbindir=$PREFIX/sbin/$ISAPART
    --libdir=$OPREFIX/lib
"
CONFIGURE_OPTS_64="
    --bindir=$PREFIX/bin
    --sbindir=$PREFIX/sbin
    --libdir=$OPREFIX/lib/$ISAPART64
"

init
download_source $PROG $PROG $VER
prep_build
patch_source
build
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
