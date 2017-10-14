cat /usr/share/X11/xorg.conf.d/XX-libinput.conf

# Match on all types of devices but tablet devices and joysticks

Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "NaturalScrolling" "on"
        Option "Tapping" "on"
        Option "TappingDrag" "on"
        Option "DisableWhileTyping" "on"
EndSection
