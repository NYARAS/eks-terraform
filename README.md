# Google Kubernetes Engine (GKE)

This repo contains [Terraform](https://www.terraform.io) configs for running a Kubernetes cluster on [Amazon Web Services (AWS)](https://aws.amazon.com/)
using [Amazon Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/).

## Usage

Check this medium for detailed explanation on how to use this configuration

### Environment Variables
These Environment Variables are needed for the pipeline when runnig Terraform commands.

  * `AWS_DEFAULT_REGION` - AWS region to create the resources
  * `AWS_ACCESS_KEY_ID` - Access Key ID to be used by the pipeline to authenticate with your AWS Account
  * `AWS_SECRET_ACCESS_KEY` - Secret Access Key to be used by the pipeline to authenticate with your AWS Account
