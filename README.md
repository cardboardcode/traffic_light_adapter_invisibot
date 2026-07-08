# **traffic_light_adapter_invisibot**

> [!NOTE]
> In contrast to a `full_control` fleet adapter, `traffic_light_adapter_invisibot` does not offer full control over a specific robot in the fleet. 

> Instead, it does the following:
> - Allows participation in traffic deconfliction
> - Pauses/Resumes a robot's navigation trajectory.

## **Dependencies**

- [ROS 2 Jazzy Jalisco](https://docs.ros.org/en/jazzy/index.html)
- [Open-RMF on Jazzy Jalisco](https://github.com/open-rmf/rmf/releases/tag/release-jazzy-240617)

## **Build**

```bash
git clone https://github.com/cardboardcode/traffic_light_adapter_invisibot.git --branch main --single-branch --depth 1 && cd traffic_light_adapter_invisibot
```

```bash
bash scripts/1_build_docker_image.bash
```

## **Run**

```bash
bash scripts/2_run_docker_container.bash
```