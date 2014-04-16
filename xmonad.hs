import qualified Data.Map as M
import System.IO
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.SpawnOn
import XMonad.Actions.UpdatePointer
import XMonad.Config.Azerty
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Grid
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.ToggleLayouts
import XMonad.Util.Run(spawnPipe)
--Rezise
--import XMonad.Layout.ResizableTile
--sub layouts
--import XMonad.Layout.SubLayouts
--import XMonad.Layout.Simplest
--Window Navigator
--import XMonad.Layout.WindowNavigation
import qualified XMonad.StackSet as W



newKeys x = M.union (M.fromList (myKeys x)) (keys azertyConfig x)
myKeys conf@(XConfig {XMonad.modMask = modMask}) =
    [
    -- lock screen ctrl + mod + space
    ((modMask .|. controlMask, xK_space), spawn "gnome-screensaver-command --lock")

    
    --, ((modMask .|. shiftMask, xK_twosuperior), spawn "setxkbmap fr bepo") -- with bepo keyboard
    , ((modMask .|. shiftMask, xK_twosuperior), spawn "~/bin/swith-keyboard-layout") -- Switch bepo <-> azerty
    --, ((modMask .|. controlMask, xK_1), spawn "setxkbmap fr") -- with azerty keyboard
    , ((modMask .|. shiftMask, xK_b), goToSelected defaultGSConfig)
    , ((mod1Mask, xK_F2), spawn "synapse") --mod1Mask = left alt
    ]
    ++
    -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
--        | (key, sc) <- zip [xK_e, xK_z, xK_r] [0..]
        | (key, sc) <- zip [xK_z, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- Layouts
-- default
myLayout = (toggleLayouts $ noBorders Full) $ -- toggle fullscreen
  (noBorders tabbed ||| Grid ||| layoutHook defaultConfig)
  where tabbed = named "Tabbed" $ simpleTabbed

--------------
--Tab Colors--
--------------

-- Workspaces
w1Id = "1 web"
w2Id = "2 term"
w3Id = "3 idea"
w4Id = "4 sql"
w5Id = "5"
w6Id = "6"
w7Id = "7"
w8Id = "8 mail"
w9Id = "9 pidgin"

myWorkspaces = [w1Id, w2Id, w3Id, w4Id, w5Id, w6Id, w7Id, w8Id, w9Id]


myInternet = "google-chrome"
myIDE = "sh /home/aromanet/devtools/idea/bin/idea.sh"
myMail = "thunderbird"
myIM = "launch-pidgin.sh"
-- terminal
myTerminal = "gnome-terminal --hide-menubar"



-- pour trouver le className d'une fenetre :
-- ouvrir un term dans le mm workspace que la fenetre
-- taper : xprop | grep WM_CLASS
-- cliquer sur la fenetre
-- le classname est la deuxième String. (la premiere correspond au nom de la resource)
myManageHook = composeAll
  [ title =? "gitk"               --> doFullFloat
  , className =? "Diffmerge"      --> doFullFloat
  , manageDocks  -- manageDocks pour que le trayer apparaisse sur tous les workspaces du monitor, et pas seulement le 1er
  , manageSpawn
  ]

main = do
      xmproc <- spawnPipe "xmobar"
      xmonad $ defaultConfig {
                          manageHook = myManageHook <+> manageHook defaultConfig,
			  workspaces = myWorkspaces,
                          keys = newKeys,
                          modMask = mod4Mask,
                          layoutHook = smartBorders (avoidStruts $ myLayout),
			  startupHook = do
			      setWMName "LG3D"
			      spawnOn w1Id myInternet  --this line and following : start apps on given workspace
			      spawnOn w2Id myTerminal
			      spawnOn w3Id myIDE
			      spawnOn w8Id myMail
			      spawnOn w9Id myIM
			  ,
                          terminal = myTerminal,
                          logHook = (dynamicLogWithPP $ xmobarPP
                                    { ppOutput = hPutStrLn xmproc
                                    , ppCurrent = xmobarColor "#09F" "" . wrap "[" "]"
                                    , ppTitle = xmobarColor "pink" "" . shorten 50
                                    }) >> updatePointer (Relative 0.5 0.5) >> takeTopFocus
			,
			focusFollowsMouse = myFocusFollowsMouse
}


-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True 

