
. .\environment.ps1

$invokePath = Split-Path $MyInvocation.MyCommand.Path

Invoke-Expression "$invokePath\1_s3.ps1"

<# Invoke-Expression "$invokePath\2_aurora.ps1"

Invoke-Expression "$invokePath\3_dynamodb_to_s3.ps1"

Invoke-Expression "$invokePath\4_firehose.ps1"

Invoke-Expression "$invokePath\5_s3_to_aurora.ps1" #>

