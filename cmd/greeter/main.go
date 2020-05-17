package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

func handleRequest(rw http.ResponseWriter, r *http.Request) {
	rw.Header().Set("Content-Type", "application/json")
	rw.WriteHeader(http.StatusOK)
	if _, err := rw.Write([]byte(`{"message":"Hello, World!"}`)); err != nil {
		log.Printf("failed to write to response writer: %s\n", err)
		rw.WriteHeader(500)
		return
	}
}

func logRequest(next http.Handler) http.Handler {
	fn := func(w http.ResponseWriter, r *http.Request) {
		log.Printf("[request] host=%s url=%s\n", r.Host, r.URL)
		next.ServeHTTP(w, r)
	}

	return http.HandlerFunc(fn)
}

func main() {
	fmt.Println("started")
	m := mux.NewRouter()

	m.PathPrefix("/").Handler(http.HandlerFunc(handleRequest))
	m.Use(mux.MiddlewareFunc(logRequest))
	log.Fatal(http.ListenAndServe(":8080", m))
}
