# AD-AAD-Powershell
Quelques commandes et script powershell utilles
# PowerShell Scripts pour la gestion des politiques de mot de passe et des groupes

Ce dépôt contient des scripts PowerShell pour gérer les politiques de mot de passe dans Active Directory (AD On-premises) et Entra (Azure AD), ainsi que pour générer des rapports et gérer les membres des groupes.

## Prérequis

1. Pour les scripts Active Directory On-premises :
   - PowerShell Active Directory Module
2. Pour les scripts Entra (Azure AD) :
   - Microsoft Graph PowerShell SDK
   - Permission `User.Read.All`

## Scripts

### 1. AD-OnPremises-PasswordPolicy.ps1
Ce script permet de gérer la politique de mot de passe pour les utilisateurs d'Active Directory On-premises en modifiant l'attribut `PasswordNeverExpires`.

### 2. Entra-PasswordPolicy.ps1
Ce script gère la politique de mot de passe dans Azure AD, en désactivant l'expiration des mots de passe pour les utilisateurs via Microsoft Graph API.

### 3. Generate-HTML-Report.ps1
Génère un rapport HTML listant les utilisateurs dont le mot de passe ne expire jamais.

### 4. Generate-CSV-Report.ps1
Génère un rapport CSV pour les utilisateurs dont le mot de passe ne expire jamais.

### 5. Manage-Group-Memberships.ps1
Gère les adhésions aux groupes d'utilisateurs dans Azure AD via Microsoft Graph API.

## Installation

1. Installez le module Microsoft Graph pour les scripts Entra :
   ```powershell
   Install-Module Microsoft.Graph -Scope CurrentUser

2. Installez le module Microsoft Graph pour les scripts Entra :
   ```powershell
   Connect-MgGraph -Scopes "User.Read.All"
