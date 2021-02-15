#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat 

FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8
#ARG source
#WORKDIR /inetpub/wwwroot
#COPY ${source:-obj/Docker/publish} .
#FROM mcr.microsoft.com/dotnet/framework/sdk:4.8
#WORKDIR "/app"

#COPY . .

#COPY Test4.5App/bin/app.publish/* ./
#RUN ls
#ENTRYPOINT ["Test4.5App.dll"]

FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY Test4.5App/*.csproj ./Test4.5App/
COPY Test4.5App/*.config ./Test4.5App/
RUN nuget restore

# copy everything else and build app
COPY Test4.5App/. ./Test4.5App/
WORKDIR /app/Test4.5App
RUN msbuild /p:Configuration=Release


# copy build artifacts into runtime image
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8
WORKDIR /inetpub/wwwroot
COPY --chown=1000 --from=build ./app/Test4.5App/. ./