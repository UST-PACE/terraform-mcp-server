FROM golang:1.24.4-alpine AS builder
WORKDIR /app
RUN apk add --no-cache ca-certificates
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o terraform-mcp-server ./cmd/terraform-mcp-server

FROM scratch
WORKDIR /server
COPY --from=builder /app/terraform-mcp-server .
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
CMD ["bin/terraform-mcp-server"]