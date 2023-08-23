$tdofilesource="\\ceserver\TDO\TDOBuilds\12.416d ERX Fix - New"
$destination = "C:\Program Files (x86)\TDOffice\DotNet"
Copy-Item $tdofilesource $destination -recurse -force