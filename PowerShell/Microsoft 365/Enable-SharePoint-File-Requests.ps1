#
# Author: cbr-tech
# Date: August 23, 2023
# Description:
# This script enables file requests for ALL SharePoint sites and OneDrive accounts by connecting to 
# SharePoint Online services. Individual sites can be done but that is beyond the scope of this script. 
# NOTE: Make sure that the prerequisites are enabled by visiting the source article below. 
# Source: https://learn.microsoft.com/en-us/sharepoint/enable-file-requests
# More documentation: https://learn.microsoft.com/en-us/powershell/sharepoint/sharepoint-online/connect-sharepoint-online
#

# Check operating system
if (-not (Test-Path -Path "C:\Windows") ) {
    Write-Output "ERROR: This script only works on machines running the Windows 10/11 operating system."
    exit
}

# Ask for SharePoint domain
$sharepoint_site = Read-Host -Prompt "Enter the SharePoint Admin Center site URL (e.g. https://contoso-admin.sharepoint.com)"

# Check if input is blank
while ($true) {
    if ( $sharepoint_site -eq "" ) {
        Write-Output "You must enter the SharePoint Admin Center site URL. To find it, do the following: "
        Write-Output "1. Visit admin.microsoft.com and click 'Show all' on the left"
        Write-Output "2. Under 'Admin centers' select SharePoint from the left"
        Write-Output "3. From the URL of the page, copy only the part that looks like https://contoso-admin.sharepoint.com"

        # Blank line and prompt again
        Write-Output
        $sharepoint_site = Read-Host -Prompt "Enter the SharePoint Admin Center site URL (e.g. https://contoso-admin.sharepoint.com)"      
    
    # End loop if not blank
    } else {
        break 
    }
}

# Install, update, and import Microsoft SharePoint Online
Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force
Update-Module -Name Microsoft.Online.SharePoint.PowerShell -Force
Import-Module -Name Microsoft.Online.SharePoint.PowerShell -Force

# Connect to SharePoint Online (allows for MFA)
Write-Output "Connecting to $sharepoint_site now..."
Connect-SPOTentant -Url $sharepoint_site

# Enable file requests for SharePoint
Write-Output "Enabling SharePoint file requests"
Set-SPOTenant -CoreRequestFIlesLinkEnabled $True

# Enable file requests for OneDrive
Write-Output "Enabling OneDrive file requests"
Set-SPOTenant -OneDriveRequestFIlesLinkEnabled $True

Disconnect-SPOService