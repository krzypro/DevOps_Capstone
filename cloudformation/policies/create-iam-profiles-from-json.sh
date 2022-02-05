#!/bin/sh -e

aws iam create-role --role-name K8sMaster --assume-role-policy-document file://K8sMaster.00.role.json
aws iam put-role-policy --role-name K8sMaster --policy-name master --policy-document file://K8sMaster.01.master.json
aws iam put-role-policy --role-name K8sMaster --policy-name ecr --policy-document file://K8sMaster.02.ecr.json
aws iam put-role-policy --role-name K8sMaster --policy-name cni --policy-document file://K8sMaster.03.cni.json
aws iam put-role-policy --role-name K8sMaster --policy-name autoscaler --policy-document file://K8sMaster.04.autoscaler.json
aws iam put-role-policy --role-name K8sMaster --policy-name loadbalancing --policy-document file://K8sMaster.05.loadbalancing.json
aws iam create-instance-profile --instance-profile-name K8sMaster
aws iam add-role-to-instance-profile --instance-profile-name K8sMaster --role-name K8sMaster
aws iam create-role --role-name K8sNode --assume-role-policy-document file://K8sNode.00.role.json
aws iam put-role-policy --role-name K8sNode --policy-name node --policy-document file://K8sNode.01.node.json
aws iam put-role-policy --role-name K8sNode --policy-name ecr --policy-document file://K8sNode.02.ecr.json
aws iam put-role-policy --role-name K8sNode --policy-name cni --policy-document file://K8sNode.03.cni.json
aws iam create-instance-profile --instance-profile-name K8sNode
aws iam add-role-to-instance-profile --instance-profile-name K8sNode --role-name K8sNode
