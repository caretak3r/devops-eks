terraform {
  extra_arguments "common_vars" {
    commands = ["plan", "apply"]

    arguments = [
      "-var-file=dev/terraform.tfvars"
    ]
  }
}