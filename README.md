# ce-aks-cli

Defines a docker image with a couple of CLI-tools to access an AKS cluster.
At this moment the azure cli (az) cannot be installed on a standard Acerta laptop.
Also, when dealing with multiple clusters and/or azure/aks-accounts at the same time, it is often safer/handier to run the CLI in a separate container so that the 'standard' .kube/config (with most probably a specual okteto-user/account) on the laptop is preserved.

https://argoproj.github.io/argo-cd/getting_started/

## Run AZ cli on Acerta Laptop

The following build and then pushes to DockerHub (docker.io). Of course, you should use your own DockerHub account (or don't push).

```bash
docker build -t cbonami/ce-aks-cli .
docker tag cbonami/ce-aks-cli cbonami/ce-aks-cli:v1
docker tag cbonami/ce-aks-cli cbonami/ce-aks-cli:latest
docker push cbonami/ce-aks-cli:v1
docker push cbonami/ce-aks-cli:latest
```
The run it:
```bash
docker run -it cbonami/ce-aks-cli
```

Go to azure portal (https://portal.azure.com) and retrieve AKS connect info from the right AKS-cluster. 
Click on the right cluster and in the 'Overview'-tab, you click 'Connect'.

Inside container:

```bash
# login to your azure account
az login

# see Overview tab of AKS cluster (Connect-button)
az account set --subscription 1824decd-b137-4338-897f-e349d0c52e81
az aks get-credentials --resource-group rg-ace-devtst-okteto --name aks-ace-devtst-okteto

# install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```