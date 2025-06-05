locals {
  tags = {
    Environment = var.env
    Project     = "eks"
    Managed     = "true"
    ManagedBy   = "Terraform"
  }
}
