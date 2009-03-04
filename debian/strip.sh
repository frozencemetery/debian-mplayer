#!/bin/sh

# This contains the dreaded DVD decryption code. We can live without it
#  by using libdvdread3 (and the optional library installed by
#    http://www.debian-unofficial.org/   :-)
rm -rfv libdvdcss

# Well this may seem a bit excessive... But this code is not useful
#  for building the package, and most of it does not correctly state
#  author-license-copyright:  So I throw out the baby and the bath...
# When and if someone needs this stuff, I will carefully scrutinize
#  it and add what is suitable.
rm -rf TOOLS

#Check if upstream includes DOCS and then don't rebuild them.
if [ -r DOCS/HTML ]; then touch DOCS/.upstream_ships_docs; fi

# Do not support encoding in any way.
rm -fv mencoder.c

