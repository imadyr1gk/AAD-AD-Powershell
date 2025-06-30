Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All"

# Chemin du fichier CSV pour l'exportation
$CsvPath = "C:\Users\ifikara\GroupsAndMembers-2.csv" 

# Récupérer tous les groupes
$groups = Get-MgGroup -All

# Initialiser une liste pour stocker les données
$Report = [System.Collections.Generic.List[Object]]::new()

# Paramètres de la barre de progression
$totalGroups = $groups.Count
$currentGroup = 0

# Parcourir chaque groupe et récupérer les membres
foreach ($group in $groups) {
    # Récupérer les membres du groupe
    $members = Get-MgGroupMember -GroupId $group.id -All

    # Déterminer le type de groupe
    $groupType = if ($group.groupTypes -eq "Unified" -and $group.securityEnabled) { "Microsoft 365 (sécurisé)" }
    elseif ($group.groupTypes -eq "Unified" -and !$group.securityEnabled) { "Microsoft 365" }
    elseif (!($group.groupTypes -eq "Unified") -and $group.securityEnabled -and $group.mailEnabled) { "Sécurité activée par e-mail" }
    elseif (!($group.groupTypes -eq "Unified") -and $group.securityEnabled) { "Sécurité" }
    elseif (!($group.groupTypes -eq "Unified") -and $group.mailEnabled) { "Distribution" }
    else { "N/A" }

    # Si le groupe n'a pas de membres, créer un objet avec des valeurs vides
    if ($members.Count -eq 0) {
        $ReportLine = [PSCustomObject][ordered]@{
            GroupId            = $group.Id
            GroupDisplayName   = $group.DisplayName
            GroupType          = $groupType
            UserDisplayName    = "N/A"
            UserPrincipalName  = "N/A"
            UserAlias          = "N/A"
            UserType           = "N/A"
            UserAccountEnabled = "N/A"
        }
        # Ajouter la ligne au rapport
        $Report.Add($ReportLine)
    }
    else {
        # Parcourir chaque membre et récupérer les détails de l'utilisateur
        foreach ($member in $members) {
            $user = Get-MgUser -UserId $member.Id -Property 'DisplayName', 'UserPrincipalName', 'UserType', 'AccountEnabled' -ErrorAction SilentlyContinue | Select-Object 'DisplayName', 'UserPrincipalName', 'UserType', 'AccountEnabled'

            # Vérifier si $user n'est pas nul avant d'accéder aux propriétés
            if ($user.Count -ne 0) {
                # Extraire l'alias de UserPrincipalName
                $alias = $user.UserPrincipalName.Split("@")[0]

                # Créer un objet personnalisé avec les propriétés dans un ordre spécifique
                $ReportLine = [PSCustomObject][ordered]@{
                    GroupId            = $group.Id
                    GroupDisplayName   = $group.DisplayName
                    GroupType          = $groupType
                    UserDisplayName    = $user.DisplayName
                    UserPrincipalName  = $user.UserPrincipalName
                    UserAlias          = $alias
                    UserType           = $user.UserType
                    UserAccountEnabled = $user.AccountEnabled
                }

                # Ajouter la ligne au rapport
                $Report.Add($ReportLine)
            }
        }
    }

    # Mettre à jour la barre de progression
    $currentGroup++
    $status = "{0:N0}" -f ($currentGroup / $totalGroups * 100)

    $progressParams = @{
        Activity        = "Récupération des membres de groupe"
        Status          = "Traitement du groupe : $($group.DisplayName) - $currentGroup sur $totalGroups : $status% terminé"
        PercentComplete = ($currentGroup / $totalGroups) * 100
    }

    Write-Progress @progressParams
}

# Compléter la barre de progression
Write-Progress -Activity "Récupération des membres de groupe" -Completed

# Exporter toutes les informations des utilisateurs dans un fichier CSV
$Report | Sort-Object GroupDisplayName | Export-Csv $CsvPath -NoTypeInformation -Encoding utf8

Write-Host "Exportation terminée. Le fichier a été enregistré sous : $CsvPath"
