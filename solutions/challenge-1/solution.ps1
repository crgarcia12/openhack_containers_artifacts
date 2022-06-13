$SQL_PASSWORD="Password123!"
$NETWORK = "tripinsights"
$ACR = 'registrybmg2730'
$ACR_URL = 'registrybmg2730.azurecr.io'

pushd src/poi
docker build `
    -t "tripinsights/poi:1.0" `
    .
popd

# Create a Docker network
docker network create $NETWORK
docker pull mcr.microsoft.com/mssql/server:2017-latest

docker run `
    --name sql `
    --network $NETWORK `
    -p 1433:1433 `
    -e "ACCEPT_EULA=Y" `
    -e "SA_PASSWORD=$SQL_PASSWORD" `
    -d `
    mcr.microsoft.com/mssql/server:2017-latest

docker exec `
    -it sql `
    /opt/mssql-tools/bin/sqlcmd `
    -S localhost -U SA -P $SQL_PASSWORD `
    -Q "CREATE DATABASE mydrivingDB"

# Login to Azure & to team ACR
az acr login -n $ACR

# Run dataload image
docker run `
    #--network $NETWORK `
    -e "SQLFQDN=sql" `
    -e "SQLUSER=SA" `
    -e "SQLPASS=$SQL_PASSWORD" `
    -e "SQLDB=mydrivingDB" `
    $ACR_URL/dataload:1.0

# Run POI
docker run `
    --name poi `
    #--network $NETWORK `
    -p 8080:80 `
    -e "SQL_USER=SA" `
    -e "SQL_PASSWORD=$SQL_PASSWORD" `
    -e "SQL_SERVER=sql" `
    -e "ASPNETCORE_ENVIRONMENT=Local" `
    -d `
    tripinsights/poi:1.0