Set-Location $PSScriptRoot

Start-Process `
    -WorkingDirectory "$PSScriptRoot\..\..\cloudformation" `
    -FilePath "$PSScriptRoot\..\..\cloudformation\create.bat" `
    -ArgumentList @("capstone-prv-network", "k8s-private-net-with-bastion\network.yml", "k8s-private-net-with-bastion\network-params.json") `
    -NoNewWindow

Start-Sleep 20

aws cloudformation wait stack-create-complete --stack-name "capstone-prv-network" --region=us-east-1

Start-Process `
    -WorkingDirectory "$PSScriptRoot\..\..\cloudformation" `
    -FilePath "$PSScriptRoot\..\..\cloudformation\create.bat" `
    -ArgumentList @("capstone-prv-bastion", "k8s-private-net-with-bastion\bastion.yml", "k8s-private-net-with-bastion\bastion-params.json") `
    -NoNewWindow

Start-Sleep 20

aws cloudformation wait stack-create-complete --stack-name "capstone-prv-bastion" --region=us-east-1

Start-Process `
    -WorkingDirectory "$PSScriptRoot\..\..\cloudformation" `
    -FilePath "$PSScriptRoot\..\..\cloudformation\create.bat" `
    -ArgumentList @("capstone-prv-k8s", "k8s-private-net-with-bastion\k8s-hosts.yml", "k8s-private-net-with-bastion\k8s-hosts.json") `
    -NoNewWindow

Start-Sleep 20

aws cloudformation wait stack-create-complete --stack-name "capstone-prv-k8s" --region=us-east-1