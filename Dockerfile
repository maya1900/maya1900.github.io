# node环境镜像
FROM node:latest AS build-env
# 创建hexo-blog文件夹且设置成工作文件夹
RUN mkdir -p /usr/src/hexo-blog
WORKDIR /usr/src/hexo-blog
# 复制当前文件夹下面的所有文件到hexo-blog中
COPY . .
# 安装 hexo-cli
RUN npm --registry=https://registry.npm.taobao.org install hexo-cli -g && npm install
# 生成静态文件
RUN hexo clean && hexo g

# 把上一部生成的HTML文件复制到Nginx中
COPY --from=build-env /usr/src/hexo-blog/public /usr/share/nginx/html
EXPOSE 80
