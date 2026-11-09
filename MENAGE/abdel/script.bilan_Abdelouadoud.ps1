<# 
================================================================================
  SCRIPT DE BILAN ET DIAGNOSTIC AUTOMATISÉ - POWERSHELL ISE
================================================================================
  Auteur  : Abdelouadoud Benali
  Fichier : menu.ps1
  Version : 7.0 (Prénom dynamique au démarrage et à la fermeture)
================================================================================
#>

# À QUOI ÇA SERT : Active l'encodage UTF-8 pour la console PowerShell.
# POURQUOI LE FAIRE : Empêche les bugs d'affichage des accents et symboles comme '\ (^o^) /'.
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# --- [0] DÉTECTION DYNAMIQUE DU PRÉNOM DE L'UTILISATEUR CONNECTÉ ---

# À QUOI ÇA SERT : Extrait dynamiquement le prénom de la personne qui utilise le PC.
# POURQUOI LE FAIRE : Cherche d'abord le nom complet du compte Windows local (ex: "Jean Dupont" -> "Jean"). 
# Si non défini, il prend le nom de session ($env:USERNAME).
$compteWin = Get-CimInstance Win32_UserAccount -Filter "Name='$env:USERNAME'" -ErrorAction SilentlyContinue
$prenomUtilisateur = if ($compteWin.FullName) { $compteWin.FullName.Split(' ')[0] } else { $env:USERNAME }

# --- [1] UTILITIES ET ANIMATION ---

# À QUOI ÇA SERT : Affiche le petit bonhomme en vert lorsque le score atteint 100/100.
function Afficher-Bravo ($texte) {
    Write-Host "  \ (^o^) /  BRAVO ! $texte (Score 100/100)" -ForegroundColor Green
}

# --- [2] MODULE : SYSTÈME ET CPU ---

function Diag-Sys {
    Write-Host "`n--- [1] SYSTEME & CPU ---" -ForegroundColor Cyan
    
    # À QUOI ÇA SERT : Interroge les composants matériels et le système via CIM.
    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = (Get-CimInstance Win32_Processor | Select-Object -First 1).LoadPercentage
    if (-not $cpu) { $cpu = 0 }
    
    Write-Host "PC: $env:COMPUTERNAME | Utilisateur : $prenomUtilisateur ($env:USERNAME) | OS: $($os.Caption)"
    Write-Host "Charge CPU : $cpu/100 ($cpu%)" -ForegroundColor Yellow
}

# --- [3] MODULE : MÉMOIRE RAM ---

function Diag-Ram {
    Write-Host "`n--- [2] MEMOIRE RAM ---" -ForegroundColor Cyan
    $os = Get-CimInstance Win32_OperatingSystem
    
    # À QUOI ÇA SERT : Convertit les Kilo-octets de Windows en Gigaoctets (/ 1MB) arrondis à 2 décimales.
    $tot = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $free = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $used = [math]::Round($tot - $free, 2)
    
    # À QUOI ÇA SERT : Calcule les ratios d'utilisation et de liberté sur 100.
    $pctUsed = [math]::Round(($used / $tot) * 100, 0)
    $pctFree = 100 - $pctUsed
    
    Write-Host "Total: $tot Go | Occupé: $used Go ($pctUsed/100) | Libre: $free Go ($pctFree/100)"
    if ($pctFree -eq 100) { Afficher-Bravo "Mémoire RAM entièrement disponible !" }
}

# --- [4] MODULE : ESPACE DISQUE ---

function Diag-Disk {
    Write-Host "`n--- [3] DISQUES ---" -ForegroundColor Cyan
    
    # À QUOI ÇA SERT : Filtre DriveType=3 pour cibler uniquement les disques locaux réels.
    Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        $t = [math]::Round($_.Size / 1GB, 2); $f = [math]::Round($_.FreeSpace / 1GB, 2)
        $pFree = [math]::Round(($f / $t) * 100, 0)
        
        Write-Host "Lecteur [$($_.DeviceID)] Total: $t Go | Libre: $f Go ($pFree/100 libre)"
        if ($pFree -eq 100) { Afficher-Bravo "Disque [$($_.DeviceID)] 100% disponible !" }
    }
}

