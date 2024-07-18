# go-tick-tock-bong

## Description

This is an example Go application that prints "tick" every second, "tock" every minute, and "bong" every hour. The application can be deployed on a Kubernetes cluster using Terraform for infrastructure configuration.

## Project Structure

- `.github/workflows/deploy.yml`: GitHub Actions CI/CD configuration.
- `k8s/`: Kubernetes configuration files.
    - `deployment.yaml`: Kubernetes Deployment configuration.
    - `service.yaml`: Kubernetes Service configuration.
- `terraform/`: Terraform configuration files.
    - `main.tf`: Main resource definitions.
    - `variables.tf`: Variables used in Terraform.
    - `outputs.tf`: Outputs from the resources created.
    - `provider.tf`: Terraform provider configuration (AWS).
- `main.go`: Go application source code.
- `go.mod`: Go module dependencies.
- `go.sum`: Go module checksums.
- `Dockerfile`: Dockerfile to build the Go application image.
- `README.md`: Project documentation.

## Instructions

### Build and Run Locally

1. Clone the repository:
   ```sh
   git clone git@github.com:andrew221293/go-tick-tock-bong.git
   cd go-tick-tock-bong
   
2. Clone the repository:
   ```sh
   docker build -t andres221293/go-tick-tock-bong .

3. Run the Docker container:
   ```sh
   docker run -it andres221293/go-tick-tock-bong

### Deploy to Kubernetes
1. Apply the Kubernetes configuration files:
    ```sh
    kubectl apply -f k8s/deployment.yaml
    kubectl apply -f k8s/service.yaml
   
### Deploy to AWS using Terraform
1. Initialize and apply Terraform:
    ```sh
    cd terraform
    terraform init
    terraform apply
   
### CI/CD with GitHub Actions
1. Configure the following secrets in your GitHub repository:
    - `AWS_ACCESS_KEY_ID`: AWS Access Key ID.
    - `AWS_SECRET_ACCESS_KEY`: AWS Secret Access Key.
    - `DOCKER_USERNAME`: Docker Hub username. 
    - `DOCKER_PASSWORD`: Docker Hub password.
2. Any changes pushed to the main branch will trigger the CI/CD pipeline in GitHub Actions to build and deploy the application automatically.