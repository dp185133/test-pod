#!/usr/bin/env -S docker build  --platform linux/i386 . --tag=alp386

FROM alpine:3.17

RUN addgroup -S pcrfuel \
    && adduser -S pcrfuel -G pcrfuel \
    && chown pcrfuel:pcrfuel /home/pcrfuel

run locale-en gen_us.utf-8
env lang en_us.utf-8

user pcrfuel

WORKDIR /home/pcrfuel

CMD ["/bin/sh"]

