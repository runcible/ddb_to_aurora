
. .\environment.ps1

aws s3api create-bucket `
--region $config.awsRegion `
--profile $config.awsProfile `
--bucket $s3Bucket

aws s3api put-object `
--region $config.awsRegion `
--profile $config.awsProfile `
--bucket $s3Bucket `
--key processed/


aws s3api put-object `
--region $config.awsRegion `
--profile $config.awsProfile `
--bucket $s3Bucket `
--key transformation_failed_data_backup/