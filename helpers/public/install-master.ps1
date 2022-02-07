$workingLocation = $PSScriptRoot
. ".\shared-data.ps1"

function Main
{
    $remoteUser = $script:remoteUser
    $root = $script:root
    $ec2keyName = $script:ec2keyName
    $ec2Key = $script:ec2Key
    $tmp = "$workingLocation\tmp"

    $masterName = "Capstone K8s Master"

    $master = `
        aws ec2 describe-instances `
            --filters "Name=tag:Name,Values=$masterName" "Name=instance-state-name,Values=running" `
            --region=us-east-1 `
            --query 'Reservations[*].Instances[*].PublicDnsName' `
            --output=text
    
    if ($false -eq (Test-Path $tmp))
    {
        New-Item $tmp -ItemType Directory
    }
            
    $nodeScriptsPath = "$root\Capstone\cloudformation\install-scripts"

    ssh -tt -i $ec2Key "$remoteUser@$master" -o "StrictHostKeyChecking no" './master.sh'
    scp -i $ec2Key -o "StrictHostKeyChecking no" "$remoteUser@$master`:/home/ubuntu/node-join" "$tmp\join-node.sh"
}

Main