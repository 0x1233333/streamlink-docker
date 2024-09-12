#!/bin/bash

API_KEY=$1
CHANNEL_ID=$2
COOKIES_FILE=${COOKIES_FILE}
PORT=${PORT}
QUALITY=${QUALITY}
RETRY_OPEN=${RETRY_OPEN}
RETRY_MAX=${RETRY_MAX}
SEGMENT_TIMEOUT=${SEGMENT_TIMEOUT}
STREAM_TIMEOUT=${STREAM_TIMEOUT}
BUFFER_SIZE=${BUFFER_SIZE}
CHECK_INTERVAL=${CHECK_INTERVAL}

while true; do
    echo "Checking for live stream..."
    API_RESPONSE=$(curl -s "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$CHANNEL_ID&eventType=live&type=video&key=$API_KEY")
    VIDEO_ID=$(echo "$API_RESPONSE" | jq -r '.items[0].id.videoId')

    if [[ -z $VIDEO_ID || $VIDEO_ID == "null" ]]; then
        echo "No live stream detected. Checking again in $CHECK_INTERVAL seconds..."
    else
        LIVE_URL="https://www.youtube.com/watch?v=$VIDEO_ID"
        echo "Live stream detected: $LIVE_URL"

        echo "Extracting stream URL using yt-dlp..."
        STREAM_URL=$(yt-dlp -g --cookies "$COOKIES_FILE" "$LIVE_URL")

        if [[ -z $STREAM_URL ]]; then
            echo "Failed to extract stream URL. Retrying in $CHECK_INTERVAL seconds..."
        else
            echo "Starting streamlink..."
            streamlink "$STREAM_URL" "$QUALITY" \
                --player-external-http \
                --player-external-http-port $PORT \
                --retry-open $RETRY_OPEN \
                --retry-max $RETRY_MAX \
                --stream-segment-timeout $SEGMENT_TIMEOUT \
                --stream-timeout $STREAM_TIMEOUT \
                --ringbuffer-size $BUFFER_SIZE
        fi

        echo "Streamlink stopped. Restarting check in $CHECK_INTERVAL seconds..."
    fi

    sleep $CHECK_INTERVAL
done
