---
outline: deep
---

# 脚本

项目中包含了大量的脚本，在此文档中记录并说明如何使用

- [获取网络资源](#🛜-获取网络资源)

| 脚本                 | 说明                                                |
| -------------------- | --------------------------------------------------- |
| `docker-pull-ros.sh` | [获取 ROS 的 Docker 镜像](#获取-ros-的-docker-镜像) |
| `get-ros-key.sh`     | [获取 ROS2 的公钥环文件](#获取-ros2-的公钥环文件)   |

- [ROS 相关脚本](#🤖-ros-相关脚本)

| 脚本 | 说明 |
| ---- | ---- |
| `create-ros-package.sh` | [创建 ROS 包](#创建-ros-包) |

## 脚本列表

### 🛜 获取网络资源

#### 获取 ROS 的 Docker 镜像

在编译镜像 `dockerfiles/*` 的时候可能需要获取一些网络资源，例如 ROS 的镜像

这些资源可能需要🪜全局代理，因此集中放置在脚本中，在容器启动前执行避免编译镜像失败

```bash
bash scripts/docker-pull.sh
```

#### 获取 ROS2 的公钥环文件

获取 ROS2 的公钥环文件，在容器安装

```bash
bash scripts/get-ros-key.sh
```

### 🤖 ROS 相关脚本

#### 创建 ROS 包

```bash
bash scripts/create-ros-package.sh [package_group] [package_name]
```

需要指定包的分组 `package_group` 和包的名称 `package_name`

例如，创建一个名为 `my_package` 的包，分组为 `my_group`。如果不指定，这将是默认参数

```bash
bash scripts/create-ros-package.sh my_group my_package
```

执行后，会在 `modules/my_group` 目录下创建一个名为 `my_package` 的 ROS 包 (C++) 和 `my_package_py` 的 ROS 包 (Python)，如果不需要相关语言的包，可以自行删除
