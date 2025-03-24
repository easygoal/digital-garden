---
title: Build Linux
---

在Linux系统中，构建内核（Kernel）、U-Boot和根文件系统（Root Files System，简称RootFS）通常遵循以下顺序：

1. **U-Boot**：
   - U-Boot是系统的引导加载程序（Bootloader），它通常是第一个运行的软件。U-Boot负责初始化硬件设备、配置内存布局并加载内核和根文件系统。
   - 通常，你会首先编译U-Boot，因为它需要被烧录到板级存储器（如SPI Flash或NOR Flash）中，以便在系统启动时首先执行。

2. **内核（Kernel）**：
   - 内核是操作系统的核心，负责管理系统资源，包括CPU、内存、设备驱动等。
   - 在U-Boot准备好之后，接下来编译内核。内核映像（通常是vmlinuz或zImage）需要被编译并链接，以便在U-Boot启动过程中被加载。
   - [[linux-kernel-intro|Linux Kernel 简介]]
   
3. **根文件系统（RootFS）**：
   - 根文件系统是Linux系统的文件系统，包含了运行时所需的所有文件、库和应用程序。
   - 最后，你会构建根文件系统。这通常涉及到选择一个基础文件系统（如busybox、buildroot、Yocto Project等），并根据需要添加额外的软件包和配置。

构建顺序的总结如下：
1. 编译U-Boot。
2. 编译Linux内核。
3. 构建根文件系统。

在实际操作中，这些步骤可能涉及到交叉编译环境的设置，以及对特定硬件平台的配置。构建完成后，你会得到U-Boot二进制文件、内核映像和根文件系统镜像，这些需要被烧录或复制到相应的存储介质上，以便在目标硬件上运行。

# Reference

[ARM64 启动过程之一：内核第一个脚印](http://www.wowotech.net/armv8a_arch/arm64_initialize_1.html)
[ARM64 启动过程之二：创建页表](http://www.wowotech.net/armv8a_arch/create_page_tables.html)
[ARM64 启动过程之三：CPU 初始化](http://www.wowotech.net/armv8a_arch/__cpu_setup.html)
[ARM64 启动过程之四：打开 MMU](http://www.wowotech.net/armv8a_arch/turn-on-mmu.html)
[ARM64 启动过程之五：UEFI](http://www.wowotech.net/armv8a_arch/UEFI.html)
[ARM64 启动过程之六：异常向量表](http://www.wowotech.net/armv8a_arch/238.html)

[QEMU 搭建 ARM vexpress 开发环境 1](https://mshrimp.github.io/2019/08/11/Qemu%E6%90%AD%E5%BB%BAARM-vexpress%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83(%E4%B8%80)/)
[QEMU 搭建 ARM vexpress 开发环境 2](https://mshrimp.github.io/2019/08/18/Qemu%E6%90%AD%E5%BB%BAARM-vexpress%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83(%E4%BA%8C)----u-boot%E5%90%AF%E5%8A%A8kernel/)

[[your-first-note|Back to Main]]
