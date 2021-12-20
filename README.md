# Docker backup

This is a small shell script to backup running docker containers along with their volumes

# Usage

Edit the `docker_bckup.sh` by modifying the function `backup_docker_dump` to suit your need

> The script will throw an error `E: please implement a backup strategy for 'container-name'` if not implemented properly

then run the script with `/bin/bash docker_backup.sh`

# Automatic backup

Automatic backup can be configure in crontab, here's few examples

```crontab
# run the script every 6 hours
0 */6 * * * /bin/bash /opt/docker_backup.sh > /dev/null 2>&1

# run the script every morning at 7:00 AM
0 7 * * * /bin/bash /opt/docker_backup.sh > /dev/null 2>&1
```

# Logging

The logs are stored in `/var/log/docker_backup.log`