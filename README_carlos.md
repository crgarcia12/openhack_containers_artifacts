# Challenge 1
1. Place dockerfiles
1. Build Poi
1. Run the data loader:

```
 docker run -p 7777:80 -e SQL_SERVER=sqlserveryib2999.database.windows.net -e SQL_USER=sqladminyIb2999 -e SQL_PASSWORD=sqladminyIb2999 -e SQLDB=mydrivingDB poi

 curl localhost:7777/api/poi
```

Challenge 2
1. Create AKS
1. push all containers to ACR
1. Create deployment files and deploy
1. check all pods

curl 20.23.118.171/api/poi/healthcheck
curl 20.23.118.171/api/poi/healthcheck