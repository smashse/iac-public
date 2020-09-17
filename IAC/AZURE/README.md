This is an example template for creating an environment with the AZURE provider in Terraform.

## Download the Terraform template

```bash
git clone https://github.com/smashse/iac-public.git
cd iac-public/IAC/AZURE/template_terraform_azure/
```

Or to download "README.md" and "template_terraform_azure":

```bash
git init iac-public
cd iac-public
git remote add iac-public https://github.com/smashse/iac-public.git
git fetch iac-public
git checkout iac-public/master -- IAC/AZURE/template_terraform_azure
```

```bash
cd IAC/AZURE/template_terraform_azure/
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

## Install Azure

```bash
cd /tmp
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt update --fix-missing && sudo apt -y install azure-cli
az login
```

Or

```bash
cd /tmp
curl -L https://aka.ms/InstallAzureCli | bash
exec -l $SHELL
az login
```

**Notes:**

```txt
https://docs.microsoft.com/pt-br/cli/azure/install-azure-cli-apt?view=azure-cli-latest
https://docs.microsoft.com/pt-br/azure/developer/terraform/
```
