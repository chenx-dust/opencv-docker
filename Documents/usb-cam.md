# 使用 USB 摄像头（已弃用）

## Windows 配置

### 参考：

- [[Github] dorssel/usbipd-win/wiki/WSL-support](https://github.com/dorssel/usbipd-win/wiki/WSL-support)
- [[CSDN] WSL2连接调用USB设备](https://blog.csdn.net/leiconghe/article/details/123877944)
- [[StackOverflow] WSL - webcam USB : Can not open camera by index](https://stackoverflow.com/questions/72255353/wsl-webcam-usb-can-not-open-camera-by-index/72259612#72259612)

### 已知问题：

* USBPcap （可能）存在兼容性问题，需要加入 `--force` 参数
* 如要使用图形界面，请配置好 WSLg

### 步骤：

1. 跟从参考资料 [[StackOverflow] WSL - webcam USB : Can not open camera by index](https://stackoverflow.com/questions/72255353/wsl-webcam-usb-can-not-open-camera-by-index/72259612#72259612) 编译支持的内核，检查 WSL2 的内核版本（>=5.10.60.1）

   ```bash
   uname -a
   # Linux DEVICE_NAME KERNEL_VERSION(>=5.10.60.1)
   ```
2. 安装 usbipd-win

   ```powershell
   # 请使用管理员权限运行
   winget install usbipd
   ```
3. 为 WSL2 进行准备工作

   ```bash
   # 适用于Ubuntu/Debian
   sudo apt install linux-tools-virtual hwdata
   sudo update-alternatives --install /usr/local/bin/usbip usbip `ls /usr/lib/linux-tools/*/usbip | tail -n1` 20
   ```
4. 在 WSL2 窗口开启时（保证运行），在主机检查可连接的 USB 设备

   ```powershell
   # 请使用管理员权限运行
   usbipd wsl list
   # BUSID	VID:PID		DEVICE                  STATE
   # 2-6	174f:2435	Integrated Camera	Not attached
   ```
5. 连接摄像头（例如：Integrated Camera）

   ```powershell
   # 请使用管理员权限运行
   usbipd wsl attach --busid YOUR_ID(2-6) [--force]
   ```
6. 检查 WSL2 中是否存在摄像头设备

   ```bash
   ls /dev | grep video
   # video0
   ```
7. 运行 Docker 容器

   ```bash
   docker run -itd \
       -v PATH_TO_SOURCE:PATH_TO_CONTAINER \
       --device PATH_TO_VIDEO(e.g. /dev/video0) \
       opencv-docker:latest /bin/bash
   ```

### 图形显示

参见：[WSLg: Container](https://github.com/microsoft/wslg/blob/main/samples/container/Containers.md)

```
# 增加以下参数
# -v /tmp/.X11-unix:/tmp/.X11-unix -v /mnt/wslg:/mnt/wslg \
# -e DISPLAY=$DISPLAY -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
# -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR -e PULSE_SERVER=$PULSE_SERVER
# 示例：

docker run -itd -v /home:/home --device /dev/video0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix -v /mnt/wslg:/mnt/wslg \
    -e DISPLAY=$DISPLAY -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
    -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR -e PULSE_SERVER=$PULSE_SERVER \
    opencv-docker:latest /bin/bash
```

## Linux 配置

```bash
docker run -itd \
      -v PATH_TO_SOURCE:PATH_TO_CONTAINER \
      --device PATH_TO_VIDEO(e.g. /dev/video0) \
      opencv-docker:latest /bin/bash
```
