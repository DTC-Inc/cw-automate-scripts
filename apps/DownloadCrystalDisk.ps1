# URL of the compressed file to download
$url = "https://github.com/DTC-Inc/cw-automate-scripts/raw/main/apps/CrystalDiskInfo9_1_1.zip"

# Location where you want to save the downloaded file
$downloadLocation = "C:\CrystalDiskInfo\Download\CrystalDiskInfo9_1_1.zip"

# Location where you want to extract the contents
$extractLocation = "C:\CrystalDiskInfo"

# Download the compressed file
Invoke-WebRequest -Uri $url -OutFile $downloadLocation

# Check if the download was successful
if (Test-Path $downloadLocation) {
    # Extract the contents to the specified location
    Expand-Archive -Path $downloadLocation -DestinationPath $extractLocation -Force
    Write-Host "Extraction completed successfully."
} else {
    Write-Host "Download failed. Please check the URL and try again."
}
