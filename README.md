# zabbix-pvs-disk-replication
Zabbix Template to monitor provisioning services replikation status


Prerequesites:  
-Serviceaccount with permissions to access PVS.  
-Installed PVS Powershell


Installation:  
-Copy the .ps1 file to your PVS Server where you want the monitoring to run that has the Provisioning Services Powershell CMDlet installed.  
-Make sure that the path to the zabbix config file and to the zabbix_sender.exe are correct  
-Install two scheduled Tasks:  
1.  
Name: Zabbix PVS Discovery  
Schedule: 1x per Day  
Command: powershell.exe -NoProfile -ExecutionPolicy Bypass -File [PATHTOSCRIPT]\get_pvsdiskstatus.ps1 -ActionType discover  
Runas: ServiceAccount that has PVS Permissions  
2.  
Name: Zabbix PVS Send DiskState  
Schedule: every 5 minutes  
Command: powershell.exe -NoProfile -ExecutionPolicy Bypass -File [PATHTOSCRIPT]\get_pvsdiskstatus.ps1 -ActionType getdiskstate  
Runas: ServiceAccount that has PVS Permissions  
-Import Template and attach to your host.  
-Execute the task "Zabbix PVS Discovery" once. Make sure that the Items and triggers get created  
