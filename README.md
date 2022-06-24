# Amazon Elastic Kubernetes Service (EKS)

This repo contains [Terraform](https://www.terraform.io) configs for running a Kubernetes cluster on [Amazon Web Services (AWS)](https://aws.amazon.com/)
using [Amazon Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/).

## Usage

Check this 
[DevOps Automation with Terraform, AWS and Docker)](https://calvineotieno010.medium.com/devops-automation-with-terraform-aws-and-docker-build-production-grade-eks-cluster-with-ec8fbfa269c9)
for detailed explanation.

### Environment Variables
These Environment Variables are needed for the pipeline when runnig Terraform commands.

  * `AWS_DEFAULT_REGION` - AWS region to create the resources
  * `AWS_ACCESS_KEY_ID` - Access Key ID to be used by the pipeline to authenticate with your AWS Account
  * `AWS_SECRET_ACCESS_KEY` - Secret Access Key to be used by the pipeline to authenticate with your AWS Account
