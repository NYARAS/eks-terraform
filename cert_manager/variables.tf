
variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled."
}

variable "service_account_name" {
  type        = string
  default     = "cert-manager"
  description = "External Secrets service account name"
}

variable "helm_chart_name" {
  type        = string
  default     = "cert-manager"
  description = "Cert Manager Helm chart name to be installed"
}

variable "helm_chart_release_name" {
  type        = string
  default     = "cert-manager"
  description = "Helm release name"
}

variable "helm_chart_version" {
  type        = string
  default     = "1.14.4"
  description = "Cert Manager Helm chart version."
}

variable "helm_chart_repo" {
  type        = string
  default     = "https://charts.jetstack.io"
  description = "Cert Manager repository name."
}

variable "install_CRDs" {
  type        = bool
  default     = true
  description = "To automatically install and manage the CRDs as part of your Helm release."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create Kubernetes namespace with name defined by `namespace`."
}

variable "namespace" {
  type        = string
  default     = "cert-manager"
  description = "Kubernetes namespace to deploy Cert Manager Helm chart."
}

variable "mod_dependency" {
  default     = null
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable."
}

variable "settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values."
}

variable "Hostmaster" {
  type = string
}


variable "email" {
  description = "The email address for lets encrypt"
  type        = string
}

variable "chart_version" {
  description = "The chart version of cert manager. See https://cert-manager.io/docs/installation/kubernetes/#installing-with-helm for examples"
  type        = string
  default     = "v1.6.1"
}

variable "kubernetes_namespace" {
  description = "The name of the namespace to insert the chart into"
  type        = string
  default     = "cert-manager"
}

variable "name" {
  description = "The name of this deployment"
  type        = string
  default     = "cert-manager"
}

variable "null_resource_namespace" {
  description = "Namespace of the cluster"
  type        = string
  default     = null
}

variable "stage" {
  description = "Stage of the cluster (dev, prod)"
  type        = string
  default     = null
}

variable "priority_class_name" {
  description = "Priority class for cert manager pods"
  type        = string
  default     = ""
}

variable "ingress_class" {
  description = "Ingress class to use for cert manager"
  type        = string
  default     = "nginx"
}

