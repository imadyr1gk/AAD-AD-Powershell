# Install the Microsoft Graph module
Install-Module Microsoft.Graph -Scope CurrentUser

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All"

# Get users with PasswordNeverExpires set to False
$UserPasswordExpiredList = Get-MgUser -All -Property Id, UserPrincipalName, PasswordPolicies | Where-Object { $_.PasswordPolicies -notcontains "DisablePasswordExpiration" } | Select-Object UserPrincipalName

# Update users to disable password expiration
$UserPasswordExpiredList | ForEach-Object {
    Update-MgUser -UserId $_.Id -PasswordPolicies "DisablePasswordExpiration"
}
