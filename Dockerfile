FROM alpine:3.6
LABEL maintainer "steve"

#ENV FFMPEG_VERSION=3.4.4
ENV FFMPEG_VERSION=4.1

WORKDIR /tmp/ffmpeg

RUN apk add --update --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
  build-base curl nasm tar bzip2 coreutils imagemagick libaom libass \
#  ffmpeg ffmpeg-dev ffmpeg-libs \
  zlib-dev yasm-dev lame-dev x264 x264-dev x265 x265-dev freetype-dev libass-dev rtmpdump-dev 

RUN DIR=$(mktemp -d) && cd ${DIR} && \
  curl -s http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | tar zxvf - -C . && \
  cd ffmpeg-${FFMPEG_VERSION} && \
  #--enable-gpl --enable-version3 --enable-nonfree --enable-libmp3lame --enable-libx264 --enable-libx265 --enable-postproc --enable-avresample --enable-libfreetype --disable-debug --enable-librtmp  && \
  #--enable-gpl --enable-version3 --enable-nonfree --enable-postproc --enable-libaacplus --enable-libfaac --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-openssl --enable-libopus --enable-libschroedinger --enable-libspeex --enable-libtheora --enable-libvo-aacenc --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libxvid --enable-librtmp
 ./configure \
  --pkg-config-flags="--static" \
  --enable-gpl \
  --enable-libaom \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree && \
  make -j4 && \
  make install && \
  make distclean && \
  
#  rm -rf ${DIR} && \
apk del build-base tar bzip2 openssl nasm && rm -rf /var/cache/apk/*
  
RUN apk add --update --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted apk-tools git librtmp \
autoconf automake libmicrohttpd libmicrohttpd-dev x264-libs x265 gcc build-base libjpeg-turbo-dev libjpeg-turbo libjpeg libvorbis curl libcurl pcre2 \
libacl lz4-libs xz-libs libarchive ncurses-libs readline bash libltdl libtool libjpeg-turbo libjpeg sdl2 libxau libbsd libxdmcp libxcb libx11 alsa-lib expat libpng \
bash gnutls-dev libssh2 libmagic gnutls-dev libxext libxfixes libpciaccess libdrm libva libvdpau libvorbis libvpx tzdata libjpeg-turbo-utils 

RUN apk add --update --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
libjpeg-turbo-dev libjpeg-turbo apk-tools git librtmp libjpeg-turbo-dev libjpeg-turbo libjpeg libvorbis curl libcurl pcre2 \
perl autoconf automake pkgconf libmicrohttpd libmicrohttpd-dev x264-libs x265 gcc build-base ncurses-terminfo-base ncurses-terminfo \
expat libpng libacl lz4-libs xz-libs libarchive ncurses-libs readline bash libltdl libtool libjpeg-turbo libjpeg \
xvidcore libjpeg-turbo-dev ca-certificates nghttp2-libs libssh2 libcurl pcre2 make libattr musl musl-utils \
gcc libmagic file musl-dev libc-dev g++ fortify-headers build-base libvdpau freetype fontconfig fribidi libass tzdata 

RUN apk add --update --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
musl busybox alpine-base alpine-keys ssl_client \
zlib apk-tools scanelf musl-utils libc-utils m4 libbz2 perl autoconf automake pkgconf ncurses-terminfo-base ncurses-terminfo \
ncurses-libs readline bash libltdl libtool libjpeg-turbo libjpeg sdl2 libxau libbsd libxdmcp libxcb libx11 alsa-lib expat libpng \
freetype fontconfig fribidi libass gmp nettle libffi p11-kit libtasn1 libunistring gnutls lame opus librtmp libogg \
libxext libxfixes libpciaccess libdrm libva libvdpau libvorbis libvpx x264-libs libgcc libstdc++ x265 \
xvidcore  libjpeg-turbo-dev ca-certificates nghttp2-libs libssh2 libcurl pcre2 make libattr \
libacl lz4-libs xz-libs libarchive libuv cmake binutils isl libgomp libatomic mpfr3 mpc1 \
gcc libmagic file musl-dev libc-dev g++ fortify-headers build-base libmicrohttpd gnutls-c++ libgmpxx gmp-dev nettle-dev \
libtasn1-dev p11-kit-dev gnutls-dev libmicrohttpd-dev 

#RUN apk add --update --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
#ffmpeg-libs ffmpeg-dev ffmpeg

#RUN git clone --single-branch -b 4.1 https://github.com/Motion-Project/motion.git  && \
RUN git clone https://github.com/Motion-Project/motion.git  && \
#RUN git clone --branch release-4.1 https://github.com/Motion-Project/motion.git && \
   cd motion  && \
   cd .. && \
   cd motion  && \
   autoreconf -fiv && \
   ./configure && \
   make && \
   make install && \
   cd .. && \
   rm -fr motion && \
   apk del build-base openssl nasm && rm -rf /var/cache/apk/*

CMD [ "motion", "-n" ]
