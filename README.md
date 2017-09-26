<<<<<<< HEAD
# ddb_to_aurora
Source code which enables Data Replication from DynamoDB to Amazon Aurora. This source code was modified from an AWS Database <a href="https://aws.amazon.com/blogs/database/how-to-stream-data-from-amazon-dynamodb-to-amazon-aurora-using-aws-lambda-and-amazon-kinesis-firehose/">Blog post</a> which shows you how you could implement data replication from dynamodb to Amazon Aurora. It is not production ready.

The 'cfTemplates' folder contains source code for all the cloudformation templates used within the blog post.

The 'lambda_iam' folder contains IAM Policies and the source code (Zip files) for all the Lambda functions used in the blog post.

The 'setup_commands' folder contains Powershell scripts calling AWS CLI for configuring aspectes of the stack after creation, including roles and policies

The cleanup.ps1 file contains the CLI commands to cleanup resources which were created using setup_commands.

=======
# ddb_to_aurora
>>>>>>> 8972c7f734f9972a79bcaa54c3db89dc2fbd99e7
