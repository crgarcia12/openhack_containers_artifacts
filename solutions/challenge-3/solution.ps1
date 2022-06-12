$RESOURCE_GROUP = "teamResources-private-aks-rg"
$CLUSTER_NAME = "teamResources-private-aks"
$GROUP_OBJECT_ID = "47a12f63-81ba-45a8-9a5b-11536c050b87"
$AAD_TENANT_ID = "70cf8c0f-facf-4cc3-9177-63c03dd53c13"
$REGISTRY_NAME = "registryyib2999"
$CLUSTER_SUBNET_ID="/subscriptions/4aa8f62c-835f-416e-9170-634235763a69/resourceGroups/teamResources/providers/Microsoft.Network/virtualNetworks/vnet/subnets/aks-subnet"
$LOCATION="northeurope"

az ad group list --filter "displayname eq 'crgar-aks-admins'" -o table

# Create an AKS-managed Azure AD cluster
az group create --name $RESOURCE_GROUP --location $LOCATION

az aks create --name $CLUSTER_NAME `
              --resource-group $RESOURCE_GROUP `
              --node-count 1 `
              --location $LOCATION `
              --enable-aad `
              --network-plugin azure `
              --aad-admin-group-object-ids $GROUP_OBJECT_ID `
              --vnet-subnet-id "$CLUSTER_SUBNET_ID" `
              --zones 1 2 3 `
              --enable-managed-identity `
              --attach-acr $REGISTRY_NAME `
              --generate-ssh-keys
              # --private-dns-zone none `
              # --enable-private-cluster `

#################
# IP FILTERING
#################

$CURRENT_IP=Invoke-RestMethod http://ipinfo.io/json | Select -exp ip
az aks update `
    --resource-group $RESOURCE_GROUP `
    --name $CLUSTER_NAME `
    --api-server-authorized-ip-ranges $CURRENT_IP

# Get kubeconfig credentials
az aks get-credentials 

#################
# Permissions 
#################

$WEB_AD_USER="hacker2gjk@msftopenhack7087ops.onmicrosoft.com"
$API_AD_USER="hacker3hv7@msftopenhack7087ops.onmicrosoft.com"
$WEB_AD_GROUP_NAME="crgar-aks-web-dev"
$API_AD_GROUP_NAME="crgar-aks-api-dev"
$WEB_GROUP_ID="4f310383-7476-43f9-9774-3a095a661e13"
$API_GROUP_ID="2b8dc4f8-805c-4301-9e27-4a0f1267f92e"

$WEB_GROUP_ID = az ad group create `
    --display-name $WEB_AD_GROUP_NAME `
    --mail-nickname $WEB_AD_GROUP_NAME `
    --query objectId -o tsv

    
az ad group member add -g $WEB_AD_GROUP_NAME --member-id $WEB_AD_USER

$CLUSTER_ID=az aks show `
    -g $RESOURCE_GROUP -n $CLUSTER_NAME `
    --query id -o tsv

az role assignment create `
    --assignee $WEB_GROUP_ID `
    --role "Azure Kubernetes Service Cluster User Role" `
    --scope $CLUSTER_ID

    #api-devs
az ad group create `
    --display-name $API_AD_GROUP_NAME `
    --mail-nickname $API_AD_GROUP_NAME `
    --query objectId -o tsv

az ad group member add -g $API_AD_GROUP_NAME --member-id $API_AD_USER

az role assignment create `
    --assignee $API_GROUP_ID `
    --role "Azure Kubernetes Service Cluster User Role" `
    --scope $CLUSTER_ID

kubectl apply -f namespaces.yaml
kubectl apply -f .\rolebinding-web.yaml
kubectl apply -f .\rolebinding-api.yaml