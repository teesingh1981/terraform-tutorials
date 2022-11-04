### Azure Terraform Linux VM Creation 

Reference Azure Documentation: https://docs.microsoft.com/en-us/azure/developer/terraform/create-linux-virtual-machine-with-infrastructure

# Pre-Requisite 

# Terraform installed 

# 01 - CLONE THE CODE LOCALLY 
# 02 - terraform init
# 03 - terraform plan -out main.tfplan
# 04 - terraform apply main.tfplan

# After the terraform script has completed, run the following command to create & save the output to a key.pem file

terraform output -raw tls_private_key

# How to connect to the Linux VM 

chmod 400 azureuser.pem

ssh -i azureuser.pem azureuser@<public_ip_address>
