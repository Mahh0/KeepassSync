<#
.SYNOPSIS
	Sync a keepass database contained in a remote folder to the local computer
.DESCRIPTION
	This PowerShell script synchronize the remote keepass database to a local folder, only if it is needed. It can be used with the task planificator (windows startup)
#>

try {
    #Beginning of the script : creation of a notification warning the user of the start of the program
     [reflection.assembly]::loadwithpartialname('System.Windows.Forms')
     [reflection.assembly]::loadwithpartialname('System.Drawing')
     $notify = new-object system.windows.forms.notifyicon
     $notify.icon = [System.Drawing.SystemIcons]::Information
     $notify.visible = $true
     $notify.showballoontip(10,'Keepass Sync !','Starting the keepass sync task !',[system.windows.forms.tooltipicon]::None)
 
     $wshell = New-Object -ComObject Wscript.Shell 
 
     Start-Sleep -s 2
    
     # get the parameters from the parameters file (if it exists)
     $parameters = Get-Content -Path "$PSScriptRoot\parameters.txt" -Encoding utf8
         $parameters | % {
             if ($_.StartsWith("remoteFolder=")) {
                 $remoteFolder = $_.Substring(13)
             }
             if ($_.StartsWith("localFolder=")) {
                 $localFolder = $_.Substring(12)
             }
             if ($_.StartsWith("keepassFileName=")) {
                 $keepassFileName = $_.Substring(16)
             }
         }
 
         # if the parameters are not set, ask the user
         if ($remoteFolder -eq $null -or $localFolder -eq $null) {
             # ask the user to set the parameters
             $wshell.Popup("At least one of the two parameters is not set, please set them in the parameters file or in the script itself",0,"Keepass Sync",[system.windows.forms.messageboxicon]::Information)
             # prompt the user to set the parameters
             $remoteFolder = Get-Location -Prompt "Remote folder"
             $localFolder = Get-Location -Prompt "Local folder"
 
             #write the parameters in the parameters file
             $parameters = "remoteFolder=$remoteFolder\nlocalFolder=$localFolder"
             Set-Content -Path "$PSScriptRoot\parameters.txt" -Value $parameters -Encoding utf8
         }
     
     
         # Testing the accessibility of the local folder
         if(!(Test-Path -Path $localFolder)){
             $notify.showballoontip(10,'Keepass Sync !','The local path is not accessible ! Exiting',[system.windows.forms.tooltipicon]::Error)
             exit 1
         } else {
             $notify.showballoontip(10,'Keepass Sync !','The local path is accessible !',[system.windows.forms.tooltipicon]::Info)
         }
     
     Start-Sleep -s 2
 
         # Testing the accessibility of the remote folder
         if(!(Test-Path -Path $remoteFolder)){
             $notify.showballoontip(10,'Keepass Sync !','The remote path is not accessible ! Exiting',[system.windows.forms.tooltipicon]::Error)
             exit 1
         } else {
             $notify.showballoontip(10,'Keepass Sync !','The remote path is accessible !',[system.windows.forms.tooltipicon]::Info)
         }
     
     Start-Sleep -s 2
 
 
     # Move to the remote folder and get the list of files.
     Set-Location $remoteFolder
     $remotePwd = (Get-Location).Path
     $remoteFiles = (Get-ChildItem -Path $remotePwd -Recurse).Name
     $wshell.Popup("Files in the remote folder : `n " + $remoteFiles)
 
 
 
         # if there is a file named keepassdb.kdbx, we try to sync it (after checking if there is nothing on the local computer, or if the file is older than the remote one)
         if ($remoteFiles -contains $keepassFileName) {
             #check the last modification date of remote keepassdb.kdbx
             $remoteLastModified = [datetime](Get-ItemProperty -Path $keepassFileName -Name LastWriteTime).lastwritetime
             $wshell.Popup("The remote file $keepassFileName is present. Last modification date: $remoteLastModified`n")
 
             # Moove to the local folder and get the list of files.
             Set-Location $localFolder
             $localPwd = (Get-Location).Path
             $localFiles = (Get-ChildItem -Path $localPwd -Recurse).Name
 
             $wshell.Popup("Files in the local folder : `n " + $localFiles)
             
 
             if ($localFiles -contains $keepassFileName) { # Here, the two files are present. We check if they are the same.
                 #check the last modification date of local keepassdb.kdbx
                 $localLastModified = [datetime](Get-ItemProperty -Path $keepassFileName -Name LastWriteTime).lastwritetime
                 $wshell.Popup("The local file $keepassFileName is present. Last modification date: $localLastModified`n")
 
             # si le fichier local est plus recent que le fichier distant, on le copie au répertoire distant
             if ($localLastModified -gt $remoteLastModified) {
                 $wshell.Popup("The local file $keepassFileName is more recent than the remote one. The local file will be copied to the remote folder.`n")
                 Copy-Item -Path $keepassFileName -Destination $remotePwd -Force
                 $notify.showballoontip(10,'Keepass Sync !','The local file $keepassFileName has been copied to the remote folder',[system.windows.forms.tooltipicon]::Info)
             # si le fichier local est plus ancien que le fichier distant, on copie le fichier distant au répertoire local
             } elseif ($localLastModified -lt $remoteLastModified) {
                 $wshell.Popup("The local file $keepassFileName is older than the remote one. Synchronizing the remote file to the local one...")
                 Copy-Item -Path $keepassFileName -Destination $localPwd -Force
                 $wshell.Popup("Synchronization done !`n")
             } elseif ($localLastModified -eq $remoteLastModified) {
                 $wshell.Popup("The local file $keepassFileName is the same as the remote one. No sync needed`n")
 
             }
     
             } else {
                 $wshell.Popup("No local $keepassFileName found, syncing it from the remote folder")
                 #copy the remote keepassdb.kdbx to the local one
                 Copy-Item -Path $keepassFileName -Destination $localPwd -Force
                 $wshell.Popup("Synchronization done !`n Exiting...")
                 Start-Sleep -Seconds 10
                 exit
             }
             
         } else { # If there is no keepassdb.kdbx file on the remote folder
             $wshell.Popup("No remote $keepassFileName found, trying to sync from the local file.`n Do you want to sync it ? (y/n)`n")
             $answer = Read-Host "Type y to try to sync, n to exit"
             if ($answer == "y") {
                 Set-Location $localFolder
                 # write the current directory to the console
                 $localPwd = (Get-Location).Path
                 # get the list of files in the current directory
                 $localFiles = (Get-ChildItem -Path $localPwd -Recurse).Name
 
                 if ($files2 -contains $keepassFileName) {
                     $wshell.Popup("Found $keepassFileName in local, syncing it to the remote")
                     #copy the local keepassdb.kdbx to the remote one
                     copy-item $keepassFileName -destination $remotePwd -force
                     write-host "Sync process finished"
                 } else {
                     write-host "WARNING No local $keepassFileName file found, nothing to sync !!!!"
                     write-host "Exiting"
                     Start-Sleep -Seconds 10
                     exit
                 }
 
             } else {
                 write-host "Exiting"
                 Start-Sleep -Seconds 10
                 exit
             }
         }
 
     Start-Sleep -Seconds 20
     exit
 
 
 } catch {
     "⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
     exit 1
 }