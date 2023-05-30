# zmBackup systemd Timer

Based on [zmBackp](https://github.com/lucascbeyeler/zmbackup)

## Prerequisites

* sendmail/procmail utility
* root permissions

## Setup

* Modify the email address to receive the log in case of failure: In the file zmBackup_email@.service set the $ADDRESS variable with your email address

* Modify zmBackup.sh with the correct mount/unmount command

* Copy the sh file to /usr/local/bin
```
cp zmBackup.sh systemd-email /usr/local/bin
```
* Set the appropriate permissions
```
chmod 755 /usr/local/bin/zmbackup.sh /usr/local/bin/systemd-email
```
* Copy the systemd files to /etc/systemd/system
```
cp *.service *timer /etc/systemd/system
```
* Enable the timer
```
systemctl enable zmBackup.timer
```

**that's it**

You can check the timer with:
```
systemctl list-timers
```

Start the backup now

```
systemctl start zmBackup.service
```


