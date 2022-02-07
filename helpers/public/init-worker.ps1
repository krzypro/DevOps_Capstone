$workingLocation = $PSScriptRoot
. ".\shared-data.ps1"

function Main
{
    $remoteUser = $script:remoteUser
    $root = $script:root
    $ec2keyName = $script:ec2keyName
    $ec2Key = $script:ec2Key
    $tmp = "$workingLocation\tmp"

    $workerName = "Capstone K8s Worker"

    $worker = `
        aws ec2 describe-instances `
            --filters "Name=tag:Name,Values=$workerName" "Name=instance-state-name,Values=running" `
            --region=us-east-1 `
            --query 'Reservations[*].Instances[*].PublicDnsName' `
            --output=text
    
    if ($false -eq (Test-Path $tmp))
    {
        New-Item $tmp -ItemType Directory
    }
            
    $nodeScriptsPath = "$root\Capstone\cloudformation\install-scripts"

    $nodeJoinFile = "$tmp\join-node.sh"
    if (Test-Path $nodeJoinFile)
    {
        scp -i $ec2Key -o "StrictHostKeyChecking no" $nodeJoinFile "$remoteUser@$worker`:/home/ubuntu/join-node.sh"    
        ssh -i $ec2Key "$remoteUser@$worker" -o "StrictHostKeyChecking no" 'chmod +x join-node.sh'
    }
    else {
        Write-Warning "Node joining token not found. Will not be added to cluster as part of setup."
    }

    scp -i $ec2Key -o "StrictHostKeyChecking no" $nodeScriptsPath\worker.sh "$remoteUser@$worker`:/home/ubuntu/worker.sh"
    ssh -i $ec2Key "$remoteUser@$worker" -o "StrictHostKeyChecking no" 'chmod +x worker.sh'

    "ssh -i $ec2Key `"$remoteUser@$worker`" -o `"StrictHostKeyChecking no`"" | Out-File "ssh-worker.ps1"
}

Main