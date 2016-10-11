#!/bin/bash

scriptFile='file://installapp.sh'
keyName='mujahid'
securityGroup='sg-ffa67386'
instanceType='t2.micro'
placementZone='AvailabilityZone=us-west-2b'
availabilityZone='us-west-2b'
count='2'
subnetId='subnet-9e4fd7e8'
loadBalancerName='mujahidelb'
asgLaunchConfigurationName='mujahidLaunchConfig'
asgName='mujahidasg'

aws elb create-load-balancer --load-balancer-name $loadBalancerName --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --subnets $subnetId --security-groups $securityGroup 

aws autoscaling create-launch-configuration --launch-configuration-name $asgLaunchConfigurationName --image-id $1 --key-name $keyName --security-groups $securityGroup --instance-type $instanceType --user-data $scriptFile

aws autoscaling create-auto-scaling-group --auto-scaling-group-name $asgName --launch-configuration-name $asgLaunchConfigurationName --availability-zones $availabilityZone --load-balancer-names $loadBalancerName  --max-size 5 --min-size 1 --desired-capacity 3
