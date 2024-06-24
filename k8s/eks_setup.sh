#!/bin/bash

install_eksctl() {
	if which eksctl &>/dev/null; then
	    echo "eksctl is already installed...."
	else
		echo "  Installing eksctl..."
		# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
		ARCH=amd64
		PLATFORM=$(uname -s)_$ARCH

		curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

		# (Optional) Verify checksum
		curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

		tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

		sudo mv /tmp/eksctl /usr/local/bin
	fi
}


install_kubectl() {
	if which kubectl &>/dev/null; then
	    echo "kubectl is already installed...."
	else
		echo "  Installing kubectl..."
		wget https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/kubectl
		chmod +x ./kubectl
		mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
		kubectl version --short --client
	fi
}

access_key=$(aws configure get aws_access_key_id)

echo -e 'Hoping IAM user got below roles \n    1. AmazonEC2FullAccess \n    2. AWSCloudFormationFullAccess \n    3. EksAllAccess \n    4. IamLimitedAccess (https://eksctl.io/usage/minimum-iam-policies/)\n\nHave you configured the AWS CLI with IAM user with above access using aws configure: '



if [[ -n $access_key ]]; then
    install_eksctl
    install_kubectl
    eksctl create cluster --name itdefined --version 1.30 --region ap-south-1 --nodegroup-name itdefined-workers --node-type t2.micro --nodes 2 --nodes-min 1 --nodes-max 3 --managed
else
    echo "Exiting EKS installation, comeback with IAM user..."
    echo -e 'Need a IAM user with below roles \n    1. AmazonEC2FullAccess \n    2. AWSCloudFormationFullAccess \n    3. EksAllAccess \n    4. IamLimitedAccess (https://eksctl.io/usage/minimum-iam-policies/)\n'
fi
