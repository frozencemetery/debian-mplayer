#!/bin/sh
#
#  Script to create a 'pristine' tarball for the debian mplayer source package
#  Copyright (C) 2009, Reinhard Tartler
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License along
#  with this program; if not, write to the Free Software Foundation, Inc.,
#  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

set -eu

usage() {
	cat >&2 <<EOF
usage: $0 [-dh]
  -h : display help
  -d : svn date
EOF
}

debug () {
	$DEBUG && echo "DEBUG: $*" >&2
}

error () {
	echo "$1" >&2
	exit 1;
}

set +e
PARAMS=`getopt hd: "$@"`
if test $? -ne 0; then usage; exit 1; fi;
set -e

eval set -- "$PARAMS"

DEBUG=false
SVNDATE=

while test $# -gt 0
do
	case $1 in
		-h) usage; exit 1 ;;
		-d) SVNDATE=$2; shift ;;
		--) shift ; break ;;
		*)  echo "Internal error!" ; exit 1 ;;
	esac
	shift
done

# sanity checks now
dh_testdir

if [ -z $SVNDATE ]; then
	error "you need to specify an svn date. e.g. 20081230 for Dec 29. 2008"
fi

CLEANUPSCRIPT=`pwd`/debian/strip.sh
TARBALL=`pwd`/../mplayer_1.0~rc3+svn${SVNDATE}.orig.tar.gz
TARBALL_UNSTRIPPED=`pwd`/../mplayer-non-dfsg_1.0~rc3+svn${SVNDATE}.orig.tar.gz
PACKAGENAME=mplayer

TMPDIR=`mktemp -d`
trap 'rm -rf ${TMPDIR}'  EXIT

baseurl="svn://svn.mplayerhq.hu/mplayer/branches/1.0rc3"

svn export -r{${SVNDATE}} \
	--ignore-externals \
	${baseurl}  \
	${TMPDIR}/${PACKAGENAME}

svn info -r{${SVNDATE}} \
	${baseurl} \
	| awk '/^Revision/ {print $2}' \
	> ${TMPDIR}/${PACKAGENAME}/.svnrevision

# get svn externals
svn pg svn:externals $baseurl | \
while read external url; do
    [ -z $url ] && continue
    dest="${TMPDIR}/${PACKAGENAME}/${external}"
    svn export -r{${SVNDATE}} --ignore-externals $url $dest
    svn info $url -r{${SVNDATE}} \
      | awk '/^Revision/ {print $2}' \
      > ${TMPDIR}/${PACKAGENAME}/${external}/.svnrevision
done

# this doesn't belong in strip.sh, because the unstripped source should
# have this directory renamed as well.
( cd ${TMPDIR}/${PACKAGENAME} && rm -rfv debian )

( cd ${TMPDIR}/ && mv ${PACKAGENAME} ${PACKAGENAME}-${SVNDATE} )

tar czf ${TARBALL_UNSTRIPPED} -C ${TMPDIR} ${PACKAGENAME}-${SVNDATE}
	
( cd ${TMPDIR}/${PACKAGENAME}-${SVNDATE} && sh ${CLEANUPSCRIPT} )

tar czf ${TARBALL} -C ${TMPDIR} ${PACKAGENAME}-${SVNDATE}

# print diff
( cd ${TMPDIR} && ptardiff ${TARBALL_UNSTRIPPED} ) | tee ${TARBALL}.diff
