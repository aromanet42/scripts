Config
======

Pour installer tout ça : 

    wget --no-check-certificate https://raw.githubusercontent.com/aromanet42/scripts/master/install_and_run_ansible.sh
    bash install.sh


Pour rejouer le script en local :

    [sudo] ansible-playbook local.yml

    ansible-playbook local.yml --tags postman


Mutate
------

Mutate est un launcher. Dans la config Xmonad de ce repo, il est activé avec Alt+F3

Pour ajouter des lanceurs, créer un fichier `~∕.local/share/applications/<appName>.desktop` contenant :

    [Desktop Entry]
    Name=IntelliJ
    Exec=/devtools/idea/bin/idea.sh
    Icon=/devtools/idea/bin/idea.png
    Type=Application
    Categories=Utility;

on peut ajouter des patterns customs. Par exemple, en tapant "JIRA XXX", ça ouvre un browser avec la page JIRA du bon ticket.
Pour cela :

  - créer un fichier jira.sh contenant :

         #!/bin/bash
         echo [$@]
         echo "command=google-chrome -newtab \"<URL TO JIRA>/browser/$@\""
         echo "icon="
         echo "subtext=Open Jira $@"

    `$@` contient l'argument passé (donc le numéro du ticket à ouvrir).

  - Ouvrir les préférences de Mutate en tapant `preference` dans la barre de recherche Mutate.
  - Cliquer sur `Add Item`
  - indiquer l'adresse du script .sh dans `script address`, spécifier le pattern qui va déclancher l'action (par exemple *jira*
  - cliquer sur `modify item`



Xmonad
------

- .xmonad/xmonad.hs
- .xmobarrc (pour la barre d'infos)
- dans .xsession :

<!-- -->

    #!/bin/bash

    xmonad


- dans .profile, ajouter :

<!-- -->

    . "$HOME/.oh-my-zsh/custom/custom_env.zsh"
    . "$HOME/.oh-my-zsh/custom/env.zsh"


- si xmonad veut pas se lancer, vérifier que le fichier `/usr/share/gnome/session/xmonad` ne contienne pas `gnome-panel`



Xmodmap
-------
Gestionnaire du clavier : [Xmodmap](https://wiki.archlinux.org/index.php/xmodmap)

Dans cette version, les touches sont mappées de la façon suivante : 

- touche simple
- `<Shift>` + touche
- `<Right Windows>` + touche
- `<Right Windows>` + `<Shift>` + touche
- `<AltGr>` + touche
- `<AltGr>` + `<Shift>` + touche


Bash
----
- .zshrc

si le nouveau terminal utilise toujours bash, vérifier que le fichier `/etc/passwd` contienne bien :

    <username>:.....:/bin/zsh


et si besoin lancer la commande `chsh` pour pointer vers zsh


Function completions
--------------------

Ajouter de la completion sur une fonction :

- Créer un fichier dans completions (présent dans `$fpath` via un lien symbolique vers `~/.oh-my-zsh/completions`)
- S'inspirer du script `_git-checkout`
-- Le nom du fichier doit être le nom de la fonction à compléter préfixé par `_` (underscore)
-- La première ligne du fichier doit être `#compdef <nom-de-la-fonction>`
- Pour recharger le script :

<!-- -->

    unfunction _git-checkout
    autoload -U _git-checkout


Scripts utilitaires
===================

colortail
---------
Permet de tail un fichier tout en mettant en valeur certains patterns

