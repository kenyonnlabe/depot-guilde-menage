<#
====================================================================
  SCRIPT DE BILAN ET DIAGNOSTIC SYSTEME
  Auteur       : Labe Tibedeo Kenyonn
  Nom du Script: menu.ps1
  Description  : Script automatisé avec menu interactif sous Windows.
                 Permet d'extraire les infos matérielles et réseau.
====================================================================
#>

# ------------------------------------------------------------------
# SECTION 1 : LES FONCTIONS (Vos outils de diagnostic)
# En PowerShell, une "function" (fonction) est un bloc de code qu'on 
# enregistre sous un nom pour pouvoir l'appeler quand on en a besoin.
# ------------------------------------------------------------------

# --- FONCTION 1 : Afficher qui est le PC et quel est son système ---
function Get-MachineIdentity {
    # Write-Host sert à afficher du texte à l'écran. 
    # -ForegroundColor permet de choisir la couleur du texte.
    Write-Host "==================================================" -ForegroundColor Yellow
    Write-Host " 1. IDENTITE DU SYSTEME ET DU POSTE               " -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Yellow
    Write-Host ""
    
    # $env:COMPUTERNAME et $env:USERNAME sont des "variables d'environnement".
    # Ce sont des raccourcis automatiques de Windows pour connaître le nom du PC et de l'utilisateur.
    $ComputerName = $env:COMPUTERNAME
    $UserName     = $env:USERNAME

    # Get-CimInstance interroge le cœur de Windows (WMI/CIM) pour obtenir des infos matérielles.
    # Win32_OperatingSystem contient tout sur la version de Windows installée.
    $OSInfo = Get-CimInstance Win32_OperatingSystem

    # On calcule depuis combien de temps le PC est allumé (Uptime) :
    # (Get-Date) donne l'heure actuelle, à laquelle on soustrait l'heure du dernier démarrage ($OSInfo.LastBootUpTime).
    $Uptime = (Get-Date) - $OSInfo.LastBootUpTime

    # On affiche proprement les résultats
    Write-Host "  > Nom de la machine : $ComputerName" -ForegroundColor Cyan
    Write-Host "  > Utilisateur actif : $UserName" -ForegroundColor Cyan
    Write-Host "  > Système d'expl.   : $($OSInfo.Caption)"
    Write-Host "  > Temps en ligne    : $($Uptime.Days) jours, $($Uptime.Hours) heures et $($Uptime.Minutes) minutes"
    Write-Host ""
}

# --- FONCTION 2 : Vérifier l'espace sur les disques durs ---
function Get-DiskStorageInfo {
    Write-Host "==================================================" -ForegroundColor Yellow
    Write-Host " 2. ESPACE DISQUE DISPONIBLE                      " -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Yellow
    Write-Host ""

    # Win32_LogicalDisk liste toutes les partitions (C:, D:, lecteur CD, etc.).
    # -Filter "DriveType=3" permet de ne garder QUE les vrais disques durs ou SSD internes.
    # Le symbole "|" (pipe) envoie ces disques à ForEach-Object pour qu'il les traite un par un.
    Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        
        # Windows donne la taille en octets. On la divise par 1GB pour l'avoir en Giga-octets.
        # [math]::Round(..., 2) arrondit le résultat avec seulement 2 chiffres après la virgule.
        $TotalGB = [math]::Round($_.Size / 1GB, 2)
        $FreeGB  = [math]::Round($_.FreeSpace / 1GB, 2)
        
        # Calcul du pourcentage d'espace encore disponible sur le disque
        $PercentFree = [math]::Round(($FreeGB / $TotalGB) * 100, 1)

        # Condition IF (SI/SINON) pour gérer la couleur de l'alerte :
        # Si le disque a moins de 10% de disponible, on met le texte en Rouge ("Red"), sinon en Vert ("Green").
        $Color = if ($PercentFree -lt 10) { "Red" } else { "Green" }

        # $_.DeviceID contient la lettre de la partition (ex: C:)
        Write-Host "  > Partition $($_.DeviceID) - Total: $TotalGB GB | Libre: $FreeGB GB ($PercentFree % libre)" -ForegroundColor $Color
    }
    Write-Host ""
}

# --- FONCTION 3 : Mesurer l'utilisation de la mémoire RAM ---
function Get-MemoryStatus {
    Write-Host "==================================================" -ForegroundColor Yellow
    Write-Host " 3. ETAT DE LA MEMOIRE RAM                        " -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Yellow
    Write-Host ""

    # Interrogation des caractéristiques de la mémoire système
    $OSInfo = Get-CimInstance Win32_OperatingSystem

    # Windows stocke la RAM en Kilo-octets (KB). Pour des Giga-octets (GB), on divise par 1MB.
    $TotalRAM = [math]::Round($OSInfo.TotalVisibleMemorySize / 1MB, 2)
    $FreeRAM  = [math]::Round($OSInfo.FreePhysicalMemory / 1MB, 2)
    $UsedRAM  = [math]::Round($TotalRAM - $FreeRAM, 2)
    
    # Calcul du taux d'utilisation de la RAM en %
    $PctUsed  = [math]::Round(($UsedRAM / $TotalRAM) * 100, 1)

    # Condition IF : Si la RAM est occupée à plus de 85%, c'est une alerte (Rouge), sinon tout va bien (Vert).
    $Color = if ($PctUsed -gt 85) { "Red" } else { "Green" }

    Write-Host "  > RAM Totale    : $TotalRAM GB"
    Write-Host "  > RAM Utilisée  : $UsedRAM GB ($PctUsed %)" -ForegroundColor $Color
    Write-Host "  > RAM Libre     : $FreeRAM GB"
    Write-Host ""
}

