# Generate HTML Report for users with Password Never Expires
Get-MgUser -All -Property UserPrincipalName, PasswordPolicies | Select-Object UserPrincipalName,@{
    N="PasswordNeverExpires";E={$_.PasswordPolicies -contains "DisablePasswordExpiration"}
} | ConvertTo-Html | Out-File $env:userprofile\Desktop\ReportPasswordNeverExpires.html
