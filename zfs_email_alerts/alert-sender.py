# Import smtplib for the actual sending function
import os
import sys
import smtplib
import mimetypes
from email.Encoders import encode_base64
from email.MIMEBase import MIMEBase
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText

def sendAlertMail(subj, body):
        #print("sending mail...")
        FROM = 'my@email.com'
        TO = 'my@email.com'
        MAILSERVER = 'smtp.mail.com'
        PORT = 465
        MLOGIN = 'mylogin'
        MPASSWORD = 'mypassword'

        try:
                s = smtplib.SMTP_SSL(MAILSERVER, PORT)
                #s.set_debuglevel(1)
                s.login(MLOGIN, MPASSWORD)

                msg = MIMEMultipart()
                msg['From'] = FROM
                msg['To'] = TO
                msg['Subject'] = subj
                msg.attach(MIMEText(body))

                #send it
                s.sendmail(FROM, TO.split(";"), msg.as_string())
                #print("sending successful")
                s.quit()
                s.close()
        except Exception as e:
                print(e)
                sys.exit(1)

        sys.exit(0)

# test emailing
#sendAlertMail('ZFS alert test', os.popen("/sbin/zpool status").read().strip())

# zpool checking
if os.popen("/sbin/zpool status -x").read().strip() != "all pools are healthy":
        sendAlertMail("ZFS alert: zpool error", os.popen("/sbin/zpool status").read().strip())

# SMART checking
# include disks to be checked in the list
disks = ['/dev/disk/by-id/ata-WDC_WD...', '/dev/disk/by-id/ata-WDC_WD...']
for disk in disks:
        s = os.popen('/usr/sbin/smartctl -H ' + disk + ' | grep "SMART overall-health self-assessment test result"').read().strip()
        if s != "SMART overall-health self-assessment test result: PASSED":
                sendAlertMail("ZFS NAS alert: SMART error", os.popen('/usr/sbin/smartctl -a ' + disk).read().strip())

sys.exit(0)
