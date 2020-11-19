#!/bin/sh

logName="logFile.log"
rm $logName

START_TIME=$SECONDS
echo  ----------- Start ----------- | tee -a $logName

# var waitTime 
declare -i waitTime=30

# Orgs: This can be user name Or alias
SrcOrg="" 
DestOrg=""

# Change Set Name || Packege Name
CSName=""

# Folders/Files Name 

readyToDeployFileName="readyToDeploy.zip"
backupFolderName="backupFolder"
backupFileName="backupZip.zip"
# NoTestRun, RunSpecifiedTests, RunLocalTests, RunAllTestsInOrg
testLevel="RunLocalTests"

# Remove Old Files/Folders
rm $readyToDeployFileName
rm -rf $backupFolderName

sfdx force:mdapi:retrieve -u $SrcOrg -p $CSName -w $waitTime -r . | tee -a $logName
if [ "$?" = "1" ]
then 
    echo "Can't retrieve your source."| tee -a $logName
    exit 1
fi
echo OK : retrieve succsess | tee -a $logName
sfdx force:mdapi:deploy -f unpackaged.zip -u $DestOrg -w $waitTime -l $testLevel -c | tee -a $logName
if [ "$?" = "1" ]
then 
     echo "Can't deploy your unpackaged.zip."| tee -a $logName
     rm unpackaged.zip | tee -a $logName
     exit 1
fi
echo OK , rename Zip file to be $readyToDeployFileName | tee -a $logName
echo OK , start backup | tee -a $logName
mkdir $backupFolderName | tee -a $logName
unzip -p unpackaged.zip $CSName/package.xml > $backupFolderName/package.xml
sfdx force:mdapi:retrieve -u $DestOrg -k $backupFolderName/package.xml -w $waitTime -r $backupFolderName/ | tee -a $logName 
if [ "$?" = "1" ]
then 
    echo "Can't retrieve your backup."| tee -a $logName
    exit 1
fi
mv -f $backupFolderName/unpackaged.zip $backupFolderName/$backupFileName | tee -a $logName
mv -f unpackaged.zip $readyToDeployFileName | tee -a $logName
   
ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "Full procees in:  $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"  | tee -a $logName
echo  ----------- End ----------- | tee -a $logName
exit 0
