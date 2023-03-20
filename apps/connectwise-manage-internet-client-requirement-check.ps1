$softwareName = "ConnectWise Manage Client"

if (Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -eq $softwareName}) {
    Write-Host "$softwareName is installed"
    $uninstallResult = (Start-Process "msiexec.exe" "/x $($softwareName.ProductCode) /qn" -Wait -Passthru).ExitCode
    if ($uninstallResult -eq 0) {
        Write-Host "$softwareName was successfully removed"
        exit 0
    } else {
        Write-Host "Error removing $softwareName"
        exit 1
    }
} else {
    Write-Host "$softwareName is not installed"
    exit 0
}