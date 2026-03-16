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
        113)                          echo "☀️"  ;;
        116)                          echo "⛅"  ;;
        119|122)                      echo "☁️"  ;;
        143|248|260)                  echo "🌫️" ;;
        176|263|266|293|296)          echo "🌦️" ;;
        299|302|305|308)              echo "🌧️" ;;
        200|386|389|392|395)          echo "⛈️" ;;
        227|230)                      echo "❄️"  ;;
        179|182|185|281|284|311|314|317|350|377) echo "🌨️" ;;
        *)                            echo "🌡️" ;;
    esac
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

    local code temp feels desc humidity wind city
    code=$(printf '%s' "$json"     | jq -r '.current_condition[0].weatherCode')
    temp=$(printf '%s' "$json"     | jq -r '.current_condition[0].temp_F')
    feels=$(printf '%s' "$json"    | jq -r '.current_condition[0].FeelsLikeF')
    desc=$(printf '%s' "$json"     | jq -r '.current_condition[0].weatherDesc[0].value')
    humidity=$(printf '%s' "$json" | jq -r '.current_condition[0].humidity')
    wind=$(printf '%s' "$json"     | jq -r '.current_condition[0].windspeedMiles')
    city=$(printf '%s' "$json"     | jq -r '.nearest_area[0].areaName[0].value')

    local icon
    icon=$(weather_icon "$code")

    local bar_text="$icon ${temp}°F"
    local tooltip
    tooltip=$(printf '<b>%s — %s</b>\n%s\nFeels like: %s°F\nHumidity: %s%%\nWind: %s mph' \
        "$city" "$desc" "$icon" "$feels" "$humidity" "$wind")

    jq -c -n \
      --arg text "$bar_text" \
      --arg tooltip "$tooltip" \
      '{text: $text, tooltip: $tooltip, class: "weather"}'
}

main
