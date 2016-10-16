#!/bin/bash

#declaring variables
instanceType='t2.micro'
placementZone='AvailabilityZone=us-west-2b'
availabilityZone='us-west-2b'
subnetId='subnet-9e4fd7e8'
loadBalancerName='mujahidelb'
asgName='mujahidasg'
scriptFile='file://installapp.sh'

#if logic to verify the count of total parameters is 5
if [ $# != 5 ]
then echo "To run this script, provide 5 arguments in the following order. 
 
 1. AMI-IMAGE ID 
 2. Key Name  
 3. Security Group 
 4. Launch Configuration 
 5. Count

Not less, not more. Else, the script will fail just like it has this time"
else
		echo "AMI IMAGE ID: $1"
		echo "Key Name: $2"
		echo "Security Group: $3"
		echo "Launch Config: $4"
		echo "Count: $5"		
		aws elb create-load-balancer --load-balancer-name $loadBalancerName --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --subnets $subnetId --security-groups $3
 
		aws autoscaling create-launch-configuration --launch-configuration-name $4 --image-id $1 --key-name $2 --security-groups $3 --instance-type $instanceType --user-data $scriptFile

		aws autoscaling create-auto-scaling-group --auto-scaling-group-name $asgName --launch-configuration-name $4 --availability-zones $availabilityZone --load-balancer-names $loadBalancerName  --max-size 5 --min-size 1 --desired-capacity 4
fi   
