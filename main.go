package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

func readSecret(secretPath string) (string, error) {
	secret, err := os.ReadFile(secretPath)
	if err != nil {
		return "", fmt.Errorf("failed to read secret: %w", err)
	}

	return string(secret), nil
}

func getRoot(w http.ResponseWriter, r *http.Request) {
	secret, err := readSecret(os.Getenv("SECRET_PATH"))
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		io.WriteString(w, fmt.Sprintf("{\"message\":\"%s\"}", err.Error()))
		return
	}

	w.WriteHeader(http.StatusOK)
	io.WriteString(w, fmt.Sprintf("secret: %s", secret))
}

func main() {
	http.HandleFunc("/", getRoot)

	if err := http.ListenAndServe(":3333", nil); err != nil {
		log.Panicf("http server failed: %+v", err)
	}
}
