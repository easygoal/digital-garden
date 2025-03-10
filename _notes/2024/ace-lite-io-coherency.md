---
title: ACE-Lite IO coherency 分析
---

[原文](https://abcamus.github.io/2017/06/26/ARM-CCI/)

ACE-Lite口实现了ACE协议的子集，包含三个部分：
- Non-shared
- Non-cached
- Cache Maintenance

情景分析：

假设现在ACE口上有ARM core，ACE Lite一路有USB，分两种情况，ACE读和ACE写

# ACE 读，IO 设备写

现在usb cacaheable写了一笔数据进ddr，然后cpu读了一次，这个时候cache中有对应数据的缓存。
然后usb又通过dma往同样的地址写了一笔数据，这个时候ACE-Lite 发送 MakeInvalid transaction
告诉ACE说这笔缓存的数据需要invalidate，这样下次cpu读同样地址数据的时候就从ddr去读了，这样就保证了读数据的一致性。

# ACE写，I/O设备读

CPU写一笔setup包，数据进入dcache，然后usb读对应的虚拟地址发送请求，这个时候ACE-Lite发起ReadOnce transaction，
发现cache中有数据，那么直接从cache中把数据snoop过来；如果cache是dirty的，那么ACE还会把数据写入ddr（clean cache）。

[[your-first-note|Back to Main]]
