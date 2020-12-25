# simple-directnic-ddns-updater  

a simple systemd timer and shell script using HTTP GET \(wget \(or curl\)\) to update DirectNIC dynamic dns with a public facing IP also determined by an HTTP request  

### full disclosure:  

putting this on here so i won't lose it and made it public because perhaps it will help someone out one day.
it's just thrown together from various tutorials, scripts, as well as myself just reading the man pages, but it works as intended.
i'll remain open to pointers and constructive criticism if there is something sub-standard regarding the systemd configuration.  

It's so simple, here's the files and where they go on Arch Linux. Adopt to your specific distro flavor appropriately.  


### /etc/systemd/system/ddns.service 
```                             
# /etc/systemd/system/ddns.service
[Unit]
Description=Updates directnic ddns via wget (or curl)

[Service]
Type=oneshot
ExecStart=/usr/local/bin/directddnsgrab.sh 
#You might have or want to change user/group
#User=nobody
#Group=nogroup
#Or just use a dynamically generated one
DynamicUser=yes

PrivateTmp=yes
ProtectSystem=strict
ProtectHome=true
MemoryDenyWriteExecute=yes
PrivateDevices=true
PrivateUsers=true
ProtectKernelTunables=true
ProtectKernelModules=true
ProtectControlGroups=true
RestrictNamespaces=true
LockPersonality=true
RestrictRealtime=true

[Install]
WantedBy=multi-user.target
```  

### /etc/systemd/system/ddns.timer  

```
# /etc/systemd/system/ddns.timer
# systemctl start ddns.timer
# systemctl enable ddns.timer
[Unit]
Description=Update directnic ddns provider

[Timer]
OnBootSec=15m
OnUnitActiveSec=12hr

[Install]
WantedBy=timers.target 
```  


> __*Please take note of the timers and customize them for your specific needs.
> It's currently set so that 15 minutes after a boot the script will run and then again every 12 hours the system is operational.*__  
  
  
### /usr/local/bin/directddnsgrab.sh  

```
#!/bin/bash
IPADDR=$(wget -q -O- http://whatismyip.akamai.com --no-check-certificate)
RESULT=$(wget -q -O- "https://directnic.com/dns/gateway/ **<YOUR ID STRING HERE>** /?data=$IPADDR")
```  
> __*You can use whatever IP checking service you desire for obtaining the IPADDR variable, or a different method which tailors to your needs.
> This is for DirectNIC but can also be utilized with any provider that allows HTTP GET requests for updating.*__  
  

### Last Step  

```
# systemctl start ddns.timer
# systemctl enable ddns.timer
```  
> __*Start the systemctl timer and check it with `systemctl status ddns.timer`, if all is good - enable it.  You are now providing DirectNIC your updated IP every 12 hours. Once again, make sure you adjust it for your needs.  Enjoy!*__  
  
