FROM golang:1.22 AS builder

RUN apt-get -qq update

ENV GOOS=linux
ENV GOARCH=amd64
ENV GO111MODULE=on 
ENV CGO_ENABLED=0 

WORKDIR /src

COPY . .
RUN go build \
  -a \
  -trimpath \
  -ldflags "-s -w -extldflags '-static'" \
  -tags 'osusergo netgo static_build' \
  -o /bin/vault-init \
  .

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /bin/vault-init /bin/vault-init
CMD ["/bin/vault-init"]
