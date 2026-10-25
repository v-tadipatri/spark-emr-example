#!/bin/bash
source user_conf.sh
timestamp=$(date +%Y%m%d%H%M%S)
job_name="TestJob-$timestamp"
jar_path="s3://$BUCKET/spark-emr-example.jar"
class_name="com.example.SparkWordCountApp"
arg_list="[\"s3://$BUCKET/input/infile.txt\",\"s3://$BUCKET/output/job-$timestamp/\" ]"
set -x
aws emr-serverless start-job-run \
  --application-id $APP_ID \
  --execution-role-arn $EMR_ROLE_ID \
  --name "$job_name" \
  --job-driver '{
      "sparkSubmit": {
        "entryPoint": "'"$jar_path"'",
        "entryPointArguments": '"$arg_list"',
        "sparkSubmitParameters": "--class '"$class_name"' --conf spark.hadoop.mapreduce.fileoutputcommitter.algorithm.version=2 --conf spark.hadoop.fs.s3a.committer.name=directory --conf spark.hadoop.mapreduce.outputcommitter.factory.scheme.s3a=org.apache.hadoop.fs.s3a.commit.S3ACommitterFactory --conf spark.sql.parquet.output.committer.class=org.apache.hadoop.mapreduce.lib.output.DirectFileOutputCommitter"
      }
    }'
  
