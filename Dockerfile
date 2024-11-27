# Build Golang binary
FROM golang:1.20.2 AS build-golang

WORKDIR .

COPY . .
RUN go get -v && go build -v -o /usr/local/bin/backend

EXPOSE 8080
CMD ["backend"]
