export DISPLAY=:0 
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus
notify-send "TAKE YOUR FEET OFF THE DESK" "This is not good for you stop it now!"
