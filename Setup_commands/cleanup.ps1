. .\environment.ps1

<# DeleteStack first #>

<# Delete db cluster parameter group #>
aws rds delete-db-cluster-parameter-group --region $config.awsRegion --profile $config.awsProfile --db-cluster-parameter-group-name "$($firehoseStream)ClusterParamGroup"

<# Delete all roles and access policies created #>
aws iam delete-role-policy --policy-name aurora-s3-access-Policy --region $config.awsRegion --profile $config.awsProfile --role-name $roles.auroraS3Role
#aws iam delete-role-policy --policy-name firehose_lambda_transformation_AccessPolicy --region $config.awsRegion --profile $config.awsProfile --role-name $roles.firehoseTransformationRole
aws iam delete-role-policy --policy-name lambdaRole-DDB-Stream-AccessPolicy --region $config.awsRegion --profile $config.awsProfile --role-name $roles.lambdaRole
aws iam delete-role-policy --policy-name lambdaRole-Firehose-AccessPolicy --region $config.awsRegion --profile $config.awsProfile --role-name $roles.lambdaRole
aws iam delete-role-policy --policy-name lambda-aurora-AccessPolicy --region $config.awsRegion --profile $config.awsProfile --role-name $roles.lambdaAuroraRole

#aws iam delete-role --region $config.awsRegion --profile $config.awsProfile --role-name $roles.firehoseTransformationRole
aws iam delete-role --region $config.awsRegion --profile $config.awsProfile --role-name $roles.lambdaAuroraRole
aws iam delete-role --region $config.awsRegion --profile $config.awsProfile --role-name $roles.auroraS3Role

<# Delete the firehose stream #>
aws firehose delete-delivery-stream --region $config.awsRegion --profile $config.awsProfile --delivery-stream-name $firehoseStream

