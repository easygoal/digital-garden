---
title: FFmpeg test
---

Test ``ffmpeg`` hardware decoder performance

# Basic Info
[输入视频：骁龙8至尊版评测](https://www.bilibili.com/video/BV1fMyLYZE1n/)

ffmpeg command line path:
- Emby docker: ``/app/emby/bin/ffmpeg``
- Jellyfin docker: ``/usr/lib/jellyfin-ffmpeg/ffmpeg``

Supported hardware accelerator and codecs, which depends on the ``ffmpeg`` compile-time configs:
```
ffmpeg -hwaccels -hide_banner

Hardware acceleration methods:
cuda
vaapi
dxva2
qsv
d3d11va
d3d12va

ffmpeg -codecs | findstr <h264/hevc/vp9/av1/jpeg>

DEV.LS h264                 H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10 (decoders: h264 h264_qsv h264_cuvid) (encoders: libx264 libx264rgb h264_amf h264_mf h264_nvenc h264_qsv h264_vaapi)
DEV.L. hevc                 H.265 / HEVC (High Efficiency Video Coding) (decoders: hevc hevc_qsv hevc_cuvid) (encoders: libx265 hevc_amf hevc_mf hevc_nvenc hevc_qsv hevc_vaapi)
DEV.L. vp9                  Google VP9 (decoders: vp9 libvpx-vp9 vp9_cuvid vp9_qsv) (encoders: libvpx-vp9 vp9_vaapi vp9_qsv)
DEV.L. av1                  Alliance for Open Media AV1 (decoders: libaom-av1 av1 av1_cuvid av1_qsv) (encoders: libaom-av1 av1_nvenc av1_qsv av1_amf av1_vaapi)
DEVIL. mjpeg                Motion JPEG (decoders: mjpeg mjpeg_cuvid mjpeg_qsv) (encoders: mjpeg mjpeg_qsv mjpeg_vaapi)
```
You need to use the supported codec as parameter for ``-hwaccel``

```
Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'Geekerwan_snapdragon_8_elite_debut.mp4':
  Metadata:
    major_brand     : isom
    minor_version   : 512
    compatible_brands: isomiso2mp41
    encoder         : Lavf60.16.100
    description     : Packed by Bilibili XCoder v2.0.2
  Duration: 00:08:36.27, start: 0.000000, bitrate: 1798 kb/s
  Stream #0:0[0x1](und): Video: hevc (Main) (hev1 / 0x31766568), yuv420p(tv, bt709), 3840x2160 [SAR 1:1 DAR 16:9], 1610 kb/s, 59.94 fps, 59.94 tbr, 16k tbn (default)
      Metadata:
        handler_name    : Bento4 Video Handler
        vendor_id       : [0][0][0][0]
  Stream #0:1[0x2](und): Audio: aac (LC) (mp4a / 0x6134706D), 48000 Hz, stereo, fltp, 172 kb/s (default)
      Metadata:
        handler_name    : Bento4 Sound Handler
        vendor_id       : [0][0][0][0]
```

# Intel QSV

- [ffmpeg wiki](https://trac.ffmpeg.org/wiki/Hardware/QuickSync)
- [QSV decoder](https://ffmpeg.org/ffmpeg-codecs.html#toc-QSV-Decoders)

## Environment
- Model: Dell Latitude 7490
- CPU: Intel Core i7-8650U @ 3.9GHz
- Memory: 16GB DDR4
- GPU: Intel UHD Graphic 620
- OS: Windows 10 Professional 22H2 19045.4780
- ffmpeg version: 7.1-full_build-www.gyan.dev

## Result
```bash
# use hevc_qsv decoder and mjpeg_qsv encoder
ffmpeg -hwaccel_output_format qsv -c:v hevc_qsv -i input.mp4 -f image2 -r 1 -c:v mjpeg_qsv -q:v 2 img-%3d.jpg

frame=  104 fps=1.1 q=-0.0 Lsize=N/A time=00:01:43.00 bitrate=N/A dup=0 drop=6010 speed=1.06x
```
There is around 60% utilization on GPU Video Decode engine and 3D engine.

```bash
# start from 300s
ffmpeg -hwaccel_output_format qsv -c:v hevc_qsv -ss 300 -i input.mp4 -f image2 -r 1 -c:v mjpeg_qsv -q:v 2 img-%3d.jpg

frame=  272 fps=1.0 q=-0.0 size=N/A time=00:04:31.00 bitrate=N/A dup=0 drop=16096 speed=1.03x
```
There is around 45% utilization on GPU Video Decode engine, 70% on 3D engine and 35% on CPU.

```bash
# use dxva2 decoder and encoder
ffmpeg -hwaccel dxva2 -threads 4 -i input.mp4 -f image2 -r 1 -q:v 2 img-%3d.jpg

frame=  126 fps=0.9 q=2.0 size=N/A time=00:02:06.00 bitrate=N/A dup=0 drop=7425 speed=0.894x
```
There is around 70% utilization on GPU Video Decode engine, 5% on 3D engine and 70% on CPU.

# Intel 2

## Environment
- Model: OEM
- CPU: Intel Pentium Gold G5400 @ 3.7GHz
- Memory: 16GB DDR4
- GPU: Intel UHD Graphic 610 @ 600MHz
- OS: Linux 6.1.79 with docker 
- ffmpeg version: 6.0.1-Jellyfin

## Result
```bash
# use hevc_qsv decoder and mjpeg_qsv encoder
ffmpeg -hwaccel_output_format qsv -c:v hevc_qsv -ss 300 -i input.mp4 -f image2 -r 1 -c:v mjpeg_qsv img-%3d.jpg

frame=  218 fps=1.1 q=-0.0 Lsize=N/A time=00:03:37.00 bitrate=N/A dup=0 drop=12744 speed=1.08x    8 speed=N/A  
```
There is around 55% utilization on GPU Video Load and Decode engine and 35% on CPU.

# AMD

- [ffmpeg AMF](https://trac.ffmpeg.org/wiki/HWAccelIntro#AMDUVDVCE)

## Environment
- Model: Tianbei GEM12
- CPU: AMD Ryzen 7 8845HS @ 5.1GHz
- Memory: 32GB DDR5
- GPU: AMD Radeon 780M
- OS: Windows 11 Enterprise 23H2 22631.4169
- ffmpeg version: 

## Result
```bash
ffmpeg -hwaccel dxva2 -threads 4 -i input.mp4 -f image2 -r 1 -q:v 2 img-%3d.jpg

frame=  518 fps=4.3 q=24.8 Lsize=N/A time=00:08:38.00 bitrate=N/A dup=0 drop=30424 speed=4.33x
```
There is around 90% utilization on GPU video codec 0 engine and 50% on CPU.

# Nvidia 1

- [ffmpeg CUDA](https://trac.ffmpeg.org/wiki/HWAccelIntro#NVDECCUVID)
- [NVIDIA FFmpeg 转码指南](https://developer.nvidia.com/zh-cn/blog/nvidia-ffmpeg-transcoding-guide/)

## Hardware
- Model: MSI Trident
- CPU: Intel Core CC150 @ 3.50GHz
- Memory: 32GB DDR4
- GPU: GeForce GTX 1660, 6GB GDDR, CUDA version 12.6
- OS: Windows 10 Professional 22H2, 19045.4894
- ffmpeg version: 7.0.2-essentials_build-www.gyan.dev

## Result
Use ``dxva`` hardware engine
```bash
ffmpeg -hwaccel dxva2 -threads 4 -i input.mp4 -f image2 -r 1 -q:v 2 image-%3d.jpg

frame=  118 fps=2.8 q=2.0 Lsize=N/A time=00:01:58.00 bitrate=N/A dup=0 drop=6848 speed=2.78x
```
There is around 30% utilization on GPU 3D engine, 55% on Video Engine and 50% on CPU.

Explicitly specify ``cuda`` engine
```bash
ffmpeg -hwaccel cuda -c:v hevc_cuvid -ss 400 -i input.mp4 -f image2 -r 1 -c:v mjpeg -q:v 2 img-%3d.jpg

frame=  118 fps=2.8 q=2.0 Lsize=N/A time=00:01:58.00 bitrate=N/A dup=0 drop=6848 speed=2.75x
```
There is around 30% utilization on GPU CUDA engine, 55% on Video Engine and 40% on CPU.

# Nvidia 2

## Hardware
- Model: OEM
- CPU: Intel Core i5-9400F @ 2.90GHz
- Memory: 64GB DDR4
- GPU: RTX A2000 Laptop GPU 8GB GDDR, CUDA version 12.2
- OS: Windows 10 Enterprise 22H2, 19045.4957
- ffmpeg version: 7.1-full_build-www.gyan.dev

## Result
```bash
ffmpeg -hwaccel dxva2 -threads 4 -ss 400 -i input.mp4 -f image2 -r 1 -q:v 2 img-%3d.jpg

frame=  118 fps=1.3 q=2.0 Lsize=N/A time=00:01:58.00 bitrate=N/A dup=0 drop=6848 speed=1.29x
```
There is around

```bash
ffmpeg -hwaccel cuda -c:v hevc_cuvid -ss 400 -i input.mp4 -f image2 -r 1 -c:v mjpeg -q:v 2 img-%3d.jpg

frame=  118 fps=2.4 q=2.0 Lsize=N/A time=00:01:58.00 bitrate=N/A dup=0 drop=6848 speed=2.39x
```
There is around 95% utilization on GPU 3D Engine, 30% on Video Decode engine and 90% on CPU.

[[your-first-note|Back to Main]]
