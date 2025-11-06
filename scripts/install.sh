#!/bin/bash
basedir=`pwd`
instdir=.install
rm -Rf $instdir
mkdir $instdir
cd $instdir
echo "Installing aws"
check=`which aws2`
if [ "$check" = "" ]
then
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
	echo "Using profile configured by AWS_PROFILE=$AWS_PROFILE ."
	echo "Run 'aws configure' again for a different profile"
	echo "Click a user here: https://us-east-1.console.aws.amazon.com/iam/home?region=us-east-1#/users , and create access key"
	echo "Enter 'us-east-1' for example for region"
	aws configure 
fi
if [ "$check" = "" ]
then
	curl https://install.duckdb.org | sh
	set -x
	export PATH="/home/$USER/.duckdb/cli/latest:$PATH"
	set +x
fi
if [ ! -f 'user_conf.sh' ]
then
	cd $basedir
	cp -v tpl/example_user_conf.sh user_conf.sh
	echo "Please update user_conf.sh"
fi
