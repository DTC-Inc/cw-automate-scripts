# Set backup health checks on storage for physical endpoints
foreach ($job in Get-VBRComputerBackupJob) {
    $options = Get-VBRJobOptions -Job $job
    $options.GenerationPolicy.EnableRechek = $true
    $options.GenerationPolicy.RecheckScheduleKind = 'Monthly'
    $options.GenerationPolicy.RecheckDays = "Sunday"
    Set-VBRJobOptions -Job $job -Options $options | Out-Null
}


# Set backup health checks on storage for virtual endpoints
foreach ($job in Get-VBRJob) {
    $options = Get-VBRJobOptions -Job $job
    $options.GenerationPolicy.EnableRechek = $true
    $options.GenerationPolicy.RecheckScheduleKind = 'Monthly'
    $options.GenerationPolicy.RecheckDays = "Sunday"
    Set-VBRJobOptions -Job $job -Options $options | Out-Null
}