<# Create and configure the Lambda function to access VPC resources#>
. .\environment.ps1

<# Create an IAM execution role for the Lambda function#>
 $auroraLambdaRole=aws iam create-role `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --role-name $roles.lambdaAuroraRole `
    --assume-role-policy-document file://../lambda_iam/lambda-aurora-Trust-Policy.json `
    --query 'Role.Arn' --output text

aws iam put-role-policy `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --role-name $roles.lambdaAuroraRole `
    --policy-name lambda-aurora-AccessPolicy `
    --policy-document file://../lambda_iam/lambda-aurora-AccessPolicy.json

<# Create the Lambda function specifying a VPC configuration #>
$envVars = 
'{
  \"Variables\": {
      \"AuroraEndpoint\": \"'+$dbJson.dbEndpoint+'\",
      \"dbUser\": \"'+$dbJson.dbUser+'\",
      \"dbPassword\": \"'+$dbJson.dbPassword+'\",
      \"dbName\": \"'+$dbJson.dbName+'\"
  }
}'

aws lambda update-function-configuration `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --function-name $lambdaS3toAurora `
    --role $("arn:aws:iam::$($awsAccount):role/$($roles.lambdaAuroraRole)") `
    --timeout 30 `
    --vpc-config SubnetIds=$subnetIds,SecurityGroupIds=$secGrpIds `
    --memory-size 1024 `
    --environment=$envVars

<# Grant S3 the permissions to invoke a Lambda function#>
aws lambda add-permission `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --function-name 'zef-rds' `
    --action “lambda:InvokeFunction” `
    --statement-id Demo1234 `
    --principal s3.amazonaws.com `
    --source-arn "arn:aws:s3:::$($s3Bucket)" `
    --source-account $config.awsAccount

<# Configure S3 bucket notification#>
$lambdaConfig= '{  
  \"LambdaFunctionConfigurations\": [
    {
      \"Id\": \"'+$firehoseStream+'\",
      \"LambdaFunctionArn\": \"arn:aws:lambda:'+$config.awsRegion+':'+$config.awsAccount+':function:zef-rds\",
      \"Events\": [\"s3:ObjectCreated:*\"],
      \"Filter\": {
        \"Key\": {
          \"FilterRules\": [
            {
              \"Name\": \"prefix\",
              \"Value\": \"processed/2\"
            }            
          ]
        }
      }
    }    
  ]
}' 
aws s3api put-bucket-notification-configuration `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --bucket $s3Bucket `
    --notification-configuration=$lambdaConfig