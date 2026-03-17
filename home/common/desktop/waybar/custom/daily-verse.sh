#!/run/current-system/sw/bin/bash
set -euo pipefail

URL="https://www.biblegateway.com/votd/get/?format=json&version=KJV"

get_daily_verse() {
    local json verse_html reference plain

    json=$(curl -fsS "$URL" 2>/dev/null || true)

    if [ -z "${json:-}" ]; then
        echo ""
        echo ""
        return
    fi

    reference=$(printf '%s' "$json" | jq -r '.votd.display_ref // empty' 2>/dev/null || echo "")
    verse_html=$(printf '%s' "$json" | jq -r '.votd.text // empty' 2>/dev/null || echo "")

    if [ -z "$reference" ] || [ -z "$verse_html" ]; then
        echo ""
        echo ""
        return
    fi

    # Strip HTML tags and common entities, keep it plain text
    plain=$(
        printf '%s' "$verse_html" \
        | sed 's/&ldquo;/“/g; s/&rdquo;/”/g; s/&rsquo;/’/g; s/&quot;/"/g' \
        | sed -E 's/<[^>]+>//g' \
        | tr '\n' ' ' \
        | sed 's/  */ /g' \
        | sed 's/^ *//; s/ *$//'
    )

    echo "$reference"
    echo "$plain"
}

main() {
    read -r reference
    read -r text

    # Fallback if fetch/parse failed
    if [ -z "$reference" ] || [ -z "$text" ]; then
        local bar_text="📖 n/a"
        local tooltip="No verse available (request or parse error)."

        jq -c -n --arg text "$bar_text" --arg tooltip "$tooltip" \
          '{text: $text, tooltip: $tooltip, class: "daily-verse"}'
        return
    fi

    local bar_text="📖 (${reference})"

    # Trim tooltip if very long
    local tooltip_verse="$text"
    if [ "${#tooltip_verse}" -gt 280 ]; then
        tooltip_verse="${tooltip_verse:0:277}…"
    fi

    # Build tooltip with *real* newlines (not "\n", not <br>)
    # printf will insert literal newlines into the variable.
    local tooltip
    tooltip=$(printf '<b>%s</b>\n%s\n<span foreground="#7aa2f7">KJV</span>' \
        "$reference" \
        "$tooltip_verse")

    jq -c -n --arg text "$bar_text" --arg tooltip "$tooltip" \
      '{text: $text, tooltip: $tooltip, class: "daily-verse"}'
}

get_daily_verse | main

