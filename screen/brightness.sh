


SCREEN=$(xrandr -q | grep " connected" | awk '{print $1}')

# 0.1 => ?
xrandr --output ${SCREEN} --brightness 1

