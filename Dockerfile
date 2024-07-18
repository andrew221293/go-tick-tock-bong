# Use the official Golang image as the base image
FROM golang:1.21.4

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy all the files from the current directory to the container
COPY . .

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod tidy

# Build the Go app
RUN go build -o app

# Command to run the executable
CMD ["./app"]
