scripts
=======

Fichiers de config de différents outils.

    ln -s <path_to_git_repo>/.gitconfig ~/.gitconfig

Xmonad
------

- .xmonad/xmonad.hs
- .xmobarrc (pour la barre d'infos)
- dans .xsession :

<!-- -->

    #!/bin/bash

    /usr/bin/trayer --edge top  --align right --SetDockType true --SetPartialStrut false  --expand true  -    -widthtype percent --width 4 --transparent true --alpha 0  --tint 0x000000 --height 15 --monitor 0 &
    
    exec ck-launch-session xmonad



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
