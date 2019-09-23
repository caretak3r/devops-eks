#!/usr/bin/env bash

# AWS_IAM_AUTHENTICATOR
echo "===================================>> Setup aws-iam-authenticator"
curl --silent --location -o "/usr/local/bin/aws-iam-authenticator" https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/aws-iam-authenticator

if [[ $? != 0 ]]; then
  echo "aws-iam-authenticator did not install correctly, exiting script"
  exit 1
else
  chmod +x /usr/local/bin/kubectl;
  whereis aws-iam-authenticator;
fi