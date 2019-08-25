# k8s_assign
## Prerequisites
Need to have a GCP account and create a project.  
Install gloud sdk if not running on a google cloud shell.  

Clone this repository.  
**Wrapper.sh scripts runs all the steps of installing Demo application on both the Namespaces and configuring Ingress-nginx**.

## Installing the application.
Script can be run from cloud shell or from any local shell.    
From  Cloud shell run **sh wrapper.sh <project_name>**, it installs Guest book application and configures Nginx Ingress.

From a localmachine or outside GCP we need to install gcloud sdk. Below example shows steps to install gcloud for RHEL family.  
1.sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM  
  [google-cloud-sdk]  
  name=Google Cloud SDK  
  baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64  
  enabled=1  
  gpgcheck=1  
  repo_gpgcheck=1  
  gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg  
         https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg  
  EOM  
2.Install the Cloud SDK  
  yum install google-cloud-sdk  
3.gcloud init --console-only   

Once the gcloud sdk is installed run **sh wrapper.sh <project_name>** to install the application.

## Testing Autoscalar.

Run **sh loadtest.sh start <namespace>** to start the load test on any namespace.  
kubectl get hpa -n <namespace> shows the current utilization and replicas.

Run **sh loadtest.sh stop** to stop the current running load.

Even though when you stop the load it will take few mins to adjust the replica count.
