<#
.SYNOPSIS
	Sync a keepass database contained in a remote folder to the local computer
.DESCRIPTION
	This PowerShell script synchronize the remote keepass database to a local folder, only if it is needed. It can be used with the task planificator (windows startup)
#>

try {
    # Move to the remote folder, print the path to the console and get the list of the files in the current directory
    Set-Location \\raspimaho.maho.local\keepass
    $remotePwd = (Get-Location).Path
    write-host "Current directory: $remotePwd"
    $remoteFiles = (Get-ChildItem -Path $remotePwd -Recurse).Name
    write-host "Files in the remote directory: $remoteFiles"

    # if there is a file named keepassdb.kdbx, we try to sync it (after checking if there is nothing on the local computer, or if the file is older than the remote one)
    if ($remoteFiles -contains "keepassdb.kdbx") {
        write-host "Found keepassdb.kdbx in the remote folder, syncing it"
        write-host "Sync process started"
        #check the last modification date of keepassdb.kdbx
        $remoteLastModified = (Get-Item -Path keepassdb.kdbx).LastWriteTime
        write-host "Last modification date of remote keepassdb.kdbx: $remoteLastModified. Checking the local one"

        Set-Location $home/Documents/keepass
        # write the current directory to the console
        $localPwd = (Get-Location).Path
        write-host "Current directory: $localPwd"
        # get the list of files in the current directory
        $localFiles = (Get-ChildItem -Path $localPwd -Recurse).Name
        write-host "Files in the current directory: $localFiles"

        if ($localFiles -contains "keepassdb.kdbx") {
            write-host "Found keepassdb.kdbx in local, checking the last modification date"
            #check the last modification date of keepassdb.kdbx
            $localLastModified = (Get-Item -Path keepassdb.kdbx).LastWriteTime
            write-host "Last modification date of keepassdb.kdbx: $localLastModified"

            if ($remoteLastModified -ne $localLastModified) {
                write-host "The local keepassdb.kdbx is older than the remote one, syncing it"
                #copy the remote keepassdb.kdbx to the local one
                copy-item keepassdb.kdbx -destination $localPwd
                write-host "Sync process finished"
                write-host "Exiting"
                Start-Sleep -Seconds 20
            } else {
                write-host "The local keepassdb.kdbx is up to date, no need to sync"
                write-host "Exiting"
                Start-Sleep -Seconds 20
            exit
            }
        } else {
            write-host "No local keepassdb.kdbx found, syncing it"
            #copy the remote keepassdb.kdbx to the local one
            copy-item $remotePwd\keepassdb.kdbx -destination $localPwd
            write-host "Sync process finished"
            write-host "Exiting"
            Start-Sleep -Seconds 20
        }
        
    } else {
        write-host "WARNING No keepassdb.kdbx file found in the remote folder, nothing to sync !!!!"
        write-host "Do you wan't to try to sync a local keepassdb.kdbx file to the remote folder ?"
        $answer = Read-Host "Type y to try to sync, n to exit"
        if ($answer == "y") {
            Set-Location $home/Documents/keepass
            # write the current directory to the console
            $localPwd = (Get-Location).Path
            write-host "Current directory: $localPwd"
            # get the list of files in the current directory
            $localFiles = (Get-ChildItem -Path $localPwd -Recurse).Name
            write-host "Files in the current directory: $localFiles"

            if ($files2 -contains "keepassdb.kdbx") {
                write-host "Found keepassdb.kdbx in local, syncing it"
                #copy the local keepassdb.kdbx to the remote one
                copy-item keepassdb.kdbx -destination $remotePwd
                write-host "Sync process finished"
            } else {
                write-host "WARNING No local keepassdb.kdbx file found, nothing to sync !!!!"
                write-host "Exiting"
                Start-Sleep -Seconds 20
                exit
            }

        } else {
            write-host "Exiting"
            Start-Sleep -Seconds 20
            exit
        }
    }

    Start-Sleep -Seconds 20


} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}