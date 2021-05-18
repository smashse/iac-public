# Instalação do LXD e utilização com o Terraform localmente

### Instalar o SNAP caso não tenha

```bash
sudo apt install -y snap snapd
```

### Instalar o LXD

```bash
sudo snap install lxd --classic
```

### Inicializar a configuração do LXD

```bash
sudo lxd init
```

```txt
Would you like to use LXD clustering? (yes/no) [default=no]: no
Do you want to configure a new storage pool? (yes/no) [default=yes]: yes
Name of the new storage pool [default=default]: default
Name of the storage backend to use (ceph, btrfs, dir, lvm, zfs) [default=zfs]: zfs
Create a new ZFS pool? (yes/no) [default=yes]: yes
Would you like to use an existing empty disk or partition? (yes/no) [default=no]: no
Size in GB of the new loop device (1GB minimum) [default=30GB]: 10GB
Would you like to connect to a MAAS server? (yes/no) [default=no]: no
Would you like to create a new local network bridge? (yes/no) [default=yes]: yes
What should the new bridge be called? [default=lxdbr0]: lxdbr0
What IPv4 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]: auto
What IPv6 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]: auto
Would you like LXD to be available over the network? (yes/no) [default=no]: yes
Address to bind LXD to (not including port) [default=all]: all
Port to bind LXD to [default=8443]: 8443
Trust password for new clients:
Again:
Would you like stale cached images to be updated automatically? (yes/no) [default=yes] yes
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]: yes
```

```yaml
config:
  core.https_address: "[::]:8443"
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
      size: 10GB
    description: ""
    name: default
    driver: zfs
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

### Adicionar acesso local ao LXD

```bash
lxc remote add mobile 127.0.0.1 --accept-certificate
```

### Definir o acesso remoto padrão ao LXD

```bash
lxc remote set-default mobile
```

### Caso deseje alterar a porta do LXD

```bash
lxc config set core.https_address :8443
```

### Caso deseje alterar a senha do LXD

```bash
lxc config set core.trust_password mobile
```

### Copiar o perfil padrão

```bash
lxc profile copy default ubuntu-profile
```

### Customizar o perfil criado

```bash
lxc profile set ubuntu-profile boot.autostart true
lxc profile set ubuntu-profile boot.autostart.delay 1
lxc profile set ubuntu-profile security.nesting true
lxc profile set ubuntu-profile security.privileged true
lxc profile set ubuntu-profile linux.kernel_modules br_netfilter,ip_vs,ip_vs_rr,ip_vs_wrr,ip_vs_sh,ip_tables,ip6_tables,netlink_diag,nf_nat,overlay,xt_conntrack
lxc profile set ubuntu-profile limits.cpu 2
lxc profile set ubuntu-profile limits.memory 1024MB
lxc profile set ubuntu-profile limits.memory.swap false
lxc profile device set ubuntu-profile root size 2048MB
```

### Copiar imagem do Ubuntu para o LXD

```bash
lxc image copy images:ubuntu/focal/cloud mobile: --alias focal --auto-update
```

### Criando um container do Ubuntu

```bash
lxc launch mobile:focal boat --profile=ubuntu-profile
```

### Criando um YAML para Cloud-Init

```bash
sudo nano -c ubuntu-generic-clean.yml
```

```yaml
#cloud-config
runcmd:
  - sudo echo "#ubuntu" > /etc/apt/sources.list
  - sudo echo "deb http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse" >> /etc/apt/sources.list
  - sudo echo "deb http://archive.ubuntu.com/ubuntu focal-updates main restricted universe multiverse" >> /etc/apt/sources.list
  - sudo echo "deb http://archive.ubuntu.com/ubuntu focal-backports main restricted universe multiverse" >> /etc/apt/sources.list
  - sudo echo "deb http://archive.ubuntu.com/ubuntu focal-proposed restricted main universe multiverse" >> /etc/apt/sources.list
  - sudo echo "#security" >> /etc/apt/sources.list
  - sudo echo "deb http://security.ubuntu.com/ubuntu focal-security main restricted universe multiverse" >> /etc/apt/sources.list
  - sudo echo "#partner" >> /etc/apt/sources.list
  - sudo echo "deb http://archive.canonical.com/ubuntu focal partner" >> /etc/apt/sources.list
  - sudo echo "DEBIAN_FRONTEND=noninteractive" >> /etc/environment
  - sudo source /etc/environment && source /etc/environment
  - sudo apt update --fix-missing
  - sudo apt -y install apt-transport-https bash-completion ca-certificates conntrack curl ethtool htop ipset mlocate nano net-tools nftables socat software-properties-common tar unzip wget xz-utils
  - sudo apt -y dist-upgrade
  - sudo apt -y autoremove
