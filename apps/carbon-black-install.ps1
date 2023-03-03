Start-Transcript -Path $ltSvcDir'\'$packageFileName'.log'
$packageFileName = $packageName -Replace "\s", "-"
# Check if Carbon Black is installed.
$installed = Get-Package | Where {$_.Name -like "*$packageName*"}
if ($installed) {
    Write-Ouput "$packageName already installed. Exiting"
    exit  
}

# Check if URL or MSI Path is set then run installer.
if ($msiUrl -ne '@msiUrl@') {
    Write-Output "msiUrl variable has data. We're going to download the msi and execute."
    Invoke-WebRequest -Uri $msiUrl -OutFile $ltSvcDir'\packages\$packageFileName.msi'
    msiexec /i $ltSvcDir'\packages\$packageFileName.msi ' + $msiArguments 

} else {
    Write-Output "msiUrl is blank. Launching msi from msiPath."
    msiexec /i $msiPath + ' ' + $msiArugments
}

Stop-Transcript