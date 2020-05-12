**Fontes:**

```txt
https://rancher.com/docs/rancher/v2.x/en/installation/other-installation-methods/single-node-docker/
```

```txt
https://rancher.com/docs/rancher/v2.x/en/installation/options/server-tags/
```

Este é um template de exemplo para criação de um ambiente com o provider AWS em Terraform.


## Download do template Terraform

```bash
git clone https://github.com/smashse/iac-private.git
cd IAC/template_terraform/
```

**Observação:** Caso deseje alterar o nome dado a VPC, Subnets e Security Groups, execute dentro da pasta do template o comando abaixo.

```bash
sed -i "s/template/nomedesejado/g" *.*
```

## Configurar ambiente Terraform

```bash
curl "https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip" -o "terraform.zip"
unzip terraform.zip && sudo cp terraform /usr/local/bin/
```

## Realizar customizações do template

```bash
nano -c variables.tf
```

## Criar chave ssh e exportar para a AWS (Opcional)

```bash
ssh-keygen -f nomedesejado-access
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install
aws configure
aws ec2 import-key-pair --public-key-material "$(cat nomedesejado-access.pub | base64)" --key-name nomedesejado-access --profile seuprofile --region us-east-1
```

## Iniciar, planejar e criar a infraestrutura

```bash
terraform init
terraform plan
terraform apply
```

## Para adicionar o backend S3 e DynamoDB

```bash
mv terraform.tf.example terraform.tf
terraform init
terraform plan
terraform apply
```

## Rancher

Edite o arquivo "variables.tf" na variável "aws_certificate_arn", linha 59 e adicione o ARN para o certificado que deverá ser utilizado na ALB(ele servirá para as demais ALB's).

Para criar as instancias do Rancher, Master, Worker e ALB:

```bash
mv alb_rancher.tf.example alb_rancher.tf
mv iam_rancher.tf.example iam_rancher.tf
mv ec2_private.tf.example ec2_private.tf
terraform plan
terraform apply
```

**Observação:** Salve o "User" e "Secret" referentes ao usuário "rancher-user" e comente a saída para os mesmos no arquivo "iam_rancher.tf"(linha 16).

## Atlantis e GitLab (Opcional)

Dentro da pasta "other" existem as ALB's e instancias EC2 para a criação do Atlantis e Gitlab.

### Para Gitlab:

```bash
cp other/*_gitlab.tf .
terraform plan
terraform apply
```

### Para Atlantis:

```bash
cp other/*_atlantis.tf .
terraform plan
terraform apply
```

**Observação:** Nos arquivos "ec2_atlantis.tf" e "ec2_gitlab.tf" há a referencia para o "user_data" com os comandos para instalação daquilo que é necessário para o funcionamento das respectivas aplicações durante a criação das instancias.


# Estrutura do template

```txt
template_terraform
   |-cloud_init                # Pasta contendo os arquivos "User Data" padrão
        |-cloud-init-atlantis.conf                # "User Data" para instalação do "Atlantis"
        |-cloud-init-docker.conf                  # "User Data" para instalação do "Docker"
        |-cloud-init-docker-rancher.conf          # "User Data" para instalação do "Rancher"
        |-cloud-init-docker-rancher-master.conf   # "User Data" para instalação do "Rancher" node "Master"
        |-cloud-init-docker-rancher-worker.conf   # "User Data" para instalação do "Rancher" node "Worker"
        |-cloud-init-generic.conf                 # "User Data" para instalação do "Bastion"
        |-cloud-init-gitlab.conf                  # "User Data" para instalação do "Gitlab"
   |-other                     # Pasta contendo os exemplos para "Atlantis" e "Gitlab"
        |-alb_atlantis.tf      # Recurso de criação de "ALB" para acesso ao "Atlantis"
        |-alb_gitlab.tf        # Recurso de criação de "ALB" para acesso ao "Gitlab"
        |-ec2_atlantis.tf      # Recurso de criação de Instancia para acesso ao "Atlantis"
        |-ec2_gitlab.tf        # Recurso de criação de Instancia para acesso ao "Gitlab"
   |-alb_rancher.tf.example    # Recurso de criação de "ALB" para acesso ao "Rancher"
   |-.gitignore                # Especifica arquivos para ignorar
   |-dynamodb.tf               # Recurso de criação de tabela de lock no "DynamoDB"
   |-ec2_private.tf.example    # Instancias para "Subnets" privadas(Rancher, Master, Worker)
   |-ec2_public.tf             # Instancias para "Subnets" publicas(Bastion)
   |-eip.tf                    # Recurso para criação de "Elastic IP"
   |-iam_rancher.tf.example    # Recurso para criação de usuário "IAM" para o "Rancher"
   |-igw.tf                    # Recurso para criar um "Internet Gateway"
   |-nacl.tf                   # Recurso para gerenciar "NetWork ACL"
   |-nat.tf                    # Recurso para criar um "NAT Gateway"
   |-provider.tf               # Provedor usado para interagir com os recursos da AWS
   |-rta.tf                    # Recurso para associar "Route tables" e "Subnets"
   |-rt.tf                     # Recurso para criar "Route tables"
   |-s3.tf                     # Recurso "S3 Bucket"
   |-sg.tf                     # Recurso de "Security Groups"
   |-sn.tf                     # Recurso de "Subnets"
   |-terraform.tf.example      # Arquivo contendo o recurso de "Backend S3" para o "TFSTATE"
   |-variables.tf              # Arquivo de variáveis para utilização no projeto
   |-vpc.tf                    # Recurso de criação de "VPC"
```
