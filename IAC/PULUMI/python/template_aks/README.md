This is a model for creating in Python an AKS environment with the AZURE provider on Pulumi.

# Install AZURE (Optional)

```bash
cd /tmp
sudo touch /etc/apt/sources.list.d/azure-cli.list
sudo chmod 666 /etc/apt/sources.list.d/azure-cli.list
sudo curl -fsSL 'https://packages.microsoft.com/keys/microsoft.asc' | sudo apt-key add -
sudo echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > "/etc/apt/sources.list.d/azure-cli.list"
sudo chmod 644 /etc/apt/sources.list.d/azure-cli.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF
sudo apt update --fix-missing
sudo apt -y install azure-cli
az login
```

## Download the PULUMI template

```bash
mkdir -p $HOME/Pulumi
cd $HOME/Pulumi
git clone https://github.com/smashse/iac-public.git
cd iac-public/IAC/PULUMI/python/template_aks/
```

Or to download "README.md" and "template_aks":

```bash
mkdir -p $HOME/Pulumi
cd $HOME/Pulumi
git init iac-public
cd iac-public
git remote add iac-public https://github.com/smashse/iac-public.git
git fetch iac-public
git checkout iac-public/master -- IAC/PULUMI/python/template_aks
git checkout iac-public/master -- IAC/PULUMI/python/template_aks/README.md
```

## Install Pulumi on Linux by running the installation script:

```bash
curl -fsSL https://get.pulumi.com | sh && bash
```

## Install Python VirtualEnv:

```bash
sudo apt -y install python3-virtualenv
```

## Create a "pulumi_aks_py" project:

```bash
cd $HOME/Pulumi
mkdir pulumi_aks_py && cd pulumi_aks_py && pulumi new azure-python --emoji --generate-only --name pulumi_aks_py --description "Pulumi AKS Python"
cp -raf $HOME/Pulumi/iac-public/IAC/PULUMI/python/template_aks/* .
```

**Note:** If you want to change the name given to Kubernetes cluster, execute the command below in the template folder.

```bash
sed -i "s/"template-"/"desiredname-"/g" *.py
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
pulumi stack init pulumi_aks_py
```

## Set AZURE_PROFILE:

```bash
pulumi config set azure-py-aks:password `openssl rand -base64 12` --secret
ssh-keygen -f pulumi_aks_py_access
pulumi config set azure-py-aks:sshkey < pulumi_aks_py_access.pub
```

## Set AZURE_REGION:

```bash
pulumi config set azure:location westus2
```

## Review the "pulumi_aks_py" project

```bash
pulumi preview
```

## Deploy the Stack

```bash
pulumi up
```

## Access AKS Kubernetes cluster

```bash
sudo snap install kubectl --classic
pulumi stack output kubeconfig > kubeconfig.yaml
KUBECONFIG=./kubeconfig.yaml kubectl get po --all-namespaces
```

## Destroy the "pulumi_aks_py" project

```bash
pulumi destroy
```

## Remove the "pulumi_aks_py" project from Stack

```bash
pulumi stack rm pulumi_aks_py
```

## Source:

<https://www.pulumi.com/docs/get-started/>

<https://www.pulumi.com/docs/reference/pkg/>

<https://www.pulumi.com/docs/intro/concepts/state/>
