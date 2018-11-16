Config
======

Pour installer tout ça : 

    wget --no-check-certificate https://raw.githubusercontent.com/aromanet42/scripts/master/install_and_run_ansible.sh
    bash install.sh


Pour rejouer le script en local :

    ansible-playbook local.yml

    ansible-playbook local.yml --tags postman


Create App launcher
------


Pour ajouter des lanceurs, créer un fichier `~∕.local/share/applications/<appName>.desktop` contenant :

    [Desktop Entry]
    Name=IntelliJ
    Exec=/devtools/idea/bin/idea.sh
    Icon=/devtools/idea/bin/idea.png
    Type=Application
    Categories=Utility;



Xmodmap
-------
Gestionnaire du clavier : [Xmodmap](https://wiki.archlinux.org/index.php/xmodmap)

### Trouver le keycode lié à une touche du clavier
- lancer `xev` (ou `xev | grep keycode` pour éviter le spam)
- appuyer sur la touche
- dans la console, un pavé s'affiche
  ```
  KeyRelease event, serial 32, synthetic NO, window 0x4000001,
    root 0xb6, subw 0x0, time 72482524, (925,448), root:(3486,449),
    state 0x10, keycode 54 (keysym 0x63, c), same_screen YES,
    XLookupString gives 1 bytes: (63) "c"
    XFilterEvent returns: False
  ```
  - on voit le _keycode_ (ici 54), et le code hexa _keysym_ (ici `0x63`)
  
### Trouver la touche liée à un caractère
- `xmodmap -pke | grep <nom du caractère>`

   Exemple: `xmodmap -pke | grep guillem` pour trouver comment faire un "guillemet français" `«`
- lire le résultat : on obtient une ligne décrivant les différents caractères liés à cette touche, en fonction des modificateurs utilisés. Il peut y avoir jusqu'à 8 caractères pour une seule touche

   Exemples:
     - `keycode  52 = w W w W guillemotleft leftdoublequotemark guillemotleft leftdoublequotemark`
     - `keycode  54 = c C ccedilla Ccedilla cent copyright`

   Interprétations
     - premier caractère (`w`, `c`) : touche simple
     - 2eme caractère (`W`, `C`) : `<Shift>` + touche
     - 3eme caractère (`w`, `ç` _ccedilla_) : `<Ctrl Right>` + touche
     - 4eme caractère (`W`, `Ç` _Ccedilla_) : `<Ctrl Right>` + `<Shift>` + touche
     - 5eme caractère (`«` _guillemotleft_ , `¢` _cent_) : `<AltGr>` + touche
     - 6eme caractère (`“` _leftdoublequotemark_ , `©` _copyright_) : `<AltGr>` + `<Shift>` + touche
     - 7eme et 8eme caractères: en général non utilisés. Correspondent à la combinaison des modifications `<Ctrl Right>` et `<AltGr>`
  
### Trouver le mapping lié à une touche 
- il faut connaitre le _keycode_ de la touche (voir _Trouver le keycode lié à une touche du clavier_)
- `xmodmap -pke | grep <keycode>`

### Modifier le mapping d'une touche
- modifier le fichier _~/.Xmodmap_
- rafraichir xmodmap avec `xmodmap ~/.Xmodmap`

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


