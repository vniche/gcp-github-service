FROM gcr.io/distroless/static-debian12:nonroot-amd64

COPY gcp-github-service /

CMD ["/gcp-github-service"]