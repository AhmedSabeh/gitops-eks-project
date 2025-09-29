# 🚀 GitOps EKS Project with GitHub Actions, ArgoCD, and Terraform #

## Overview ##

-  This project demonstrates a GitOps workflow on AWS EKS using:

   * Terraform → Provision AWS infrastructure (EKS, nodes).

   * GitHub Actions → CI pipeline (build Java app, Docker image, push to ECR).

   * ArgoCD → CD tool (sync manifests from GitHub to Kubernetes).

---

## Architecture ##

-  Terraform provisions:

   *  EKS cluster (multi-AZ, high availability).

   *  Worker nodes in default VPC.

   *  IAM roles and Kubernetes configuration.

-  GitHub Actions Workflow automates:

   *  Checkout the repo on every push/PR to main.

   *  Set up Java (JDK 17) and build the Maven project.

   *  Upload optional artifact (JAR).

   *  Authenticate with AWS using secrets.

   *  Login to Amazon ECR.

   *  Build and push Docker image to ECR with latest tag and commit SHA tag.

   *  ArgoCD watches the repo and automatically deploys new images to the cluster.

---

## 📂 Folder Structure ##
```
gitops-eks-project/
│── terraform/              # Terraform code for EKS + infrastructure
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── argocd.tf
│   ├── eks-nodegroup.tf
│   ├── data.tf
│   ├── iam.tf
│   ├── locals.tf
│   └── eks-cluster.tf
│
│── Jenkins_App/            # Application + CI/CD config
│   ├── src/main/java/...   # Java source code
│   ├── Dockerfile          # Docker build instructions
│   ├── deployment.yaml     # Kubernetes deployment
│   └── pom.xml             # Maven build file
│
│── .github/workflows/      # GitHub Actions workflows
│   └── ci-cd-ecr.yml      # CI/CD pipeline
│
└── README.md               # Documentation
```

---

## ⚙️ Setup Instructions ##

1️⃣ Provision Infrastructure
```
cd terraform
terraform init
terraform apply -auto-approve
```
2️⃣ Configure kubectl
```
aws eks update-kubeconfig --region <your-region> --name <eks-cluster-name>
kubectl get nodes
```
3️⃣ Install ArgoCD
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

-  Expose ArgoCD (for testing):
```
kubectl port-forward svc/argocd-server -n argocd 8081:443
```
-  Open browser: https://localhost:8081

-  Login credentials:
```
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
```
4️⃣ GitHub Actions CI/CD Workflow

   *  The workflow triggers on push or pull request to main.

   *  Builds Maven project, Docker image, pushes to AWS ECR.

   *  ArgoCD detects updated manifests or images and deploys automatically.

   *  Make sure to add the following GitHub Secrets to your repo:

   *  ACCESS_KEY → AWS access key

   *  SECRET_ACCESS_KEY → AWS secret key

   *  ECR_REPOSITORY → ECR repo URI

5️⃣ Verify Deployment
```
kubectl get pods -n app
kubectl get svc -n app
```
---

## Features ##

-  Fully automated CI/CD GitOps workflow with GitHub Actions.

-  High availability via multi-AZ EKS cluster.

-  Low-cost setup using default VPC.

-  Infrastructure as Code (Terraform).

-  Continuous Deployment with ArgoCD.

## ScreenShots ##

<img width="1182" height="480" alt="Screenshot (294)" src="https://github.com/user-attachments/assets/101d3839-2b8c-40cc-a275-d2a6c046ff76" />
<img width="1182" height="481" alt="Screenshot (295)" src="https://github.com/user-attachments/assets/4421051a-44e1-47c0-a26b-5dcef15dcbd6" />
<img width="1183" height="461" alt="Screenshot (296)" src="https://github.com/user-attachments/assets/fb6ca788-d86e-4d5a-bbae-63ed2e624e6e" />

- Some informations after creating the eks cluster

---

<img width="982" height="474" alt="Screenshot (293)" src="https://github.com/user-attachments/assets/24809a8d-8d64-41fd-8f74-2bda67bc279a" />

-  Output of ```kubectl get pods -n argocd ```

---
<img width="1366" height="509" alt="Screenshot (290)" src="https://github.com/user-attachments/assets/d6d85f92-4862-42e3-a2b2-3763bf9e503d" />

-  Shows the ArgoCD dashboard with app Healthy & Synced

---
<img width="1366" height="446" alt="Screenshot (297)" src="https://github.com/user-attachments/assets/eb40673a-4ff8-48a2-acc6-79b781430370" />

-  Successful CI build and Docker image pushed to ECR
