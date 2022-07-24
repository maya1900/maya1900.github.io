# node环境镜像
FROM nginx

# 把上一部生成的HTML文件复制到Nginx中
COPY  . /usr/share/nginx/html
EXPOSE 80
