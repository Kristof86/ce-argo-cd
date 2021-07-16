# see https://github.com/Azure/azure-cli/blob/dev/Dockerfile
FROM mcr.microsoft.com/azure-cli

# install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN alias k="kubectl"

RUN mkdir /workdir
WORKDIR /workdir

CMD bash
