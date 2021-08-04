# see https://github.com/Azure/azure-cli/blob/dev/Dockerfile
FROM mcr.microsoft.com/azure-cli

# install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN echo '\n' >> ~/.bashrc && echo 'alias k="kubectl"' >> ~/.bashrc

# install argocd cli
RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 && chmod +x /usr/local/bin/argocd
RUN echo 'alias a="argocd"' >> ~/.bashrc

# install helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
RUN chmod 700 get_helm.sh && ./get_helm.sh

RUN mkdir /workdir
WORKDIR /workdir

COPY *.yaml /workdir

CMD bash
