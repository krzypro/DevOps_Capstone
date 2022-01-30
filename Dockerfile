# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /App
COPY testapp/bin/Release/net6.0/publish/ /App/
ENTRYPOINT ["dotnet", "testapp.dll"]