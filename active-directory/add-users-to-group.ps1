# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Set the URL of the CSV file containing the list of users
$csvUrl = "@csvUrl@"

# Set the name of the group in Active Directory that you want to add the users to
$groupName = "@groupName@"

# Download the CSV file and read its content
wget $csvUrl -OutFile $env:windir'\temp\user.csv'
$csvContent = Get-Content $env:windir'\temp\user.csv'

# Convert the CSV content to a PowerShell object
$csvData = ConvertFrom-Csv -InputObject $csvContent

# Add each user to the specified group in Active Directory
$csvData | ForEach-Object {
    $user = $_.userPrinicipalName
    $username = (Get-AdUser -Filter 'UserPrincipalName -eq $user').SamAccountName
    Add-ADGroupMember -Identity $groupName -Members $username
}
