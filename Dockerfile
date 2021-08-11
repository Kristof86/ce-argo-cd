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
RUN echo 'alias h="helm"' >> ~/.bashrc

# install kubeseal
RUN curl -Lo /usr/local/bin/kubeseal https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.16.0/kubeseal-linux-amd64 && chmod +x /usr/local/bin/kubeseal

# install krew
RUN set -x; cd "$(mktemp -d)" && \
  OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" && \
  tar zxvf krew.tar.gz && \
  KREW=./krew-"${OS}_${ARCH}" && \
  "$KREW" install krew
RUN echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> ~/.bashrc

# install kubectx and kubens
RUN kubectl krew install ctx && kubectl krew install ns

RUN pip install kube-shell

RUN apk add nano

RUN mkdir /workdir
WORKDIR /workdir

COPY *.yaml /workdir

CMD bash
