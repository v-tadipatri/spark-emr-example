#!/bin/bash
cluster=${1?Specify cluster}
source user_conf.sh
set -x
aws emr add-steps --cluster-id $cluster \
	    --steps Type=Spark,Name="BeamKinesisStep",ActionOnFailure=CONTINUE,Args=[--class,org.cscie88c.beam.BeamKinesisToS3,"--conf","spark.eventLog.enabled=true","--conf","spark.eventLog.dir=s3://$BUCKET/logs/","--conf","spark.history.fs.logDirectory=s3://$BUCKET/logs/",s3://$BUCKET/BeamJob.jar,"--runner=SparkRunner","--experiments=disable_runner_v2"]
