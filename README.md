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

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml 
kubectl apply -f https://raw.githubusercontent.com/hashicorp/learn-terraform-provision-gke-cluster/main/kubernetes-dashboard-admin.rbac.yaml

kubectl -n kubernetes-dashboard describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')

kubectl proxy 

helm repo add apache-airflow https://airflow.apache.org
helm show values apache-airflow/airflow > values.yaml
helm upgrade --install airflow apache-airflow/airflow -n airflow  \\n  -f values.yaml \\n  --debug

# Next steps

1. Add container repo for airflow container
2. link kubernetes <-> container repo
3. deploy new image to kubernetes
4. Run example dag
5. Create example docker container with standalone task
6. Create example dag with kubernetes dag