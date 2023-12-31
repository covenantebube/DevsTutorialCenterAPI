FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

 

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DevsTutorialCenterAPI.csproj", "."]
RUN dotnet restore "./DevsTutorialCenterAPI.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DevsTutorialCenterAPI.csproj" -c Release -o /app/build

 

FROM build AS publish
RUN dotnet publish "DevsTutorialCenterAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

 

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

 

CMD ASPNETCORE_URLS=http://*:$PORT dotnet DevsTutorialCenterAPI.dll
#ENTRYPOINT ["dotnet", "DevsTutorialCenterAPI.dll"]
