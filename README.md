# GitOps EKS Project with Jenkins, ArgoCD, and Terraform #

## 📌 Overview ##

-  This project demonstrates a GitOps workflow on AWS EKS using:

-  Terraform → Provision AWS infrastructure (EKS, nodes).

-  Jenkins → CI pipeline (build app, build Docker image, push to registry, update manifests).

-  ArgoCD → CD tool (sync manifests from GitHub to Kubernetes).


## 🏗️ Architecture ##

-  Terraform provisions:

-  EKS cluster (multi-AZ, high availability).

-  Worker nodes in default VPC.

-  IAM roles and Kubernetes configuration.

-  Jenkins Pipeline automates:

-  Build Java app using Maven.

-  Build Docker image.

-  Push Docker image to DockerHub.

-  Update Kubernetes deployment.yaml with the new image tag.

-  Push changes back to GitHub.

-  ArgoCD watches the repo and automatically deploys new changes to the cluster.

📂 Folder Structure
```
gitops-eks-project/
│── terraform/              # Terraform code for EKS + infrastructure
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── ...
│
│── Jenkins_App/            # Application + CI/CD config
│   ├── src/main/java/...   # Java source code
│   ├── Dockerfile          # Docker build instructions
│   ├── Jenkinsfile         # Jenkins pipeline definition
│   ├── deployment.yaml     # Kubernetes deployment
│   └── pom.xml             # Maven build file
│
└── README.md               # Documentation
```
# ⚙️ Setup Instructions #
1. Provision Infrastructure
```
cd terraform
terraform init
terraform apply -auto-approve
```
2. Configure kubectl
```
aws eks update-kubeconfig --region <your-region> --name <eks-cluster-name>
kubectl get nodes
```
3. Install ArgoCD
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Expose ArgoCD:

```
kubectl port-forward svc/argocd-server -n argocd 8080:443
Login via: https://localhost:8080
```
4. Setup Jenkins Pipeline

   *  Open Jenkins UI → New Item → Pipeline.

   *  Select Pipeline script from SCM.

   *  Git Repo: ```https://github.com/AhmedSabeh/gitops-eks-project.git```

   *  Branch: main

   *  Script Path: Jenkins_App/Jenkinsfile

5. Verify GitOps Deployment

   *  ArgoCD will automatically sync changes.
```
kubectl get pods -n jenkins-app
kubectl get svc -n jenkins-app
```

# Features #

-  Fully automated CI/CD GitOps workflow.

-  High availability via multi-AZ EKS cluster.

-  Low-cost setup using default VPC.

-  Infrastructure as Code (Terraform).

-  Continuous Deployment with ArgoCD.
