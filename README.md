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


# Strategy

## DRY principals
    DRY principles are aimed at reducing repetition in patterns and code.

## branching strategy
    
    trunk-based development
        - always in deployable state
        - easy integrations for features
        - helps validate said features
        - "trunk" == master
        - feature branches are short-lived
        - branches are kept "shallow"

    example:
        ├── README.md
        ├── variables.tf
        ├── main.tf
        ├── outputs.tf
        ├── modules
        │   ├── compute
        │   │   ├── README.md
        │   │   ├── variables.tf
        │   │   ├── main.tf
        │   │   ├── outputs.tf
        │   ├── networking
        │   │   ├── README.md
        │   │   ├── variables.tf
        │   │   ├── main.tf
        │   │   ├── outputs.tf

## release process

    repository:
    |-> terraform
        |-> env/
            |-> dev
                |-> main.tf
                |-> modules.tf
            |-> staging
                |-> main.tf
                |-> modules.tf
            |-> prod
                |-> main.tf
                |-> modules.tf
        |-> aws/
            |-> resourcesA.tf
            |-> resourcesB.tf

    # staging can reference the RC (release candidate branch)
    # prod can reference the tag for new code
        - helps with hotfixes


## check
    - which autoscaler is being used in default EKS?
        - Horizontal Pod Autoscaler (HPA)
        - Cluster Autoscaler (CA)

## goals:
    - use terraform to deploy EKS and services
    - module + env based
    - use github actions for CI when I push new terraform code
        - eventually make this trigger on pull_requests being merge
    - to achieve the goal by working toward maximum reusability
        
## stretch:
    - kubeflow - from code to container to deploying in kubernetes

####----------------------------------

# tasks:
    - deploy with custom IAM roles
    - deploy with bare minimum configurations
    - helm/istio/kubectl : wait on these until you know how the EKS cluster is being set up, provisioned
    
# long term goals
    - ensure state is being managed by S3 bucket per environment
        - e.g: cadent-${var,ENV}-terraform-state
        - or: s3://cadent-terraform-state/prod/state
            - s3://cadent-terraform-state/qa/state
            - s3://cadent-terraform-state/dev/state