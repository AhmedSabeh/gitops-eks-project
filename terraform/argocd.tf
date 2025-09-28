# Create namespace for ArgoCD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }

  depends_on = [aws_eks_node_group.nodes]
}

# Install ArgoCD using Helm with simpler configuration
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.46.8"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  
  # Wait for namespace to be created
  depends_on = [kubernetes_namespace.argocd]

  # Set simpler values for the Helm chart
  set {
    name  = "server.service.type"
    value = "ClusterIP"  # Use ClusterIP and we'll port-forward
  }

  set {
    name  = "server.extraArgs"
    value = "{--insecure}"
  }

  set {
    name  = "controller.args.appResyncPeriod"
    value = "30"
  }

  # Add a timeout to wait longer for installation
  timeout = 600
}

# Wait for ArgoCD pods to be ready
resource "null_resource" "wait_for_argocd" {
  depends_on = [helm_release.argocd]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for ArgoCD pods to be ready..."
      timeout 300 bash -c 'until kubectl get pods -n argocd 2>/dev/null | grep -q "Running"; do sleep 5; done'
      echo "ArgoCD pods are ready!"
    EOT
  }
}

# Get the ArgoCD admin password
data "kubernetes_secret" "argocd_admin" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }

  depends_on = [null_resource.wait_for_argocd]
}

# Output ArgoCD access information
output "argocd_info" {
  description = "ArgoCD access information"
  value = <<EOT
ArgoCD has been installed successfully!

To access ArgoCD UI:
1. Port-forward to access the UI:
   kubectl port-forward svc/argocd-server -n argocd 8080:80

2. Open browser to: http://localhost:8080
   Username: admin
   Password: ${try(nonsensitive(data.kubernetes_secret.argocd_admin.data.password), "Run 'kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d; echo' to get the password")}

Alternatively, you can use the CLI:
   kubectl port-forward svc/argocd-server -n argocd 8080:80 &
   argocd login localhost:8080 --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
EOT

  depends_on = [null_resource.wait_for_argocd]
}
