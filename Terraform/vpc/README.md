## VPC - Production


Terraform AWS VPC Infrastructure
📌 Overview

This project provisions a highly available AWS VPC infrastructure using Terraform.
It creates a production-ready network setup including:

VPC

Internet Gateway

Public and Private Subnets across multiple AZs

Elastic IPs

NAT Gateways

Public and Private Route Tables with associations

Common tagging strategy

The setup is designed for production (prod) environment and follows AWS best practices.

🏗️ Architecture Components
Network Resources

VPC

Internet Gateway

Public Subnets (one per AZ)

Private Subnets (one per AZ)

Elastic IPs (for NAT Gateways)

NAT Gateways (one per public subnet)

Routing

Public Route Table

Routes traffic to Internet Gateway

Private Route Tables

Routes outbound traffic via NAT Gateway

Subnet Route Table Associations

🧱 Infrastructure Diagram (Logical)
VPC
├── Internet Gateway
├── Public Subnets (AZ1, AZ2, ...)
│   ├── NAT Gateway
│   └── Route Table → IGW
└── Private Subnets (AZ1, AZ2, ...)
    └── Route Table → NAT Gateway

🏷️ Tagging Strategy

All resources are tagged using a common tagging convention:

managed_by = "terraform"
project    = "otel"


Each resource also includes a meaningful Name tag with environment suffix:

<resource>-prod-<index>

⚙️ Local Values
locals {
  env = "prod"

  common_tags = {
    managed_by = "terraform"
    project    = "otel"
  }
}


env controls environment naming

common_tags ensures consistent tagging across all resources

📥 Input Variables
Variable Name	Description	Type
vpc_cidr	CIDR block for the VPC	string
public_subnet_cidr	List of CIDRs for public subnets	list(string)
private_subnet_cidr	List of CIDRs for private subnets	list(string)
avz	Availability Zones list	list(string)
Example terraform.tfvars
vpc_cidr = "10.0.0.0/16"

public_subnet_cidr = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidr = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

avz = [
  "us-east-1a",
  "us-east-1b"
]

🚀 How to Deploy
1️⃣ Initialize Terraform
terraform init

2️⃣ Validate Configuration
terraform validate

3️⃣ Preview Changes
terraform plan

4️⃣ Apply Infrastructure
terraform apply

🧹 Cleanup

To destroy all created resources:

terraform destroy

✅ Key Features

Multi-AZ architecture

Separate public and private networking

Secure outbound internet access via NAT Gateway

Scalable and reusable Terraform code

Production-ready tagging and naming conventions

📌 Notes

Ensure AWS credentials are configured before running Terraform.

NAT Gateway incurs cost — use carefully in non-production environments.

Number of public subnets, private subnets, and AZs must match.

👨‍💻 Author

Managed and maintained using Terraform
Project: otel
