# Challenge 1
1. Place dockerfiles
1. Build Poi
1. Run the data loader:

```
 docker run -p 7777:80 -e SQL_SERVER=sqlserveryib2999.database.windows.net -e SQL_USER=sqladminyIb2999 -e SQL_PASSWORD=sqladminyIb2999 -e SQLDB=mydrivingDB poi

 curl localhost:7777/api/poi
```

# Challenge 2
1. Create AKS
1. push all containers to ACR
1. Create deployment files and deploy
1. check all pods

curl 20.23.118.171/api/poi/healthcheck
curl 20.23.118.171/api/poi/healthcheck

# Challenge 3

```
az ad group list --filter "displayname eq 'crgar-aks-admins'" -o table

# Create an AKS-managed Azure AD cluster
az group create --name teamResources-private-aks-rg --location westeurope

az aks create --name teamResources-private-aks `
              --resource-group teamResources-private-aks-rg `
              --location northeurope `
              --enable-aad `
              --aad-admin-group-object-ids 47a12f63-81ba-45a8-9a5b-11536c050b87 `
              --aad-tenant-id 70cf8c0f-facf-4cc3-9177-63c03dd53c13 `
              --vnet-subnet-id "/subscriptions/4aa8f62c-835f-416e-9170-634235763a69/resourceGroups/teamResources/providers/Microsoft.Network/virtualNetworks/vnet/subnets/aks-subnet" `
              --zones 1 2 3 `
              --
              # --enable-private-cluster `
              --enable-managed-identity `
              --private-dns-zone none `
              --attach-acr registryyib2999


az aks get-credentials --name teamResources-private-aks `
                       --resource-group teamResources-private-aks-rg `
                       --admin

```