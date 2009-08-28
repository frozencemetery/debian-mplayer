#!/bin/sh

# This contains the dreaded DVD decryption code. We can live without it
#  by using libdvdread3 (and the optional library installed by
#    http://www.debian-unofficial.org/   :-)
rm -rfv libdvdcss

# strip/clean the code from potentially dangerous patented code
# KEEP THIS IN SYNC WITH THE ffmpeg-debian PACKAGE!
for codec in 'h263.*' 'h264.*' mpeg2video mpeg4 'msmpeg4.*'; do
    F=libavcodec/allcodecs.c
    sed -i "/REGISTER_ENCODER.*\\<$codec\\>/d" $F
    sed -i "s/REGISTER_ENCDEC\\(.*\\<$codec\\>\\)/REGISTER_DECODER\\1/" $F
    F=libavcodec/*.c
    sed -i "/AVCodec *${codec}_encoder *=/,/^[[:space:]]*}/d" $F
done
