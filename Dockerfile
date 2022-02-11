# syntax=docker/dockerfile:1
_FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /App
COPY testapp/bin/Release/net6.0/publish/ /App/
EXPOSE 80
ENTRYPOINT ["dotnet", "testapp.dll"]