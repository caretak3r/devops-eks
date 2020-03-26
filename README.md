# terraform-aws-eks
using Terraform to deploy an EKS cluster and nodegroups, which follows environment separation and multiple release pipelines

### services to host:

- https://github.com/PrivateBin/PrivateBin/wiki/Docker
- https://hub.docker.com/r/hashicorp/terraform
- https://falco.org/docs/installation/
- https://github.com/eliasgranderubio/dagda
- https://docs.aws.amazon.com/en_pv/eks/latest/userguide/calico.html

### kubernetes tools to install
 
 - Kubernetes dashboard
 - Kiali (istio)
 - grafana + prometheus
 - Calico
 - https://krew.sigs.k8s.io/docs/user-guide/quickstart/


## Strategy

### DRY principals
- DRY principles are aimed at reducing repetition in patterns and code.
- This is why we will use terragrunt to assist us in managing this complexity    
- Repository strategies:

        
        modules: This repo defines reusable modules. Think of each module as a “blueprint” that defines a specific part of your infrastructure.
        
        
        live: This repo defines the live infrastructure you’re running in each environment (stage, prod, mgmt, etc). Think of this as the “houses” you built from the “blueprints” in the modules repo.
        

### branching strategy
    
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
        ├── environments
        │   ├── prod
        │   │   ├── README.md
        │   │   ├── variables.tf
        │   │   ├── main.tf
        │   │   ├── outputs.tf
        │   ├── stage
        │   │   ├── README.md
        │   │   ├── variables.tf
        │   │   ├── main.tf
        │   │   ├── outputs.tf
        │   ├── dev
        │   │   ├── README.md
        │   │   ├── variables.tf
        │   │   ├── main.tf
        │   │   ├── outputs.tf
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

### release process

    repository:
    |-> terraform
        |-> dev
            |-> main.tf
            |-> modules.tf
        |-> staging
            |-> main.tf
            |-> modules.tf
        |-> prod
            |-> main.tf
            |-> modules.tf
            |-> /services/
            |-> /vpc/

    # staging can reference the RC (release candidate branch)
    # prod can reference the tag for new code
        - helps with hotfixes

### another repository structure
    live.git
      └ stage
          └ vpc
          └ services
              └ frontend-app
              └ backend-app
          └ data-storage
              └ mysql
              └ redis
      └ prod
          └ vpc
          └ services
              └ frontend-app
              └ backend-app
          └ data-storage
              └ mysql
              └ redis
      └ mgmt
          └ vpc
          └ services
              └ bastion-host
              └ jenkins
      └ global
          └ iam
          └ s3modules.git
          
          
          
    modules.git
      └ data-stores
           └ mysql
           └ redis           
      └ mgmt
           └ vpc           
           └ jenkins           
      └ security
           └ iam
           └ s3
           └ bastion-host
      └ services
           └ webserver-cluster
           
## modules
- Modules should be released by a specific version
- Here's how to commit them when ready for a release:
        
        git tag -a "v0.0.1" -m "First release of webserver-cluster module"
        git push --follow-tags


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

## tasks:
    - deploy with custom IAM roles
    - deploy with bare minimum configurations
    - helm/istio/kubectl : wait on these until you know how the EKS cluster is being set up, provisioned
    
## long term goals
    - ensure state is being managed by S3 bucket per environment
        - backend configuration with terragrunt to manage or workspaces
        - e.g: cadent-${var,ENV}-terraform-state
        - or: s3://cadent-terraform-state/prod/state
            - s3://cadent-terraform-state/qa/state
            - s3://cadent-terraform-state/dev/state
            
## tricks&?tips

 - given specific parameters to a class/environment (dev can only use small instance teirs)
        
        locals {
            environment = “${lookup(var.workspace_to_environment_map, terraform.workspace, “dev”)}”
            size = “${local.environment == “dev” ? lookup(var.workspace_to_size_map, terraform.workspace, “small”) : var.environment_to_size_map[local.environment]}”
}

- subnet_mapping based on environment

        variable “subnet_map” {
            description = “A map from environment to a comma-delimited list of     the subnets”
            type = “map”
        default = {
            dev     = “subnet-c59403abe,subnet-69483bdb33c”
            qa      = “subnet-e48unjd9a1,subnet-c085uhd93a4”
            staging = “subnet-65489uuhfn9,subnet-448hjdh86b”,
            prod    = “subnet-6dfjn2344f,subnet-0f4u3bjbd47”
          }
        }
        output “subnets” {
          value = [“${split(“,”, var.subnet_map[var.environment])}”]
        }
        
- instance_type based on environment map

        variable “instance_type_map” {
          description = “A map from environment to the type of EC2 instance”
          type = “map”
          default = {
            small  = “t2.large”
            medium = “t2.xlarge”
            large  = “m4.large”
            xlarge = “m4.xlarge”
          }
        }
        output “instance_type” {
          value = “${var.instance_type_map[var.size]}”
        }

- kubernetes namespace selectors and terraform variables

```
    TF_VAR_release   - "release" : "stable", "release" : "canary" (not used until in production)
    TF_VAR_stage     - "environment" : "dev", "environment" : "qa", "environment" : "production"
    TF_VAR_tier      - "tier" : "frontend", "tier" : "backend", "tier" : "cache"
    TF_VAR_partition - "partition" : "customerA", "partition" : "customerB"
    TF_VAR_track     - "track" : "daily", "track" : "weekly"
    TF_VAR_app       - "app" : "nginx", "dovecot", "redis"
```

        "BusinessUnit" = "Finance"
        "ManagedBy"    = "Terraform"
        "SquadName"    = "DevOps"
        "Environment"  = "Production"
        "CostCenter"   = "ProjectName"


  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
