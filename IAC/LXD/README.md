# Instalação do LXD e utilização com o Terraform localmente

### Instalar o SNAP caso não tenha

```bash
sudo apt install -y snapd
```

### Instalar o LXD

```bash
sudo snap install lxd --channel=4.1/stable --classic
```

### Inicializar a configuração do LXD

```bash
sudo lxd init
```

```txt
Would you like to use LXD clustering? (yes/no) [default=no]:
Do you want to configure a new storage pool? (yes/no) [default=yes]:
Name of the new storage pool [default=default]:
Name of the storage backend to use (ceph, btrfs, dir, lvm) [default=btrfs]:
Create a new BTRFS pool? (yes/no) [default=yes]:
Would you like to use an existing block device? (yes/no) [default=no]:
Size in GB of the new loop device (1GB minimum) [default=15GB]: 5GB
Would you like to connect to a MAAS server? (yes/no) [default=no]:
Would you like to create a new local network bridge? (yes/no) [default=yes]:
What should the new bridge be called? [default=lxdbr0]:
What IPv4 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]:
What IPv6 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]:
Would you like LXD to be available over the network? (yes/no) [default=no]: yes
Address to bind LXD to (not including port) [default=all]:
Port to bind LXD to [default=8443]:
Trust password for new clients:
Again:
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]: yes
```

```yaml
config:
  core.https_address: '[::]:8443'
  core.trust_password: mobile
networks:
- config:
    ipv4.address: auto
    ipv6.address: auto
  description: ""
  name: lxdbr0
  type: ""
storage_pools:
- config:
    size: 5GB
  description: ""
  name: default
  driver: btrfs
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      network: lxdbr0
      type: nic
    root:
      path: /
      pool: default
      type: disk
  name: default
cluster: null
```

### Copiar o perfil padrão

```bash
lxc profile copy default ubuntu-profile
```

### Customizar o perfil criado

```bash
lxc profile set ubuntu-profile boot.autostart true
lxc profile set ubuntu-profile boot.autostart.delay 1
lxc profile set ubuntu-profile limits.cpu 1
lxc profile set ubuntu-profile limits.memory 64MB
lxc profile device set ubuntu-profile root size 512MB
```

### Caso deseje alterar a porta do LXD

```bash
lxc config set core.https_address :8443
```

### Caso deseje alterar a senha do LXD

```bash
lxc config set core.trust_password mobile
```

### Adicionar acesso local ao LXD

```bash
lxc remote add mobile 127.0.0.1 --accept-certificate
lxc remote set-default mobile
```

### Copiar imagem do Ubuntu para o LXD

```bash
lxc image copy images:ubuntu/focal mobile: --alias focal --auto-update
```

### Configuração do Terraform para uso com o LXD

```bash
cd /tmp
```

```bash
curl -s https://api.github.com/repos/sl1pm4t/terraform-provider-lxd/releases/latest | jq '.assets | .[] | .browser_download_url' | grep "linux_amd64"
```

Resultado: "<https://github.com/sl1pm4t/terraform-provider-lxd/releases/download/v1.3.0/terraform-provider-lxd_v1.3.0_linux_amd64.zip>"

```bash
wget -c https://github.com/sl1pm4t/terraform-provider-lxd/releases/download/v1.3.0/terraform-provider-lxd_v1.3.0_linux_amd64.zip
```

```bash
mkdir -p ~/terraform/teste/.terraform/plugins/linux_amd64/
```

```bash
unzip terraform-provider-lxd_v1.3.0_linux_amd64.zip -d ~/terraform/teste/.terraform/plugins/linux_amd64/
```

```bash
cd ~/terraform/teste/
```

```bash
nano -c provider.tf
```

```terraform
provider "lxd" {
  generate_client_certificates = true
  accept_remote_certificate    = true

  lxd_remote {
    name     = "mobile"
    scheme   = "https"
    address  = "127.0.0.1"
    password = "mobile"
    default  = true
  }
}
```

```bash
nano -c lxd_container.tf
```

```terraform
resource "lxd_container" "ubuntu" {
  name      = "ubuntu"
  image     = "focal"
  profiles  = ["ubuntu-profile"]
  ephemeral = false

  config = {
    "boot.autostart" = true
  }

  limits = {
    cpu = 1
  }
}
```

```bash
terraform init
terraform plan
terraform apply
```
