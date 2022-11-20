# rpi-bullseye-ros2-xcompile
Cross compile tool based on rpi-bullseye-ros2

<br>

## Install (create alias)

```bash
git clone https://github.com/Ar-Ray-code/rpi-bullseye-ros2-xcompile
cd rpi-bullseye-ros2-xcompile
bash create_alias.bash
source ~/.bashrc
```

<br>

## Build your packages

`xcompile_rpi_ros2 [TARGET ROS2 WORKSPACE] [Bash_SCRIPT(optional)]`

- TARGET ROS2 WORKSPACE : Target ROS2 workspace (relative paths are also acceptable)
- Bash_SCRIPT (optional) : Bash script file to be executed within Docker (Default : `${SCRIPT_DIR}/scripts/build_command.bash`)

<br>

### Building example pkg (image_common)

```bash
mkdir -p ~/ros2_ws/src/
cd ~/ros2_ws/src
git clone https://github.com/ros-perception/image_common -b ros2
```

```bash
xcompile_rpi_ros2 ~/ros2_ws
# After a successful build
ls ~/ros2_ws
#> build_built_pkg_rpi  built_pkg_rpi  built_pkg_rpi_<unixtime>.zip log src
```

<br>

## rpi-bullseye-ros2

https://github.com/Ar-Ray-code/rpi-bullseye-ros2

<br>

## About author

- author : [Ar-Ray-code](https://github.com/Ar-Ray-code)
- [Twitter](https://twitter.com/Ray255Ar)
