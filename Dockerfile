FROM golang:1.12.9-alpine3.10 as build
ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOPROXY=https://proxy.golang.org
WORKDIR /golang
RUN apk add --update --no-cache git
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .
RUN go build -a -tags netgo -ldflags '-w' -o app .

FROM alpine:3.10
LABEL MAINTAINER=1997jirasak@gmail.com
ENV TZ=Asia/Bangkok
WORKDIR /go
RUN apk add --update --no-cache tzdata ca-certificates
COPY --from=build /golang/app .
ENTRYPOINT [ "./app" ]
