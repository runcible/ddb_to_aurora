<# Configure DynamoDB streams and the Lambda function that processes the streams #>
. .\environment.ps1

<# Update the Lambda execution role #>

aws iam update-assume-role-policy `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --role-name $roles.lambdaRole `
    --policy-document file://../lambda_iam/lambdaRole-Trust-Policy.json

aws iam put-role-policy `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --role-name $roles.lambdaRole `
    --policy-name lambdaRole-DDB-Stream-AccessPolicy  `
    --policy-document file://../lambda_iam/lambdaRole-DDB-Stream-AccessPolicy.json
