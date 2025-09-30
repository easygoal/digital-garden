---
title: 使用 Docker 本地部署 dots.ocr
---

- [项目github](https://github.com/rednote-hilab/dots.ocr)
- [Demo](https://dotsocr.xiaohongshu.com/)

以下是通过 Docker 在本地部署 dots.ocr 的详细步骤，适用于需要高效 OCR 文档解析的用户。

## 步骤 1：环境准备

- 安装 Docker 确保系统已安装 Docker。可参考 Docker 官方文档 进行安装。 确保 NVIDIA 驱动已正确安装，并支持 CUDA（推荐 CUDA 12.8）。
- 创建项目目录
```bash
mkdir dots-ocr && cd dots-ocr
```

## 步骤 2：克隆项目代码
使用 Git 克隆 dots.ocr 项目：
```bash
git clone https://github.com/rednote-hilab/dots.ocr.git
cd dots.ocr
```
重命名项目文件夹以避免 Python 包名冲突：
```bash
mv dots.ocr DotsOCR
```

## 步骤 3：构建 Docker 镜像
- 修改 Dockerfile（位于 docker/Dockerfile）以确保使用 vLLM 基础镜像：
```Dockerfile
FROM vllm/vllm-openai:v0.9.1
WORKDIR /app
COPY .  /app
RUN pip install -e . --no-cache-dir
```
- 构建镜像：
```bash
docker build -f docker/Dockerfile -t dots-ocr .
```

## 步骤 4：运行容器

启动容器并挂载权重目录：
```bash
docker run -it --gpus all \
-v "$(pwd)/weights:/app/weights" \
-v "$(pwd)/demo:/app/demo" \
-v "$(pwd)/dots_ocr:/app/dots_ocr" \
-p 8000:8000 \
--name dots_ocr_container \
dots-ocr
```

## 步骤 5：下载模型权重

在容器内执行以下命令下载模型：
```bash
python3 tools/download_model.py --type modelscope
```

验证权重是否下载成功：
```bash
ls -R /app/weights/DotsOCR
```

## 步骤 6：启动服务

在容器内启动 vLLM 服务：
```bash
CUDA_VISIBLE_DEVICES=0 vllm serve ${hf_model_path} \
--tensor-parallel-size 1 \
--gpu-memory-utilization 0.85 \
--host 0.0.0.0 --port 8000 \
--served-model-name dots-ocr \
--trust-remote-code
```

## 步骤 7：测试服务

运行官方测试脚本验证部署是否成功：
```bash
python3 ./demo/demo_vllm.py --prompt_mode prompt_layout_all_en --ip localhost --port 8000
```

若返回 OCR 推理结果，则部署完成。

## 注意事项
- 确保显卡驱动和 CUDA 环境兼容。
- 若遇到 ModuleNotFoundError 错误，请检查模型路径和 Python 环境变量配置。
- 可通过 Gradio 或 Postman 测试 API 接口。

此流程适用于大多数 Linux 系统，Windows 用户可通过 WSL2 配合 Docker 部署

了解详细信息:
1. [blog.csdn.net](https://blog.csdn.net/guoqingru0311/article/details/149978671)
2. [github.com](https://github.com/maymm831218/dots-ocr-windows-guide)


[[your-first-note|Back to Main]]