```

### Criando um container do Ubuntu e usando o YAML do Cloud-Init

```bash
lxc launch mobile:focal boat --profile=ubuntu-profile --config=user.user-data="$(cat ubuntu-generic-clean.yml)"
```

### Criar perfil para utilização com Kubernetes

```bash
lxc profile create microk8s-profile
```

```bash
nano -c microk8s-profile
```

```yaml
name: microk8s-profile
config:
  boot.autostart: "true"
  boot.autostart.delay: 1
  limits.cpu: "2"
  limits.memory: 1024MB
  limits.memory.swap: "false"
  linux.kernel_modules: br_netfilter,ip_vs,ip_vs_rr,ip_vs_wrr,ip_vs_sh,ip_tables,ip6_tables,netlink_diag,nf_nat,overlay,xt_conntrack
  raw.lxc: |
    lxc.apparmor.profile=unconfined
    lxc.mount.auto=proc:rw sys:rw cgroup:rw
    lxc.cgroup.devices.allow=a
    lxc.cap.drop=
  security.nesting: "true"
  security.privileged: "true"
description: ""
devices:
  eth0:
    name: eth0
    network: lxdbr0
    type: nic
  root:
    path: /
    pool: default
    size: 2048MB
    type: disk
  aadisable:
    path: /sys/module/nf_conntrack/parameters/hashsize
    source: /sys/module/nf_conntrack/parameters/hashsize
    type: disk
  aadisable1:
    path: /sys/module/apparmor/parameters/enabled
    source: /dev/null
    type: disk
  aadisable2:
    path: /dev/zfs
    source: /dev/zfs
    type: disk
  aadisable3:
    path: /dev/kmsg
    source: /dev/kmsg
    type: disk
```

```bash
cat microk8s-profile | lxc profile edit microk8s-profile
```

**Observação:** Caso queira ajustar os valores de CPU, MEMÓRIA e DISCO para o perfil "microk8s-profile", dobrar os valores por exemplo, execute os comandos abaixo.

```bash
lxc profile set microk8s-profile limits.cpu 4
lxc profile set microk8s-profile limits.memory 2048MB
lxc profile device set microk8s-profile root size 4096MB
```

```bash
sudo nano -c microk8s.yml
```

```yaml
#cloud-config
runcmd:
  - sudo echo "DEBIAN_FRONTEND=noninteractive" >> /etc/environment
  - sudo source /etc/environment && source /etc/environment
  - sudo apt update --fix-missing
  - sudo apt -y install snap snapd
  - sudo snap install microk8s --classic
```

```bash
lxc launch mobile:focal boat --profile=microk8s-profile --config=user.user-data="$(cat microk8s.yml)"
```

```bash
lxc exec boat bash
```

```bash
root@boat:~# microk8s.kubectl get nodes
NAME   STATUS   ROLES    AGE   VERSION
boat   Ready    <none>   66s   v1.18.6-1+64f53401f200a7
oot@boat:~# microk8s add-node
Join node with: microk8s join 10.253.245.192:25000/95755207afa39ada1adda4d8c58182c6

If the node you are adding is not reachable through the default interface you can use one of the following:
 microk8s join 10.1.89.0:25000/95755207afa39ada1adda4d8c58182c6
 microk8s join 10.253.245.192:25000/95755207afa39ada1adda4d8c58182c6
root@boat:~#
```

**Fontes:**

```txt
https://microk8s.io/docs
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
