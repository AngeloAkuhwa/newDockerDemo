FROM mcr.microsoft.com/dotnet/sdk:3.1 AS base
WORKDIR /src
COPY *.sln .
# copy and restore all projects
COPY NewDockerDemo.App/*.csproj NewDockerDemo.App/
RUN dotnet restore NewDockerDemo.App/*.csproj
COPY NewDockerDemo.Test/*.csproj NewDockerDemo.Test/
RUN dotnet restore NewDockerDemo.Test/*.csproj
# Copy everything else
COPY . .
#Testing
FROM base AS testing
WORKDIR /src/NewDockerDemo.App
RUN dotnet build
#WORKDIR /src/DemoHerokuApp.Test
WORKDIR /src/NewDockerDemo.Test
RUN dotnet test

#Publishing
FROM base AS publish
WORKDIR /src/NewDockerDemo.App
RUN dotnet publish -c Release -o /src/publish
#Get the runtime into a folder called app
FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=publish /src/publish .
#ENTRYPOINT ["dotnet", "newHerokuDemo.Demo.dll"]
CMD ASPNETCORE_URLS=http://*:$PORT dotnet newDockerDemo.App.dll
    
    
 