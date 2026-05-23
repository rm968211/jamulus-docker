FROM alpine:3.23.4 AS builder
ARG releaseversion=r3_12_1

RUN \
 echo "**** updating system packages ****" && \
 apk update

RUN \
 echo "**** install build packages ****" && \
   apk add --no-cache --virtual .build-dependencies \
        build-base \
        wget \
        qt5-qtbase-dev \
        qt5-qttools-dev \
        qtchooser

WORKDIR /tmp
RUN \
 echo "**** getting source code ****" && \
   wget "https://github.com/jamulussoftware/jamulus/archive/refs/tags/${releaseversion}.tar.gz" -O jamulus-${releaseversion}.tar.gz && \
   tar xzf jamulus-${releaseversion}.tar.gz && \
   mv jamulus-${releaseversion} jamulus

# Github directory format for tar.gz export
WORKDIR /tmp/jamulus
RUN \
 echo "**** compiling source code ****" && \
   qmake "CONFIG+=nosound headless" Jamulus.pro && \
   make clean && \
   make && \
   cp Jamulus /usr/local/bin/ && \
   rm -rf /tmp/* && \
   apk del .build-dependencies

FROM alpine:3.23.4

RUN apk add --update --no-cache \
    qt5-qtbase icu-libs tzdata && \
    adduser -D -u 1000 jamulus

COPY --from=builder /usr/local/bin/Jamulus /usr/local/bin/Jamulus

USER jamulus

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD pgrep Jamulus || exit 1

ENTRYPOINT ["Jamulus", "--server", "--nogui"]
