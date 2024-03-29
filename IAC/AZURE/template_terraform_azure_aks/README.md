This is an example template for creating an AKS environment with the AZURE provider in Terraform.

## Download the Terraform template

```bash
git clone https://github.com/smashse/iac-public.git
cd iac-public/IAC/AZURE/template_terraform_azure_aks/
```

Or to download "README.md" and "template_terraform_azure_aks":

```bash
git init iac-public
cd iac-public
git remote add iac-public https://github.com/smashse/iac-public.git
git fetch iac-public
git checkout iac-public/master -- IAC/AZURE/template_terraform_azure_aks
```

```bash
cd IAC/AZURE/template_terraform_azure_aks/
```

```bash
sed -i "s/template/desiredname/g" *.*
sed -i "s/Template/DesiredName/g" *.*
```

## Configure Terraform environment

```bash
cd /tmp
curl "https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip" -o "terraform.zip"
sudo unzip terraform.zip -d /usr/local/bin/
terraform -install-autocomplete
```

OR

```bash
cd /tmp
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update --fix-missing
sudo apt -y install terraform
terraform -install-autocomplete
```

**Notes:** This document has few modifications to the original document provided by Hashicorp in "Provision an AKS Cluster (AZURE)"

<https://learn.hashicorp.com/tutorials/terraform/aks?in=terraform/kubernetes>

# Learn Terraform - Provision AKS Cluster

This repo is a companion repo to the [Provision an AKS Cluster learn guide](https://learn.hashicorp.com/terraform/kubernetes/provision-aks-cluster), containing
Terraform configuration files to provision an AKS cluster on
Azure.

After installing the Azure CLI and logging in. Create an Active Directory service
principal account.

```bash
$ az ad sp create-for-rbac --skip-assignment
{
  "appId": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
  "displayName": "azure-cli-2019-04-11-00-46-05",
  "name": "http://azure-cli-2019-04-11-00-46-05",
  "password": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
  "tenant": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
}
```

Then, replace `terraform.tfvars` values with your `appId` and `password`.
Terraform will use these values to provision resources on Azure.

After you've done this, initalize your Terraform workspace, which will download
the provider and initialize it with the values provided in the `terraform.tfvars` file.

```bash
$ terraform init

Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "azurerm" (1.27.0)...

Terraform has been successfully initialized!
```

Then, provision your AKS cluster by running `terraform apply`. This will
take approximately 10 minutes.

```bash
$ terraform apply

# Output truncated...

Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

# Output truncated...

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

kubernetes_cluster_name = light-eagle-aks
resource_group_name = light-eagle-rg
```

## Configure kubectl

To configure kubetcl run the following command:

```bash
$ az aks get-credentials --resource-group light-eagle-rg --name light-eagle-aks;
```

The
[resource group name](https://github.com/hashicorp/learn-terraform-provision-aks-cluster/blob/master/aks-cluster.tf#L16)
and [AKS name](https://github.com/hashicorp/learn-terraform-provision-aks-cluster/blob/master/aks-cluster.tf#L25)
correspond to the output variables showed after the successful Terraform run.

You can view these outputs again by running:

```bash
$ terraform output
```

## Configure Kubernetes Dashboard

To use the Kubernetes dashboard, we need to create a `ClusterRoleBinding`. This
gives the `cluster-admin` permission to access the `kubernetes-dashboard`.

```bash
$ kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
```

Finally, to access the Kubernetes dashboard, run the following command:

```bash
$ az aks browse --resource-group light-eagle-rg --name light-eagle-aks
Merged "light-eagle-aks" as current context in /var/folders/s6/m22_k3p11z104k2vx1jkqr2c0000gp/T/tmpcrh3pjs_
Proxy running on http://127.0.0.1:8001/
Press CTRL+C to close the tunnel...
```

You should be able to access the Kubernetes dashboard at <http://127.0.0.1:8001/>.
