#!/bin/bash
init=0
if [ "$init" = "1" ]
then
	#should only do this once
	aws emr create-default-roles --region us-east-1
	# 1. Create the instance profile
	aws iam create-instance-profile --instance-profile-name EMR_EC2_DefaultRole
	# # 2. Add the role to the instance profile
	aws iam add-role-to-instance-profile --instance-profile-name EMR_EC2_DefaultRole --role-name EMR_EC2_DefaultRole
fi
# --ec2-attributes KeyName=MyKeyPair,SubnetId=subnet-0123456789abcdef0 \
aws emr create-cluster \
  --name "BeamKinesisMinimal" \
  --release-label emr-6.15.0 \
  --applications Name=Hadoop \
  --instance-type c4.large \
  --instance-count 1 \
  --use-default-roles \
  --log-uri s3://my-bucket/emr-logs/
