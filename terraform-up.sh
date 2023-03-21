#!/bin/bash
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

cat $TERRAFORM_SECRET
cd ./ECS/prod
terraform init
terraform plan -var-file=$TERRAFORM_SECRET
terraform apply -var-file=$TERRAFORM_SECRET -auto-approve
