---
title: 保護 SSH Server 的一些方法
date: 2017-06-23 02:43:26
tags:
- security
---

目前大部分的 Linux Server 都會開啟 SSH 服務，預設的情況下，有被暴力破解密碼的風險，所以裝好 SSH Server 後，會建議立刻設定一些安全措施，本篇蒐集各種加強 SSH Server 安全性的方法，可以依據使用情況選擇較適合的措施。

<!--more-->

# SSH 設定檔

編輯 `/etc/ssh/sshd_config` 設定檔:

```
# 確保 Protocol 只支援第二版，(避免使用舊版的通訊協定)
Protocol 2

# 變更 SSH Server Port, (客戶端連線時指定 Port: ssh -p 2222 my.host.com)
Port 2222

# 設定只允許白名單的使用者登入
AllowUsers alice bob
# 或設定禁止登入 ssh 的黑名單
DenyUsers alise bob

# 允許群組白名單
AllowGroups my-group
```

設定完後重起伺服器即可生效

```
service ssh restart
```

# Fail2ban

Fail2ban 會根據 log 登入失敗太多次的情況發生時，將來源 IP 使用 iptables 禁止連線，可以有效預防暴力破解密碼。

## 安裝方法

* [How To Protect SSH with fail2ban on Ubuntu 12.04 | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-12-04)
* [How To Protect SSH with Fail2Ban on Ubuntu 14.04 | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-14-04)
* [How To Protect SSH With Fail2Ban on CentOS 7 | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-centos-7)

# TCP Wrapper 設定來源 IP 白名單

如果管理員有固定 IP ，可使用 Linux 內建的 TCP Wrapper 來限制可連線的 IP 白名單。

## 設定方法

設定允許登入的 IP 白名單

```
vi /etc/hosts.allow
```

加入 sshd 白名單設定

```
sshd:192.168.0.100 172.16.0.0/24 my.host.com
```

禁止其他所有 IP

```
vi /etc/hosts.deny
```

```
sshd:ALL
```

# 使用 iptables 限制短時間內產生大量的連線

我們可以透過 iptables 來限制同一個 IP 10 分鐘內的連線數量。

```
vi /etc/rc.local
```

在 `exit 0` 之前加入以下 片段，請將 22 修改為您的 ssh port，eth0 改為您機器的網卡

```
iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --set
iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --update --seconds 600 --hitcount 10 -j DROP
```
