---
title: Hello World
lang: zh-tw
date: 2017-06-13 05:29:15
tags:
- 網站建置
- 網站託管
- 域名
- 憑證
- Hexo
categories: 技術分享
---
這是技術分享部落格的第一篇網誌，在這裡，我將紀錄與分享平時遇到的問題與解決方式，歡迎大家反饋指教。

# 部落格建置建置筆記


## 網頁託管

### 免費網頁託管的選擇

[GitHub Pages](https://pages.github.com/) 提供靜態網頁服務，設定好之後可以透過 `https://自訂名稱.github.io/` 存取靜態網頁內容，很適合 Hexo 或 Jekyll 靜態網誌當作免費網頁託管的平台。

~~不過要注意的是 GitHub Pages 自訂網域，無支援 HTTPS 功能，可透過搭配 CloudFlare 來達成 [參考資料](https://sheharyar.me/blog/free-ssl-for-github-pages-with-custom-domains/)。~~

更新： 2018/05 Github Pages 推出[自訂網域支援 HTTPS 功能](https://blog.github.com/2018-05-01-github-pages-custom-domains-https/)

### 付費網頁託管的選擇

目前本站採用來自加拿大廠商的 [crocweb](https://www.crocweb.com/web-hosting.html)，使用永久8折優惠碼(`ssdcrocweb`)之後，平均一個月租金 70 台幣，C/P值很高。該服務主機硬碟採用 SSD，管理系統是 CPanel，還支援 PHP, Ruby on Rails，而且無限制服務帳號或域名數量，可說是非常大方的網站託管商。

<!--more-->
{% asset_img 20170613-crocweb-pricing.png crocweb 價目表與代管服務主要特色 %}

## 域名購買

域名購買廠商有很多選擇，這邊推薦 [GoDaddy](https://tw.godaddy.com/)，這是一家來自美國的老牌域名與網站託管廠商，優惠活動較多，界面支援中文，簡單易用。

## SSL 憑證

目前單網域最便宜的購買方法，是上 [SSLs.com](https://www.ssls.com/) 購買 PositiveSSL ，一年約 150 台幣。

更新：免費 SSL 可參考 [Let's Encrypt](https://letsencrypt.org/)

{% asset_img 20170613-positive-ssl.png ssls.com 較便宜的 Positive SSL %}

## 靜態網誌系統

本站採用 [Hexo](https://hexo.io/) 靜態網誌系統，並搭配佈景主題 [Next](https://github.com/iissnan/hexo-theme-next)。靜態網誌系統好處是文章編輯好之後，直接產生出靜態網頁，使用者在瀏覽網站時無須執行程式邏輯，可以加速載入速度，也可以減少資安漏洞的風險。

### 基礎操作

#### 安裝 npm 相關模組

```bash
yarn global add hexo-cli@1.1.0
```

#### 新增文章

```bash
hexo new post "use-trashbin-in-linux-cli" --lang zh-tw
```

#### 本機預覽

```bash
hexo s
```

開啟瀏覽器 [http://localhost:4000](http://localhost:4000)

#### 建置與發布

```bash
hexo g
hexo d
```