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
#
# Copyright 2018 OmniOS Community Edition (OmniOSce) Association.
# Use is subject to license terms.
#
. ../../lib/build.sh

PROG=sysstat
VER=20151012
VERHUMAN=$VER
PKG=ooce/system/sysstat
SUMMARY="System statistics"
DESC="Key system statistics at a glance"

OPREFIX=$PREFIX
PREFIX+="/$PROG"
XFORM_ARGS=" -DOPREFIX=${OPREFIX#/} -DPROG=$PROG"

# Build 64-bit only and skip the arch-specific directories
BUILDARCH=64
CONFIGURE_OPTS_64="
    --prefix=$PREFIX
"

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
