package main

import (
    "fmt"
    "log"
    "net"
    "net/http"

    "google.golang.org/grpc"
    "google.golang.org/grpc/health"
    "google.golang.org/grpc/health/grpc_health_v1"
)

func main() {
    // Start HTTP server
    go func() {
        http.HandleFunc("/", handleHTTP)
        http.HandleFunc("/health", handleHTTPHealth)
        log.Println("Starting HTTP server on :8080")
        log.Fatal(http.ListenAndServe(":8080", nil))
    }()

    // Start gRPC server
    lis, err := net.Listen("tcp", ":50051")
    if err != nil {
        log.Fatalf("Failed to listen: %v", err)
    }
    s := grpc.NewServer()
    grpc_health_v1.RegisterHealthServer(s, health.NewServer())
    log.Println("Starting gRPC server on :50051")
    log.Fatal(s.Serve(lis))
}

func handleHTTP(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello from HTTP!")
}

func handleHTTPHealth(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    fmt.Fprintf(w, "OK")
}
