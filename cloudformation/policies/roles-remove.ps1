aws iam remove-role-from-instance-profile --instance-profile-name K8sNode --role-name K8sNode
aws iam delete-instance-profile --instance-profile-name K8sNode
aws iam delete-role-policy --role-name K8sNode --policy-name cni
aws iam delete-role-policy --role-name K8sNode --policy-name ecr
aws iam delete-role-policy --role-name K8sNode --policy-name node
aws iam delete-role --role-name K8sNode

aws iam remove-role-from-instance-profile --instance-profile-name K8sMaster --role-name K8sMaster
aws iam delete-instance-profile --instance-profile-name K8sMaster
aws iam delete-role-policy --role-name K8sMaster --policy-name loadbalancing
aws iam delete-role-policy --role-name K8sMaster --policy-name autoscaler
aws iam delete-role-policy --role-name K8sMaster --policy-name cni
aws iam delete-role-policy --role-name K8sMaster --policy-name ecr
aws iam delete-role-policy --role-name K8sMaster --policy-name master
aws iam delete-role --role-name K8sMaster