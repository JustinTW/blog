---
title: Docker 變更路徑與釋出磁碟空間設定
lang: zh-tw
date: 2017-06-20 12:29:18
tags:
- docker
categories: 筆記
---

筆者近期在使用 Linux 環境開發軟體時，經常需要安裝各種相依套件或函式庫，為了讓環境建置設定可以重複使用，前一陣子採用社群流行的 Vagrant 定義虛擬機，開機後搭配 Recipes 工具如: Puppets 或 Chef 來自動化建置環境。這樣做的確讓所有開發人員的開發環境都統一了，也可以讓佈署產品過程更一致。不過是有些缺點，例如：虛擬化會消耗額外的硬體資源，Puppets 執行可能因網路環境等因素而導致安裝套件緩慢。因此最近火紅的**作業系統層級**的虛擬化技術: Docker 則成為我們環境建置自動化的最佳取代方案。

<!--more-->

然而 Docker 預設映像檔路徑在 `/var/lib/docker` ，經常使用下，可能累積許多映像檔，而導致空間不足，本篇分享一下搬遷的方法。


# 清除 Docker Image 釋放空間

## 清除無名稱 的 Images

{% note info %}
執行下列指令，只刪除 Image Name 為 none 的映像檔
{% endnote %}

```bash
docker images --no-trunc | grep none | awk '{print $3}' | xargs docker rmi -f
```

## 清除所有 Container 與 Image

{% note danger %}
危險動作，刪除後無法還原，請使用 `docker images` 查看並確定所有 Image 都是可以重新建置的，否則請忽略此步驟
{% endnote %}

```bash
docker stop `docker ps -a -q`
docker rm `docker ps -a -q`
docker rmi -f `sudo docker images -q`
```

## 清除所有 Volumes

{% note danger %}
危險動作，刪除後無法還原，如果您有服務已經跑一陣子，有使用 Volumes 保存資料，請先備份
{% endnote %}

```bash
docker volume rm $(docker volume ls -f dangling=true -q)
```

# 修改 Docker 儲存路徑

## 複製 Docker 資料夾到新的目錄

```bash
sudo mkdir -p /mnt/disk/docker
sudo rsync -aqxP /var/lib/docker/* /mnt/disk/docker
```

## 更改 Docker daemon 設定檔

```bash
sudo vi /etc/docker/daemon.json
```

檔案為 JSON 格式， 設定 `graph` : `新目錄的路徑`

```js
{
  "graph": "/mnt/disk/docker"
}
```

## 重新啟動服務

```bash
sudo systemctl stop docker
sudo systemctl daemon-reload
sudo systemctl start docker
```



