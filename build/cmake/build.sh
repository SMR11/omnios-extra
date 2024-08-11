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

# Copyright 2024 OmniOS Community Edition (OmniOSce) Association.

. ../../lib/build.sh

PROG=cmake
VER=3.30.2
PKG=ooce/developer/cmake
SUMMARY="Build coordinator"
DESC="An extensible system that manages the build process in a "
DESC+="compiler-independent manner"

set_arch 64
set_clangver

SKIP_LICENCES=Kitware

MAKE=$NINJA

CONFIGURE_OPTS[amd64]="
    --prefix=$PREFIX
    --generator=Ninja
    --system-curl
"

init
download_source $PROG $PROG $VER
patch_source
prep_build autoconf-like
build
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
