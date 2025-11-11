#!/bin/sh

# Use location from first argument when provided, fallback to default city.
LOCATION="${1:-newmilns}"
MAX_ATTEMPTS=5
ATTEMPT=0

while [ "$ATTEMPT" -lt "$MAX_ATTEMPTS" ]; do
    ATTEMPT=$((ATTEMPT + 1))

    # Fetch temperature + condition symbol (e.g. ☀️ +12°C).
    WEATHER=$(curl -s "https://wttr.in/${LOCATION}?format=1") || WEATHER=""

    if [ -n "$WEATHER" ] && echo "$WEATHER" | grep -qi "Unknown location"; then
        # wttr.in can suggest a coordinate-based lookup when a place name is not recognised.
        SUGGESTED=$(echo "$WEATHER" | sed -n 's/.*~\([^ ]*\).*/~\1/p')
        if [ -n "$SUGGESTED" ] && [ "$SUGGESTED" != "$LOCATION" ]; then
            LOCATION="$SUGGESTED"
            continue
        fi
        WEATHER=""
    fi

    if [ -z "$WEATHER" ]; then
        sleep 2
        continue
    fi

    SYMBOL=$(echo "$WEATHER" | awk '{print $1}')
    TEMP=$(echo "$WEATHER" | awk '{print $2}' | tr -d '[:space:]')

    # Fetch tooltip with detailed description.
    TOOLTIP=$(curl -s "https://wttr.in/${LOCATION}?format=4") || TOOLTIP=""
    if [ -n "$TOOLTIP" ] && echo "$TOOLTIP" | grep -qi "Unknown location"; then
        TOOLTIP=""
    fi

    if [ -n "$TOOLTIP" ]; then
        TOOLTIP=$(echo "$TOOLTIP" | sed -E "s/\\s+/ /g")
        echo "{\"text\":\"${SYMBOL} ${TEMP}\", \"tooltip\":\"${TOOLTIP}\"}"
        exit 0
    fi

    sleep 2
done

# Fallback if all attempts fail.
echo "{\"text\":\"error\", \"tooltip\":\"error\"}"
