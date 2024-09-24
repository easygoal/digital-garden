---
title: Docker Mirror
---

## 国内镜像加速列表(by 20240910)
| DockerHub 镜像仓库            | 是否正常 |
| ------------------------- | ---- |
| docker.registry.cyou      | 正常   |
| docker-cf.registry.cyou   | 正常   |
| dockerpull.com            | 正常   |
| dockerproxy.cn            | 正常   |
| docker.1panel.live        | 正常   |
| hub.rat.dev               | 正常   |
| dhub.kubesre.xyz          | 正常   |
| docker.hlyun.org          | 正常   |
| docker.kejilion.pro       | 正常   |
| registry.dockermirror.com | 正常   |
| docker.mrxn.net           | 正常   |
| docker.chenby.cn          | 正常   |
| ccr.ccs.tencentyun.com    | 正常   |
| hub.littlediary.cn        | 正常   |
| hub.firefly.store         | 正常   |
| docker.nat.tf             | 正常   |
| hub.yuzuha.cc             | 正常   |
| hub.crdz.gq               | 正常   |
| noohub.ru                 | 正常   |
| docker.nastool.de         | 正常   |
| hub.docker-ttc.xyz        | 正常   |
| freeno.xyz                | 正常   |
| docker.hpcloud.cloud      | 正常   |
| dislabaiot.xyz            | 正常   |
| docker.wget.at            | 正常   |
| ginger20240704.asia       | 正常   |
| lynn520.xyz               | 正常   |
| doublezonline.cloud       | 正常   |
| dockerproxy.com           | 正常   |

### 临时使用
直接使用，直接拿镜像域名拼接上官方镜像名，例如要拉去镜像yidadaa/chatgpt-next-web，可以用下面写法
```sh
docker pull <mirror>/yidadaa/chatgpu-next-web
```

### 长久使用
修改文件 /etc/docker/daemon.json（如果不存在则需要创建创建，注意不要写入中文），并重启服务。
```sh
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "registry-mirrors": [
    	"https://dockerpull.com",
        "https://docker.anyhub.us.kg",
        "https://dockerhub.jobcher.com",
        "https://dockerhub.icu",
        "https://docker.awsl9527.cn"
    ]
}
EOF
sudo systemctl daemon-reload && sudo systemctl restart docker
```

[[your-first-note|Back to Main]]
