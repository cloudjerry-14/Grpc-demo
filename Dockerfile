FROM golang:1.16-alpine AS builder

WORKDIR /app

# Copy the Go source code
COPY *.go ./

# Initialize the module (if go.mod doesn't exist)
RUN go mod init myapp

# Add any external dependencies your code needs (if any)
# RUN go get github.com/some/dependency

# Build the application
RUN go build -o /app/myapp

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/myapp /app/myapp

EXPOSE 8080 50051

CMD ["/app/myapp"]
