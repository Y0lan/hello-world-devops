FROM node
RUN apt-get update && apt-get install -y nginx && \
    rm -rf /var/cache/apt/*
COPY . /usr/local/src/app/
WORKDIR /usr/local/src/app/
RUN npm install && \
    npm run build && \
    mv dist/* /var/www/html/
ENTRYPOINT ["/usr/sbin/nginx", "-g daemon off;"]
