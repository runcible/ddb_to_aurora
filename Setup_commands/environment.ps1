$awsRegion = "us-east-1"
$awsProfile = "zef"
$awsAccount = 341704623426

$lambdaRole="lambda-dynamodb-execution-role"
$firehoseTransformationRole="firehose_delivery_lambda_transformation_role"
$auroraS3Role="aurora_s3_access_role"
$lambdaAuroraRole="lambda_aurora_role"

$dbClusterId = "zefdb-aurora-databasestack-10z70o-databasecluster-c5921zsx6lqq"
$dbEndpoint= $dbClusterId+".cluster-co03uf1gq571.us-east-1.rds.amazonaws.com"
$dbPrimaryInstance= "zd97kss4zn2epz"
$dbUser="<user>"
$dbPassword="<password>"
$dbName="<dbname>"

$s3bucket = 'dynamo-firehose-aurora'
$firehoseStream = 'nodeMeasures'
$subnetIds = 'subnet-59b34f12,subnet-eb1d2cb1'
$secGrpIds = 'sg-6450cd17'
$lambdaS3toAurora = 'zef-rds'

$config = '{
    "awsRegion" : "'+$awsRegion+'",
    "awsProfile" : "'+$awsProfile+'",
    "awsAccount" : '+$awsAccount+'
}' | ConvertFrom-Json

$roles = '{
    "lambdaRole" : "'+$lambdaRole+'",
    "firehoseTransformationRole" : "'+$firehoseTransformationRole+'",
    "auroraS3Role" : "'+$auroraS3Role+'",
    "lambdaAuroraRole" : "'+$lambdaAuroraRole+'"
}' | ConvertFrom-Json

$dbJson = '{
    "dbClusterId" : "'+$dbClusterId+'",
    "dbEndpoint" : "'+$dbEndpoint+'",
    "dbPrimaryInstance" : "'+$dbPrimaryInstance+'",
    "dbUser" : "'+$dbUser+'",
    "dbPassword" : "'+$dbPassword+'",
    "dbName" :  "'+$dbName+'"
}' | ConvertFrom-Json

