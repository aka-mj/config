-------------------- imports --------------------
 
-- necessary
import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit
import Graphics.X11.Xlib
import Graphics.X11.ExtraTypes.XF86
import IO (Handle, hPutStrLn) 

-- utils
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig
import XMonad.Util.Scratchpad
import XMonad.Util.Font
import XMonad.Util.XSelection
import XMonad.Util.WorkspaceCompare
import XMonad.Util.WindowProperties

-- actions
import XMonad.Actions.NoBorders
import XMonad.Actions.SwapWorkspaces

-- hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.XPropManage
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive

-- Dialog and menu hooks
import Graphics.X11.Xlib.Extras
import Foreign.C.Types (CLong)

-- layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LayoutHints
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.TwoPane
import XMonad.Layout.Tabbed
import XMonad.Layout.ResizableTile
import XMonad.Layout.Gaps
import XMonad.Layout.Named
import XMonad.Layout.PerWorkspace
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import Data.Ratio((%))

----------------------------------------------------------------
main = do
       h <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
       xmonad $ defaultConfig 
              { workspaces = [" eax ", " ebx ", " ecx ", " edx "]
              , modMask = mod1Mask
              , borderWidth = 1
              , normalBorderColor = "#222222"
              , focusedBorderColor = "#444444"--"#B7CE42"
              , terminal = "urxvtc"
              , keys = keys'
              , logHook = logHook' h  >> (fadeLogHook)
              , layoutHook = layoutHook'
              , manageHook = manageHook'
							, startupHook = myStartupHook'
              }

--------------------- Log Hooks --------------------------------
logHook' :: Handle ->  X ()
logHook' h = dynamicLogWithPP $ customPP { ppOutput = hPutStrLn h }

customPP :: PP
customPP = defaultPP { ppCurrent = xmobarColor "#222222" "#888888". wrap "" ""
                     , ppTitle =  shorten 80
                     , ppSep =  "<fc=#aaaaaa> // </fc>"
                     , ppHiddenNoWindows = xmobarColor "#333333" ""
                     , ppUrgent = xmobarColor "#AFAFAF" "#333333" . wrap "!" ""
                     }
                     
fadeLogHook :: X ()
fadeLogHook = fadeInactiveLogHook fadeAmount
	where fadeAmount = 0.9 
                     

------------------- Startup Hooks ------------------------------
-- By default do nothing.
myStartupHook' = do
--	spawn "xsetroot -cursor_name left_ptr"
--	spawn "nitrogen --restore"
 return ()


--------------------- Layout hooks ------------------------------
layoutHook' = customLayout
--customLayout = onWorkspace "www" simpleTabbed $ avoidStrutsOn [U] (spiral (6/7) ||| spaced ||| smartBorders tiled ||| smartBorders (Mirror tiled) ||| noBorders Full) ||| Grid
customLayout = avoidStrutsOn [U] (smartBorders tiled ||| smartBorders (Mirror tiled) ||| spiral (6/7) ||| spaced ||| noBorders Full) ||| Grid ||| simpleTabbed
  where
    tiled = named "Tiled" $ ResizableTall 1 (2/100) (1/2) [] 
    spaced = named "Spacing" $ spacing 6 $ Tall 1 (3/100) (1/2)
   -- im = named "InstantMessenger" $ withIM (12/50) (Role "buddy_list") Grid
   
   
-- [[old (made gap for bottom)
-- customLayout = gaps [(D,16)] $ avoidStruts $ onWorkspace "im" im $ smartBorders tiled ||| smartBorders (Mirror tiled) ||| im ||| noBorders Full ||| Grid
-- ]]end


--------------- Dialog and menu hooks -------------------------------
getProp :: Atom -> Window -> X (Maybe [CLong])
getProp a w = withDisplay $ \dpy -> io $ getWindowProperty32 dpy a w

checkAtom name value = ask >>= \w -> liftX $ do
                a <- getAtom name
                val <- getAtom value
                mbr <- getProp a w
                case mbr of
                  Just [r] -> return $ elem (fromIntegral r) [val]
                  _ -> return False 

checkDialog = checkAtom "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_DIALOG"
checkMenu = checkAtom "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_MENU"

manageMenus = checkMenu --> doFloat
manageDialogs = checkDialog --> doFloat


----------------------- Manage Hooks ---------------------------------
myManageHook :: ManageHook
myManageHook = composeAll . concat $
    [ [ className       =? c                 --> doFloat | c <- myFloats ]
    , [ title           =? t                 --> doFloat | t <- myOtherFloats ]
    , [ resource        =? r                 --> doIgnore | r <- myIgnores ]
  --  , [ (className =? "URxvt" <&&> title =? "urxvt") --> doF (W.shift "1:main")]
    , [ className       =? "Shiretoko"         --> doF (W.shift "www") ]
    , [ className       =? "Firefox"         --> doF (W.shift "www") ]
--    , [ className       =? "Gimp"            --> doF (W.shift "etc") ]
--    , [ className       =? "Gvim"            --> doF (W.shift "code") ]
--    , [ className       =? "OpenOffice.org 3.0" --> doF (W.shift "doc") ]
--    , [ className       =? "Abiword" 					--> doF (W.shift "doc") ]
    , [ className       =? "Pidgin"          --> doF (W.shift "im") ]
    ]
    where
        myIgnores       = ["stalonetray"]
        myFloats        = []
        myOtherFloats   = ["alsamixer", "&#1053;&#1072;&#1089;&#1090;&#1088;&#1086;&#1081;&#1082;&#1080; Firefox", "&#1047;&#1072;&#1075;&#1088;&#1091;&#1079;&#1082;&#1080;", "&#1044;&#1086;&#1087;&#1086;&#1083;&#1085;&#1077;&#1085;&#1080;&#1103;", "Clear Private Data", "Downloads", "urxvt-float", "galculator"]

