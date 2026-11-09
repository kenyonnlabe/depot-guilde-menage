Opération Workspace

Kenyonn Labe Tibedeo
Guilde ménage


Je vais d'abord sur PowerShell en tant qu'administrateur. Ensuite je tape cd "$HOME\kit-poste" puis ".\scripts\specialites.ps1 -Specialite Menage" comme indiqué dans le cahier.

1) Au moins 20 % de place libre sur C, corbeille de moins de 1 Go : 
D'abord, j'ai vérifié mon espace libre à travers le chemin : Explorateur de fichiers > Ce PC > Disque Dur (C:). Ayant 416 Go, il me fallait 83,2 Go de libre. J'en avais 325 Go donc la tâche était déjà réalisée.  
Sinon j'aurais pu procéder au Nettoyage de disque intégré (outil Windows). Ensuite, j'aurais sélectionné les Fichiers Windows Update temporaires, Fichiers temporaires, Corbeille, Vignettes. Enfin, 'aurais cliqué sur « Nettoyer les fichiers système ». 
Pourquoi cette manipulation ? Car Windows Update a besoin d'espace pour ses MaJ et téléchargements. Car les fichiers d’échange et de veille prolongée (pagefile.sys, hiberfil.sys) ont besoin d’espace réservé pour fonctionner correctement, le système peut devenir instable ou planter. Car Les points de restauration et clichés instantanés (ceux que j'ai configuré en quête précédente) ont besoin de place pour exister, sinon je ne peux pas retourner en arrière en cas de problème. 

2) Applications au démarrage : 6
D'abord, j'ai ouvert le Gestionnaire des tâches pour aller sur l’onglet « Applications de démarrage ». Ensuite il faut repérer l’impact de chaque appli pour choisir quoi désactiver en premier. J'ai alors remarqué que j'avais 3 applications de démarrage en trop, ainsi j'ai désactivé Discord, Steam et Copilot afin d'atteindre les 6 applications au démarrage.
Il faut s'en assurer car chaque application lancée au démarrage prend de la mémoire et du processeur. Aussi, une application qui se lance seule peut être une porte d’entrée pour un programme indésirable

3) Assistant Stockage activé
Pour m’assurer que l’Assistant Stockage est activé, j’ai ouvert les Paramètres de Windows, puis Système, Stockage. Dans cette page, l’option « Assistant Stockage » possède un interrupteur. Je l’ai vérifié et il était déjà activer. Dans le cas contraire, je l’aurais simplement basculé sur « Activé » d’un clic.
Cette fonction s'avère utile parce qu’elle supprime automatiquement les fichiers temporaires dont Windows n’a plus besoin et qu’elle vide la corbeille à intervalle régulier.

4) Corbeille de moins de 1 Go
Pour vérifier la taille de ma corbeille, j’ai utilisé l’interface de Windows. Je suis encore allé dans Paramètres, puis Système, Stockage. J’ai cliqué sur « Fichiers temporaires » pour avoir la ligne « Corbeille » qui indique sa taille. On peut aussi ouvrir la Corbeille depuis le bureau, sélectionner tous les fichiers avec Ctrl + A, puis faire un clic droit et choisir Propriétés pour lire la taille totale. Chez moi, elle fait 219 Mo, donc elle est sous la limite de 1 Go. Si elle avait dépassé 1 Go, j’aurais d’abord regardé son contenu pour ne pas perdre un fichier utile. Ensuite, j’aurais fait un clic droit sur l’icône de la corbeille et choisi « Vider la corbeille ». 
Un fichier supprimé reste sur le disque tant que la corbeille n’est pas vidée. Il occupe donc de la place pour rien et peut garder des documents que je croyais effacés.

A la fin, j'ai exécuté l'outil "winget upgrade --all" pour appliquer les dernières mises à jour.
