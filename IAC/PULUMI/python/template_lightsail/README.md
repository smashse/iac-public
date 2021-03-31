This is a model for creating in Python an EC2 environment with the AWS provider on Pulumi.

# Install AWS (Optional)

```bash
cd /tmp
ssh-keygen -f pulumi_lightsail_py_access
curl "<https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip>" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install
aws configure
aws ec2 import-key-pair --public-key-material "$(cat pulumi_lightsail_py_access.pub | base64)" --key-name pulumi_lightsail_py_access --region us-west-2 --profile yourprofile
```

## Download the PULUMI template

```bash
mkdir -p $HOME/Pulumi
cd $HOME/Pulumi
git clone https://github.com/smashse/iac-public.git
cd iac-public/IAC/PULUMI/python/template_lightsail/
```

Or to download "README.md" and "template_lightsail":

```bash
mkdir -p $HOME/Pulumi
cd $HOME/Pulumi
git init iac-public
cd iac-public
git remote add iac-public https://github.com/smashse/iac-public.git
git fetch iac-public
git checkout iac-public/master -- IAC/PULUMI/python/template_lightsail
git checkout iac-public/master -- IAC/PULUMI/python/template_lightsail/README.md
```

## Install Pulumi on Linux by running the installation script:

```bash
curl -fsSL https://get.pulumi.com | sh && bash
```

## Install Python VirtualEnv:

```bash
sudo apt -y install python3-virtualenv
```

## Create a "pulumi_lightsail_py" project:

```bash
cd $HOME/Pulumi
mkdir pulumi_lightsail_py && cd pulumi_lightsail_py && pulumi new aws-python --emoji --generate-only --name pulumi_lightsail_py --description "Pulumi EC2 Python"
cp -raf $HOME/Pulumi/iac-public/IAC/PULUMI/python/template_lightsail/* .
```

**Note:** If you want to change the name given to resources, execute the command below in the template folder.

```bash
sed -i "s/"template"/"desiredname"/g" *.py
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
pulumi stack init pulumi_lightsail_py
```

## Set AWS_PROFILE:

```bash
pulumi config set aws:profile yourprofile
```

## Set AWS_REGION:

```bash
pulumi config set aws:region us-east-1
```

## Review the "pulumi_lightsail_py" project

```bash
pulumi preview
```

## Deploy the Stack

```bash
pulumi up
```

## Destroy the "pulumi_lightsail_py" project

```bash
pulumi destroy
```

## Remove the "pulumi_lightsail_py" project from Stack

```bash
pulumi stack rm pulumi_lightsail_py
```

## Source:

<https://www.pulumi.com/docs/get-started/>

<https://www.pulumi.com/docs/reference/pkg/>

<https://www.pulumi.com/docs/intro/concepts/state/>

<https://aws.amazon.com/pt/lightsail/>

<https://lightsail.aws.amazon.com/ls/docs/en_us/articles/compare-options-choose-lightsail-instance-image>

<https://www.cloudsavvyit.com/2307/amazon-lightsail-is-aws-for-regular-people/amp/>

<https://www.sankalpjonna.com/posts/our-aws-bill-is-2-of-revenue-heres-how-we-did-it>