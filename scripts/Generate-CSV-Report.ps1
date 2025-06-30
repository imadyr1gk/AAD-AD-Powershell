# Generate CSV Report for users with Password Never Expires
$UserWhoPasswordExpire = Get-MgUser -All -Property UserPrincipalName, PasswordPolicies | Select-Object UserPrincipalName,@{
    N="PasswordNeverExpires";E={$_.PasswordPolicies -contains "DisablePasswordExpiration"}
} | ConvertTo-Csv -NoTypeInformation | Out-File $env:userprofile\Desktop\ReportPasswordNeverExpires.csv
