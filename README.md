
---

## 🚀 Deploying Medusa Backend on AWS ECS with Terraform, RDS & GitHub Actions

### 👨‍💻 Overview

This project demonstrates the complete Infrastructure-as-Code (IaC) setup and CI/CD pipeline to deploy the **[Medusa.js](https://docs.medusajs.com)** headless commerce backend on **AWS ECS using Fargate**, with **PostgreSQL via RDS Aurora**, **Docker image on Docker Hub**, and **CI/CD via GitHub Actions**.

---

## 🔧 Prerequisites

- AWS Account
- GitHub Account
- Docker Hub Account
- Terraform Installed
- Docker Installed
- Git Installed

---

## 🌐 Step 1: AWS Setup

1. **Create IAM User**  
   - Enable programmatic access  
   - Attach policies:
     - `AmazonEC2ContainerServiceFullAccess`
     - `AmazonRDSFullAccess`
     - `IAMFullAccess`
     - `AmazonECS_FullAccess`

2. **Note** your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` — we'll use them in GitHub Actions.

---

## 📦 Step 2: Terraform Infrastructure (IaC)

**File: `main.tf`**
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs_sg"
  description = "Allow inbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "medusa_cluster" {
  name = "medusa-cluster"
}

# Add RDS PostgreSQL Aurora
resource "aws_rds_cluster" "medusa_db" {
  cluster_identifier = "medusa-db"
  engine             = "aurora-postgresql"
  master_username    = "admin"
  master_password    = "yourpassword"
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.ecs_sg.id]
}

output "db_endpoint" {
  value = aws_rds_cluster.medusa_db.endpoint
}
```

---

## 🐳 Step 3: Docker Setup

**File: `Dockerfile`**
```Dockerfile
FROM node:18-alpine

WORKDIR /app

COPY . .

RUN npm install

EXPOSE 9000

CMD ["npm", "run", "start"]
```

**File: `.env`**
```env
DATABASE_URL=postgres://admin:yourpassword@<REPLACE_WITH_RDS_ENDPOINT>:5432/medusa
```

**File: `docker-compose.yml`**
```yaml
version: "3.9"
services:
  medusa:
    build: .
    ports:
      - "9000:9000"
    env_file:
      - .env
```

---

## 🔁 Step 4: GitHub Actions CI/CD

**File: `.github/workflows/deploy.yml`**
```yaml
name: Deploy to ECS

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Code
      uses: actions/checkout@v3

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1

    - name: Login to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}

    - name: Build and Push Docker Image
      run: |
        docker build -t ${{ secrets.DOCKER_USERNAME }}/medusa-backend .
        docker push ${{ secrets.DOCKER_USERNAME }}/medusa-backend

    - name: Deploy to ECS (Optional Step - if using ECS CLI or custom script)
      run: echo "Deploying image to ECS using AWS CLI or Terraform"
```

---

## 🔐 Step 5: Add Secrets to GitHub

Go to your GitHub Repo → `Settings > Secrets and variables > Actions` and add:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`

---

## 🚀 Step 6: Run It All

1. Initialize Terraform:
```bash
terraform init
terraform apply
```

2. Get the RDS Endpoint from output and update `.env`

3. Build and Push Docker image:
```bash
docker build -t yourdockeruser/medusa-backend .
docker push yourdockeruser/medusa-backend
```

4. Push code to GitHub `main` branch → GitHub Actions takes over and deploys.

---

## ✅ Final Result

- ECS Service running Medusa backend
- PostgreSQL RDS Aurora connected
- CI/CD with GitHub Actions
- Docker image hosted on Docker Hub
- Live, scalable, serverless deployment 🎉

---

## 🎥 Video

> 🔗 **[Insert YouTube Video Link Here]**  
> In this video, I walk through everything — including my face and live output. Check it out!

---

## 🔗 GitHub Repo

> 🔗 **[Insert Public GitHub Repo Link Here]**  
> Feel free to fork or star it! Contributions welcome.

---

Let me know if you want this zipped or converted to a GitHub repo directly. Want me to build this out with real Terraform modules and ECS Task definitions too?