# --- [5] MODULE : RÉSEAU ET CONNECTIVITÉ ---

function Diag-Net {
    Write-Host "`n--- [4] RESEAU ---" -ForegroundColor Cyan
    
    # À QUOI ÇA SERT : Retire la boucle locale (Loopback) et les IP temporaires (169.254).
    Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.254*" } | ForEach-Object {
        Write-Host "Carte: $($_.InterfaceAlias) -> IP: $($_.IPAddress)"
    }
    
    # À QUOI ÇA SERT : Teste l'accès Internet vers Google (8.8.8.8) en mode silencieux.
    $ping = Test-Connection 8.8.8.8 -Count 1 -Quiet
    if ($ping) {
        Write-Host "Santé Connexion : 100/100 (En ligne)" -ForegroundColor Green
        Afficher-Bravo "Connexion Internet Parfaite !"
    } else {
        Write-Host "Santé Connexion : 0/100 (Hors ligne)" -ForegroundColor Red
    }
}

# --- [6] MODULE : GENERATION ET AFFICHAGE DU CHEMIN DU RAPPORT ---

function Exporter-Rapport {
    $fichier = "$env:USERPROFILE\Desktop\Bilan_Systeme_$env:COMPUTERNAME.txt"
    
    $(
        Write-Output "================================================="
        Write-Output "  RAPPORT DE DIAGNOSTIC AUTOMATISÉ"
        Write-Output "  Développé par : Abdelouadoud Benali"
        Write-Output "  Analyse de    : $prenomUtilisateur ($env:USERNAME)"
        Write-Output "  Date          : $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')"
        Write-Output "================================================="
        Diag-Sys; Diag-Ram; Diag-Disk; Diag-Net
    ) | Out-File -FilePath $fichier -Encoding UTF8
    
    Write-Host "`n--- [5] RAPPORT GÉNÉRÉ & ENREGISTRÉ ---" -ForegroundColor Cyan
    Write-Host "  ► Fichier enregistré sous :" -NoNewline -ForegroundColor White
    Write-Host " $fichier" -ForegroundColor Yellow
}

# À QUOI ÇA SERT : Met en pause l'affichage proprement dans PowerShell ISE.
function Pause-ISE { Write-Host "`nAppuyez sur Entrée pour continuer..."; $null = Read-Host }

# --- [7] BOUCLE INTERACTIVE ET MENU PRINCIPAL ---

do {
    Clear-Host
    Write-Host "=== BILAN SYSTEME - DEVELOPPER PAR ABDELOUADOUD BENALI ===" -ForegroundColor Yellow
    Write-Host "1. Bilan Complet (Affiche l'analyse + Génère et montre le chemin TXT)" -ForegroundColor Green
    Write-Host "2. Systeme & CPU"
    Write-Host "3. RAM"
    Write-Host "4. Disques"
    Write-Host "5. Reseau"
    Write-Host "6. Exporter uniquement le Rapport TXT" -ForegroundColor Cyan
    Write-Host "0. Quitter"
    
    $c = Read-Host "`nChoix (0-6)"
    
    switch ($c) {
        "1" { Clear-Host; Diag-Sys; Diag-Ram; Diag-Disk; Diag-Net; Exporter-Rapport; Pause-ISE }
        "2" { Clear-Host; Diag-Sys; Pause-ISE }
        "3" { Clear-Host; Diag-Ram; Pause-ISE }
        "4" { Clear-Host; Diag-Disk; Pause-ISE }
        "5" { Clear-Host; Diag-Net; Pause-ISE }
        "6" { Clear-Host; Exporter-Rapport; Pause-ISE }
        "0" { 
            # À QUOI ÇA SERT : Affiche l'au revoir personnalisé avec le prénom extrait de la session de la personne.
            Write-Host "`nAu revoir $prenomUtilisateur !" -ForegroundColor Cyan 
            Start-Sleep -Seconds 1
        }
        default { Write-Host "Choix invalide !"; Start-Sleep 1 }
    }
} until ($c -eq "0")
