<!-- PROJECT LOGO -->
<br />
  <h3 align="center">KeePass database save</h3>

  <p align="center">
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template"><strong>Template used »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Mahh0/KeepassSync/pulls">Pull Request</a>
    ·
    <a href="https://github.com/Mahh0/KeepassSync/issues">Report Bug</a>
  </p>
</div>


<!-- ABOUT THE PROJECT -->
## About The Project

Small projet to have my keepass db accessible from everywhere without having to use gdrive, onedrive or smthing like this.

### Built With

* [Powershell](https://docs.microsoft.com/fr-fr/powershell/)
* [Copilot](https://copilot.github.com/)
* [Windows Tasks Scheduler](https://docs.microsoft.com/fr-fr/windows/win32/taskschd/task-scheduler-start-page)
* [Raspberry Pi 4](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/)
* [Samba linux service](https://doc.ubuntu-fr.org/samba)


### Installation
1. Samba service
After configuring samba service, add the following configuration into /etc/samba/smb.conf
```
[keepass]
        comment = keepass folder
        path = /media/keepass
        valid users = shareuser
        public = no
        browseable = yes
        writeable = yes
        create mask = 0644
        directory mask = 0755
        guest ok = no
```
guest ok = no unallow the use of guest account and valid users = shareuser says that only "shareuser" can access to this share. You also have to specify a path (you can make a separate partition). I created a folder (mkdir /media/keepass).

After adding this configuration, you also have to create the user shareuser, create his password and a samba password :
```
sudo useradd shareuser
sudo passwd shareuser
sudo smbdpasswd shareuser
```

Finally, you can restart the service :
```
sudo service smbd restart
sudo service nbmd restart
```

Note : I've already connected the drive (File explorer > This computer > Add a network drive) in which one in added my credentials.
Note 2 : To make it accessible from WAN, you have to create a rule on your router to redirect WAN Port 445 to LAN RasperryIpAddress:445. You can also use a VPN, it's what I do with a VPN Server on my Raspberry Pi.

2. Powershell script
The .ps1 script synchronize the remote keepass database to a local folder. If there is no remote file, it tries to find the local one and copy it to the remote one.

You can download it [here](https://github.com//Mahh0/KeepassSync/archive/refs/heads/main.zip). There is no exe currently, but you can launch the powershell script with the task scheduler.

3. Task scheduler
I placed everything in C:\Program Files (x86)\keesync. First, we need to create a task for powershell-bypass.bat to bypass the powershell execution policies :
```
=> Windows button, Task scheduler
=> Create a task
=> Main tab | Name : Keepass Powershell Bypass, run with max privileges
=> Triggers | : New => At session opening, choose your user
=> Action | Start a program, Program/script : the bat file (for me : "C:\Program Files (x86)\keesync\powershell-bypass.bat")
=> Conditions | Untick "Start the task only if the computer is connected ... " if you have a laptop
```

We can now add the main task for the powershell script :
```
=> Windows button, Task scheduler
=> Create a task
=> Main tab | Name : Keesync, Run with max privileges
=> Trigger | New => At session opening, choose your user
=> Action | Program/script : powershell, Arguments : -File "C:\Program Files (x86)\keesync\keepass-sync.ps1" (the ps1)
=> Conditions | Untick "Start the task only if the computer is connected ... " if you have a laptop
```

4. Nice
Now, it should be working. I'm still working on this small project, it should be updated in the next few days. There are currently 2 knowns bugs : 
  - At startup, sometimes it cannot access to the remote share
  - It cannot overwrite the files

