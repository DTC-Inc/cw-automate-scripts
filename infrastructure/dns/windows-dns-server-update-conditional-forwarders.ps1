Start-Transcript -Path %ltsvcdir%\logs\set-conditional-forwwards.log

# Define the name server to use for DNS resolution
$masterServers = @masterServers@

# Read the list of domains from a file
$domains = @domains@

# Remove DNS zones that match & add domains as conditional forwarders
$domains | ForEach-Object {Get-DnsServerZone | Where -Property ZoneName -eq $_ | Remove-DnsServerZone -Force}

$domains | ForEach-Object {Add-DnsServerConditionalForwarderZone -Name $_ -MasterServers $masterServers -PassThru -ReplicationScope Forest}

Stop-Transcript