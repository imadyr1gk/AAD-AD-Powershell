# To see if a single user's password is set to never expire, run the following cmdlet by using the UPN (for example, user@contoso.onmicrosoft.com) or the user ID of the user you want to check:
Get-MGuser -All -Property UserPrincipalName, PasswordPolicies | Select-Object UserprincipalName,@{    N="PasswordNeverExpires";E={$_.PasswordPolicies -contains "DisablePasswordExpiration"} }Get-MGuser -UserId <user id or UPN> -Property UserPrincipalName, PasswordPolicies | Select-Object UserPrincipalName,@{
    N="PasswordNeverExpires";E={$_.PasswordPolicies -contains "DisablePasswordExpiration"}
}

# To see the Password never expires setting for all users, run the following cmdlet:
Get-MGuser -All -Property UserPrincipalName, PasswordPolicies | Select-Object UserprincipalName,@{
    N="PasswordNeverExpires";E={$_.PasswordPolicies -contains "DisablePasswordExpiration"}
 }
