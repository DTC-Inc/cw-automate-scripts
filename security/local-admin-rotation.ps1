# VARIABLE SET IN LT EXECUTE SCRIPT BLOCK
# Define the local administrator username
# $localAdmin = "@myLocalAdmin@" 

# Define the log file path
# $logFilePath = "%ltsvcdir%\logs\local-admin-rotate.log"

# Define new password
# $newPassword = "%randompassword%"

# Create the log file directory if it doesn't exist
$LogDirectory = Split-Path $LogFilePath
if (!(Test-Path -Path $LogDirectory)) {
    New-Item -Path $LogDirectory -ItemType Directory | Out-Null
}

# Check if the log file exists, and create it if it doesn't
if (!(Test-Path -Path $LogFilePath)) {
    New-Item -Path $LogFilePath -ItemType File | Out-Null
}

# Redirect all output to the log file
Start-Transcript -Path $LogFilePath

try {
    # Check if the current machine is a domain controller
    $isDomainController = (Get-WmiObject -Query "Select DomainRole from Win32_ComputerSystem").DomainRole -eq 4

    if (!$isDomainController) {
        # If not a domain controller, proceed with local administrator account creation

        # Check if the local administrator account already exists
        $existingAccount = Get-LocalUser -Name $LocalAdmin -ErrorAction SilentlyContinue

        if ($existingAccount -eq $null) {
            # If the account doesn't exist, create a new one with a random password
            New-LocalUser -Name $LocalAdmin -Password (ConvertTo-SecureString -AsPlainText $newPassword -Force) -PasswordNeverExpires:$true
            Write-Host "Local administrator account '$LocalAdmin' created with password: $newPassword"
        } else {
            # If the account exists, reset the password to a new random one
            $existingAccount | Set-LocalUser -Password (ConvertTo-SecureString -AsPlainText $newPassword -Force)
            Write-Host "Password for local administrator account '$LocalAdmin' reset to: $newPassword"
        }

        # Get the current date and time
        $now = Get-Date

        # Calculate the expiration date as 60 days from now
        $expirationDate = $now.AddDays(60)

        # Set the account expiration date
        $existingAccount | Set-LocalUser -AccountExpires $expirationDate

        Write-Host "Local administrator account '$LocalAdmin' set to expire on: $expirationDate"

        # Add the user to the Administrators group
        Add-LocalGroupMember -Group "Administrators" -Member $LocalAdmin

        Write-Host "Local administrator account '$LocalAdmin' added to the Administrators group"
    } else {
        # If a domain controller, skip local administrator account creation and display a message
        Write-Host "Skipping local administrator account creation and built-in administrator account disabling as the current machine is a domain controller."
    }

    # Check if the built-in Administrator account exists
    $builtInAdmin = Get-LocalUser -Name "Administrator" -ErrorAction SilentlyContinue

    if ($builtInAdmin -ne $null) {
        # If the built-in Administrator account exists, disable it
        $builtInAdmin | Disable-LocalUser

        Write-Host "Built-in Administrator account disabled"
    }
}
catch {
    Write-Host "Error: $_"
}
finally {
    # Stop transcript logging
    Stop-Transcript
}