<# Configure an Aurora DB cluster
Once the CloudFormation stack is complete, you must modify the Aurora cluster 
in order to load data into the DB cluster from text files in an S3 bucket
#>
. .\environment.ps1

<# Allow Amazon Aurora to access Amazon S3 by creating an IAM role 
and attaching the trust and access policy that’s been created. #>
$auroraS3Arn = aws iam create-role `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --role-name $roles.auroraS3Role `
    --assume-role-policy-document file://../lambda_iam/aurora-s3-Trust-Policy.json `
    --query 'Role.Arn' `
    --output text

<# !! Ensure the BUCKET listed in this policy document is correct !! #>
aws iam put-role-policy `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --role-name $roles.auroraS3Role `
    --policy-name aurora-s3-access-Policy `
    --policy-document file://../lambda_iam/aurora-s3-access-Policy.json

<# Associate that IAM role with your Aurora DB cluster by creating a 
new DB cluster parameter group and associating this new parameter group with the DB cluster #>
aws rds add-role-to-db-cluster `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --db-cluster-identifier $dbJson.dbClusterId `
    --role-arn $auroraS3Arn

aws rds create-db-cluster-parameter-group `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --db-cluster-parameter-group-name "$($firehoseStream)ClusterParamGroup" `
    --db-parameter-group-family aurora5.6 `
    --description 'Aurora cluster parameter group - Allow access to Amazon S3'

aws rds modify-db-cluster-parameter-group `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --db-cluster-parameter-group-name "$($firehoseStream)ClusterParamGroup" `
    --parameters "ParameterName=aws_default_s3_role,ParameterValue=$auroraS3Arn,ApplyMethod=pending-reboot"

aws rds modify-db-cluster `
    --region $config.awsRegion `
    --profile $config.awsProfile `
	--db-cluster-identifier $dbJson.dbClusterId `
	--db-cluster-parameter-group-name "$($firehoseStream)ClusterParamGroup"

<# Reboot the primary DB instance #>
aws rds reboot-db-instance `
    --region $config.awsRegion `
    --profile $config.awsProfile `
    --db-instance-identifier $dbJson.dbPrimaryInstance