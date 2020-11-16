FROM ubuntu:20.04 as stage

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get -y install build-essential libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev

WORKDIR /wrk2

COPY . .

RUN make

FROM ubuntu:20.04 as run

LABEL org.opencontainers.image.source https://github.com/kborovik/azure-aks-deployment

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get -y install openssl ntp

COPY  --from=stage /wrk2/wrk /bin/

CMD ["wrk"]
