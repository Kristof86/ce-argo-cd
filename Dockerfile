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
RUN export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH" && kubectl krew install ctx && kubectl krew install ns

RUN pip install kube-shell

RUN apk add nano tar wget

# install JDK 11
RUN apk --no-cache add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

## install Maven
ENV MAVEN_VERSION 3.8.1
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $MAVEN_HOME/bin:$PATH

RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

# install telepresence (https://www.getambassador.io/docs/telepresence/latest/reference/inside-container/)
#RUN apk add --no-cache curl iproute2 sshfs && curl -fL https://app.getambassador.io/download/tel2/linux/amd64/latest/telepresence -o telepresence && \
#   install -o root -g root -m 0755 telepresence /usr/local/bin/telepresence

# install ms sql tools
#RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.8.1.1-1_amd64.apk && \
#    curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.8.1.1-1_amd64.apk && \
#    echo y | apk add --allow-untrusted msodbcsql17_17.8.1.1-1_amd64.apk mssql-tools_17.8.1.1-1_amd64.apk
#ENV PATH=$PATH:/opt/mssql-tools/bin

RUN mkdir /workdir
WORKDIR /workdir

COPY *.yaml /workdir

CMD bash
