Start-Transcript -Path $ltSvcDir\carbon-black-install.log
Write-Output $msiPath
# Check if Carbon Black is installed.
$installed = Get-Package | Where {$_.Name -like "*Carbon Black*"}
if ($installed) {
    exit
}

# Check if URL or MSI Path is set then run installer.
if ($msiUrl -ne '@msiUrl@') {

    Invoke-WebRequest -Uri $msiUrl -OutFile $ltSvcDir'\packages\carbon-black.msi'
    msiexec /i $ltSvcDir'\packages\carbon-black.msi' /qn COMPANY_CODE=$companyCode HIDE_COMMAND_LINES=1

} else {
    msiexec /i $msiPath /qn COMPANY_CODE=$companyCode HIDE_COMMAND_LINES=1
}

Stop-Transcript