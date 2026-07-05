ARG ROS_DISTRO=jazzy

# ==========================================
# Builder
# ==========================================
FROM cardboardcode/rmf:$ROS_DISTRO-ros-core AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        cmake \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /rmf_ws

COPY traffic_light_adapter_invisibot src/traffic_light_adapter_invisibot

RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    colcon build \
        --merge-install \
        --cmake-args \
        -DCMAKE_BUILD_TYPE=Release

# Remove build artifacts
RUN rm -rf \
    build \
    log \
    src

# ==========================================
# Runtime
# ==========================================
FROM cardboardcode/rmf:$ROS_DISTRO-ros-core

ENV DEBIAN_FRONTEND=noninteractive

RUN pip3 install --no-cache-dir \
        flask-socketio \
        uvicorn \
        nudged \
        --break-system-packages

COPY --from=builder \
    /rmf_ws/install \
    /rmf_ws/install

RUN sed -i '$isource "/rmf_ws/install/setup.bash"' \
    /ros_entrypoint.sh

RUN echo "source /ros_entrypoint.sh" >> /etc/bash.bashrc

CMD ["bash"]