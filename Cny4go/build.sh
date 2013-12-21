#!/bin/bash
##############################
#####Setting Environments#####
echo "Setting Environments"
set -e
export PATH=$PATH:$GOPATH/bin:$HOME/bin
export GOPATH=$GOPATH:`pwd`

##############################
######Install Dependence######
echo "Installing Dependence"
#go get github.com/axw/gocov/gocovs

##############################
#########Running Test#########
echo "Running Test"
pkgs="\
 github.com/Centny/Cny4go/smartio\
 github.com/Centny/Cny4go/log\
"
for p in $pkgs;
do
 echo $p
done
exit 1
gocov test\
 github.com/Centny/Cny4go/smartio\
 github.com/Centny/Cny4go/log\
>coverage.json

##############################
#####Create Coverage Report###
echo "Create Coverage Report"
cat coverage.json | gocov-xml -b `pwd`/src > coverage.xml
