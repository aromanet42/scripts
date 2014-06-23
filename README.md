Config
======

Pour utiliser les fichers de config, utiliser des liens symboliques

    ln -s <path_to_git_repo>/.gitconfig ~/.gitconfig

Xmonad
------

- .xmonad/xmonad.hs
- .xmobarrc (pour la barre d'infos)
- `ln -s <path_to_git_repo>/bin ~/.xmonad/bin`
- dans .xsession :

<!-- -->

    #!/bin/bash

    /usr/bin/trayer --edge top  --align right --SetDockType true --SetPartialStrut false  --expand true  -    -widthtype percent --width 4 --transparent true --alpha 0  --tint 0x000000 --height 15 --monitor 0 &
    
    exec ck-launch-session xmonad


Xmodmap
-------
Gestionnaire du clavier : [Xmodmap](https://wiki.archlinux.org/index.php/xmodmap)

- .Xmodmap


### Definitions des touches

    /usr/include/X11/keysymdef.h

Pour trouver une lettre :

    grep -i "CEDILLA" /usr/include/X11/keysymdef.h

### Trouver la touche associée à une lettre

    xmodmap -pke | grep ccedilla
    xmodmap -pke | grep "c "



Git
---
- .gitconfig
- dossier Git/

Vim
---
- .vimrc
- dossier Vim/

Bash
----
- .zshrc

Scripts utilitaires
===================

colortail
---------
Permet de tail un fichier tout en mettant en valeur certains patterns

