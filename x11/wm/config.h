/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

#define BROWSER "firefox"
#define TERMINAL "st"
#define NOTIFICATION_FILE "/tmp/noti.txt"

/* appearance */
static const unsigned int borderpx  = 2;    /* border pixel of windows */
static const int startwithgaps     = 1;    /* 1 means gaps are used by default */
static const unsigned int gappx    = 16;   /* default gap between windows in pixels */
static const unsigned int snap     = 32;   /* snap pixel */
static const int showbar           = 1;    /* 0 means no bar */
static const int topbar            = 1;    /* 0 means bottom bar */
static const char *fonts[]         = { "Liberation Mono:size=10" };
static const char dmenufont[]      = "Liberation Mono:size=10";
static const char col_gray1[]      = "#222222";
static const char col_gray2[]      = "#444444";
static const char col_gray3[]      = "#bbbbbb";
static const char col_gray4[]      = "#eeeeee";
static const char col_cyan[]       = "#005577";
static const char col_brown[]      = "#282828";
static const char col_green[]      = "#689d6a";
static const char *colors[][3]     = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_brown, col_green },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *    WM_CLASS(STRING) = instance, class
	 *    WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact        = 0.65; /* factor of master area size [0.05..0.95] */
static const int nmaster        = 1;    /* number of clients in master area */
static const int resizehints    = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1;   /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                  KEY,   view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,      KEY,   toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,        KEY,   tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY, toggletag,   {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } } /* NOT USED */

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_green, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { TERMINAL, NULL };
static const char *browsercmd[]  = { BROWSER, NULL };

/* scripts */
static const char
	*br_promptcmd[]     = {"br", NULL},
	*light_downcmd[]    = {"slight", "-d", "5", NULL},
	*light_upcmd[]      = {"slight", "-i", "5", NULL},
	*vimousecmd[]       = {"vimouse", NULL},
	*screenshotcmd[]    = {"sh", "-c", "shot -s | xargs sclip -c", NULL },
	*zoomcmd[]          = {"sh", "-c", "nsxiv -fb $(shot)", NULL },
	*vol_downcmd[]      = {"svol", "-d", "5", NULL},
	*vol_togglecmd[]    = {"svol", "-t", NULL},
	*vol_upcmd[]        = {"svol", "-i", "5", NULL},
	*wallpapercmd[]     = {"swall", NULL},
	*clipcmd[]          = {"sh", "-c", "sclip | xargs sclip -f", NULL},
	*lockcmd[]          = {"sslock", NULL},
	*simplelockcmd[]    = {"sslock", "-n", NULL},
	*blurlockcmd[]      = {"sslock", "-cb", NULL},
	*clearnotifcmd[]    = {"nsend", "-s", "", NULL};

