#!/bin/bash

gcloud beta container --project "superb-ethos-247305" clusters create "standard-cluster-2" --zone "us-central1-a" --no-enable-basic-auth --cluster-version "1.12.8-gke.10" --machine-type "n1-standard-1" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --enable-cloud-logging --enable-cloud-monitoring --enable-ip-alias --network "projects/superb-ethos-247305/global/networks/default" --subnetwork "projects/superb-ethos-247305/regions/us-central1/subnetworks/default" --default-max-pods-per-node "110" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair

user=`kubectl config current-context`

kubectl config set-context staging --namespace=staging --cluster=$user --user=$user

kubectl config set-context production --namespace=production --cluster=$user --user=$user


for i in staging production 
do
  kubectl create namespace $i
  kubectl config use-context  $i
  kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml
  kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml
  kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml
  kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml
  kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml
  kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml
  kubectl autoscale deployment frontend -n $i --cpu-percent=10 --min=1 --max=5
done

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f nginx-ingress.yaml
kubectl apply -f ingress.yaml



