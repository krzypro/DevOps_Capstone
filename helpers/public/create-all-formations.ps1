Set-Location $PSScriptRoot

Start-Process `
    -WorkingDirectory "$PSScriptRoot\..\..\cloudformation" `
    -FilePath "$PSScriptRoot\..\..\cloudformation\create.bat" `
    -ArgumentList @("capstone-pub-network", "k8s-public-net\network.yml", "k8s-public-net\network-params.json") `
    -NoNewWindow

Start-Sleep 20

aws cloudformation wait stack-create-complete --stack-name "capstone-pub-network" --region=us-east-1

Start-Process `
    -WorkingDirectory "$PSScriptRoot\..\..\cloudformation" `
    -FilePath "$PSScriptRoot\..\..\cloudformation\create.bat" `
    -ArgumentList @("capstone-pub-k8s", "k8s-public-net\k8s-hosts.yml", "k8s-public-net\k8s-hosts.json") `
    -NoNewWindow

Start-Sleep 20

aws cloudformation wait stack-create-complete --stack-name "capstone-pub-k8s" --region=us-east-1