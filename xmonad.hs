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
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.PerWorkspace
import XMonad.Util.Run(spawnPipe)
--Rezise
--import XMonad.Layout.ResizableTile
--sub layouts
--import XMonad.Layout.SubLayouts
--import XMonad.Layout.Simplest
--Window Navigator
--import XMonad.Layout.WindowNavigation
import qualified XMonad.StackSet as W

-- ----------
-- Workspaces
-- ----------
w1Id = "1 web"
w2Id = "2 term"
w3Id = "3 idea"
w4Id = "4 sql"
w5Id = "5"
w6Id = "6"
w7Id = "7"
-- w8Id = "8 mail"
w8Id = "8"
w9Id = "9 IM"

myWorkspaces = [w1Id, w2Id, w3Id, w4Id, w5Id, w6Id, w7Id, w8Id, w9Id]


myInternet = "google-chrome --allow-file-access-from-files"
myIDE = "~/.xmonad/bin/idea.sh"
myIM = "~/.xmonad/launch/im.sh"
-- terminal
myTerminal = "terminator"
-- myMail = "thunderbird"

-- ----
-- Keys
-- ----
newKeys x = M.union (M.fromList (myKeys x)) (keys azertyConfig x)
myKeys conf@(XConfig {XMonad.modMask = modMask}) =
    [
    -- lock screen ctrl + mod + space
    ((modMask .|. controlMask, xK_space), spawn "~/.xmonad/bin/screensaver.sh")

    
    --, ((modMask .|. shiftMask, xK_twosuperior), spawn "setxkbmap fr bepo") -- with bepo keyboard
    --, ((modMask .|. controlMask, xK_1), spawn "setxkbmap fr") -- with azerty keyboard
    , ((modMask .|. shiftMask, xK_b), goToSelected defaultGSConfig)
    , ((mod1Mask, xK_F2), spawn "mutate") --mod1Mask = left alt
    , ((modMask, xK_u), sendMessage ShrinkSlave)     -- Shrink a slave area
    , ((modMask, xK_i), sendMessage ExpandSlave)     -- Expand a slave area
    , ((0, 0x1008FF12), spawn "amixer -D pulse set Master toggle")
    , ((0, 0x1008FF11), spawn "amixer sset Master 2-")
    , ((0, 0x1008FF13), spawn "amixer sset Master 2+")
    , ((0, 0xff61), spawn "~/.xmonad/bin/printscreen.sh")	--print screen with crop
    , ((modMask, 0xff61), spawn "~/.xmonad/bin/printwindow.sh")	--select window to print

    , ((0 .|. modMask, xK_a), windows $ W.greedyView w9Id)
    , ((shiftMask .|. modMask, xK_a), windows $ W.shift w9Id)
    ]
    ++
    -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
--        | (key, sc) <- zip [xK_e, xK_z, xK_r] [0..]
        | (key, sc) <- zip [xK_z, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- Layouts
myLayout = mouseResizableTile ||| tiled ||| simpleTabbed
    where
    	tiled = Tall nmaster delta ratio
	nmaster = 1
	ratio = 1/2
	delta = 3/100

tabFirstLayout = simpleTabbed ||| mouseResizableTile

pidginLayout = pidginTiled ||| mouseResizableTile
    where
        pidginTiled = Tall nmaster delta ratio
	nmaster = 1
	ratio = 4/5
	delta = 3/100

-- smartBorder : change focused window border
-- avoidStruts : smart handle of xmobar (if not set, window will be placed hover it)
-- onWorkspace <workspaceId> <layoutName>
-- last layout will be applied on other workspaces
myLayoutHook = smartBorders (avoidStruts 
		$ onWorkspace w2Id myLayout 
		$ onWorkspace w9Id pidginLayout 
		$ tabFirstLayout)

--------------
--Tab Colors--
--------------


-- className :
--   xprop | grep WM_CLASS
--   cliquer sur la fenetre
--   Deuxième String
-- appName :
--   xprop | grep WM_CLASS
--   cliquer sur la fenetre
--   Première String
-- title :
--   xprop | grep WM_NAME
--   cliquer sur la fenetre
myManageHook = composeAll
  [ className =? "Gitk"           --> doFullFloat
  , className =? "Diffmerge"      --> doFullFloat
  , className =? "Pidgin"         --> doF (W.shift w9Id)
  , className =? "HipChat"        --> doF (W.shift w9Id)
  , className =? "jetbrains-idea" --> doF (W.shift w3Id)
  , title     =? "Postman"        --> doF (W.shift w4Id)
  -- , className =? "Thunderbird"    --> doF (W.shift w8Id)
  , title =? "Do"                 --> doFloat
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
                          layoutHook = myLayoutHook,
			  startupHook = do
			      setWMName "LG3D"
			      spawnOn w1Id myInternet  --this line and following : start apps on given workspace
			      spawnOn w2Id myTerminal
			      spawn myIDE  --this line and following : just start apps (workspace is handled by manageHook)
			      spawn myIM
			      -- spawn myMail
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

