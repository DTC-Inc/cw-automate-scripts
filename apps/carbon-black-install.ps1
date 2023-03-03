# Set the MSI path. Please only use one of these.
$msiUrl = '@msiUrl@'
$msiPath = '@msiPath@'
$companyCode = '@companyCode@'
$argumentList = '/qn ' +  $companyCode + ' HIDE_COMMAND_LINES=1'
$ltSvcPath = %ltsvcdir%


# Check if URL or MSI Path is set then run installer.
if ($msiUrl) {

    wget $msiUrl -OutFile '$ltSvcPath\packages\carbon-black.msi'
    msi /i '$ltSvcPath\packages\carbon-black.msi' /qn COMPANY_CODE=QUQCEWZQW!YHP@2O!W0 HIDE_COMMAND_LINES=1

} else {
    msiexec /i '$msiPath' /qn COMPANY_CODE=QUQCEWZQW!YHP@2O!W0 HIDE_COMMAND_LINES=1
}