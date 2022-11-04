### Azure Terraform Resource Group 

### Ref: https://docs.microsoft.com/en-us/azure/developer/terraform/create-resource-group?tabs=azure-cli
### Ref: https://docs.microsoft.com/en-us/azure/developer/terraform/ 
### Ref: https://docs.microsoft.com/en-us/azure/developer/terraform/best-practices-integration-testing

### Commands to run ### 

# 1 #  terraform init
# 2 # terraform plan -out main.tfplan
# 3 # terraform apply main.tfplan

### Clean Up 

# 1 # terraform plan -destroy -out main.destroy.tfplan
# 2 # terraform apply main.destroy.tfplan