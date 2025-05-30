`markdown
# Medusa Backend on AWS ECS

This repository contains the source and infrastructure setup to deploy the **Medusa.js** headless commerce backend on **AWS ECS Fargate** with a PostgreSQL database on **AWS RDS**. The app is containerized with Docker and automated deployment is configured via GitHub Actions.

---

## Table of Contents

- [Getting Started Locally](#getting-started-locally)  
- [Environment Variables](#environment-variables)  
- [Docker](#docker)  
- [Deploying to AWS ECS](#deploying-to-aws-ecs)  
- [Common Issues & Troubleshooting](#common-issues--troubleshooting)  
- [Useful Commands](#useful-commands)  

---

## Getting Started Locally

1. **Clone the repo**

bash
git clone https://github.com/tom-lars/medusa-ecs.git
cd medusa-ecs
`

2. **Install dependencies**

Make sure you have Node.js installed (recommended v18+).

bash
npm install


3. **Set up environment variables**

Copy the example env file:

bash
cp .env.example .env


Update `.env` with your local or remote PostgreSQL connection string and other secrets.

4. **Run migrations**

bash
npx medusa db:migrate


5. **Start development server**

bash
npm run start


The backend will run on `http://localhost:9000`

---

## Environment Variables

At minimum, configure:

env
DATABASE_URL=postgres://username:password@host:5432/medusa
JWT_SECRET=<your-secure-random-string>
REDIS_URL=redis://localhost:6379


Adjust for your database, Redis, and secrets.

---

## Docker

A Dockerfile is provided to build the Medusa backend image.

To build and run locally:

bash
docker build -t medusa-backend .
docker run -p 9000:9000 --env-file .env medusa-backend


Alternatively, use `docker-compose.yml` (if provided):

bash
docker-compose up


---

## Deploying to AWS ECS

* Infrastructure (VPC, ECS Cluster, RDS) is managed with Terraform scripts in `/terraform`.

* GitHub Actions workflow automates:

  * Docker image build & push to Docker Hub
  * Deployment updates to ECS service

* Ensure your GitHub secrets contain:

  * `AWS_ACCESS_KEY_ID`
  * `AWS_SECRET_ACCESS_KEY`
  * `DOCKER_USERNAME`
  * `DOCKER_PASSWORD`

* Terraform outputs provide RDS endpoints — update your `.env` with the correct `DATABASE_URL`.

---

## Common Issues & Troubleshooting

* **Health checks failing on ECS tasks**
  Verify your ECS task container listens on the same port as your ALB target group health check path & port (usually port 9000 and `/`).

* **Database connection errors**
  Make sure your RDS security groups allow inbound traffic from your ECS subnets. Check username/password and `DATABASE_URL`.

* **Missing JWT\_SECRET**
  Medusa requires a JWT secret for authentication — generate one securely.

* **Redis connection errors**
  If using Redis, ensure it's running and accessible from your app (update `REDIS_URL`).

* **Task keeps restarting**
  Check ECS task logs (CloudWatch) for runtime errors or missing dependencies.

---

## Useful Commands

* Run local Medusa server:

  bash
  npm run start
  

* Run migrations:

  bash
  npx medusa db:migrate
  

* Build Docker image:

  bash
  docker build -t medusa-backend .
  

* Run Docker container locally:

  bash
  docker run -p 9000:9000 --env-file .env medusa-backend
  

---

