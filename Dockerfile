FROM golang:1.21 as builder

WORKDIR /app
COPY . .

# Download dependencies and build the application
RUN go mod tidy && go build -o app

# Create a minimal final image
FROM gcr.io/distroless/base-debian10

WORKDIR /app
COPY --from=builder /app/app /app/

EXPOSE 8080 50001

CMD ["/app/app"]
