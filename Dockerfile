FROM sleekybadger/libpostal:1.1-alpine as libpostal-build

FROM perl:5.34.0 as dzil

RUN cpanm -n App::cpm

RUN cpm install -g Dist::Zilla
WORKDIR /app
COPY ./dist.ini .  
RUN dzil authordeps | cpm install -g -
COPY . .
RUN dzil listdeps | cpm install -

FROM perl:5.34.0

COPY --from=libpostal-build /data /data
COPY --from=libpostal-build /usr/lib/libpostal.so /usr/lib/libpostal.so
COPY --from=libpostal-build /usr/lib/libpostal.so.1 /usr/lib/libpostal.so.1
COPY --from=libpostal-build /usr/lib/libpostal.so /usr/lib/libpostal.so
COPY --from=libpostal-build /lib/libc.musl-x86_64.so.1 /usr/lib/libc.musl-x86_64.so.1

WORKDIR /app
COPY --from=dzil /app/local ./local
COPY . .

RUN prove -Ilocal/lib/perl5 -lvj2 t/

