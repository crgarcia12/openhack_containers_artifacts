$RESOURCE_GROUP = "teamResources-private-aks-rg"
$CLUSTER_NAME = "teamResources-private-aks"
$GROUP_OBJECT_ID = "47a12f63-81ba-45a8-9a5b-11536c050b87"
$AAD_TENANT_ID = "70cf8c0f-facf-4cc3-9177-63c03dd53c13"
$REGISTRY_NAME = "registryyib2999"
$CLUSTER_SUBNET_ID="/subscriptions/4aa8f62c-835f-416e-9170-634235763a69/resourceGroups/teamResources/providers/Microsoft.Network/virtualNetworks/vnet/subnets/aks-subnet"
$LOCATION="northeurope"



######
# ingress
######
$NAMESPACE="ingress"

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx `
    --create-namespace `
    --namespace $NAMESPACE `
    -f ingress/nginx-helm-values.yaml

kubectl apply -f ingress/api-ingress.yaml
kubectl apply -f ingress/web-ingress.yaml

kubectl delete -f ../challenge-3/yaml
kubectl apply -f yaml


######
# KeyVault
######
$KEYVAULT_NAME="teamResources-private-kv"

az aks enable-addons `
    -g $RESOURCE_GROUP `
    -n $CLUSTER_NAME `
    --addons azure-keyvault-secrets-provider



$SECRETS_PROVIDER_IDENTITY= az aks show `
    -g $RESOURCE_GROUP `
    -n $CLUSTER_NAME `
    --query "addonProfiles.azureKeyvaultSecretsProvider.identity.clientId" `
    -o tsv


az keyvault create -n $KEYVAULT_NAME -g $RESOURCE_GROUP

$SQL_PASSWORD = "wV8hp3Ti7"
$SQL_SERVER = "sqlserveryib2999.database.windows.net"
$SQL_USER = "sqladminyIb2999"

az keyvault secret set --vault-name $KEYVAULT_NAME -n SQLSERVER --value "$SQL_SERVER"
az keyvault secret set --vault-name $KEYVAULT_NAME -n SQLUSER --value "$SQL_USER"
az keyvault secret set --vault-name $KEYVAULT_NAME -n SQLPASSWORD --value "$SQL_PASSWORD"

# Allow Secrets Provider id to get secrets
az keyvault set-policy -n $KEYVAULT_NAME --secret-permissions get --spn $SECRETS_PROVIDER_IDENTITY

k delete -f ..\challenge-3\yaml\secrets.yaml
k apply -f secrets.yaml
