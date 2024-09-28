resource "kubernetes_namespace" "cert_manager" {
  depends_on = [var.mod_dependency]
  count      = (var.enabled && var.create_namespace && var.namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.namespace
  }
}

module "cert_manager_label" {
  # The label module makes it easy to name things consistently.
  source    = "git::https://github.com/cloudposse/terraform-null-label.git"
  namespace = var.null_resource_namespace
  name      = var.name
  stage     = var.stage
}

resource "helm_release" "cert_manager" {
  name       = module.cert_manager_label.id
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.14.4"
  namespace  = var.kubernetes_namespace
  values = [<<EOF
global.priorityClassName: ${var.priority_class_name}
global.podSecurityPolicy.enabled: true
installCRDs: true
EOF
  ]
}


locals {
  issuer_self_signed = <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-issuer
  namespace: ${var.kubernetes_namespace}
  labels:
    app.kubernetes.io/name: cert-manager
    app.kubernetes.io/part-of: public-ingress
    app.kubernetes.io/component: self-signed
    app.kubernetes.io/managed-by: terraform
spec:
  selfSigned: {}
EOF

  issuer_letsencrypt_staging = <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging-issuer
  namespace: ${var.kubernetes_namespace}
  labels:
    app.kubernetes.io/name: cert-manager
    app.kubernetes.io/part-of: public-ingress
    app.kubernetes.io/component: letsencrypt
    app.kubernetes.io/managed-by: terraform
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: ${var.Hostmaster}
    privateKeySecretRef:
      name: letsencrypt-staging
    solvers:
    - http01:
        ingress:
          class: ${var.ingress_class}
EOF

  issuer_letsencrypt_prod = <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: ${var.kubernetes_namespace}
  labels:
    app.kubernetes.io/name: cert-manager
    app.kubernetes.io/part-of: public-ingress
    app.kubernetes.io/component: letsencrypt
    app.kubernetes.io/managed-by: terraform
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ${var.Hostmaster}
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: ${var.ingress_class}
EOF
}

resource "kubectl_manifest" "cluster-issuer" {
  depends_on = [helm_release.cert_manager]
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ${var.Hostmaster}
    privateKeySecretRef:
      name: letsencrypt-key
    solvers:
    - http01:
        ingress:
          class: nginx
YAML
}

resource "kubectl_manifest" "cluster-issuer-staging" {
  depends_on = [helm_release.cert_manager]
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: ${var.Hostmaster}
    privateKeySecretRef:
      name: letsencrypt-staging-key
    solvers:
    - http01:
        ingress:
          class: nginx
YAML
}
