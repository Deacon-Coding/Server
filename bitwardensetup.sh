# Create database
# pwsh migrate.ps1

#Build and Run Server
cd src/Identity
dotnet restore
dotnet run
# http://localhost:33656/.well-known/openid-configuration

cd src/Api
dotnet restore
dotnet run
# http://localhost:4000/alive

