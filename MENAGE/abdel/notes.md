Diagnostic initial (Bilan réalisé le mercredi)
Pour vérifier l'état du PC et savoir quelles actions réaliser parmi les 4 points, la démarche a été exécutée ce mercredi à l'aide d'un script de diagnostic. Toute la procédure s'est déroulée de manière fluide, sans aucun problème technique rencontré.

Ouvrir le Terminal / PowerShell.

Se déplacer dans le dossier du kit :

PowerShell
cd $HOME\kit-poste
Lancer le script d'évaluation :

PowerShell
.\scripts\specialites.ps1 -Specialite Menage
Résultat du bilan : Ce script a affiché l'état de conformité du poste et a indiqué précisément les éléments à corriger (le point 1 restait à faire, tandis que les points 2, 3 et 4 étaient déjà validés).

1. Limiter les applications au démarrage (Max. 6)
Statut sur mon PC : Non fait au départ (relevé par le script le mercredi). J'ai recherché la procédure sur Internet et je l'ai appliquée immédiatement sans rencontrer de problème.

C'est quoi ? Le blocage des programmes secondaires qui se lancent automatiquement à l'allumage de l'ordinateur.

Pourquoi ? Réduire le temps de démarrage de Windows et libérer immédiatement de la mémoire RAM et du processeur.

Comment faire ?

Ouvrir le Gestionnaire des tâches (Ctrl + Maj + Échap).

Aller dans l'onglet Applications de démarrage.

Clic droit > Désactiver sur les logiciels non essentiels (garder au maximum 6 applications).

2. Activer l'Assistant de Stockage
Statut sur mon PC : Déjà fait. La vérification et la compréhension de la méthode le mercredi se sont déroulées sans aucun problème.

C'est quoi ? Un outil automatique intégré à Windows qui nettoie régulièrement les fichiers temporaires et obsolètes.

Pourquoi ? Conserver un système propre en continu sans intervention manuelle et économiser de l'espace disque.

Comment faire ?

Ouvrir les Paramètres (Win + I) > Système > Stockage.

Activer le commutateur Assistant de stockage.

Cliquer dessus pour régler la fréquence de nettoyage (ex. mensuel) et la suppression automatique des temporaires.

3. Garder au moins 20 % d'espace libre sur C: et Corbeille < 1 Go
Statut sur mon PC : Déjà fait. Contrôlé le mercredi sans souci particulier, la configuration était déjà conforme.

C'est quoi ? Le maintien d'une marge de sécurité sur le disque principal et la limitation de l'espace réservé aux fichiers jetés.

Pourquoi ? Éviter les baisses de performances des SSD/HDD (perte de vitesse d'écriture) et garantir l'espace nécessaire au bon fonctionnement de Windows.

Comment faire ?

Ouvrir l'Explorateur de fichiers (Win + E) > Ce PC (vérifier qu'au moins 20 % de la barre du disque C: reste vide).

Clic droit sur l'icône Corbeille sur le bureau > Propriétés.

Fixer la Taille maximale à 1000 Mo (1 Go) puis vider la corbeille.

4. Désinstaller les applications inutiles et tout mettre à jour (winget & choco)
Statut sur mon PC : Déjà fait. Les commandes et la vérification effectuées le mercredi ont fonctionné parfaitement sans aucune difficulté.

C'est quoi ? La suppression des logiciels superflus (bloatwares) et l'automatisation des mises à jour via des gestionnaires de paquets en ligne de commande.

Pourquoi ? Supprimer les failles de sécurité, alléger le registre Windows et mettre à jour tous ses programmes en une seule commande sans passer par un navigateur.

Comment faire ?

Désinstallation : Paramètres (Win + I) > Applications > Applications installées > Supprimer les logiciels inutilisés.

Mises à jour : Ouvrir le Terminal (Administrateur) et lancer la commande winget upgrade --all (ou choco upgrade all -y si Chocolatey est utilisé).
