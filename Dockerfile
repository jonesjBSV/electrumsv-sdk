FROM python:3.10

WORKDIR .
# Install ASP.NET Core 3.1 - https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get install -y apt-transport-https && apt-get update && apt-get install -y dotnet-sdk-3.1
RUN dotnet tool install --global dotnet-ef
ENV PATH="${PATH}:/root/.dotnet/tools"

RUN apt-get update && apt-get install net-tools

# Allow sudo commands and make noninteractive
RUN apt-get update
RUN apt-get -y install sudo
RUN echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
RUN sudo apt-get install -y -q

# Node.js
RUN apt-get -y install curl dirmngr apt-transport-https lsb-release ca-certificates
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt-get -yq install build-essential nodejs

# Install SDK
RUN git clone https://github.com/electrumsv/electrumsv-sdk /electrumsv-sdk
WORKDIR /electrumsv-sdk


RUN pip install -e .
RUN electrumsv-sdk install node
RUN electrumsv-sdk install electrumx
RUN electrumsv-sdk install --branch=master electrumsv
RUN electrumsv-sdk install whatsonchain
RUN electrumsv-sdk install simple_indexer
