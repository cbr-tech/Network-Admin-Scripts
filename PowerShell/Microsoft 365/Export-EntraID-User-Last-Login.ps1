#
# Author: cbr-tech
# Date: August 23, 2023
# Description: Use this script to gather a list of users and their last sign-in time. 
# Filtering of data in Excel will still be necessary for presentation to client. 
# See thread for usage: https://stackoverflow.com/collectives/azure/articles/75885876/how-to-retrieve-the-last-sign-in-date-time-for-all-users-in-azure-ad-using-micro
#

# Set a default path for files to save to on your machine
$username = [Environment]::UserName
$default_path = "/Users/$Username/Downloads"

# Ask for client name and where to save file
while ($true) {

    # Get the file path (if left blank, then set to Caleb's downloads)
    $path = Read-Host -Prompt "Input the file path to save to (if left blank, defaults to $default_path)"

    if ( $path -eq "" ) { 
        $path = "$default_path"
    }

    # Create loop to check if file path exists
    while ($true) {
        if ( Test-Path -Path $path ) {
                break # end loop if path exists
        } else {
            $path = Read-Host -Prompt "ERROR: $path does not exist. Enter a different path" # get new path if doesn't exist
        }
    }
   
    # Get the client name (to be used with file names)
    $client = Read-Host -Prompt 'Input the client name (e.g. Contoso)'

    # Confirm input back to user
    $confirm = Read-Host "The selected file path is $path and client is $client. Is this information correct? (Y/n)"

    while ($true) {
        # Check if answer was yes
        if ( $confirm -eq "y" ) { 

            # Get date for file name
            $date = Get-Date
            $d = $date.day 
            $m = $date.month 
            $y = $date.year 
            $today = "$y-$m-$d"

            # Put the filepath together
            $filepath = "$path/$today $client Activity Report.csv"

            # Gather report using Microsoft Graph
            # Find more Graph Properties here: https://learn.microsoft.com/en-us/graph/api/resources/user?view=graph-rest-1.0#properties
            Connect-MgGraph -Scopes Directory.Read.All,AuditLog.Read.All
            Select-MgProfile -Name beta
            Get-MgUser -All -Property 'UserPrincipalName','SignInActivity','Mail','DisplayName','accountEnabled','userType' | Select-Object @{N='DisplayName';E={$_.DisplayName }}, @{N='UserPrincipalName';E={$_.UserPrincipalName}}, @{N='LastSignInDate';E={$_.SignInActivity.LastSignInDateTime}}, @{N='accountEnabled';E={$_.accountEnabled}}, @{N='userType';E={$_.userType}} | Export-Csv -Path "$filepath" -NoTypeInformation -NoClobber

            # Cleanup 
            Write-Output "The report has been saved to $filepath"
            #Read-Host "Would you like to disconnect from MS Graph? (Y/n)"
            Disconnect-MgGraph
            
            # Exit program
            exit

        # Check if answer was no
        } elseif ( $confirm -eq "n" ) { 
            Write-Output "Please enter the correct information"
            break

        # Check if answer is invalid
        } else {
            Write-Output "Invalid response (you can choose Y/n)"
            $confirm = Read-Host "The selected file path is $path and client is $client. Is this information correct? (Y/n)"

        }
    }

}

