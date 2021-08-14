FROM mcr.microsoft.com/dotnet/sdk:3.1 AS base
WORKDIR /src
COPY *.sln .
# copy and restore all projects
COPY newDockerDemo.App.App/*.csproj newDockerDemo.App/
RUN dotnet restore newDockerDemo.App.App/*.csproj
COPY newDockerDemo.App.Test/*.csproj newDockerDemo.Test/
RUN dotnet restore newDockerDemo.Test/*.csproj
# Copy everything else
COPY . .
#Testing
FROM base AS testing
WORKDIR /src/newDockerDemo
RUN dotnet build
#WORKDIR /src/DemoHerokuApp.Demo.Test
WORKDIR /src/newDockerDemo.Test
RUN dotnet test

#Publishing
FROM base AS publish
WORKDIR /src/newDockerDemo
RUN dotnet publish -c Release -o /src/publish
#Get the runtime into a folder called app
FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=publish /src/publish .
#ENTRYPOINT ["dotnet", "newHerokuDemo.Demo.dll"]
CMD ASPNETCORE_URLS=http://*:$PORT dotnet newDockerDemo.App.dll
    
    
 