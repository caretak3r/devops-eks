#!/usr/bin/env bash

# KUBERNETES
echo "===================================>> Setup kubectl"
# shellcheck disable=SC2046
curl --silent --location -o "/usr/local/bin/kubectl" https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
if [[ $? != 0 ]]; then
  echo "kubectl did not install correctly, exiting script"
  exit 1
else
  chmod +x /usr/local/bin/kubectl;
  whereis kubectl;
fi