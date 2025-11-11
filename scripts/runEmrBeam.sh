#!/bin/bash
cluster=${1?Specify cluster}
aws emr add-steps --cluster-id $cluster \
	    --steps Type=Spark,Name="BeamKinesisStep",ActionOnFailure=CONTINUE,Args=[--class,org.cscie88c.beam.BeamKinesisToS3,s3://aws-vtadipatri-bucket/BeamJob.jar]
