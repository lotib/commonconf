


SCREEN=$(xrandr -q | grep " connected" | awk '{print $1}')

# 0.1 => ?
xrandr --output ${SCREEN} --brightness 1

# specify rate
# xrandr --output eDP-1 --mode 1920x1080 --rate 59.93

# cat /sys/class/backlight/intel_backlight/max_brightness
# cat /sys/class/backlight/intel_backlight/brightness
# cat /sys/class/backlight/intel_backlight/actual_brightness


