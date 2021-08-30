### Azure Create Service Principal Account 

# Login to Azure & find the Azure Subscription ID

az login --use-device-code 

az account list --query [*].[name,id]

# Create Service Principal with the contributor role

$subscriptionId = 'xxxx-xxxxx-xxxxx' # set this to the subscription ID

$sp = az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$subscriptionId" -n sp_terrform_test | ConvertFrom-Json

# Make a note of the "appId" & "password" as Terraform will require these values with the Azure Subscription ID & Azure AD tenant 

# To delete the Service Principal account 

$spId = ((az ad sp list --all | ConvertFrom-Json) | Where-Object { '<http://sp_terraform_test>' -in $_.serviceprincipalnames }).objectId

az ad sp delete --id $spId