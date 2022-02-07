$workingLocation = $PSScriptRoot
. ".\shared-data.ps1"

function Main
{
    $remoteUser = $script:remoteUser
    $root = $script:root
    $ec2keyName = $script:ec2keyName
    $ec2Key = $script:ec2Key
    $bastionDnsDataFile = $script:bastionDnsDataFile
    $tmp = "$workingLocation\tmp"

    $bastionName = "Capstone SSH Bastion"
    $masterName = "Capstone K8s Master"
    $workerName = "Capstone K8s Worker"

    $bastion = `
        aws ec2 describe-instances `
            --filters Name=tag:Name,Values=$bastionName "Name=instance-state-name,Values=running" `
            --region=us-east-1 `
            --query 'Reservations[*].Instances[*].PublicDnsName' `
            --output=text

    $master = `
        aws ec2 describe-instances `
            --filters "Name=tag:Name,Values=$masterName" "Name=instance-state-name,Values=running" `
            --region=us-east-1 `
            --query 'Reservations[*].Instances[*].PrivateDnsName' `
            --output=text

    $worker = `
        aws ec2 describe-instances `
            --filters "Name=tag:Name,Values=$workerName" "Name=instance-state-name,Values=running" `
            --region=us-east-1 `
            --query 'Reservations[*].Instances[*].PrivateDnsName' `
            --output=text


    if ($false -eq (Test-Path $tmp))
    {
        New-Item $tmp -ItemType Directory
    }

    "$remoteUser@$bastion" | Out-File $bastionDnsDataFile

    Get-ChildItem $tmp -Recurse | Remove-Item

    $masterInitScript = "$tmp/master-init.sh"
    "#!/bin/bash" | Out-File -Encoding ASCII $masterInitScript 
    "scp -i $ec2keyName -o `"StrictHostKeyChecking no`" master.sh $remoteUser@$master`:/home/ubuntu" | Out-File -Encoding ASCII -Append $masterInitScript
    "ssh -i $ec2keyName $remoteUser@$master -o `"StrictHostKeyChecking no`" 'chmod +x master.sh'" | Out-File -Encoding ASCII -Append $masterInitScript
    Convert-WinToLinux $masterInitScript

    $masterConnectScript = "$tmp/master-connect.sh"
    "#!/bin/bash" | Out-File $masterConnectScript -Encoding ASCII
    "ssh -i $ec2keyName $remoteUser@$master -o `"StrictHostKeyChecking no`"" | Out-File $masterConnectScript -Append -Encoding ASCII
    Convert-WinToLinux $masterConnectScript

    $workerInitScript = "$tmp/worker-init.sh"

    "#!/bin/bash" | Out-File $workerInitScript -Encoding ASCII
    "scp -i $ec2keyName -o `"StrictHostKeyChecking no`" worker.sh $remoteUser@$worker`:/home/ubuntu" | Out-File $workerInitScript -Append -Encoding ASCII
    "ssh -i $ec2keyName $remoteUser@$worker -o `"StrictHostKeyChecking no`" 'chmod +x worker.sh'" | Out-File $workerInitScript -Append -Encoding ASCII
    Convert-WinToLinux $workerInitScript

    $workerConnectScript = "$tmp/worker-connect.sh"
    "#!/bin/bash" | Out-File $workerConnectScript -Encoding ASCII
    "ssh -i $ec2keyName $remoteUser@$worker -o `"StrictHostKeyChecking no`"" | Out-File $workerConnectScript -Append -Encoding ASCII
    Convert-WinToLinux $workerConnectScript

    $nodeScriptsPath = "$root\Capstone\cloudformation\install-scripts"
    $remotePath = "$remoteUser@$bastion`:/home/ubuntu/"

    scp -i $ec2Key -o "StrictHostKeyChecking no" $ec2Key $remotePath
    scp -i $ec2Key -o "StrictHostKeyChecking no" "$nodeScriptsPath\bastion-setup.sh" $remotePath
    scp -i $ec2Key -o "StrictHostKeyChecking no" "$nodeScriptsPath\master.sh" $remotePath
    scp -i $ec2Key -o "StrictHostKeyChecking no" "$nodeScriptsPath\worker.sh" $remotePath
    scp -i $ec2Key -o "StrictHostKeyChecking no" "$tmp\*" $remotePath

    ssh -i $ec2Key "$remoteUser@$bastion" -o "StrictHostKeyChecking no" 'chmod +x bastion-setup.sh && ./bastion-setup.sh'

    # ssh -i $ec2Key "$remoteUser@$bastion" -o "StrictHostKeyChecking no"
}

function Convert-WinToLinux($filepath)
{
    (Get-Content $filepath | Out-String) -replace "`r`n", "`n" | Out-File $filepath -Encoding ASCII -NoNewLine
}

Main