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

# Copyright 2021 OmniOS Community Edition (OmniOSce) Association.

. ../../lib/build.sh

PROG=vagrant
PKG=ooce/application/vagrant
VER=2.2.19
# latest release from https://github.com/hashicorp/vagrant-installers/releases
INSTVER=2.2.6
SUMMARY="Vagrant"
DESC="Build and distribute virtualized development environments"

OPREFIX=$PREFIX
PREFIX+=/$PROG

set_arch 64
set_gover
set_rubyver

XFORM_ARGS="
    -DPREFIX=${PREFIX#/}
    -DOPREFIX=${OPREFIX#/}
    -DPROG=$PROG
    -DVERSION=$VER
"

# For bsdtar, needed to unpack boxes
RUN_DEPENDS_IPS="ooce/library/libarchive"

PKGDIFFPATH="${PREFIX#/}/embedded/gems"
PKGDIFF_HELPER="
    s:$PKGDIFFPATH/[0-9.]*:$PKGDIFFPATH/VERSION:
    s:$PROG-[0-9.]*:$PROG-VERSION:
"

build() {
    pushd $TMPDIR/$BUILDDIR/$PROG >/dev/null

    logmsg "Building Vagrant"
    logcmd gem build $PROG.gemspec || logerr "Build Vagrant failed"

    popd >/dev/null
    pushd $TMPDIR/$BUILDDIR/$PROG-installers/substrate/launcher/ >/dev/null

    logmsg "Build Vagrant Installers"
    GOPATH=$TMPDIR/$BUILDDIR/$PROG-installers/substrate/launcher/_deps
    GO111MODULE=auto
    export GOPATH GO111MODULE
    logcmd go get github.com/kardianos/osext \
        || logerr "Get dependency for Vagrant Installers failed"
    logcmd go build -o $PROG || logerr "Build Vagrant Installers failed"

    popd >/dev/null
}

install() {
    pushd $TMPDIR/$BUILDDIR/$PROG >/dev/null

    EMBEDDED_DIR=$TMPDIR/$BUILDDIR/$PROG/opt/$PROG/embedded/

    logmsg "Install Vagrant"
    GEM_PATH="$EMBEDDED_DIR"/gems/$VER \
    GEM_HOME="$GEM_PATH" \
    GEMRC="$EMBEDDED_DIR"/etc/gemrc \
    logcmd gem install $PROG-$VER.gem --no-document \
        || logerr "Install failed"

    logmsg "Create embedded manifest with version number"
    echo "{ \"vagrant_version\": \"$VER\" }" > $EMBEDDED_DIR/manifest.json

    popd >/dev/null

    patch_source

    pushd $TMPDIR/$BUILDDIR >/dev/null

    logmsg "Install Vagrant, Installer and all embedded dependencies"
    logcmd mkdir -p $DESTDIR/$PREFIX/bin
    logcmd cp $TMPDIR/$BUILDDIR/$PROG-installers/substrate/launcher/$PROG \
        $DESTDIR/$PREFIX/bin/$PROG || logerr "cp failed"
    logcmd cp -r $TMPDIR/$BUILDDIR/$PROG/opt/$PROG/embedded \
        $DESTDIR/$PREFIX || logerr "cp failed"

    popd >/dev/null
}

init
clone_github_source $PROG "$GITHUB/hashicorp/$PROG" v$VER
clone_github_source $PROG-installers \
    "$GITHUB/hashicorp/$PROG-installers" v$INSTVER
PATCHDIR=patches-installer patch_source
prep_build
build
install
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
