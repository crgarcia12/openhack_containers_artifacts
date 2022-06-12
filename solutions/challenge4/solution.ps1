$RESOURCE_GROUP = "teamResources-private-aks-rg"
$CLUSTER_NAME = "teamResources-private-aks"
$GROUP_OBJECT_ID = "47a12f63-81ba-45a8-9a5b-11536c050b87"
$AAD_TENANT_ID = "70cf8c0f-facf-4cc3-9177-63c03dd53c13"
$REGISTRY_NAME = "registryyib2999"
$CLUSTER_SUBNET_ID="/subscriptions/4aa8f62c-835f-416e-9170-634235763a69/resourceGroups/teamResources/providers/Microsoft.Network/virtualNetworks/vnet/subnets/aks-subnet"
$LOCATION="northeurope"




$NAMESPACE="ingress"

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
    --create-namespace --namespace $NAMESPACE \
    -f nginx-helm-values.yaml



kubectl apply -f yaml