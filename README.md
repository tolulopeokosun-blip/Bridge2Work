Infrastructure & CI/CD Pipeline Documentation
Overview
This project provisions a production-grade AWS infrastructure with Terraform and sets up a CI/CD pipeline using GitHub Actions.

It includes:

Networking (VPC, subnets, NAT, IGW, route tables)
Compute (2 EC2 instances, 1 in each public subnet)
Databases (2 RDS PostgreSQL instances, 1 in each private subnet)
Kubernetes (2 independent EKS clusters, one per AZ/subnet)
CI/CD (Docker build & push to Docker Hub + Kubernetes deployment)
Infrastructure (Terraform)
1. Networking (main.tf)
VPC: A single VPC (10.0.0.0/16).
Subnets:
Public Subnets: 10.0.1.0/24 (AZ-a), 10.0.2.0/24 (AZ-b).
Private Subnets: 10.0.11.0/24 (AZ-a), 10.0.12.0/24 (AZ-b).
Internet Gateway (IGW): Provides internet access to public subnets.
NAT Gateways: One per AZ for outbound access from private subnets.
Route Tables: Public subnets route through IGW; private subnets route through NAT.
2. Security (security.tf)
Security groups for:
EC2 (SSH only from allowed_ssh_cidr).
RDS (only accessible from EC2 and EKS).
EKS nodes (restricted inbound, outbound to internet via NAT).
3. Compute (ec2.tf)
Two EC2 instances (t3.micro by default).
One in public subnet A and one in public subnet B.
Each instance is assigned a public IP for SSH and testing.
4. Databases (rds.tf)
Two PostgreSQL RDS instances.
Deployed into private subnets (A & B).
Not exposed to the internet (only accessible from EC2/EKS).
Separated per AZ (not Multi-AZ replication, but independent DBs).
5. Kubernetes (eks.tf)
Two independent EKS clusters:
cluster_a in private subnet A.
cluster_b in private subnet B.
Each has its own node group in its subnet.
Workloads can be deployed separately to each cluster.
6. Outputs (outputs.tf)
Terraform exports:

vpc_id
public_subnets & private_subnets
ec2_public_ips
db_endpoints
eks_cluster_a_endpoint & eks_cluster_b_endpoint
eks_cluster_a_name & eks_cluster_b_name
CI/CD Pipeline (GitHub Actions)
1. Reusable Workflow (.github/workflows/docker-build.yml)
Builds a Docker image from the repo.
Pushes to Docker Hub using DOCKER_USERNAME & DOCKER_PASSWORD secrets.
Parameters:
image_name → required (e.g., todo-api)
image_tag → optional (default: latest)
2. Main Pipeline (.github/workflows/main.yml)
Triggered on push to main branch:

Build & Push
Calls the reusable docker-build.yml workflow.
Pushes Docker image to Docker Hub.
Deploy
Uses kubectl to deploy app to EKS clusters.
Reads kubeconfig from GitHub secret KUBE_CONFIG.
Applies manifests in k8s/deployment.yml and k8s/service.yml.
Secrets Required

In GitHub repo settings → Secrets and variables → Actions:

DOCKER_USERNAME → Your Docker Hub username.
DOCKER_PASSWORD → Your Docker Hub password or access token.
KUBE_CONFIG → Base64-encoded kubeconfig file for your EKS cluster.
Usage

Provision Infrastructure
cd terraform
terraform init
terraform plan
terraform apply
Deploy Application via CI/CD
Push code to main branch.

GitHub Actions will:

Build & push Docker image.

Deploy to Kubernetes (k8s/deployment.yml, k8s/service.yml).

Access Resources
SSH to EC2:

bash
Copy code
ssh -i my-key.pem ec2-user@<EC2_PUBLIC_IP>
Connect to DB:
Use psql with RDS endpoint (from terraform output db_endpoints).

Manage Kubernetes:

bash
Copy code
aws eks update-kubeconfig --name <cluster-name> --region <region>
kubectl get nodes
kubectl get pods
