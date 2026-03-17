#!/run/current-system/sw/bin/bash
set -euo pipefail

# wttr.in JSON API — auto-detects location by IP, no key needed
URL="https://wttr.in/?format=j1"

get_weather() {
    curl -fsS --max-time 10 "$URL" 2>/dev/null || true
}

weather_icon() {
    local code="$1"
    case "$code" in
        113)                                     echo "☀️"  ;;
        116)                                     echo "⛅"  ;;
        119|122)                                 echo "☁️"  ;;
        143|248|260)                             echo "🌫️" ;;
        176|263|266|293|296)                     echo "🌦️" ;;
        299|302|305|308)                         echo "🌧️" ;;
        200|386|389|392|395)                     echo "⛈️" ;;
        227|230)                                 echo "❄️"  ;;
        179|182|185|281|284|311|314|317|350|377) echo "🌨️" ;;
        *)                                       echo "🌡️" ;;
    esac
}

uv_label() {
    local uv="$1"
    if   [ "$uv" -le 2 ];  then echo "Low"
    elif [ "$uv" -le 5 ];  then echo "Moderate"
    elif [ "$uv" -le 7 ];  then echo "High"
    elif [ "$uv" -le 10 ]; then echo "Very High"
    else                        echo "Extreme"
    fi
}

main() {
    local json
    json=$(get_weather)

    if [ -z "${json:-}" ]; then
        jq -c -n \
          --arg text "⚠ weather" \
          --arg tooltip "Weather unavailable" \
          '{text: $text, tooltip: $tooltip, class: "weather"}'
        return
    fi

    # Current conditions
    local code temp feels desc humidity wind winddir visibility uv city region
    code=$(      printf '%s' "$json" | jq -r '.current_condition[0].weatherCode')
    temp=$(      printf '%s' "$json" | jq -r '.current_condition[0].temp_F')
    feels=$(     printf '%s' "$json" | jq -r '.current_condition[0].FeelsLikeF')
    desc=$(      printf '%s' "$json" | jq -r '.current_condition[0].weatherDesc[0].value')
    humidity=$(  printf '%s' "$json" | jq -r '.current_condition[0].humidity')
    wind=$(      printf '%s' "$json" | jq -r '.current_condition[0].windspeedMiles')
    winddir=$(   printf '%s' "$json" | jq -r '.current_condition[0].winddir16Point')
    visibility=$(printf '%s' "$json" | jq -r '.current_condition[0].visibility')
    uv=$(        printf '%s' "$json" | jq -r '.current_condition[0].uvIndex')
    city=$(      printf '%s' "$json" | jq -r '.nearest_area[0].areaName[0].value')
    region=$(    printf '%s' "$json" | jq -r '.nearest_area[0].region[0].value')

    # 3-day forecast — use midday (index 4) code for icon
    local d0_min d0_max d0_code
    local d1_min d1_max d1_code
    local d2_min d2_max d2_code
    d0_min=$(  printf '%s' "$json" | jq -r '.weather[0].mintempF')
    d0_max=$(  printf '%s' "$json" | jq -r '.weather[0].maxtempF')
    d0_code=$( printf '%s' "$json" | jq -r '.weather[0].hourly[4].weatherCode')
    d1_min=$(  printf '%s' "$json" | jq -r '.weather[1].mintempF')
    d1_max=$(  printf '%s' "$json" | jq -r '.weather[1].maxtempF')
    d1_code=$( printf '%s' "$json" | jq -r '.weather[1].hourly[4].weatherCode')
    d2_min=$(  printf '%s' "$json" | jq -r '.weather[2].mintempF')
    d2_max=$(  printf '%s' "$json" | jq -r '.weather[2].maxtempF')
    d2_code=$( printf '%s' "$json" | jq -r '.weather[2].hourly[4].weatherCode')

    local icon d0_icon d1_icon d2_icon
    icon=$(    weather_icon "$code")
    d0_icon=$( weather_icon "$d0_code")
    d1_icon=$( weather_icon "$d1_code")
    d2_icon=$( weather_icon "$d2_code")

    local today tomorrow day2
    today=$(    date "+%A")
    tomorrow=$( date -d "+1 day"  "+%A")
    day2=$(     date -d "+2 days" "+%A")

    local uv_str
    uv_str=$(uv_label "$uv")

    local bar_text="$icon ${temp}°F"

    # Build tooltip with Pango markup — GTK will center via CSS
    local tooltip
    tooltip=$(printf \
'<span size="x-large" weight="bold">%s, %s</span>
<span size="small" alpha="70%%">%s</span>

<span size="xx-large">%s</span>
<span size="xx-large" weight="bold">%s°F</span>
<span size="small" alpha="70%%">feels like %s°F</span>

<span size="small" alpha="50%%">─────────────────────────</span>

 💧  Humidity       <b>%s%%</b>
 💨  Wind             <b>%s mph %s</b>
 👁   Visibility      <b>%s mi</b>
 ☀   UV Index       <b>%s — %s</b>

<span size="small" alpha="50%%">─────────────────────────</span>
<span size="small" alpha="80%%">  3-Day Forecast</span>

 %s  %-10s  ↑<b>%s°</b>  ↓%s°
 %s  %-10s  ↑<b>%s°</b>  ↓%s°
 %s  %-10s  ↑<b>%s°</b>  ↓%s°' \
        "$city" "$region" \
        "$desc" \
        "$icon" "$temp" "$feels" \
        "$humidity" \
        "$wind" "$winddir" \
        "$visibility" \
        "$uv" "$uv_str" \
        "$d0_icon" "$today"    "$d0_max" "$d0_min" \
        "$d1_icon" "$tomorrow" "$d1_max" "$d1_min" \
        "$d2_icon" "$day2"     "$d2_max" "$d2_min")

    jq -c -n \
      --arg text "$bar_text" \
      --arg tooltip "$tooltip" \
      '{text: $text, tooltip: $tooltip, class: "weather"}'
}

main
