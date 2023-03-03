#Set information needed for deploying automate agent
$Server = '@server@'
$Token = '@token@'
$LocationId = '%locaitonid%'

# Set the time range to query
$today = Get-Date
$last30days = $today.AddDays(-30)

# Query Active Directory for computers that have checked in within the last 30 days
$computers = Get-ADComputer -Filter {LastLogonTimeStamp -gt $last30days} -Properties LastLogonTimeStamp

#Prompts for domain credentials to access computer
$credentials = Get-Credential

$computers | ForEach-Object -Parallel {
    $computerName = $_.Name
    $ping = Test-Connection -Count 1 -ComputerName $computerName -Quiet
    if ($ping) {
        # Define the commands to run on the remote computer
        # Run the commands on the remote computer
        Invoke-Command -ComputerName $computername -Credential $using:credentials -ScriptBlock {
            $serviceName = Get-Service | Where {$_.Name -eq 'LTService'} | Select -ExpandProperty Name
            if ($serviceName) { 
                exit
            } else {
                [Net.ServicePointManager]::SecurityProtocol = [Enum]::ToObject([Net.SecurityProtocolType], 3072);
                Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/Get-Nerdio/NMM/main/scripted-actions/modules/CMSP_Automate-Module.psm1');
                Install-Automate -Server $using:server -LocationID $using:locationID -Token $using:token -Transcript
            }
        }
    } else {
        #Will display results in powershell window
        Write-Output "Could not connect to $computername"
    }
}