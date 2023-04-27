Get-Process pwsvr -ErrorAction SilentlyContinue | Stop-Process -Force
$pwsvrdir = get-itempropertyvalue -path 'HKLM:\Software\wow6432Node\PWInc\PWSvr\' -name PWSvrDir
Remove-Item $pwsvrdir\* -recurse
Copy-Item "C:\pwsvrbackup\*" $pwsvrdir
#Start-Process $pwsvrdir\"pwsvr.exe"
