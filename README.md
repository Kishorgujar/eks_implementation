# EKS Cluster Setup with Terraform

This repository contains a Terraform script designed to create an Amazon EKS (Elastic Kubernetes Service) cluster. The configuration is modular, flexible, and optimized for AWS best practices. This setup is intended to simplify the creation and management of EKS clusters in the AWS environment.

## Features

- **Amazon EKS Cluster**: Provisions an EKS cluster with customizable parameters for production-ready deployments.
- **Add-ons**: Includes configurations for essential EKS add-ons such as `vpc-cni`, `coredns`, `kube-proxy`.
- **IAM Roles**: Automatically creates and attaches IAM roles necessary for the add-ons, allowing fine-grained access control.
- **Modular Design**: Organized into modules for EKS, VPC, and IAM roles to promote reusability and clarity.
- **AWS Account ID and Other Variables**: Configured to retrieve the AWS account ID, AMI Type through variables, making the setup adaptable across different accounts and environments.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0.0
- [AWS CLI](https://aws.amazon.com/cli/) for local testing and authentication
- AWS Account with permissions to create IAM roles, EKS, and associated resources
- Basic understanding of EKS and Terraform

 ## Getting Started

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Kishorgujar/EKS_Terraform
   cd EKS_Terraform 

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan**:
   - Review the execution plan:
     ```bash
     terraform plan
     ```
 4. **Configure Variables**:
   - Update `terraform.tfvars` with your preferred configuration, `AWS_ACCOUNT_ID`, 'AMI_Type'
  
 5. **Apply**:
   - Deploy the resources:
     ```bash
     terraform apply
     ```

5. **Access the EKS Cluster**:
   - Configure `kubectl` to use your new cluster:
     ```bash
     aws eks update-kubeconfig --name <eks-cluster-name> --region <region>
     ```

## Customization

- **EKS Add-ons**: You can enable or disable add-ons such as `vpc-cni`, `coredns`, `kube-proxy`.
- **Security Groups and IAM Roles**: Modify or extend these configurations by adjusting the relevant Terraform module configurations.
  
## File Structure
![Screenshot (23)](https://github.com/user-attachments/assets/b47dbeac-4bf8-49f2-94bd-680d9979c8c5)


