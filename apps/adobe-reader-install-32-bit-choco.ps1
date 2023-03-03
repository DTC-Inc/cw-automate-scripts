# Install Choco
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Uninstall Adobe Acrobat (64-bit)
$MyApp = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -like "Adobe Acrobat (64-bit)"}

if ($MyApp -ne $null) {
    $MyApp.Uninstall()
}

# Install Adobe Acrobat Reader MUI
choco install adobereader /y

