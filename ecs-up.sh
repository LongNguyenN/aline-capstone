#!/bin/bash
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export AWS_DEFAULT_REGION=us-east-1

cp ${SERVICE_ENV} .
docker context use ln-ecs
#aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 649206692878.dkr.ecr.us-east-1.amazonaws.com
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${AWS_ACCESS_KEY_ID}.dkr.ecr.us-east-1.amazonaws.com
docker compose -p ln-aline --env-file ${SERVICE_ENV} up
