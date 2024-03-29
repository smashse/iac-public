This is an example model for creating an GKE environment with the GCP provider on Terraform.

## Download the Terraform template

```bash
git clone https://github.com/smashse/iac-public.git
cd iac-public/IAC/GCP/template_terraform_gcp_gke/
```

Or to download "README.md" and "template_terraform_gcp_gke":

```bash
git init iac-public
cd iac-public
git remote add iac-public https://github.com/smashse/iac-public.git
git fetch iac-public
git checkout iac-public/master -- IAC/GCP/template_terraform_gcp_gke
git checkout iac-public/master -- IAC/GCP/template_terraform_gcp_gke/README.md
```

```bash
cd IAC/GCP/template_terraform_gcp_gke/
```

**Note:** If you want to change the name given to VPC, and other items, execute the command below in the template folder.

```bash
sed -i "s/template/desiredname/g" *.*
```

## Perform template customizations

```bash
nano -c variables.tf
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

**Notes:** This document has few modifications to the original document provided by Hashicorp in "Provision an GKE Cluster (GCP)"

<https://learn.hashicorp.com/tutorials/terraform/gke?in=terraform/kubernetes>

# Learn Terraform - Provision a GKE Cluster

This repo is a companion repo to the [Provision a GKE Cluster learn guide](https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster), containing
Terraform configuration files to provision an GKE cluster on
GCP.

This sample repo also creates a VPC and subnet for the GKE cluster. This is not
required but highly recommended to keep your GKE cluster isolated.

## Install and configure GCloud

First, install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/quickstarts)
and initialize it.

```bash
$ gcloud init
```

Once you've initialized gcloud (signed in, selected project), add your account
to the Application Default Credentials (ADC). This will allow Terraform to access
these credentials to provision resources on GCloud.

```bash
$ gcloud auth application-default login
```

## Initialize Terraform workspace and provision GKE Cluster

Replace `terraform.tfvars` values with your `project_id` and `region`. Your
`project_id` must match the project you've initialized gcloud with. To change your
`gcloud` settings, run `gcloud init`. The region has been defaulted to `us-central1`;
you can find a full list of gcloud regions [here](https://cloud.google.com/compute/docs/regions-zones).

After you've done this, initalize your Terraform workspace, which will download
the provider and initialize it with the values provided in the `terraform.tfvars` file.

```bash
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "google" (hashicorp/google) 3.13.0...
Terraform has been successfully initialized!
```

Then, provision your GKE cluster by running `terraform apply`. This will
take approximately 10 minutes.

```bash
$ terraform apply

# Output truncated...

Plan: 4 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

# Output truncated...

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

kubernetes_cluster_name = dos-terraform-edu-gke
region = us-central1
```

## Configure kubectl

To configure kubetcl, by running the following command.

```bash
$ gcloud container clusters get-credentials dos-terraform-edu-gke --region us-central1
```

The
[Kubernetes Cluster Name](https://github.com/hashicorp/learn-terraform-provision-gke-cluster/blob/master/gke.tf#L63)
and [Region](https://github.com/hashicorp/learn-terraform-provision-gke-cluster/blob/master/vpc.tf#L29)
correspond to the resources spun up by Terraform.

## Deploy and access Kubernetes Dashboard

To deploy the Kubernetes dashboard, run the following command. This will schedule
the resources necessary for the dashboard.

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
namespace/kubernetes-dashboard created
serviceaccount/kubernetes-dashboard created
service/kubernetes-dashboard created
secret/kubernetes-dashboard-certs created
secret/kubernetes-dashboard-csrf created
secret/kubernetes-dashboard-key-holder created
configmap/kubernetes-dashboard-settings created
role.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
deployment.apps/kubernetes-dashboard created
service/dashboard-metrics-scraper created
deployment.apps/dashboard-metrics-scraper created
```

Finally, to access the Kubernetes dashboard, run the following command:

```plaintext
$ kubectl proxy
Starting to serve on 127.0.0.1:8001
```

You should be
able to access the Kubernetes dashboard at <http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/>.

## Authenticate to Kubernetes Dashboard

To view the Kubernetes dashboard, you need to provide an authorization token.
Authenticating using `kubeconfig` is **not** an option. You can read more about
it in the [Kubernetes documentation](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/#accessing-the-dashboard-ui).

Generate the token in another terminal (do not close the `kubectl proxy` process).

```plaintext
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')

Name:         service-controller-token-m8m7j
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: service-controller
              kubernetes.io/service-account.uid: bc99ddad-6be7-11ea-a3c7-42010a800017

Type:  kubernetes.io/service-account-token

Data
====
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9...
ca.crt:     1119 bytes
```

Select "Token" then copy and paste the entire token you receive into the
[dashboard authentication screen](http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)
to sign in. You are now signed in to the dashboard for your Kubernetes cluster.
