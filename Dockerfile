FROM debian:9 AS step1

RUN apt update && \
apt install wget -y && \
apt install tar -y && \
apt-get install build-essential -y && \
wget http://nginx.org/download/nginx-1.22.0.tar.gz && \
tar xvfz nginx-1.22.0.tar.gz && \
cd nginx-1.22.0 && \
./configure --without-http_rewrite_module --without-http_gzip_module && \
make && \
make install

FROM debian:9

WORKDIR /usr

COPY --from=step1 /usr/local/nginx /usr/local/nginx
RUN apt update && \
apt install curl -y && \
apt-get install procps -y && \
useradd -s /bin/false nginx && \
mkdir data && \
mkdir data/www && \
#touch data/www/index.html && \
#echo "<h1>Hello</h1>" >> /data/www/index.html && \
#mkdir /usr/local/nginx/logs && \
touch /usr/local/nginx/logs/error.log && \
touch /usr/local/nginx/logs/access.log 

COPY nginx.conf /usr/local/nginx/conf/nginx.conf
COPY index.html data/www/index.html

# вот до этого момента все ОК
# если собрать, запустить, войти в контейнер и сделать:
# >> cd /usr/local/nginx/sbin
# >> ./nginx
# >> curl 127.0.0.1
# возвращает мою index.html

# АВТОМАТИЗИРУЕМ так сказать:


# вариант 1
# CMD ["/usr/local/nginx/sbin/nginx"]

# вариант 2 
# RUN /usr/local/nginx/sbin/nginx

# вариант 3
# CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

# вариант 4 - кринж
RUN cd local/nginx/sbin && ./nginx 
#вывод курла 
#root@53ad2e42409d:/usr# curl 127.0.0.1
#curl: (7) Failed to connect to 127.0.0.1 port 80: Connection refused
#но если сделать по схеме на строках 36-38 этого фала, все ок выдает 



