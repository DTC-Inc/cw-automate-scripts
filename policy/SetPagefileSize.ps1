#Enable privelege to modify pagefile
$computersys = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges

#Set System Managed Pagefile to False
$computersys.AutomaticManagedPagefile = $False
$computersys.Put()

#Query the pagefile settings
$pagefileset = Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name like '%pagefile.sys'"

#Set InitalSize and MaximumSize for PageFile
$pagefileset.InitialSize = 1024
$pagefileset.MaximumSize = 3072
$pagefileset.Put()
