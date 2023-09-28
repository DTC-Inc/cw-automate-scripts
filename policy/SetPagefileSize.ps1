$computersys = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
$computersys.AutomaticManagedPagefile = $False
$computersys.Put()
$pagefileset = Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name like '%pagefile.sys'"
$pagefileset.InitialSize = 1024
$pagefileset.MaximumSize = 3072
$pagefileset.Put()