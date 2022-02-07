Set-Location $PSScriptRoot

Start-Process `
    -WorkingDirectory "$PSScriptRoot\..\..\cloudformation" `
    -FilePath "$PSScriptRoot\..\..\cloudformation\delete.bat" `
    -ArgumentList @("capstone-prv-k8s") `
    -NoNewWindow

Start-Sleep 20

aws cloudformation wait stack-delete-complete --stack-name "capstone-prv-k8s" --region=us-east-1

Start-Process `
    -WorkingDirectory "$PSScriptRoot\..\..\cloudformation" `
    -FilePath "$PSScriptRoot\..\..\cloudformation\delete.bat" `
    -ArgumentList @("capstone-prv-bastion") `
    -NoNewWindow

Start-Sleep 20

aws cloudformation wait stack-delete-complete --stack-name "capstone-prv-bastion" --region=us-east-1


Start-Process `
    -WorkingDirectory "$PSScriptRoot\..\..\cloudformation" `
    -FilePath "$PSScriptRoot\..\..\cloudformation\delete.bat" `
    -ArgumentList @("capstone-prv-network") `
    -NoNewWindow

Start-Sleep 20

aws cloudformation wait stack-delete-complete --stack-name "capstone-prv-network" --region=us-east-1

