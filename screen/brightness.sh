


SCREEN=$(xrandr -q | grep " connected" | awk '{print $1}')

# 0.1 => ?
xrandr --output ${SCREEN} --brightness 1

# specify rate
# xrandr --output eDP-1 --mode 1920x1080 --rate 59.93




