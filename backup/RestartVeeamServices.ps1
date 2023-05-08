#Stop all Veeam services
Get-Service -name Veeam* -ErrorAction SilentlyContinue | Stop-Service
Get-Process VeeamAgent -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Service -name Veeam*
