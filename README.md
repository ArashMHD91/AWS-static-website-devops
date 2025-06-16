# 🚀 AWS Static Website Deployment with GitHub Actions + Fargate + ECR

This repository demonstrates a complete CI/CD pipeline that deploys a **static website** using **Docker**, **AWS Fargate**, **ECR**, and **GitHub Actions**. It provisions infrastructure using **Terraform** and makes the site publicly accessible through an **Application Load Balancer** (ALB).

---

## 📌 Features

* Static website hosted with **Nginx**
* Dockerized and stored in **Amazon ECR**
* Serverless deployment with **AWS Fargate (ECS)**
* Load-balanced public access using **ALB**
* CI/CD pipeline built with **GitHub Actions**
* Infrastructure as Code using **Terraform**

---

## 🛍️ Architecture Overview

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│             │     │             │     │             │     │             │
│   GitHub    │────▶│   GitHub    │────▶│   AWS ECR  │────▶│ AWS Fargate │
│ Repository  │     │   Actions   │     │             │     │   (ECS)     │
│             │     │             │     │             │     │             │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
                                                                    │
                                                                    ▼
                                                            ┌─────────────┐
                                                            │     ALB     │
                                                            │ (Public IP) │
                                                            └─────────────┘
```

---

## 🧰 Prerequisites

* GitHub account
* AWS account (Free Tier works)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
* [Terraform](https://www.terraform.io/downloads)
* [Docker](https://docs.docker.com/get-docker/)
* Basic knowledge of Git, Docker, AWS, and CI/CD

---

## 📁 Project Structure

```
.
├── index.html              # Static website content
├── Dockerfile              # Docker configuration
├── .github/workflows/      # GitHub Actions pipeline
│   └── deploy.yml
├── terraform/              # Infrastructure as Code
│   └── main.tf
└── .gitignore
```

---

## ⚙️ Setup Instructions

### 1. Clone & Initialize

```bash
git clone https://github.com/YOUR_USERNAME/AWS-static-website-devops.git
cd AWS-static-website-devops
```

### 2. Create GitHub Secrets

In your GitHub repo, go to:
**Settings > Secrets and variables > Actions**, then add:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

### 3. Provision Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

⚠️ Note the Terraform outputs:

* **ECR repository URL**
* **Load Balancer DNS Name**

### 4. Push Initial Docker Image to ECR

```bash
# Login to ECR
aws ecr get-login-password --region us-east-1 | \
docker login --username AWS --password-stdin <your-ecr-repo-url>

# Build and push
docker build -t static-website-fargate .
docker tag static-website-fargate:latest <your-ecr-repo-url>:latest
docker push <your-ecr-repo-url>:latest
```

### 5. Deploy via GitHub Actions

Commit and push changes to trigger the pipeline:

```bash
git add .
git commit -m "Deploy static site via Fargate"
git push origin main
```

GitHub Actions will:

* Build the Docker image
* Push it to ECR
* Update the ECS Task
* Redeploy your Fargate service

---

## 🌐 Access the Website

Once deployed, your static site will be live at the **Load Balancer URL** from the Terraform output:

```
http://<load-balancer-dns-name>
```

---

## 🧪 Troubleshooting

* **ECS task not found**: Push initial image to ECR before running pipeline
* **ALB health check failing**: Ensure Nginx is serving on port 80
* **Permission errors**: Confirm AWS credentials in GitHub Secrets

Useful AWS CLI commands:

```bash
# ECS service status
aws ecs describe-services \
  --cluster static-website-fargate-cluster \
  --services static-website-fargate-service

# Logs
aws logs describe-log-groups --log-group-name-prefix "/ecs/static-website-fargate"

# Force new deployment
aws ecs update-service \
  --cluster static-website-fargate-cluster \
  --service static-website-fargate-service \
  --force-new-deployment
```

---

## 💸 Cost Optimization Tips

* Use **Fargate Spot** for cheaper compute
* Enable **ECR Lifecycle Policies** to auto-delete old images
* Set **CloudWatch log retention** to a low value (e.g., 7 days)
* Consider switching to a **Network Load Balancer** if HTTP features aren’t needed

---

## 🧹 Cleanup Resources

To avoid AWS charges:

```bash
cd terraform
terraform destroy -auto-approve
```

---

## ✅ Benefits

* **Serverless** container deployment
* **Fully automated** CI/CD pipeline
* **Highly available** architecture
* **No EC2** to manage or patch
* Easy to **extend or scale**

---

## 🙌 Contributing

Feel free to fork this repo, open issues, or submit pull requests to improve this guide.

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---
