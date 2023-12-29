$cmd = 'cscript "c:\program files\microsoft office\office16\ospp.vbs" /dstatus'
$output = Invoke-Expression $cmd -ErrorAction Stop

$licenseKey = $output | Select-String "---LICENSED---  Last 5 characters of installed product key:" | ForEach-Object { $_.Line.Split(":")[1].Trim() }

Write-Host $licenseKey
