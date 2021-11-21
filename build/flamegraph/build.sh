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

PROG=flamegraph
VER=20190323
PKG=ooce/developer/flamegraph
SUMMARY="Flame Graph Generator"
DESC="Generate interactive flame graphs to visualise system activity"
BUILDDIR=FlameGraph-master

OPREFIX=$PREFIX
PREFIX+="/$PROG"

XFORM_ARGS="
    -DPREFIX=${PREFIX#/}
    -DOPREFIX=${OPREFIX#/}
    -DPROG=$PROG
"

make_install() {
    logcmd mkdir -p $DESTDIR/$PREFIX
    pushd $DESTDIR/$PREFIX >/dev/null
    logcmd mkdir bin sbin
    for f in stackcollapse flamegraph; do
        logcmd cp $TMPDIR/$BUILDDIR/$f.pl sbin/$f.pl \
            || logerr "cp $f failed"
    done
    logcmd cp $TMPDIR/$BUILDDIR/docs/cddl1.txt LICENCE || logerr cp licence
    logcmd cp $SRCDIR/files/flamegraph bin/ || logerr cp flamegraph
    popd >/dev/null
}

init
download_source $PROG $PROG $VER
prep_build
make_install
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
