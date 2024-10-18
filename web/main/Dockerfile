FROM nginx:1.14-alpine
LABEL maintance="soonge679@gmail.com"

ENV TZ=Asia/Seoul

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
