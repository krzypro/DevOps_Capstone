$workingLocation = $PSScriptRoot
. ".\shared-data.ps1"

function Main
{
    $remoteUser = $script:remoteUser
    $root = $script:root
    $ec2keyName = $script:ec2keyName
    $ec2Key = $script:ec2Key

    $workerName = "Capstone K8s Worker"

    $worker = `
        aws ec2 describe-instances `
            --filters "Name=tag:Name,Values=$workerName" "Name=instance-state-name,Values=running" `
            --region=us-east-1 `
            --query 'Reservations[*].Instances[*].PublicDnsName' `
            --output=text
    
    $nodeScriptsPath = "$root\Capstone\cloudformation\install-scripts"

    ssh -tt -i $ec2Key "$remoteUser@$worker" -o "StrictHostKeyChecking no" './worker.sh'
}

Main