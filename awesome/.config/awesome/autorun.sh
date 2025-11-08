#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

# run /usr/lib/polkit-1/polkit-agent-helper-1

run "/usr/libexec/polkitd"
run "gnome-keyring-daemon --start --components=keyring,secrets,ssh,pkcs11,gpg"
ssh-add /home/sahasrajit/.ssh/torc_gh
run nm-applet
run blueman-applet
run ibus-daemon
run flameshot
run xfce4-clipman

run picom -b --config $HOME/.config/picom/picom.conf

# Turn screen saver on at 600s, suspend at 900s
xset +dpms
xset dpms 600 900 900
xset s 600 600
# Turn on lockscreen
# run "xss-lock -l -- lockscreen"

# Turn on Media player controller daemon
# run "pulseaudio --start"
run playerctld

# Turn on Tap Action in Trackpad
# xinput set-prop 15 348 1
# Turn on Natural Scrolling in Trackpad
touchpad_id=$(xinput list | grep "Touchpad" | sed -r 's/.*id=([0-9]*).*/\1/')
xinput set-prop $touchpad_id $(xinput list-props $touchpad_id | grep "Natural Scrolling Enabled (" | sed -r 's/.*\((.*)\).*/\1/') 1
# xinput set-prop 15 $(xinput list-props 15 | grep "Natural Scrolling Enabled (" | sed -r 's/.*\((.*)\).*/\1/') 1

autorandr -c
