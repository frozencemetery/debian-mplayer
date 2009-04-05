#!/bin/sh

# This contains the dreaded DVD decryption code. We can live without it
#  by using libdvdread3 (and the optional library installed by
#    http://www.debian-unofficial.org/   :-)
rm -rfv libdvdcss

# Do not support encoding in any way.
rm -fv mencoder.c

