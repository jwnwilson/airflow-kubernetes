# Learn Terraform - Provision a GKE Cluster

This repo is a companion repo to the [Provision a GKE Cluster tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke), containing Terraform configuration files to provision an GKE cluster on GCP.

This sample repo also creates a VPC and subnet for the GKE cluster. This is not
required but highly recommended to keep your GKE cluster isolated.


# Create airflow service using these guides:

https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke

https://towardsdatascience.com/deploying-airflow-on-google-kubernetes-engine-with-helm-28c3d9f7a26b

Commands ran:

brew install gcloud kubectl helm

gcloud init
gcloud auth application-default login
terraform init
terraform apply

gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)

cd infra/kube
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml 
kubectl apply -f https://raw.githubusercontent.com/hashicorp/learn-terraform-provision-gke-cluster/main/kubernetes-dashboard-admin.rbac.yaml
kubectl apply -f service_account.yaml

## image pull secret

This can be the default service account with viewer role

kubectl create secret docker-registry artifact-registry \
--docker-server=https://LOCATION-docker.pkg.dev \
--docker-email=SERVICE-ACCOUNT-EMAIL \
--docker-username=_json_key \
--docker-password="$(cat KEY-FILE)"

kubectl edit serviceaccount default --namespace default

Add:
```
imagePullSecrets:
- name: artifact-registry
```

## Push airflow image

cd source
docker build . -t europe-west1-docker.pkg.dev/noel-wilson-kube/airflow/airflow-test:latest
docker push europe-west1-docker.pkg.dev/noel-wilson-kube/airflow/airflow-test:latest

## Setup airflow

kubectl create namespace airflow 
helm repo add apache-airflow https://airflow.apache.org
helm show values apache-airflow/airflow > values.yaml
helm upgrade --install airflow apache-airflow/airflow -n airflow -f values.yaml --debug

# Go to proxy to debug

kubectl -n kubernetes-dashboard create token admin-user
kubectl proxy 

# Next steps

1. Create example dag with kubernetes dag