#
# Author: cbr-tech
# Date: August 22, 2023
# Description: This script connects to an SMTP server with the provided credentials and emails your account
#

$defaultEmail = ""

if ( $defaultEmail -eq "" ) {
    Write-Output "ERROR: You must edit the script and setup the default email"
    exit
}


# Ask for the server to connect to
$server = Read-Host -Prompt "Enter 'Google' or 'Microsoft' for the SMTP server"

# Check for a valid server
while ($true) {
    if ( $server -eq "Microsoft" ) {
        $smtpServer = "smtp.office365.com"
        break
    } elseif ( $server -eq "Google" ) {
        $smtpServer = "smtp.gmail.com"
        break
    } else {
        $server = Read-Host -Prompt "Enter 'Google' or 'Microsoft' for the SMTP server"
    }
}

# Ask for a recipient email address
$email = Read-Host "Enter a recipient address or leave blank to use the default"

if ( $email -eq "" ) {
    $email = $defaultEmail # Set a default email address if none provided
}

# Prompt for SMTP account credentials
$cred = Get-Credential -Message "Please enter the email address and password to test SMTP..."

$mailParams = @{
    smtpServer="$smtpServer"
    Port= '587'
    UseSSL=$true
    Credential = $cred
    From = $cred.Username
    To=“$email”
    Subject=“SMTP Relay"
    Body="Message SMTP Relay"
    DeliveryNotificationOption='onFailure','OnSuccess'
}

Send-MailMessage @mailParams
