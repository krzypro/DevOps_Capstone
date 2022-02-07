Set-Location $PSScriptRoot

Start-Process `
    -WorkingDirectory "$PSScriptRoot\..\..\cloudformation" `
    -FilePath "$PSScriptRoot\..\..\cloudformation\delete.bat" `
    -ArgumentList @("capstone-pub-k8s") `
    -NoNewWindow

Start-Sleep 20

aws cloudformation wait stack-delete-complete --stack-name "capstone-pub-k8s" --region=us-east-1

Start-Process `
    -WorkingDirectory "$PSScriptRoot\..\..\cloudformation" `
    -FilePath "$PSScriptRoot\..\..\cloudformation\delete.bat" `
    -ArgumentList @("capstone-pub-network") `
    -NoNewWindow

Start-Sleep 20

aws cloudformation wait stack-delete-complete --stack-name "capstone-pub-network" --region=us-east-1

