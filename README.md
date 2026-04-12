
# Overview:
 This repository contains the Terraform (IaC) configuration files used to provision the foundational Azure infrastructure required for the EpicBook application deployment. 
This repo is structured to provision: 
- A dedicated Azure Resource Group. 
- Virtual Network and Subnets. 
- Azure Compute instances (Ubuntu VMs) for both Frontend and Backend services.
- Azure Database for MySQL (PaaS). 
The deployment is fully automated via an Azure DevOps YAML pipeline (`azure-pipelines.yaml`) triggered on changes to the `main` branch within the `terraform/` subdirectory. 

*Please take note that this is just one of the 2 repositories required for the complete deployment of the Epicbook application. We are making use of the poly-repo approach*
## Repository  Folder Structure
```text
terraform/
├── modules/
│ ├── compute/
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ ├── database/
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ └── network/
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
├── .gitignore
├── azure-pipelines.yaml
├── main.tf
├── outputs.tf
├── provider.tf
├── README.md
├── terraform.tfvars
└── variables.tf

```
 
 ## Requirements & Prerequisites 
### 1. Azure Setup:
Before running the pipeline, ensure you have: 
- An active Azure Subscription.
- A Service Principal (SPN) with Contributor access to the target subscription/resource group.
### 2. Azure DevOps Pipelines Configuration:
The azure-pipelines.yaml requires specific configuration in your Azure DevOps project settings: 
#### Service Connection:
Establish an Azure Resource Manager Service Connection named epicbook-azure-connection. 
Ensure it uses the Service Principal created in step 1.
Also, create an SSH service connection that ensures your self-hosted agent connects securely to the VM. 
Critical: Check the "Grant access permission to all pipelines" box.*
 
#### Secure Files
Generate an SSH Keypair. Upload both the public key (id_rsa.pub) and the private key (id_rsa) to the Libraries > Secure Files section of your pipeline.
- Terraform uses the public key for VM creation. 
- The Application pipeline uses the private key for deployment access. 
#### Agent Pool 
The pipeline is configured to use a self-hosted agent named epicbook-agent-pool. Ensure your agent is configured and online. Also ensure that the agent has Terraform and Azure CLI installed; otherwise, the pipeline would not work and throw you an error `command not found` when the pipeline starts.
### 3. Terraform Backend State 
The pipeline is configured for a remote backend. This helps Terraform remember its state. If we do not configure a remote backend, then  `terraform apply` would fail each time because it would have created some resources in the Azure management console and still believes it has not because it has no recorded memory of ever creating the infrastructure. It has to have a way to track it, hence, the backend configuration.

These storage resources must be pre-provisioned in Azure: 
- Resource Group Name: e.g., tfstate-rg 
- Storage Account Name: e.g., epictfstate2600 (Must be unique) 
- Container Name: tfstate 
*If you change these, you must update the backend configuration inside the AzureCLI@2 task in azure-pipelines.yaml.*
## How to use 
#### Continuous Integration 
Any commit pushed to the main branch inside the terraform/ directory will automatically trigger the azure-pipelines.yaml, executing a Terraform plan followed by an automated Terraform apply.

Once the pipeline runs, it then outputs the hostname of the database as well as the pipeline public IP. This is what we have configured, and this output would be used as a manual handoff to the Application aspect of deployment with Ansible.
The repo: [Epicbook Application](https://github.com/Thormie-Harshey/app-epicbook.git)