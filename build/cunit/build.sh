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

# Copyright 2018 OmniOS Community Edition (OmniOSce) Association.

. ../../lib/build.sh

PROG=cunit
VER=2.1-3
VERHUMAN=$VER
PKG=ooce/developer/cunit
SUMMARY="C Unit Testing Framework"
DESC="$SUMMARY"

BUILDDIR=CUnit-$VER

OPREFIX=$PREFIX
PREFIX+="/$PROG"

XFORM_ARGS="
    -DPREFIX=${PREFIX#/}
    -DOPREFIX=${OPREFIX#/}
    -DPROG=$PROG
"

init
download_source $PROG CUnit $VER
prep_build
patch_source
run_autoreconf -fi
build
VER=${VER//-/.}
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
