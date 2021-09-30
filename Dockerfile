FROM pelias/libpostal_baseimage as libpostal-build

FROM perl:5.34.0 as dzil

WORKDIR /app
RUN curl -fsSL --compressed https://git.io/cpm > cpm && chmod +x cpm

RUN ./cpm install -g Dist::Zilla
COPY ./dist.ini .  
RUN dzil authordeps | ./cpm install -g -
COPY . .
RUN dzil listdeps | ./cpm install -

FROM perl:5.34.0

COPY --from=libpostal-build /usr/share/libpostal /usr/share/libpostal
COPY --from=libpostal-build /usr/local/lib/libpostal.so.1 /usr/lib/libpostal.so.1
COPY --from=libpostal-build /usr/local/lib/libpostal.so /usr/lib/libpostal.so

RUN cpanm -n Mojolicious

WORKDIR /app
COPY --from=dzil /app/local ./local
COPY . .
ENV PERL5LIB=/app/local/lib/perl5

CMD [ "hypnotoad", "app", "-f" ]
