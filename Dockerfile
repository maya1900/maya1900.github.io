# node环境镜像
FROM ngnix

# 把上一部生成的HTML文件复制到Nginx中
COPY --from=build-env /usr/src/hexo-blog/public /usr/share/nginx/html
EXPOSE 80
