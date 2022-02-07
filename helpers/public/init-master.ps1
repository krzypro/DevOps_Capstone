$workingLocation = $PSScriptRoot
. ".\shared-data.ps1"

function Main
{
    $remoteUser = $script:remoteUser
    $root = $script:root
    $ec2keyName = $script:ec2keyName
    $ec2Key = $script:ec2Key

    $masterName = "Capstone K8s Master"

    $master = `
        aws ec2 describe-instances `
            --filters "Name=tag:Name,Values=$masterName" "Name=instance-state-name,Values=running" `
            --region=us-east-1 `
            --query 'Reservations[*].Instances[*].PublicDnsName' `
            --output=text
    
            $master
            
    $nodeScriptsPath = "$root\Capstone\cloudformation\install-scripts"

    scp -i $ec2Key -o "StrictHostKeyChecking no" "$nodeScriptsPath\master.sh" "$remoteUser@$master`:/home/ubuntu/"
    ssh -i $ec2Key "$remoteUser@$master" -o "StrictHostKeyChecking no" 'chmod +x master.sh'

    scp -i $ec2Key -o "StrictHostKeyChecking no" "$root\Capstone\.circleci\files\*.*" "$remoteUser@$master`:/home/ubuntu/"

    "ssh -i $ec2Key `"$remoteUser@$master`" -o `"StrictHostKeyChecking no`"" | Out-File "ssh-master.ps1"
    "scp -i $ec2Key -o `"StrictHostKeyChecking no`" %1 `"$remoteUser@$master`:/home/ubuntu/`"" | Out-File "copy-to-master.ps1"


}

Main