Start-Transcript -Path %ltsvcdir%\logs\set-conditional-forwwards.log

# Define the name server to use for DNS resolution
$nameServer = @nameServer@

# Import the Active Directory module for PowerShell
Import-Module ActiveDirectory

# Read the list of domains from a file
$domains = @domains@

foreach ($domain in $domains) {

     # Remove conditional forwarders from DNS Server
     Get-DnsServerZone | Where -Property ZoneName -eq $domain | Remove-DnsServerZone -Force
     
    # Resolve the domain's name servers
    $domainNS = Resolve-DnsName -Name $domain -Type NS -Server $nameServer

    # Check if the NS record contains a valid set of name servers
    $nsRecord = (Resolve-DnsName -Name $domain -Type NS -Server $nameServer).NameHost
    
    if ($nsRecord -ne $null) {
        Write-Host "Domain has valid name servers listed in SOA record."
        $ipAddresses = $nsRecord | ForEach-Object { (Resolve-DnsName -Name $_ -Server $nameServer).IPAddress }

        # Add a conditional forwarder pointing towards the authoritative name server for the domain
        $zoneName = $domain
        $masterServers = $ipAddresses | ForEach-Object { [System.Net.IPAddress]::Parse($_) }
        Add-DnsServerConditionalForwarderZone -Name $zoneName -MasterServers $masterServers -PassThru -ReplicationScope Forest
    } else {
        Write-Host "Domain does not have valid name servers listed in SOA record. Querying parent domain name servers."
        $domainLabels = $domain.Split(".")
        $parentLabels = $domainLabels[1..($domainLabels.Count - 1)]
        $parentDomain = $parentLabels -join "."
        $parentNS = (Resolve-DnsName -Name $parentDomain -Type NS -Server 1.1.1.1).NameHost
        # Convert the name servers to IP addresses
        $ipAddresses = $parentNS | ForEach-Object { (Resolve-DnsName -Name $_ -Server $nameServer).IPAddress }

        # Add a conditional forwarder pointing towards the authoritative name server for the domain
        $zoneName = $domain
        $masterServers = $ipAddresses | ForEach-Object { [System.Net.IPAddress]::Parse($_) }
        Add-DnsServerConditionalForwarderZone -Name $zoneName -MasterServers $masterServers -PassThru -ReplicationScope Forest
    }
}

Stop-Transcript