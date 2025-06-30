# Get the groups a specific user is a member of
$groupIdUser = Get-MgUserMemberOf -UserId "user.Cc@domain.tld" | Select-Object -ExpandProperty Id
$targetUserId = "user2.Cc2@domain.tld"

# Add the target user to each group
foreach ($groupId in $groupIdUser) {
    Add-MgGroupMember -GroupId $groupId -DirectoryObjectId $targetUserId
}
