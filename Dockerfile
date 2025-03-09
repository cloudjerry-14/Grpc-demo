FROM golang:1.21-alpine AS builder

WORKDIR /app

# Add build tools
RUN apk add --no-cache git

# Copy the Go source code
COPY *.go ./

# Initialize the module (if go.mod doesn't exist)
RUN go mod init myapp

# Add gRPC dependencies with specific versions
RUN go get google.golang.org/grpc@v1.59.0
RUN go get google.golang.org/grpc/health@v1.59.0
RUN go get google.golang.org/grpc/health/grpc_health_v1@v1.59.0

# Ensure dependencies are properly vendored
RUN go mod tidy
RUN go mod vendor

# Build the application
RUN go build -o /app/myapp

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/myapp /app/myapp

EXPOSE 8080 50051

CMD ["/app/myapp"]
