#!/bin/bash
cd $(dirname $0)

#
# Edit zed.rc before running this script
# zed.rc should have the recipient email address
# When running this script, provide a dumby email, as the password is stored in plain text
#



# Install required packages
sudo apt-get install libgsasl7 libntlm0 -y
sudo apt-get install msmtp -y
sudo apt-get install -y msmtp-mta ca-certificates heirloom-mailx


##############################################################################
#configure mail alerts
# Sending emails using Gmail and msmtp
# Author: [Josef Jezek](http://about.me/josefjezek)
# Donate: [Gittip](https://www.gittip.com/josefjezek)
# Link: [Gist](https://gist.github.com/6194563)
# Usage: setup-msmtp-for-gmail.sh
###############################################################################
echo "***************************************************************"
echo "***************************************************************"
echo
echo "CONFIGURING EMAIL CLIENT"
echo "PLEASE PROVIDE A VALID EMAIL ADDRESS AND PASSWORD"
echo
echo "***************************************************************"
echo "***************************************************************"
if command -v zenity >/dev/null; then
  GMAIL_USER=$(zenity --entry --title="Gmail username" --text="Enter your gmail username with domain (username@gmail.com):")
  GMAIL_PASS=$(zenity --entry --title="Gmail password" --text="Enter your gmail password:" --hide-text)
else
  read -p "Gmail username with domain (username@gmail.com): " GMAIL_USER
  read -p "Gmail password: " GMAIL_PASS
fi
echo # an empty line
if [ -z "$GMAIL_USER" ]; then echo "No gmail username given. Exiting."; exit -1; fi
if [ -z "$GMAIL_PASS" ]; then echo "No gmail password given. Exiting."; exit -1; fi
sudo tee /etc/msmtprc >/dev/null <<__EOF
# Accounts will inherit settings from this section
defaults
auth            on
tls             on
tls_certcheck   off
# tls_trust_file  /etc/ssl/certs/ca-certificates.crt
logfile /var/log/msmtp.log
# A first gmail address
account   gmail
host      smtp.gmail.com
port      587
from      $GMAIL_USER
user      $GMAIL_USER
password  $GMAIL_PASS
# A second gmail address
account   gmail2 : gmail
from      username@gmail.com
user      username@gmail.com
password  password
# A freemail service
account   freemail
host      smtp.freemail.example
from      joe_smith@freemail.example
user      joe.smith
password  secret
# A provider's service
account   provider
host      smtp.provider.example
# Set a default account
account default : gmail
__EOF
sudo chmod 600 /etc/msmtprc
sudo chown -R www-data:www-data /etc/msmtprc
HOST=$(hostname)
sudo mail -vs "Email relaying configured at ${HOST}" $GMAIL_USER <<__EOF
The postfix service has been configured at host '${HOST}'.
Thank you for using this postfix configuration script.
__EOF
echo "I have sent you a mail to $GMAIL_USER"
echo "This will confirm that the configuration is good."
echo "Please check your inbox at gmail."



# Enable ZFS email alerts
sudo mv /etc/zfs/zed.d/zed.rc /etc/zfs/zed.d/zed.rc.old
sudo cp zed.rc /etc/zfs/zed.d/zed.rc
sudo chown root:root /etc/zfs/zed.d/zed.rc
sudo chmod 644 /etc/zfs/zed.d/zed.rc
sudo service zed restart
