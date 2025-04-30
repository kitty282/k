FROM alpine:latest

# Установка зависимостей для сборки и nginx
RUN apk add --no-cache build-base curl nginx

# Скачивание и сборка 3proxy из исходников
RUN curl -L https://github.com/3proxy/3proxy/archive/refs/tags/0.9.5.tar.gz -o 3proxy.tar.gz \
    && tar -xzf 3proxy.tar.gz \
    && cd 3proxy-0.9.5 \
    && make -f Makefile.Linux \
    && cp bin/3proxy /usr/local/bin/3proxy \
    && chmod +x /usr/local/bin/3proxy \
    && cd .. \
    && rm -rf 3proxy-0.9.5 3proxy.tar.gz

# Создание директорий для Nginx
RUN mkdir -p /usr/share/nginx/html \
    && mkdir -p /var/log/nginx \
    && mkdir -p /run/nginx \
    && echo "OK" > /usr/share/nginx/html/health

# Конфигурация Nginx для ответа на Health Check
RUN echo "server { listen 8080; location /health { root /usr/share/nginx/html; } }" > /etc/nginx/http.d/default.conf

# Копирование конфигурации 3proxy
COPY 3proxy.cfg /etc/3proxy/3proxy.cfg

# Открытие портов
EXPOSE 3128 1080 8080

# Отладка: запуск с выводом логов
CMD echo "Starting 3proxy..." && \
    /usr/local/bin/3proxy /etc/3proxy/3proxy.cfg & \
    echo "Starting nginx..." && \
    nginx -g 'daemon off;'
