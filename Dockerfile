FROM golang:buster as cmd-builder

ENV GO111MODULE=on

WORKDIR /overlord
ADD . /overlord/
RUN cd /overlord && go install ./cmd/...


FROM node as web-builder

WORKDIR /web
ADD ./web /web
RUN cd /web && npm install && npm run build


FROM nginx:stable

WORKDIR /app

COPY --from=cmd-builder /go/bin/* /usr/local/bin/
COPY --from=web-builder /web/dist/ /app/web/

COPY web/nginx.conf /etc/nginx/nginx.conf
