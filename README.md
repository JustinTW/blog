# Justin Tech Blog

[![Build Status](https://travis-ci.org/JustinTW/blog.svg?branch=master)](https://travis-ci.org/JustinTW/blog)


[https://blog.justintw.com](https://blog.justintw.com)

## Setup Devlopment environment

```
git clone https://github.com/JustinTW/docker-dev-env.git
cd docker-dev-env
git clone https://github.com/JustinTW/blog.git src
cd src
git submodule update --init --recursive
```

## Preview blog on local machine

```
cd docker-dev-env
make at
cd packages/blog
hexo s
```
