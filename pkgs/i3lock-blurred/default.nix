{ writeShellScriptBin
, scrot
, imagemagick
, i3lock-color }:

writeShellScriptBin "i3lock-blurred" ''
    img=/tmp/i3lock-blurred.png

    # Colors
    bg=1a1b26
    fg=c0caf5
    ring=15161e
    wrong=f7768e
    date=c0caf5
    verify=9ece6a

    # suspend message display
    pkill -u "$USER" -USR1 dunst
    sleep 1

    # take screenshot
    ${scrot.out}/bin/scrot -o $img

    # blur screenshot
    ${imagemagick.out}/bin/convert $img -scale 10% -scale 1000% $img

    # lock the screen
    ${i3lock-color.out}/bin/i3lock -i $img -enb \
        --force-clock --indicator --pass-volume-keys \
        --radius=30 --ring-width=60 --inside-color=$bg \
        --ring-color=$ring --insidever-color=$verify --ringver-color=$verify \
        --insidewrong-color=$wrong --ringwrong-color=$wrong --line-uses-inside \
        --keyhl-color=$verify --separator-color=$verify --bshl-color=$verify \
        --time-str="%H:%M" --time-size=140 --date-str="%a, %d %b" \
        --date-size=45 --verif-text="Verifying password..." --wrong-text="Wrong password!" \
        --noinput-text="" --greeter-text="Enter password to unlock" --ind-pos="300:610" \
        --time-font="JetBrainsMono NF:style=Bold" --date-font="JetBrainsMono NF" --verif-font="JetBrainsMono NF" \
        --greeter-font="JetBrainsMono NF" --wrong-font="JetBrainsMono NF" --verif-size=23 \
        --greeter-size=23 --wrong-size=23 --time-pos="300:390" \
        --date-pos="300:450" --greeter-pos="300:780" --wrong-pos="300:820" \
        --verif-pos="300:655" --date-color=$date --time-color=$date \
        --greeter-color=$fg --wrong-color=$wrong --verif-color=$verify \
        --verif-pos="300:820" --pointer=default --refresh-rate=0 \

    # resume message display
    pkill -u "$USER" -USR2 dunst
''