# --- FONCTION 4 : Récupérer l'adresse IP et les cartes réseau ---
function Get-NetworkStatus {
    Write-Host "==================================================" -ForegroundColor Yellow
    Write-Host " 4. ETAT DU SYSTEME ET DU RESEAU                  " -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Yellow
    Write-Host ""

    # Get-NetIPAddress cherche les configurations IP du PC.
    # -AddressFamily IPv4 : pour avoir une adresse au format classique (ex: 192.168.1.15).
    # Where-Object : on exclut la carte réseau de bouclage interne ("Loopback" / 127.0.0.1).
    Get-NetIPAddress -AddressFamily IPv4 | Where-Object InterfaceAlias -notlike "*Loopback*" | ForEach-Object {
        # $_.InterfaceAlias donne le nom de la carte (ex: Wi-Fi ou Ethernet)
        # $_.IPAddress donne l'adresse IP attribuée
        Write-Host "  > Carte Réseau : $($_.InterfaceAlias) | Adresse IP : $($_.IPAddress)" -ForegroundColor Cyan
    }
    Write-Host ""
}

# --- FONCTION 5 : Lancer le bilan complet d'un seul coup ---
function Get-FullDiagnostic {
    # Clear-Host nettoie l'écran du terminal pour repartir d'une page vierge.
    Clear-Host
    
    # On exécute l'une après l'autre les 4 fonctions définies au-dessus
    Get-MachineIdentity
    Get-DiskStorageInfo
    Get-MemoryStatus
    Get-NetworkStatus
}

# --- FONCTION 6 : Créer un fichier texte de rapport sur le bureau ---
function Export-BilanReport {
    Clear-Host
    
    # [Environment]::GetFolderPath('Desktop') trouve l'emplacement exact du dossier Bureau du PC.
    # Get-Date -Format 'yyyy-MM-dd' donne la date du jour (ex: 2026-11-09).
    $FilePath = "$([Environment]::GetFolderPath('Desktop'))\Bilan_Systeme_$(Get-Date -Format 'yyyy-MM-dd').txt"
    
    # Le symbole "|" prend tout le texte affiché par Get-FullDiagnostic
    # et Out-File l'écrit directement dans le fichier texte spécifié.
    Get-FullDiagnostic | Out-File -FilePath $FilePath

    Write-Host "`n[SUCCÈS] Rapport généré sur le bureau !" -ForegroundColor Green
    Write-Host "Chemin : $FilePath`n" -ForegroundColor Yellow
}

# ------------------------------------------------------------------
# SECTION 2 : BOUCLE DU MENU INTERACTIF
# ------------------------------------------------------------------

# La structure "do { ... } while (...)" fait tourner le menu en boucle.
# Le menu reste affiché tant que vous ne tapez pas '0' pour quitter.
do {
    # On vide l'écran pour réafficher le menu principal de façon propre
    Clear-Host

    # Affichage du menu principal
    Write-Host "==================================================" -ForegroundColor Yellow
    Write-Host " SCRIPT DE BILAN ET DIAGNOSTIC SYSTEME           " -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host " 1  Afficher l'identité de la machine"
    Write-Host " 2  Vérifier l'espace disque"
    Write-Host " 3  Vérifier la mémoire RAM"
    Write-Host " 4  Vérifier la configuration réseau"
    Write-Host " 5  Exécuter le bilan complet"
    Write-Host " 6  Exporter le bilan dans un fichier .txt sur le bureau"
    Write-Host ""
    Write-Host " 0  Quitter"
    Write-Host ""

    # Read-Host stoppe le script et attend que l'utilisateur tape un choix au clavier
    $selection = Read-Host "Ton choix"

    # La structure "switch" regarde ce qui a été tapé dans $selection
    # et exécute la ligne correspondante.
    switch ($selection) {
        # 'Pause' met en attente et demande d'appuyer sur une touche avant de réafficher le menu.
        '1' { Clear-Host; Get-MachineIdentity; Pause }
        '2' { Clear-Host; Get-DiskStorageInfo; Pause }
        '3' { Clear-Host; Get-MemoryStatus; Pause }
        '4' { Clear-Host; Get-NetworkStatus; Pause }
        '5' { Get-FullDiagnostic; Pause }
        '6' { Export-BilanReport; Pause }
        '0' { Write-Host "`nFermeture du script..." -ForegroundColor Yellow }
        
        # 'default' s'exécute si l'utilisateur tape un mauvais chiffre (ex: 9)
        default { Write-Host "`nChoix invalide." -ForegroundColor Red; Start-Sleep 1 }
    }

# Le script boucle TANT QUE ($selection -ne '0') -> "-ne" signifie "Not Equal" (Pas égal à 0)
} while ($selection -ne '0')