manageHook' :: ManageHook
manageHook' = manageHook defaultConfig <+> manageDocks <+> manageMenus <+> manageDialogs <+> myManageHook
-- }}}
------------------------------------------------------------------------------
-- {{{ Keys/Button bindings
keys' :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keys' conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- launching and killing programs
    [ ((modMask,               xK_Return     ), spawn $ XMonad.terminal conf)
    , ((modMask .|. shiftMask, xK_Return     ), spawn "urxvtc -pe tabbed")
    , ((modMask,               xK_d     ), spawn "dmenu_run -fn \"-*-terminus-medium-r-normal-*-12-*-*-*-*-*-*-*\" -nb \"#eeeeee\" -nf \"#555555\" -sb \"#eeeeee\" -sf \"#000000\"")
    , ((modMask .|. shiftMask, xK_f     ), spawn "firefox")
    , ((modMask .|. shiftMask, xK_g     ), spawn "thunar")
    , ((modMask .|. shiftMask, xK_c     ), kill)
 
    -- layouts
    , ((modMask,               xK_space ), sendMessage NextLayout)
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modMask,               xK_b     ), sendMessage ToggleStruts)
 
    -- floating layer stuff
    , ((modMask,               xK_f     ), withFocused $ windows . W.sink)
 
    -- refresh
    , ((modMask,               xK_r     ), refresh)
    , ((modMask .|. shiftMask, xK_w     ), withFocused toggleBorder)
 
    -- focus
    , ((modMask,               xK_Tab   ), windows W.focusDown)
    , ((modMask,               xK_t     ), windows W.focusDown)
    , ((modMask,               xK_n     ), windows W.focusUp)
    , ((modMask,               xK_m     ), windows W.focusMaster)
 
    -- swapping
    , ((modMask .|. shiftMask, xK_m     ), windows W.swapMaster)
    , ((modMask .|. shiftMask, xK_t     ), windows W.swapDown  )
    , ((modMask .|. shiftMask, xK_n    ), windows W.swapUp    )
 
    -- increase or decrease number of windows in the master area
    , ((modMask,		xK_comma     ), sendMessage (IncMasterN 1))
    , ((modMask,		xK_period     ), sendMessage (IncMasterN (-1)))
 
    -- resizing
    , ((modMask,               xK_h     ), sendMessage Shrink)
    , ((modMask,               xK_s     ), sendMessage Expand)
    , ((modMask .|. shiftMask, xK_h     ), sendMessage MirrorShrink)
    , ((modMask .|. shiftMask, xK_s     ), sendMessage MirrorExpand)
 
 		 -- mpd controls
    , ((modMask .|. controlMask,  xK_h     ), spawn "mpc prev")
    , ((modMask .|. controlMask,  xK_t     ), spawn "mpc stop")
    , ((modMask .|. controlMask,  xK_n     ), spawn "mpc toggle")
    , ((modMask .|. controlMask,  xK_s     ), spawn "mpc next")
    , ((modMask .|. controlMask,  xK_g     ), spawn "mpc seek -2%")
    , ((modMask .|. controlMask,  xK_c     ), spawn "/home/anomaly/bin/volcontrol.rb -d 4")
    , ((modMask .|. controlMask,  xK_r     ), spawn "/home/anomaly/bin/volcontrol.rb -u 4")
    , ((modMask .|. controlMask,  xK_l     ), spawn "mpc seek +2%")

    -- misc controls
    , ((modMask .|. controlMask, xK_a     ), spawn "slock")
		-- stuff from old keyboard
		-- mpd controls via keyboard media buttons
		-- set according to xmodmap -pk
		--, ((0,											0x1008ff12), spawn "amixer set Master toggle")
		--, ((0,											xF86XK_AudioMute), spawn "amixer set Master toggle")
		--, ((0,											xF86XK_AudioRaiseVolume), spawn "mpc volume +4")
		--, ((0,											xF86XK_AudioLowerVolume), spawn "mpc volume -4")
		--, ((0,											xF86XK_AudioMute), spawn "/home/anomaly/bin/volcontrol.rb -m")
		--, ((0,											xF86XK_AudioRaiseVolume), spawn "/home/anomaly/bin/volcontrol.rb -u 4")
		--, ((0,											xF86XK_AudioLowerVolume), spawn "/home/anomaly/bin/volcontrol.rb -d 4")
		--, ((0,											xF86XK_AudioPlay), spawn "mpc toggle")
		--, ((0,											xF86XK_AudioStop), spawn "mpc stop")
		--, ((0,											xF86XK_AudioPrev), spawn "mpc prev")
		--, ((0,											xF86XK_AudioNext), spawn "mpc next")

		-- launching apps via media buttons
		--, ((0,											0x1008ff10), spawn "slock")


    -- quit, or restart
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    , ((modMask              , xK_q     ), restart "xmonad" True)
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_F1 .. xK_F9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
--    ++
--    [((modMask .|. controlMask, k), windows $ swapWithCurrent i)
--      | (i, k) <- zip workspaces [xK_1 .. xK_4]]

-- }}}
