Config
======

Pour utiliser les fichers de config, utiliser des liens symboliques

    ln -s <path_to_git_repo>/.gitconfig ~/.gitconfig

Synapse
-------

Synapse est un launcher. Dans la config Xmonad de ce repo, il est activé avec Alt+F2

Pour l'installer :

    sudo add-apt-repository ppa:noobslab/apps
    sudo apt-get update
    sudo apt-get install synapse


Pour ajouter des lanceurs Synapse, créer un fichier `~∕.local/share/applications/<appName>.desktop` contenant :

    [Desktop Entry]
    Name=IntelliJ
    Exec=/devtools/idea/bin/idea.sh
    Icon=/devtools/idea/bin/idea.png
    Type=Application
    Categories=Utility;


Xmonad
------

- .xmonad/xmonad.hs
- .xmobarrc (pour la barre d'infos)
- `ln -s <path_to_git_repo>/bin ~/.xmonad/bin`
- dans .xsession :

<!-- -->

    #!/bin/bash

    xmonad


- dans .xsessionrc :

<!-- -->

    . ~/.env

    /usr/bin/trayer --edge top  --align right --SetDockType true --SetPartialStrut false  --expand true  --widthtype percent --width 4 --transparent true --alpha 0  --tint 0x000000 --height 15 --monitor 0 &

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


Git
---
- .gitconfig

Vim
---
- .vimrc
- dossier Vim/

Bash
----
- .zshrc

installer avec le lien fourni par :

    https://github.com/lucmazon/custom-zsh

si le nouveau terminal utilise toujours bash, vérifier que le fichier `/etc/passwd` contienne bien :

    <username>:.....:/bin/zsh


et si besoin lancer la commande `chsh` pour pointer vers zsh


Pour avoir la coloration de la ligne de commande (en vert quand la commande existe, etc), utiliser [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)


Scripts utilitaires
===================

colortail
---------
Permet de tail un fichier tout en mettant en valeur certains patterns

