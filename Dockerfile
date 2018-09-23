FROM alpine:3.6
LABEL maintainer "steve"

ENV FFMPEG_VERSION=4.0.2

WORKDIR /tmp/ffmpeg

RUN apk add --update --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
  build-base curl nasm tar bzip2 coreutils \
  zlib-dev yasm-dev lame-dev libogg-dev x264-dev libvpx-dev libvorbis-dev x265-dev freetype-dev libass-dev libwebp-dev rtmpdump-dev libtheora-dev opus-dev && \

  DIR=$(mktemp -d) && cd ${DIR} && \

  curl -s http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | tar zxvf - -C . && \
  cd ffmpeg-${FFMPEG_VERSION} && \
  ./configure \
  --enable-gpl --enable-nonfree --enable-libmp3lame --enable-libx264 --enable-libx265 --enable-libvpx --enable-libtheora --enable-libvorbis --enable-libopus --enable-libass --enable-libwebp --enable-postproc --enable-avresample --enable-libfreetype --disable-debug && \
  make && \
  make install && \
  make distclean && \

  rm -rf ${DIR} && \
  apk del build-base curl tar bzip2 x264 openssl nasm && rm -rf /var/cache/apk/*
  
#RUN apk add --update --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
#libjpeg-turbo-dev libjpeg-turbo apk-tools git librtmp libjpeg-turbo-dev libjpeg-turbo libjpeg libvorbis curl libcurl pcre2 \
#perl autoconf automake pkgconf libmicrohttpd libmicrohttpd-dev x264-libs x265 gcc build-base ncurses-terminfo-base ncurses-terminfo \
#expat libpng libacl lz4-libs xz-libs libarchive ncurses-libs readline bash libltdl libtool libjpeg-turbo libjpeg 

RUN apk add --update --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted apk-tools git librtmp \
autoconf automake libmicrohttpd libmicrohttpd-dev x264-libs x265 gcc build-base libjpeg-turbo-dev libjpeg-turbo libjpeg libvorbis curl libcurl pcre2 \
libacl lz4-libs xz-libs libarchive ncurses-libs readline bash libltdl libtool libjpeg-turbo libjpeg sdl2 libxau libbsd libxdmcp libxcb libx11 alsa-lib expat libpng \
bash gnutls-dev libssh2 libmagic gnutls-dev libxext libxfixes libpciaccess libdrm libva libvdpau libvorbis libvpx tzdata libjpeg-turbo-utils

#musl busybox alpine-base layout alpine-keys libressl2.7-libcrypto libressl2.7-libssl libressl2.7-libtls ssl_client \
#zlib apk-tools scanelf musl-utils libc-utils m4 libbz2 perl autoconf automake pkgconf ncurses-terminfo-base ncurses-terminfo \
#ncurses-libs readline bash libltdl libtool libjpeg-turbo libjpeg sdl2 libxau libbsd libxdmcp libxcb libx11 alsa-lib expat libpng \
#freetype fontconfig fribidi libass gmp nettle libffi p11-kit libtasn1 libunistring gnutls lame opus librtmp libogg \
#libxext libxfixes libpciaccess libdrm libva libvdpau libvorbis libvpx x264-libs libgcc libstdc++ x265 \
#xvidcore ffmpeg-libs ffmpeg-dev libjpeg-turbo-dev ca-certificates nghttp2-libs libssh2 libcurl pcre2 make libattr \
#libacl lz4-libs xz-libs libarchive rhash-libs libuv cmake cmake-bash-completion binutils isl libgomp libatomic mpfr3 mpc1 \
#gcc libmagic file musl-dev libc-dev g++ fortify-headers build-base libmicrohttpd gnutls-c++ libgmpxx gmp-dev nettle-dev \
#libtasn1-dev p11-kit-dev gnutls-dev libmicrohttpd-dev && \
RUN git clone --single-branch -b 4.1 https://github.com/Motion-Project/motion.git  && \
   cd motion && \
   git reset --hard ccbe2f59272b029b49a106224e8bde7114da0814 && \
   autoreconf -fiv && \
   ./configure && \
   make && \
   make install && \
   cd .. && \
   rm -fr motion && \
   apk del build-base tar bzip2 openssl nasm && rm -rf /var/cache/apk/*

CMD [ "motion", "-n" ]
