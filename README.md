# devops-eks
eks cluster for devops tooling

## services to host:

- https://github.com/PrivateBin/PrivateBin/wiki/Docker
- https://hub.docker.com/r/hashicorp/terraform
- https://falco.org/docs/installation/
- https://github.com/eliasgranderubio/dagda

## kubernetes tools to install
 
 - Kubernetes dashboard
 - Kiali (istio)
 - grafana + prometheus
 
## check
- which autoscaler is being used in default EKS?
- Horizontal Pod Autoscaler (HPA)
- Cluster Autoscaler (CA)

## goals:
    - use terraform to deploy EKS and services
    - use github actions for CI when I push new terraform code
        - eventually make this trigger on pull_requests being merge
        
## stretch:
    - kubeflow - from code to container to deploying in kubernetes

####----------------------------------

# tasks:
    - deploy with custom IAM roles
    - deploy with bare minimum configurations
    - helm/istio/kubectl : wait on these until you know how the EKS cluster is being set up, provisioned