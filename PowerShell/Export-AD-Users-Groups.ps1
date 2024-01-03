# Export list of AD Users and their groups

$date = Get-Date -Format "yyyy-MM-dd" # Get date for file name
$username = [Environment]::UserName # Get current user
$ExportPath = "C:\Users\$username\Desktop\$date-AD-Users-Groups.csv" # Get file path (save to Desktop)

# Single line to export results with 
get-aduser -filter * -Properties name,memberof |select name, @{n='MemberOf'; e= { ( $_.memberof | % { (Get-ADObject $_).Name }) -join "," }} | export-csv $ExportPath -nti