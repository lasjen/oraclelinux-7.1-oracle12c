#!/bin/bash

export ORACLE_HOSTNAME=oracle12c.localdomain
export ORACLE_UNQNAME=orcl
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/12.1.0/db_1
export ORACLE_SID=cdb12c

#prerequisites
sudo yum -y install unzip
sudo yum -y install oracle-rdbms-server-12cR1-preinstall
sudo cp /tmp/database_installer/env/etc/hosts /etc/hosts
sudo cp /tmp/database_installer/env/etc/sysconfig/network /etc/sysconfig/network
sudo /etc/init.d/network restart

sudo hostname oracle12c.localdomain

cd /tmp/database_installer/source

unzip linuxamd64_12102_database_1of2.zip
unzip linuxamd64_12102_database_2of2.zip

cd /home/oracle

#copy in oracle .bash_profile

sudo -Eu oracle cp /tmp/database_installer/env/bash_profile /home/oracle/.bash_profile 

#create /u01 directory

sudo rm -r -f /u01
sudo mkdir /u01
sudo chown oracle:oinstall /u01

#run oracle installer

cd /tmp/database_installer/source/database

sudo -Eu oracle ./runInstaller -showProgress -silent -waitforcompletion -ignoreSysPrereqs \
-responseFile /tmp/database_installer/response_file/oracle12c.rsp

errorlevel=$?

if [ "$errorlevel" != "0" ] && [ "$errorlevel" != "6" ]; then
  echo "There was an error preventing script from continuing"
  exit 1
fi

#install patches before creating databases
sudo su - oracle /tmp/database_installer/patches/installpatch.sh

cd

#clean up database_installer directory
rm -r -f /tmp/database_installer/source/database

#run the root scripts

sudo /u01/app/oraInventory/orainstRoot.sh

sudo /u01/app/oracle/product/12.1.0/db_1/root.sh

#configure listener

#SRC=/tmp/database_installer/env/listener.ora
DEST=$ORACLE_HOME/network/admin/listener.ora
#sudo cp $SRC $DEST
#sudo chown oracle:oinstall $DEST
#sudo chmod 0644 $DEST
sudo rm $DEST

#start listener

sudo -Eu oracle $ORACLE_HOME/bin/lsnrctl start

#install oracle service
SRC=/tmp/database_installer/env/etc/init.d/oracle
DEST=/etc/init.d/oracle
sudo cp $SRC $DEST
sudo chmod 0755 $DEST

#set oracle service to start at boot
sudo chkconfig oracle on

#sqlplus startup config file
SRC=/tmp/database_installer/env/glogin.sql
DEST=$ORACLE_HOME/sqlplus/admin/glogin.sql
sudo cp $SRC $DEST
sudo chown oracle:oinstall $DEST
sudo chmod 0644 $DEST

#create the container and a pluggable database

sudo -Eu oracle $ORACLE_HOME/bin/dbca -silent \
-createDatabase \
-templateName General_Purpose.dbc \
-gdbName cdb12c \
-sid cdb12c \
-createAsContainerDatabase true \
-numberOfPdbs 1 \
-pdbName pdb \
-pdbadminUsername vagrant \
-pdbadminPassword vagrant \
-SysPassword vagrant \
-SystemPassword vagrant \
-emConfiguration NONE \
-datafileDestination /u01/oradata \
-storageType FS \
-characterSet AL32UTF8 \
-memoryPercentage 40 \
-listeners LISTENER

#tnsnames.ora
SRC=/tmp/database_installer/env/tnsnames.ora
DEST=$ORACLE_HOME/network/admin/tnsnames.ora
sudo cp $SRC $DEST
sudo chown oracle:oinstall $DEST
sudo chmod 0644 $DEST

#oratab
SRC=/tmp/database_installer/env/etc/oratab
DEST=/etc/oratab
sudo cp $SRC $DEST
sudo chown oracle:oinstall $DEST
sudo chmod 0644 $DEST

