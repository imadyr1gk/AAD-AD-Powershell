Import-Module MSOnline
Import-Module Microsoft.Graph.Users

# Connexion aux services MSOL et Graph
Connect-MsolService
Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All"

# Récupération des utilisateurs et extraction des attributs demandés
$users = Get-MsolUser -All | Where-Object { $_.UserType -ne "Guest" } | ForEach-Object {
    # Récupération des données complémentaires via Microsoft Graph
    $mgUser = Get-MgUser -UserId $_.UserPrincipalName -Property EmployeeId, EmployeeType, CompanyName, Mail, BusinessPhones -ErrorAction SilentlyContinue
    $managerInfo = Get-MgUserManager -UserId $_.UserPrincipalName -ErrorAction SilentlyContinue

    # Extraction du manager et du téléphone
    $manager = if ($managerInfo) { (Get-MgUser -UserId $managerInfo.Id -Property DisplayName -ErrorAction SilentlyContinue).DisplayName } else { "N/A" }
    $businessPhone = if ($mgUser.BusinessPhones.Count -gt 0) { $mgUser.BusinessPhones[0] } else { "N/A" }

    # Création d'un objet personnalisé avec tous les attributs
    [PSCustomObject]@{
        DisplayName       = $_.DisplayName
        FirstName        = $_.FirstName
        LastName         = $_.LastName
        UserPrincipalName = $_.UserPrincipalName
        UserType         = $_.UserType
        Title            = $_.Title
        Company          = $mgUser.CompanyName
        Department       = $_.Department
        EmployeeId       = $mgUser.EmployeeId
        EmployeeType     = $mgUser.EmployeeType
        Office           = $_.Office
        Manager          = $manager
        PhoneNumber      = $businessPhone
        EmailAddress     = $mgUser.Mail
        MailNickname     = $_.MailNickname
    }
}

# Exportation des résultats en CSV
$users | Export-Csv -Path "C:\Users\ifikara\InternalUsers365-MGMS.csv" -NoTypeInformation -Encoding UTF8

Write-Output "Les données des utilisateurs ont été exportées avec succès dans le fichier users.csv."
