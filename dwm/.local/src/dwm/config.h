/* See LICENSE file for copyright and license details. */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */

/* appearance */
static const unsigned int borderpx  = 3;          /* border pixel of windows */
static const unsigned int snap      = 48;           /* snap pixel */
static const unsigned int gappih    = 7;            /* horiz inner gap between windows */
static const unsigned int gappiv    = 7;            /* vert inner gap between windows */
static const unsigned int gappoh    = 10;            /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 10;            /* vert outer gap between windows and screen edge */
static       int smartgaps          = 0;            /* 1 means no outer gap when there is only one window */
static const int showbar            = 1;            /* 0 means no bar */
static const int topbar             = 1;            /* 0 means bottom bar */
static const int usealtbar          = 1;            /* 1 means use non-dwm status bar */
static const char *altbarclass      = "Polybar";    /* Alternate bar class name */
static const char *altbarcmd        = "$HOME/.local/src/cscripts/polybar.sh";  /* Alternate bar launch command FIXME: Remvoe this shit*/ 
static const char *fonts[] = {
    "ComicShannsMono Nerd Font:size=12",
    "ComicShannsMono Nerd Font:size=18",
    "Noto Sans:size=12",                        // general Unicode fallback
    "Noto Sans CJK JP:size=12",                 // Japanese / CJK fallback
    "Noto Color Emoji:size=12",                 // emoji fallback
    "Noto Sans:size=12"                         // generic fallback for most scripts
};
static const char dmenufont[]       = "monospace:size=10";
static const char col_bg[]          = "#1e1e2e";    // Background
static const char col_fg[]          = "#d4be98";    // Foreground
static const char col_accent_blue[] = "#7da6ff";    // Accent Blue
static const char col_accent_orange[] = "#fab387";  // Accent Orange
static const char col_accent_yellow[] = "#f9e2af";  // Accent Yellow
static const char col_accent_red[]  = "#f38ba8";    // Accent Red
static const char col_accent_green[] = "#9ece6a";   // Accent Green
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";

#include "vanitygaps.c"
#include <time.h>
#include <X11/XF86keysym.h>

// static const char *colors[][3]      = {
// 	/*               fg         bg         border    */
// 	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
// 	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
// };
//
static const char *colors[][3] = {
    /*               fg         bg                  border    */
    [SchemeNorm] = { col_fg,    col_bg,             col_bg    },
    [SchemeSel]  = { col_bg,    col_accent_blue,    col_gray1 },
};

/* tagging */
static const char *tags[] = {"%{T2} %{T-}", "󰖟 ", "󰍦 ", " ", " ", " ", "󰙯 ", "󰊠 "};

/* Lockfile */
static char lockfile[] = "/tmp/dwm.lock";

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class               instance    title       tags mask     isfloating   monitor */
	{ "floatterm",         NULL,       NULL,       0,            1,           -1 },
	{ "Gimp",              NULL,       NULL,       0,            0,           -1 },
	{ "Google-chrome",     NULL,       NULL,       1 << 1,       0,           -1 },
	{ "Firefox",           NULL,       NULL,       1 << 1,       0,           -1 },
	{ "Whatsapp",          NULL,       NULL,       1 << 2,       0,           -1 },
	{ "Spotify",           NULL,       NULL,       1 << 3,       0,           -1 },
	{ "jetbrains-studio",  NULL,       NULL,       1 << 6,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int attachbelow = 1;    /* 1 means attach after the currently active window */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
 	{ "[M]",      monocle },
	{ "[@]",      spiral },
	{ "[\\]",     dwindle },
	{ "H[]",      deck },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "HHH",      grid },
	{ "###",      nrowgrid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "|M|",      centeredmaster },
	{ ">M>",      centeredfloatingmaster },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ NULL,       NULL },
};

/* key definitions */
#define MODKEY Mod4Mask /* NOTE: Mod4 is Super Mod1 is Alt*/
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *rofi[] = {"rofi", "-show", "drun", "-theme", "~/.config/rofi/config.rasi", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
	// { MODKEY,                       XK_r,      spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_d,      spawn,          {.v = rofi } },
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_p,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_h,      setcfact,       {.f = +0.25} },
	{ MODKEY|ShiftMask,             XK_l,      setcfact,       {.f = -0.25} },
	{ MODKEY|ShiftMask,             XK_o,      setcfact,       {.f =  0.00} },
	{ Mod4Mask,                     XK_z,      zoom,           {0} },
	{ MODKEY|Mod1Mask,              XK_u,      incrgaps,       {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_u,      incrgaps,       {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_i,      incrigaps,      {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_i,      incrigaps,      {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_o,      incrogaps,      {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_o,      incrogaps,      {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_6,      incrihgaps,     {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_6,      incrihgaps,     {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_7,      incrivgaps,     {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_7,      incrivgaps,     {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_8,      incrohgaps,     {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_8,      incrohgaps,     {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_9,      incrovgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_9,      incrovgaps,     {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_0,      defaultgaps,    {1} },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_0,      togglegaps,     {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY,                       XK_q,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY|ShiftMask,             XK_r,      setlayout,      {.v = &layouts[3]} },
	{ MODKEY,                       XK_r,      setlayout,      {.v = &layouts[4]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
	{ MODKEY|ShiftMask,             XK_s,      togglesticky,   {0} },
	{ MODKEY|ShiftMask,             XK_o,      toggleopacity,  {0} },
	{ MODKEY|ShiftMask,             XK_f,      togglefullscr,  {0} },
	{ MODKEY|Mod1Mask,              XK_p,      spawn,          SHCMD("playerctl --player=spotify,vlc previous") },
	{ MODKEY|Mod1Mask,              XK_s,      spawn,          SHCMD("playerctl --player=spotify,vlc play-pause") },
	{ MODKEY|Mod1Mask,              XK_n,      spawn,          SHCMD("playerctl --player=spotify,vlc next") },
	{ MODKEY,                       XK_s,      spawn,          SHCMD("flameshot gui") },
	{ MODKEY|ShiftMask,             XK_b,      spawn,          SHCMD("st -c floatterm -e ~/.local/src/cscripts/bgmanager.sh select") },
	{ MODKEY|Mod1Mask,              XK_b,      spawn,          SHCMD("~/.local/src/cscripts/bgmanager.sh cycle") },
	{ MODKEY|Mod1Mask,              XK_r,      spawn,          SHCMD("~/.local/src/cscripts/bgmanager.sh random") },
	{ MODKEY,                       XK_F5,     spawn,          SHCMD("~/.local/src/cscripts/tagstoggle.sh") },
	{ 0,                            XK_F11,    togglefullscr,     {0} },
	{ 0,             XF86XK_MonBrightnessUp,   spawn,          SHCMD("~/.local/src/cscripts/brightup.sh") },
	{ 0,             XF86XK_MonBrightnessDown, spawn,          SHCMD("~/.local/src/cscripts/brightdown.sh") },
	{ 0,             XF86XK_AudioRaiseVolume,  spawn,          SHCMD("amixer set Master 5%+") },
	{ 0,             XF86XK_AudioLowerVolume,  spawn,          SHCMD("amixer set Master 5%-") },
	{ 0,             XF86XK_AudioMute,         spawn,          SHCMD("amixer set Master toggle") },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};