static const Key keys[] = {
	/* modifier            key         function        argument */
	{ MODKEY,              XK_p,       spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,    XK_p,       spawn,          {.v = br_promptcmd } },
	{ MODKEY,              XK_Return,  spawn,          {.v = termcmd } },
	{ MODKEY|ShiftMask,    XK_Return,  spawn,          {.v = browsercmd } },
	{ MODKEY,              XK_b,       togglebar,      {0} },
	{ MODKEY,              XK_j,       focusstack,     {.i = +1 } },
	{ MODKEY,              XK_k,       focusstack,     {.i = -1 } },
	{ MODKEY|ShiftMask,    XK_m,       incnmaster,     {.i = +1 } },
	{ MODKEY,              XK_m,       incnmaster,     {.i = -1 } },
	{ MODKEY,              XK_h,       setmfact,       {.f = -0.05} },
	{ MODKEY,              XK_l,       setmfact,       {.f = +0.05} },
	{ MODKEY,              XK_space,   zoom,           {0} },
	{ MODKEY|ShiftMask,    XK_q,       killclient,     {0} },
	{ MODKEY|ShiftMask,    XK_f,       togglefloating, {0} },
	{ MODKEY,              XK_f,       togglefullscr,  {0} },
	{ MODKEY,              XK_0,       view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,    XK_0,       tag,            {.ui = ~0 } },
	{ MODKEY,              XK_comma,   focusmon,       {.i = -1 } },
	{ MODKEY,              XK_period,  focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,    XK_comma,   tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,    XK_period,  tagmon,         {.i = +1 } },
	{ MODKEY,              XK_minus,   setgaps,        {.i = -1 } },
	{ MODKEY,              XK_equal,   setgaps,        {.i = +1 } },
	{ MODKEY,              XK_u,       focusmaster,    {0} },
	{ MODKEY,              XK_a,       togglefocusfloat, {0} },
	{ MODKEY|ShiftMask,    XK_w,       spawn,          {.v = wallpapercmd} },
	{ MODKEY,              XK_o,       spawn,          {.v = vimousecmd} },
	{ MODKEY|ShiftMask,    XK_s,       spawn,          {.v = screenshotcmd} },
	{ MODKEY,              XK_y,       spawn,          {.v = clipcmd} },
	{ MODKEY,              XK_z,       spawn,          {.v = zoomcmd} },
	{ MODKEY,              XK_n,       spawn,          {.v = clearnotifcmd} },
	{ MODKEY|ShiftMask,    XK_minus,   setborderpx,    {.i = -1 } },
	{ MODKEY|ShiftMask,    XK_equal,   setborderpx,    {.i = +1 } },
	{ Mod4Mask,            XK_q,       spawn,          {.v = simplelockcmd}},
	{ Mod4Mask|ShiftMask,  XK_q,       spawn,          {.v = lockcmd}},
	{ Mod4Mask|ControlMask,XK_q,       spawn,          {.v = blurlockcmd}},
	{ Mod4Mask|ShiftMask,  XK_0,       quit,           {0} },

	{ Mod4Mask,            XK_j,       moveresize,     {.v = (int []){ 0   ,25  ,0   ,0   }} },
	{ Mod4Mask,            XK_k,       moveresize,     {.v = (int []){ 0   ,-25 ,0   ,0   }} },
	{ Mod4Mask,            XK_l,       moveresize,     {.v = (int []){ 25  ,0   ,0   ,0   }} },
	{ Mod4Mask,            XK_h,       moveresize,     {.v = (int []){ -25 ,0   ,0   ,0   }} },
	{ Mod4Mask|ShiftMask,  XK_j,       moveresize,     {.v = (int []){ 0   ,0   ,0   ,25  }} },
	{ Mod4Mask|ShiftMask,  XK_k,       moveresize,     {.v = (int []){ 0   ,0   ,0   ,-25 }} },
	{ Mod4Mask|ShiftMask,  XK_l,       moveresize,     {.v = (int []){ 0   ,0   ,25  ,0   }} },
	{ Mod4Mask|ShiftMask,  XK_h,       moveresize,     {.v = (int []){ 0   ,0   ,-25 ,0   }} },

	{ 0, XF86XK_MonBrightnessUp,    spawn , {.v = light_upcmd} },
	{ 0, XF86XK_MonBrightnessDown,  spawn , {.v = light_downcmd} },
	{ 0, XF86XK_AudioLowerVolume,   spawn , {.v = vol_downcmd} },
	{ 0, XF86XK_AudioRaiseVolume,   spawn , {.v = vol_upcmd} },
	{ 0, XF86XK_AudioMute,          spawn , {.v = vol_togglecmd} },

	TAGKEYS(XK_1, 0)
	TAGKEYS(XK_2, 1)
	TAGKEYS(XK_3, 2)
	TAGKEYS(XK_4, 3)
	TAGKEYS(XK_5, 4)
	TAGKEYS(XK_6, 5)
	TAGKEYS(XK_7, 6)
	TAGKEYS(XK_8, 7)
	TAGKEYS(XK_9, 8)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click               event mask   button      function        argument */
	{ ClkLtSymbol,         0,           Button1,    setlayout,      {0} },
	{ ClkLtSymbol,         0,           Button3,    setlayout,      {.v = &layouts[2]} }, /* NOT USED */
	{ ClkWinTitle,         0,           Button2,    zoom,           {0} },
	{ ClkStatusText,       0,           Button2,    spawn,          {.v = termcmd } },
	{ ClkClientWin,        MODKEY,      Button1,    movemouse,      {0} },
	{ ClkClientWin,        MODKEY,      Button2,    togglefloating, {0} },
	{ ClkClientWin,        MODKEY,      Button3,    resizemouse,    {0} },
	{ ClkTagBar,           0,           Button1,    view,           {0} },
	{ ClkTagBar,           0,           Button3,    toggleview,     {0} },
	{ ClkTagBar,           MODKEY,      Button1,    tag,            {0} },
	{ ClkTagBar,           MODKEY,      Button3,    toggletag,      {0} },
};

/* signal definitions */
/* signum must be greater than 0 */
/* trigger signals using `xsetroot -name "fsignal:<signum>"` */
static Signal signals[] = {
	/* signum       function        argument  */
	{ 1,            updatenotification,      {.v = 0} },
};
