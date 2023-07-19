
. ../../../lib/build.sh

ARCH=aarch64
NATIVE_TRIPLET64=${TRIPLETS[$BUILD_ARCH]}
TRIPLET64=${TRIPLETS[$ARCH]}
CROSSGCCVER=10

min_rel 151045

PREFIX=/opt/cross/$ARCH
SYSROOT=$PREFIX/sysroot

TMPDIR+="/$ARCH"
DTMPDIR+="/$ARCH"
BASE_TMPDIR=$TMPDIR

