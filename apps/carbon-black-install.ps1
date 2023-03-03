Start-Transcript -Path $ltSvcDir\$packageFileName.log


$packageFileName = $packageName -Replace "\s", "-"
# Check if Carbon Black is installed.
$installed = Get-Package | Where {$_.Name -like "*$packageName*"}
if ($installed) {
    Write-Output "$packageName already installed. Exiting"
    exit  
}

# Check if URL or MSI Path is set then run installer.
if ($msiUrl) {
    Write-Output "msiUrl variable has data. We're going to download the msi and execute."
    Invoke-WebRequest -Uri $msiUrl -OutFile '$ltSvcDir\packages\$packageFileName.msi'
    Start-Process msiexec.exe -ArgumentList $msiFlag 

} else {
    Write-Output "msiUrl is blank. Launching msi from msiPath."
    $msiFlag = '/i ' + $msiPath + ' ' + $msiArguments
    Start-Process msiexec.exe -ArgumentList $msiFlag
}

Stop-Transcript