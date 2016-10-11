#!/bin/bash

loadBalancerName='mujahidelb'
asgLaunchConfigurationName='mujahidLaunchConfig'
asgName='mujahidasg'

instanceId=`aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId]' --filter Name=instance-state-name,Values=running`
aws ec2 terminate-instances --instance-ids $instanceId --output text --query 'TerminatingInstances[*].CurrentState.Name'
aws ec2 wait instance-terminated --instance-ids $instanceId
aws elb deregister-instances-from-load-balancer --load-balancer-name $loadBalancerName --instances $instanceId
aws elb delete-load-balancer-listeners --load-balancer-name $loadBalancerName --load-balancer-ports 80
aws elb delete-load-balancer --load-balancer-name $loadBalancerName 
aws autoscaling update-auto-scaling-group --auto-scaling-group-name $asgName --launch-configuration-name $asgLaunchConfigurationName --min-size 0 --max-size 0
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $asgName --force-delete 
aws autoscaling delete-launch-configuration --launch-configuration-name $asgLaunchConfigurationName 
