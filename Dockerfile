FROM alpine:3.6
LABEL maintainer "steve"

RUN apk add --update --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted apk-tools git \
autoconf automake libmicrohttpd-dev x265 gcc build-base && \

#musl busybox alpine-base layout alpine-keys libressl2.7-libcrypto libressl2.7-libssl libressl2.7-libtls ssl_client \
#zlib apk-tools scanelf musl-utils libc-utils m4 libbz2 perl autoconf automake pkgconf ncurses-terminfo-base ncurses-terminfo \
#ncurses-libs readline bash libltdl libtool libjpeg-turbo libjpeg sdl2 libxau libbsd libxdmcp libxcb libx11 alsa-lib expat libpng \
#freetype fontconfig fribidi libass gmp nettle libffi p11-kit libtasn1 libunistring gnutls lame opus librtmp libogg \
#libxext libxfixes libpciaccess libdrm libva libvdpau libvorbis libvpx x264-libs libgcc libstdc++ x265 \
#xvidcore ffmpeg-libs ffmpeg-dev libjpeg-turbo-dev ca-certificates nghttp2-libs libssh2 libcurl pcre2 make libattr \
#libacl lz4-libs xz-libs libarchive rhash-libs libuv cmake cmake-bash-completion binutils isl libgomp libatomic mpfr3 mpc1 \
#gcc libmagic file musl-dev libc-dev g++ fortify-headers build-base libmicrohttpd gnutls-c++ libgmpxx gmp-dev nettle-dev \
#libtasn1-dev p11-kit-dev gnutls-dev libmicrohttpd-dev && \
   git clone https://github.com/Motion-Project/motion.git  && \
   cd motion && \
   autoreconf -fiv && \
   ./configure && \
   make && \
   make install && \
   cd .. && \
   rm -fr motion 

# 20 camera feeds max (by default Motion will use port 8080 and +1 for each camera feed)
EXPOSE 8888

CMD [ "motion", "-n" ]
