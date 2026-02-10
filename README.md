# Backup_Nas_Sender
This script automatically backs up files from your laptop to a Raspberry Pi NAS using rsync over SSH. It maintains incremental backups with dated folders for changed/deleted files.

## Features

- Incremental backups - Only transfers changed files
- Version history - Keeps dated folders of changed/deleted files
- Automated logging - Creates backup logs for each run
- SSH key authentication - No password prompts
- Scheduled execution - Runs weekly via anacron

## Built With

- **Hardware:** Raspberry Pi 3 B+, HDD 3.5" of 4TB storage, Ethernet cable, 64gb SD card.
- **Software** WSL, Raspberry pi imager.

## Getting Started

### Prerequisites
- Python 3.8+
- pip
- rsync
- SSH
- Anacron
- Already having a NAS share folder 

### Installation

1. if you don't have a NAS share folder please follow this video https://www.youtube.com/watch?v=gyMpI8csWis&t=338s
   
2.  Clone the repository
```
git clone https://github.com/Pachakuteq/Backup_Nas_Sender.git
```

3. Create your .env file on the same directory as your backup_script.sh file and called it backup.env
```
## Add this:

#!/bin/bash

PI_USER="pi" <-- your Raspberry Pi User
PI_PATH="/srv/path/to/your/share folder"  
PI_HOST="pi.ip.address"
```

4. Set up SSH Keys (One-time setup)
```
#Generate SSH key
ssh-keygen -t rsa -b 4096

# Copy key to Raspberry Pi
ssh-copy-id pi@pi.ip.address
```

5. Create Scripts Directory
```
mkdir -p ~/scripts
cd ~/scripts
```

6. copy script to ~/scripts/
```
cp "/.../backup_script.sh" ~/scripts/
cp "/.../backup.env" ~/scripts/
```

8. Make Script Executable
```
chmod +x ~/scripts/backup_script.sh
```

9. Test it and it should appear the source directory in the share folder
```
bash ~/scripts/backup_script.sh "/path/to/source/directory"

## How It Works

1. **Creates backup directory** on Pi if it doesn't exist
2. **Syncs files** from source to `BackUp-files/` on Pi
3. **Saves changed/deleted files** to dated folder (e.g., `2026-02-09/`)
4. **Creates log file** documenting the backup operation
5. **Transfers log** to Pi for record-keeping
```

10. install anacron
```
sudo apt install anacron
```

11. Edit anacron configuration
```
sudo nano /etc/anacrontab

# Add this line to the end:
MAILTO=""
7  10  backup.weekly  /complete/path/to/scripts/backup_script.sh "/path/to/source"

This runs the backup:
- Every 7 days (weekly)
- 10 minutes after boot
- Even if the laptop was off on the scheduled day
```
12. the end


## Configuration

### Change Backup Frequency
Edit `/etc/anacrontab`:
- Daily: `1  10  backup.daily  ...`
- Weekly: `7  10  backup.weekly  ...`
- Monthly: `30  10  backup.monthly  ...`

### Change Delay After Boot
Edit the second number in anacrontab:
- `7  5  ...` = 5 minutes after boot
- `7  15  ...` = 15 minutes after boot


## Files Location

- Script: ~/scripts/backup_script.sh
- Config: ~/scripts/backup.env
- Logs: Stored on Pi at BackUp-files/backup_YYYY-MM-DD.log
- Anacron config: /etc/anacrontab

## Future Enhancements

- [ ] Send an email to me once the back up is complete with the full log
- [ ] Possible connection using an old router as bridge
- [ ] Change Hardware of Pi and the 4TB storage HDD

## Contact

Jose David Regalado Alvarado
- LinkedIn: [LinkedIn Profile](https://linkedin.com/in/jose-david-regalado)
- GitHub: [@Pachakuteq](https://github.com/Pachakuteq)
- Email: jowav467@hotmail.com

## Collaboration 

If you want to provide me with any tips or help me out on this project, please send me an email. I would love to have some opinions on this.
