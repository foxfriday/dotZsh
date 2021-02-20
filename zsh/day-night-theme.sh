#!/bin/sh
# Themes use tamplate by Chris Kempson (http://chriskempson.com)
# base16-shell (https://github.com/chriskempson/base16-shell)
# These are variations of his tomorrow schemes.

if [ "$SHELL_DAY_THEME" != true ]; then
    # Night
    black0="1d/1f/21"
    red0="cc/00/00"
    green0="00/66/00"
    yellow0="f0/c6/74"
    blue0="81/a2/be"
    magenta0="b2/94/bb"
    cyan0="8a/be/b7"
    white0="c5/c8/c6"
    grey0="96/98/96"
    # Lighter shades
    red1="e5/00/00"
    green1="00/80/00"
    yellow1=$yellow0
    blue1="00/00/ff"
    magenta1=$magenta0
    cyan1=$cyan0
    # Extre colors
    color15="ff/ff/ff"
    color16="de/93/5f"
    color17="a3/68/5a"
    color18="28/2a/2e"
    color19="37/3b/41"
    color20="b4/b7/b4"
    color21="e0/e0/e0"
    color_foreground=$white0
    color_background=$black0
else
    # Day
    black0="ff/ff/ff"
    red0="7f/00/00"
    green0="00/40/00"
    yellow0="ea/b7/00"
    blue0="42/71/ae"
    magenta0="89/59/a8"
    cyan0="3e/99/9f"
    white0="4d/4d/4c"
    grey0="8e/90/8c"
    # Lighter shades
    red1="99/00/00"
    green1="00/59/00"
    yellow1=$yellow0
    blue1="00/00/cc"
    magenta1=$magenta0
    cyan1=$cyan0
    # Extra colors
    color15="1d/1f/21"
    color16="f5/87/1f"
    color17="a3/68/5a"
    color18="e0/e0/e0"
    color19="d6/d6/d6"
    color20="96/98/96"
    color21="28/2a/2e"
    color_foreground=$white0
    color_background=$black0
fi

if [ -n "$TMUX" ]; then
    # See:
    # http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324
    put_template() { printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\' $@; }
    put_template_var() { printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\' $@; }
    put_template_custom() { printf '\033Ptmux;\033\033]%s%s\033\033\\\033\\' $@; }
else
    put_template() { printf '\033]4;%d;rgb:%s\033\\' $@; }
    put_template_var() { printf '\033]%d;rgb:%s\033\\' $@; }
    put_template_custom() { printf '\033]%s%s\033\\' $@; }
fi

# 16 color space
put_template 0  $black0
put_template 1  $red0
put_template 2  $green0
put_template 3  $yellow0
put_template 4  $blue0
put_template 5  $magenta0
put_template 6  $cyan0
put_template 7  $white0
put_template 8  $grey0
put_template 9  $red1
put_template 10 $green1
put_template 11 $yellow1
put_template 12 $blue1
put_template 13 $magenta1
put_template 14 $cyan1
put_template 15 $color15

# 256 color space
put_template 16 $color16
put_template 17 $color17
put_template 18 $color18
put_template 19 $color19
put_template 20 $color20
put_template 21 $color21

# Foreground / Background
put_template_var 10 $color_foreground
put_template_var 11 $color_background
if [ "${TERM%%-*}" = "rxvt" ]; then
    # Internal border
    put_template_var 708 $color_background
fi
# Cursor
put_template_custom 12 ";7"

# clean up
unset -f put_template
unset -f put_template_var
unset -f put_template_custom
unset black0
unset red0
unset green0
unset yellow0
unset blue0
unset magenta0
unset cyan0
unset white0
unset grey0
unset red1
unset green1
unset yellow1
unset blue1
unset magenta1
unset cyan1
unset color15
unset color16
unset color17
unset color18
unset color19
unset color20
unset color21
unset color_foreground
unset color_background
