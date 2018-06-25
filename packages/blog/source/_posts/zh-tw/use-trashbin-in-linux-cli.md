---
title: 避免 Linux rm 指令誤操作的方法
lang: zh-tw
date: 2017-07-30 06:18:44
tags:
- Linux
categories: 技術分享
---

Linux 指令操作中，最可能發生悲劇的指令是 `rm`，2016年4月 [Server Fault](https://serverfault.com/questions/587102/monday-morning-mistake-sudo-rm-rf-no-preserve-root) 有篇自稱是網站主機供應商 (Web Hosting) 的管理員，在營運中超過 1,535 個客戶的伺服器上有個 bash script ，執行 `rm -rf {foo}/{bar}` ，因 foo 跟 bar 變數是空字串，導致指令刪除整個根目錄。雖然後續跟記者表示[情境是杜撰的](http://www.telegraph.co.uk/technology/2016/04/16/did-it-guy-really-delete-entire-company-with-wrong-bit-of-code/)，出發點是為了讓大家重視 `rm` 指令的危險性。如果要避免 `rm` 的悲劇發生，筆者建議將 `rm` 指令改成資源回收筒功能的 [trash-cli](https://github.com/andreafrancia/trash-cli)。
<!--more-->
下列將介紹 [trash-cli](https://github.com/andreafrancia/trash-cli) 套件的安裝與使用，來取代 `rm` 指令，並且使用排程定期清空資源回收筒較舊的檔案釋放空間。

# 安裝需求套件

```bash
sudo apt install git
```

# 安裝 Trash-cli

```bash
git clone https://github.com/andreafrancia/trash-cli.git /tmp/trash-cli
cd /tmp/trash-cli
sudo python setup.py install
```

# 使用方法

## 刪除檔案

執行下列指令：

```bash
trash-put foo.txt
```

## 查看資源回收筒

執行下列指令：

```bash
trash-list
```

回應：

```
2008-06-01 10:30:48 /home/andrea/bar.txt
2008-06-02 21:50:41 /home/andrea/bar.txt
2008-06-23 21:50:49 /home/andrea/foo.txt
```

## 還原刪除的檔案

執行下列指令：

```bash
trash-restore
```

此時 terminal 會列出資源回收筒內的檔案，可以按數字鍵選擇要還原的檔案

```bash
0 2007-08-30 12:36:00 /home/andrea/foo.txt
1 2007-08-30 12:39:41 /home/andrea/bar.txt
2 2007-08-30 12:39:41 /home/andrea/bar2.txt
3 2007-08-30 12:39:41 /home/andrea/foo2.txt
4 2007-08-30 12:39:41 /home/andrea/foo.txt
What file to restore [0..4]: 4
```

## 清空資源回收筒

```bash
trash-empty
```

## 清除超過 30 天前的資源回收筒檔案

```bash
trash-empty 30
```

# 每日排程自動刪除 30 天的資源回收筒檔案

以下指令將會在 `/etc/cron.daily/` 下新增 trash-cli-rotate 檔案

```bash
sudo /bin/su -c "echo \"#\!/bin/bash\" > /etc/cron.daily/trash-cli-rotate"
sudo /bin/su -c "echo \"find $HOME/.local/share/Trash/ -mtime +29 -exec \\rm -rf {} \\;\n\" >> /etc/cron.daily/trash-cli-rotate"
sudo /bin/su -c "chmod +x /etc/cron.daily/trash-cli-rotate"
```

# 避免 rm 指令誤用

## 方法 1: 將 rm 指令連結到 trash-put

修改 bashrc，強制 `rm` 指令執行 `trash-put` 。

{% note info %}
下列指令中，如果您 Linux 預設 shell 是使用 zsh，則 .bashrc 須改成 .zshrc
{% endnote %}

```bash
echo "alias rm='trash-put'" >> ~/.bashrc

# 重新載入 bash 設定檔，或者重開 Terminal，以便讓 alias 生效
source ~/.bashrc
```

## 方法 2: 取消 rm 指令

修改 bashrc，讓 `rm` 指令不執行刪除動作。
平常要刪除檔案，盡可能改用 `trash-put`。
如果有不想放進資源回收筒的檔案，可用 `\rm` 指令，範例: `\rm foo.txt`。

{% note info %}
下列指令中，如果您 Linux 預設 shell 是使用 zsh，則 .bashrc 須改成 .zshrc
{% endnote %}

```bash
echo "alias rm='echo \"Please use trash-put command to delete files.\"; false'" >> ~/.bashrc

source ~/.bashrc
```

# 參考資料

* [trash-cli - Command Line Interface to FreeDesktop.org Trash](https://github.com/andreafrancia/trash-cli#trash-cli---command-line-interface-to-freedesktoporg-trash)
