$workingLocation = $PSScriptRoot
. ".\shared-data.ps1"

function Main
{
    $remoteUser = $script:remoteUser
    $root = $script:root
    $ec2keyName = $script:ec2keyName
    $ec2Key = $script:ec2Key
    $bastion = Get-Content $script:bastionDnsDataFile

    ssh -tt -i $ec2Key "$bastion" -o "StrictHostKeyChecking no" './master-init.sh'
}

Main