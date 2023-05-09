# Stop PWSvr.exe if running
Get-Process pwsvr -ErrorAction SilentlyContinue | Stop-Process -Force
# Get PWSvr directory from the registry
$pwsvrdir = get-itempropertyvalue -path 'HKLM:\Software\wow6432Node\PWInc\PWSvr\' -name PWSvrDir
# Delete all files in the production PWSvr directory
Remove-Item $pwsvrdir\* -recurse
# Copy files from backup folder to production folder
Copy-Item "C:\pwsvrbackup\*" $pwsvrdir
