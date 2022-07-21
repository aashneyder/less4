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

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]




