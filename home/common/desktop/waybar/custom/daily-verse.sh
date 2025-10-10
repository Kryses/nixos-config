#!/run/current-system/sw/bin/bash
# Function to get daily Bible verse
get_daily_verse() {
    local verse=""
    local reference=""
    
    # Try multiple sources for reliability
    if command -v curl &> /dev/null; then
        # Try BibleGateway API (free, but may have rate limits)
        verse=$(curl -s "https://www.biblegateway.com/votd/get/?format=json&version=KJV" | \
                jq -r '.votd.text' 2>/dev/null)
        reference=$(curl -s "https://www.biblegateway.com/votd/get/?format=json&version=KJV" | \
                jq -r '.votd.display_ref' 2>/dev/null)
        plain_text=$(echo "$verse" | sed 's/&ldquo;/"/g; s/&rdquo;/"/g')
    fi
    
    echo "($reference) -- $plain_text"
}

# Function to format the daily verse display
show_daily_verse() {
    local index=$1
    local icon=${2:-"📖"}
    local color=${3:-"#ffffff"}
    local text=${4:-""}
    
    # Get the daily verse
    local daily_verse=$(get_daily_verse)
    
    # Format the module for display
    local module="$icon $daily_verse"
    
    echo "$module"
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # If script is run directly, show the daily verse
    show_daily_verse 0 "📖" "#ffffff" ""
fi
