# ---- Build Stage ----
FROM golang:1.18 AS build-stage

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# ---- Run Stage ----
FROM alpine:latest

WORKDIR /app

# Copy the Pre-built binary file from the previous stage. Observe we are using --from to specify the build stage container.
COPY --from=build-stage /app/main .

# Expose port (if necessary)
EXPOSE 2112

# Command to run the executable
ENTRYPOINT ["./main"]