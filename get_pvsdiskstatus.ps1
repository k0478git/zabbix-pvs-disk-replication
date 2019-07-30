param (
       [Parameter(Mandatory = $true)][string] $ActionType
       )

Function Test-CommandExists
{
 Param ($command)
 $oldPreference = $ErrorActionPreference
 $ErrorActionPreference = ‘stop’
 try {if(Get-Command $command){RETURN $true}}
 Catch {Write-Host “$command does not exist”; RETURN $false}
 Finally {$ErrorActionPreference=$oldPreference}
} #end function test-CommandExists

#### Configuration ####
$zabbix_configfile = 'C:\zabbix\zabbix_agentd.win.conf'
#### //Configuration ####


if(-Not (Test-CommandExists Get-PvsDiskLocator)) {
Import-Module "C:\Program Files\Citrix\Provisioning Services Console\Citrix.PVS.Snapin.dll"
} 


if ($ActionType -eq "discover"){
    $result_json = [pscustomobject]@{
                'data' = @(
                    Get-PvsDiskLocator  | ForEach-Object {
                      [pscustomobject]@{                     
                                        '{#DISKLOCATORID}'     = $_.DiskLocatorId ;                                     
                                        '{#DISKLOCATORNAME}'  = $_.DiskLocatorName;
                                       }
                            }
                          )
                    } 	| ConvertTo-Json -Compress
                    echo "- pvsdisk.discovery $result_json" | C:\zabbix\zabbix_sender.exe -c ${zabbix_configfile} -i -
 }
if ($ActionType -eq "getdiskstate") {
        
            Get-PvsDiskLocator  | ForEach-Object {
            $DiskLocatorId = $_.DiskLocatorId
            $status = (Get-PvsDiskInventory -DiskLocatorId $DiskLocatorId | measure -Maximum -Property State ).Maximum
            echo "- pvsdisk.getdiskstate[$DiskLocatorId] $status" | C:\zabbix\zabbix_sender.exe -c ${zabbix_configfile} -i -

        }
 }