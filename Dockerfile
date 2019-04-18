FROM alpine:3.9 AS run-env

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ca-certificates


FROM golang:1.12-alpine AS build-env

RUN apk update && \
    apk upgrade && \
    apk add git

WORKDIR /src

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ./out/web


FROM run-env

WORKDIR /app

COPY --from=build-env /src/out/web ./

EXPOSE 8080

ENTRYPOINT ["./web"]
