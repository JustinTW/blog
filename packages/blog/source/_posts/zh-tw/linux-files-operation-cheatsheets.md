---
title: Linux 大量檔案操作筆記
lang: zh-tw
date: 2017-06-17 09:22:32
tags:
- Linux
categories: 筆記
---

當我們使用指令來操作 Linux **大量檔案**時，首先最講究的就是**效率**，本篇蒐集常用的大量檔案操作指令，盡可能列舉最快速的方法，方便需要時查詢。

# 產生檔案

## 產生 1000 個 500kb 的隨機檔案

```bash
for i in {1..1000}; do head -c 500 /dev/urandom > d_$i; done
```

## 產生隨機內容大檔案 (1G)

```bash
dd if=<(openssl enc -aes-256-ctr -pass pass:"$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64)" -nosalt < /dev/zero) of=filename bs=1M count=1000 iflag=fullblock
```

<!--more-->

# 複製大量檔案

## 複製到不同機器

根據實驗，`scp` 速度優於 `rsync` ，因此建議先使用 scp 指令複製，過程中如果失敗，再使用 rsync 進行差異複製

### 使用 scp 複製檔案

```bash
scp -r $SOURCE $TARGET
```

### 使用 rsync 複製檔案

```bash
rsync -av $SOURCE $TARGET
```



### 使用 rsync 列出差異檔案

```bash
rsync -avun $SOURCE $TARGET
```

## 複製到本地其他資料夾

### 使用 cp 方式

-u 如果目標檔案已存在，只有變動時間較新的版本會覆蓋

```bash
cp -au $SOURCE $TARGET
```

# 刪除

## 刪除大量檔案的目錄

* 方法1(50萬個檔案約 8.98秒)

```bash
find ./yourdirectory -delete
```

* 方法2(50萬個檔案約 9.28秒)

```bash
cd yourdirectory
perl -e 'for(<*>){((stat)[9]<(unlink))}'
```

# 查詢

## Inode 用量

```bash
find / -xdev -printf '%h\n' | sort | uniq -c | sort -k 1 -n
```

## 檔案數量

```bash
for t in files links directories; do echo `find . -type ${t:0:1} | wc -l` $t; done 2> /dev/null
```

## 查詢檔案存取中的程序

```bash
lsof /path/to/file/or/folder
```

## 查詢最常使用的 20 個指令

```bash
history | awk '{print $2;}' | sort | uniq -c | sort -rn | head -20
```


# 參考資料

* [Which is the fastest method to delete files in Linux](http://www.slashroot.in/which-is-the-fastest-method-to-delete-files-in-linux)
* [Efficiently delete large directory containing thousands of files](http://unix.stackexchange.com/questions/37329/efficiently-delete-large-directory-containing-thousands-of-files)
* [Sort history on number of occurences](http://stackoverflow.com/questions/13124869/sort-history-on-number-of-occurences)
* [Creating a large file of random bytes quickly](https://superuser.com/questions/792427/creating-a-large-file-of-random-bytes-quickly)
