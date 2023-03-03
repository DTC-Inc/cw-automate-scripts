# Set the MSI path. Please only use one of these.
$msiUrl = '@msiUrl@'
$msiPath = '@msiPath@'
$companyCode = '@companyCode@'
$argumentList = '/qn ' +  $companyCode + ' HIDE_COMMAND_LINES=1'
$ltSvcPath = '%ltsvcdir%'

Start-Transcript -Path $ltSvcPath\carbon-black-install.log

# Check if Carbon Black is installed.
$installed = Get-Package | Where {$_.Name -like "*Carbon Black*"}
if ($installed) {
    exit
}

# Check if URL or MSI Path is set then run installer.
if ($msiUrl -ne '@msiUrl@') {

    Invoke-WebRequest -Uri $msiUrl -OutFile $ltSvcPath'\packages\carbon-black.msi'
    msiexec /i $ltSvcPath'\packages\carbon-black.msi' /qn COMPANY_CODE=$companyCode HIDE_COMMAND_LINES=1

} else {
    msiexec /i $msiPath /qn COMPANY_CODE=$companyCode HIDE_COMMAND_LINES=1
}

Stop-Transcript