This is an example template for creating an environment with the GCP provider in Terraform.

## Download the Terraform template

```bash
git clone https://github.com/smashse/iac-public.git
cd iac-public/IAC/GCP/template_terraform_gcp/
```

Or to download "README.md" and "template_terraform_gcp":

```bash
git init iac-public
cd iac-public
git remote add iac-public https://github.com/smashse/iac-public.git
git fetch iac-public
git checkout iac-public/master -- IAC/GCP/template_terraform_gcp
git checkout iac-public/master -- GCP/README.md
```

**Note:** If you want to change the name given to VPC, and other items, execute the command below in the template folder.

```bash
sed -i "s/template/desiredname/g" *.*
```

## Configure Terraform environment

```bash
curl "https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip" -o "terraform.zip"
sudo unzip terraform.zip -d /usr/local/bin/
```

## Install Google Cloud SDK

```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
```

OR

```bash
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get install apt-transport-https ca-certificates gnupg
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-sdk
```

OR

```bash
sudo apt install google-cloud-sdk
```

## Configure environment

### Authorize gcloud to access the Cloud Platform with Google user credentials

```bash
gcloud auth login
```

### List organizations accessible by the active account

```bash
gcloud organizations list
```

### List billing account ID

```bash
gcloud beta billing accounts list
```

### Edit the variables with the values obtained in the previous commands

```bash
export TF_VAR_org_id="YOUR_ORG_ID"
export TF_VAR_billing_account="YOUR_BILLING_ACCOUNT_ID"
export TF_NAME="template"
export TF_PROJECT="${TF_NAME}-terraform-project"
export TF_CREDS=~/.config/gcloud/${TF_NAME}-account.json
```

**Note:** Change "template" in the variable "TF_NAME" to the name that will be used in your project

### Create the Terraform Project

```bash
gcloud projects create ${TF_PROJECT} --name=${TF_PROJECT} --set-as-default

gcloud beta billing projects link ${TF_PROJECT} --billing-account ${TF_VAR_billing_account}
```

### Create the Terraform service account

```bash
gcloud iam service-accounts create terraform --display-name "Terraform Admin Account"

gcloud iam service-accounts keys create ${TF_CREDS} --iam-account terraform@${TF_PROJECT}.iam.gserviceaccount.com
```

### Grant the service account permission

```bash
gcloud projects add-iam-policy-binding ${TF_PROJECT} --member serviceAccount:terraform@${TF_PROJECT}.iam.gserviceaccount.com --role roles/viewer

gcloud projects add-iam-policy-binding ${TF_PROJECT} --member serviceAccount:terraform@${TF_PROJECT}.iam.gserviceaccount.com --role roles/compute.admin

gcloud projects add-iam-policy-binding ${TF_PROJECT} --member serviceAccount:terraform@${TF_PROJECT}.iam.gserviceaccount.com --role roles/storage.admin

gcloud projects add-iam-policy-binding ${TF_PROJECT} --member serviceAccount:terraform@${TF_PROJECT}.iam.gserviceaccount.com --role roles/iam.serviceAccountAdmin

gcloud projects add-iam-policy-binding ${TF_PROJECT} --member serviceAccount:terraform@${TF_PROJECT}.iam.gserviceaccount.com --role roles/iam.serviceAccountKeyAdmin
```

### Enable API Services

```bash
gcloud services enable cloudresourcemanager.googleapis.com

gcloud services enable cloudbilling.googleapis.com

gcloud services enable iam.googleapis.com

gcloud services enable compute.googleapis.com

gcloud services enable serviceusage.googleapis.com
```

### Create a basic Terraform custom role (OPTIONAL)

```bash
gcloud projects list

gcloud config set project ${TF_PROJECT}

gcloud services list --available

gcloud projects list
```

```bash
nano -c Terraform.yaml
```

```yaml
title: "Terraform"
description: "Terraform"
includedPermissions:
- compute.disks.create
- compute.disks.createSnapshot
- compute.disks.delete
- compute.disks.get
- compute.disks.list
- compute.disks.setLabels
- compute.instances.attachDisk
- compute.instances.create
- compute.instances.delete
- compute.instances.detachDisk
- compute.instances.get
- compute.instances.getEffectiveFirewalls
- compute.instances.getGuestAttributes
- compute.instances.getIamPolicy
- compute.instances.getScreenshot
- compute.instances.getSerialPortOutput
- compute.instances.list
- compute.instances.listReferrers
- compute.instances.setMetadata
- compute.networks.access
- compute.networks.addPeering
- compute.networks.create
- compute.networks.delete
- compute.networks.get
- compute.networks.list
- compute.networks.use
- compute.networks.useExternalIp
- compute.subnetworks.create
- compute.subnetworks.delete
- compute.subnetworks.get
- compute.subnetworks.list
- compute.subnetworks.use
- compute.subnetworks.useExternalIp
- iam.serviceAccountKeys.create
- iam.serviceAccountKeys.delete
- iam.serviceAccountKeys.get
- iam.serviceAccounts.create
- iam.serviceAccounts.delete
- iam.serviceAccounts.get
```

```bash
gcloud iam roles create "Terraform" --project ${TF_PROJECT} --file Terraform.yaml
```

```bash
gcloud projects add-iam-policy-binding ${TF_PROJECT} --member serviceAccount:terraform@${TF_PROJECT}.iam.gserviceaccount.com --role projects/${TF_PROJECT}/roles/Terraform
```

**Sources:**

```txt
https://cloud.google.com/sdk/docs/downloads-versioned-archives
https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform
https://cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy
https://cloud.google.com/compute/docs/regions-zones/#available
https://cloud.google.com/compute/docs/machine-types
https://cloud.google.com/compute/docs/images
https://cloud.google.com/endpoints/docs/openapi/enable-api#gcloud
```
