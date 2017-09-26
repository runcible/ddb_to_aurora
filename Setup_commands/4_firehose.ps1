<# Create and configure the Lambda data-transformation function for Firehose#>
. .\environment.ps1

$transRole=aws iam create-role `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --role-name $roles.firehoseTransformationRole `
    --assume-role-policy-document  file://../lambda_iam/firehose_lambda_transformation_trust_policy.json `
    --query 'Role.Arn' --output text

aws iam put-role-policy `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --role-name $roles.firehoseTransformationRole `
    --policy-name firehose_lambda_transformation_AccessPolicy `
    --policy-document file://../lambda_iam/firehose_lambda_transformation_AccessPolicy.json

aws iam put-role-policy `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --role-name $lambdaRole `
    --policy-name lambdaRole-Firehose-AccessPolicy `
    --policy-document file://../lambda_iam/lambdaRole-Firehose-AccessPolicy.json

$s3config = 
'{
  \"RoleARN\": \"arn:aws:iam::'+$config.awsAccount+':role/'+$roles.lambdaRole+'\",
  \"BucketARN\": \"arn:aws:s3:::'+$s3Bucket+'\",
  \"Prefix\": \"processed/\",
  \"BufferingHints\": {
    \"SizeInMBs\": 5,
    \"IntervalInSeconds\": 60
  },
  \"CompressionFormat\": \"UNCOMPRESSED\",
  \"CloudWatchLoggingOptions\": {
    \"Enabled\": true,
    \"LogGroupName\": \"'+$firehoseStream+'\",
    \"LogStreamName\": \"'+$firehoseStream+'_firehose_success\"
  },
  \"ProcessingConfiguration\": {
    \"Enabled\": true,
    \"Processors\": [
      {
        \"Type\": \"Lambda\",
        \"Parameters\": [
          {
            \"ParameterName\": \"LambdaArn\",
            \"ParameterValue\": \"arn:aws:lambda:'+$config.awsRegion+':'+$config.awsAccount+':function:zef-tasks\"
          },
          {
            \"ParameterName\": \"NumberOfRetries\",
            \"ParameterValue\": \"3\"
          }
        ]
      }
    ]
  },
  \"S3BackupMode\": \"Enabled\",
  \"S3BackupConfiguration\": {
    \"RoleARN\": \"arn:aws:iam::'+$config.awsAccount+':role/'+$roles.lambdaRole+'\",
    \"BucketARN\": \"arn:aws:s3:::'+$s3Bucket+'\",
    \"Prefix\": \"transformation_failed_data_backup/\",
    \"BufferingHints\": {
      \"SizeInMBs\": 5,
      \"IntervalInSeconds\": 60
    },
    \"CompressionFormat\": \"UNCOMPRESSED\",
  
    \"CloudWatchLoggingOptions\": {
      \"Enabled\": true,
      \"LogGroupName\": \"'+$firehoseStream+'\",
      \"LogStreamName\": \"'+$firehoseStream+'_firehose_data_backup\"
    }
  }
}'

aws firehose create-delivery-stream `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --delivery-stream-name $firehoseStream `
    --extended-s3-destination-configuration=$s3config