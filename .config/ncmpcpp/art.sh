#!/bin/zsh

# Only works on kitty
#
# There is a bug where if the image or terminal window
# are a certain size the image will scroll with the text
#
# Original:
# https://github.com/alnj/dotfiles/tree/master/.ncmpcpp

music_library=$HOME/music # mpd music library directory
fallback="$HOME/.config/ncmpcpp/unknown.png" # image used if no cover is found

percent_reserved_cols=30
layout_reserved_rows=4

font_width=11.0
font_height=23.0

main() {
    kill_previous_instance_of_this_script
    find_cover_image
    display_cover_image
    detect_window_resizes
}

kill_previous_instance_of_this_script() {
    script_name=$(basename "$0")
    for pid in $(pidof -x $script_name); do
        if [ $pid != $$ ]; then
            kill -15 $pid
        fi
    done
}

find_cover_image() {
    file="$(mpc --format %file% current)"
    ffmpeg -y -i "$music_library/$file" -an -vcodec copy /tmp/cover.jpg
    if [ $? -eq 0 ]
    then
        src=/tmp/cover.jpg
        return
    fi
    album="$(mpc --format %album% current)"
    album_dir="${file%/*}"
    [ -z "$album_dir" ] && exit 1
    album_dir="$music_library/$album_dir"
    covers="$(find "$album_dir" -type d -exec find {} -maxdepth 1 -type f \
      -iregex ".*/.*\(${album}\|cover\|folder\|artwork\|front\)[.]\\(jpe?g\|png\|gif\|bmp\)" \; )"
    src="$(echo "$covers" | head -n1)"
    if [ -z "$src" ]
    then
        covers="$(find "$album_dir" -type d -exec find {} -maxdepth 1 -type f \
          -iregex ".*/.*\(${album}\|cover\|folder\|artwork\|front\).*[.]\\(jpe?g\|png\|gif\|bmp\)" \; )"
        src="$(echo "$covers" | head -n1)"
        [ -z "$src" ] && src=$fallback
    fi
}

display_cover_image() {
    unset LINES COLUMNS
    term_rows=$(tput lines)
    term_cols=$(tput cols)

    reserved_cols=$((term_cols * (percent_reserved_cols / 100.0)))
    reserved_rows=$((term_rows - layout_reserved_rows))

    reserved_cols_scaled=$((reserved_cols / (font_height / font_width)))
    reserved_rows_scaled=$((reserved_rows * (font_height / font_width)))

    if [[ $reserved_cols_scaled -lt $reserved_rows ]]
    then
        kitty_width=$((reserved_cols))
        kitty_height=$((reserved_cols_scaled))
    else
        kitty_width=$((reserved_rows_scaled))
        kitty_height=$((reserved_rows))
    fi

    kitty_left=$(((reserved_cols / 2.0) - (kitty_width / 2.0)))
    kitty_top=$((((term_rows / 2.0) - (kitty_height / 2.0)) + layout_reserved_rows - 3.0))

    kitty +icat --clear --transfer-mode=file
    kitty +icat --align=center --place=${kitty_width%.*}x${kitty_height%.*}@${kitty_left%.*}x${kitty_top%.*} \
        --scale-up --transfer-mode=file --sticky "$src"
}

detect_window_resizes() {
    {
        trap 'display_cover_image' WINCH
        while :; do sleep .1; done
    } &
}

main >/dev/null 2>&1
