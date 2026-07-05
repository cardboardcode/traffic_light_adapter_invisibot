#!/usr/bin/env bash

set -e

CONFIG_FILE="/traffic_light_adapter_invisibot_ws/src/traffic_light_adapter_invisibot/config.yaml"
NAV_GRAPH_FILE="/traffic_light_adapter_invisibot_ws/src/traffic_light_adapter_invisibot/nav_graph.yaml"
TRAJECTORY_SERVER_URL="ws://localhost:8000/_internal"

CONFIG_ROOT="./traffic_light_adapter_invisibot/configs"

# Find valid configuration folders
CONFIG_DIRS=()

while IFS= read -r -d '' dir; do
    if [[ -f "$dir/config.yaml" ]]; then
        CONFIG_DIRS+=("$dir")
    fi
done < <(find "$CONFIG_ROOT" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

if [[ ${#CONFIG_DIRS[@]} -eq 0 ]]; then
    echo "No valid configuration folders found in $CONFIG_ROOT"
    exit 1
fi

if [[ ${#CONFIG_DIRS[@]} -eq 1 ]]; then
    SELECTED_DIR="${CONFIG_DIRS[0]}"
else
    echo "Available configurations:"
    for i in "${!CONFIG_DIRS[@]}"; do
        echo "[$i] $(basename "${CONFIG_DIRS[$i]}")"
    done

    echo
    read -rp "Select configuration index: " SELECTION

    if ! [[ "$SELECTION" =~ ^[0-9]+$ ]]; then
        echo "Invalid selection"
        exit 1
    fi

    if (( SELECTION < 0 || SELECTION >= ${#CONFIG_DIRS[@]} )); then
        echo "Selection out of range"
        exit 1
    fi

    SELECTED_DIR="${CONFIG_DIRS[$SELECTION]}"
fi

HOST_CONFIG_FILE="$SELECTED_DIR/config.yaml"

echo
echo "Using configuration:"
echo "  Folder     : $(basename "$SELECTED_DIR")"
echo "  Config     : $HOST_CONFIG_FILE"
echo

docker run -it --rm \
    --name traffic_light_adapter_invisibot_c \
    --network host \
    -e RCL_LOG_LEVEL=debug \
    -e RCUTILS_COLORIZED_OUTPUT=1 \
    -e RMW_IMPLEMENTATION=rmw_cyclonedds_cpp \
    -v "$HOST_CONFIG_FILE:$CONFIG_FILE" \
traffic_light_adapter_invisibot:jazzy bash -c \
"source /ros_entrypoint.sh && \
ros2 launch traffic_light_adapter_invisibot fleet_adapter.launch.xml \
config_file:=$CONFIG_FILE \
server_uri:=$TRAJECTORY_SERVER_URL \
use_sim_time:=true"

unset CONFIG_FILE HOST_CONFIG_FILE