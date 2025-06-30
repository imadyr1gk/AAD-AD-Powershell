# Only for AD On-premises
$UserPasswordNeverExpiredList = Get-ADUser -Filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} | Select-Object -ExpandProperty UserPrincipalName

foreach ($user in $UserPasswordNeverExpiredList) {
    Set-ADUser -Identity $user -PasswordNeverExpires $true
} 
