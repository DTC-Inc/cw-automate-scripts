Stop-Service -name Veeam*
Get-Process VeeamAgent -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Service -name Veeam*