# ce-aks-cli

Defines a docker image with a couple of CLI-tools to access an AKS cluster.

https://argoproj.github.io/argo-cd/getting_started/

## Run AZ cli on Acerta Laptop

```bash
docker run -it mcr.microsoft.com/azure-cli
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