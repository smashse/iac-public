This is a model for creating in Python an GKE environment with the GCP provider on Pulumi.

# Install GCP (Optional)

```bash
cd /tmp
sudo touch /etc/apt/sources.list.d/google-cloud-sdk.list
sudo chmod 666 /etc/apt/sources.list.d/google-cloud-sdk.list
sudo curl -fsSL 'https://packages.cloud.google.com/apt/doc/apt-key.gpg' | sudo apt-key add -
sudo echo "deb [arch=amd64] http://packages.cloud.google.com/apt cloud-sdk main" > "/etc/apt/sources.list.d/google-cloud-sdk.list"
sudo chmod 644 /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 54A647F9048D5688D7DA2ABE6A030B21BA07F4FB
sudo apt update --fix-missing
sudo apt -y install google-cloud-sdk
gcloud init
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
gcloud beta billing accounts list --filter=open=true
```

### Create the PULUMI Project

```bash
gcloud projects create gke-project --name=gke-project --set-as-default
gcloud config set project gke-project
gcloud beta billing projects link gke-project --billing-account `gcloud beta billing accounts list --filter=open=true --uri | cut -f 6 -d "/"`
```

### Create the PULUMI service account

```bash
gcloud iam service-accounts create gkeadmin --display-name "GKE Admin"
gcloud iam service-accounts keys create ~/.config/gcloud/gkeadmin-account.json --iam-account gkeadmin@gke-project.iam.gserviceaccount.com
```

### Enable API Services

```bash
gcloud services enable cloudbilling.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable gkeconnect.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable serviceusage.googleapis.com
```

### Grant the service account permission

```bash
gcloud projects add-iam-policy-binding gke-project --member serviceAccount:gkeadmin@gke-project.iam.gserviceaccount.com --role roles/compute.admin
gcloud projects add-iam-policy-binding gke-project --member serviceAccount:gkeadmin@gke-project.iam.gserviceaccount.com --role roles/container.clusterAdmin
gcloud projects add-iam-policy-binding gke-project --member serviceAccount:gkeadmin@gke-project.iam.gserviceaccount.com --role roles/iam.serviceAccountAdmin
gcloud projects add-iam-policy-binding gke-project --member serviceAccount:gkeadmin@gke-project.iam.gserviceaccount.com --role roles/iam.serviceAccountKeyAdmin
gcloud projects add-iam-policy-binding gke-project --member serviceAccount:gkeadmin@gke-project.iam.gserviceaccount.com --role roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding gke-project --member serviceAccount:gkeadmin@gke-project.iam.gserviceaccount.com --role roles/iap.httpsResourceAccessor
gcloud projects add-iam-policy-binding gke-project --member serviceAccount:gkeadmin@gke-project.iam.gserviceaccount.com --role roles/storage.admin
gcloud projects add-iam-policy-binding gke-project --member serviceAccount:gkeadmin@gke-project.iam.gserviceaccount.com --role roles/viewer
```

## Download the PULUMI template

```bash
mkdir -p $HOME/Pulumi
cd $HOME/Pulumi
git clone https://github.com/smashse/iac-public.git
cd iac-public/IAC/PULUMI/python/template_gke/
```

Or to download "README.md" and "template_gke":

```bash
mkdir -p $HOME/Pulumi
cd $HOME/Pulumi
git init iac-public
cd iac-public
git remote add iac-public https://github.com/smashse/iac-public.git
git fetch iac-public
git checkout iac-public/master -- IAC/PULUMI/python/template_gke
git checkout iac-public/master -- IAC/PULUMI/python/template_gke/README.md
```

## Install Pulumi on Linux by running the installation script:

```bash
curl -fsSL https://get.pulumi.com | sh && bash
```

## Install Python VirtualEnv:

```bash
sudo apt -y install python3-virtualenv
```

## Create a "pulumi_gke_py" project:

```bash
cd $HOME/Pulumi
mkdir pulumi_gke_py && cd pulumi_gke_py && pulumi new gcp-python --emoji --generate-only --name pulumi_gke_py --description "Pulumi GKE Python"
cp -raf $HOME/Pulumi/iac-public/IAC/PULUMI/python/template_gke/* .
```

**Note:** If you want to change the name given to Kubernetes cluster, execute the command below in the template folder.

```bash
sed -i "s/"template-"/"desiredname-"/g" *.*
```

## Install Python Requirements

```bash
python3 -m venv venv
source venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
python -m pip install -r requirements.txt
```

## Perform an initial deployment, run the following commands:

```bash
pulumi login
pulumi stack init pulumi_gke_py
```

## Set GCP_PROJECT:

```bash
pulumi config set gcp:project gke-project
```

## Set GCP_REGION:

```bash
pulumi config set gcp:zone us-west1-a
```

## Review the "pulumi_gke_py" project

```bash
pulumi preview
```

## Deploy the Stack

```bash
pulumi up
```

## Access GKE Kubernetes cluster

```bash
sudo snap install kubectl --classic
pulumi stack output kubeconfig > kubeconfig.yaml
KUBECONFIG=./kubeconfig.yaml kubectl get po --all-namespaces
```

## Destroy the "pulumi_gke_py" project

```bash
pulumi destroy
```

## Remove the "pulumi_gke_py" project from Stack

```bash
pulumi stack rm pulumi_gke_py
```

## Source:

<https://www.pulumi.com/docs/get-started/>

<https://www.pulumi.com/docs/reference/pkg/>

<https://www.pulumi.com/docs/intro/concepts/state/>
