FROM alpine:latest

# 1) Устанавливаем зависимости для сборки 3proxy и nginx
RUN apk add --no-cache build-base curl nginx

# 2) Скачиваем и собираем 3proxy версии 0.9.5
RUN curl -L https://github.com/3proxy/3proxy/archive/refs/tags/0.9.5.tar.gz -o 3proxy.tar.gz \
 && tar xzf 3proxy.tar.gz \
 && cd 3proxy-0.9.5 \
 && make -f Makefile.Linux \
 && cp bin/3proxy /usr/local/bin/3proxy \
 && chmod +x /usr/local/bin/3proxy \
 && cd .. \
 && rm -rf 3proxy-0.9.5 3proxy.tar.gz

# 3) Создаём нужные директории
RUN mkdir -p /etc/3proxy \
         /usr/share/nginx/html \
         /var/log/nginx \
         /run/nginx

# 4) Настраиваем простую страницу для health-check
RUN echo "OK" > /usr/share/nginx/html/health \
 && printf "server {\n  listen 8080;\n  location /health { root /usr/share/nginx/html; }\n}" \
      > /etc/nginx/http.d/default.conf

# 5) Копируем конфиг 3proxy внутрь контейнера
COPY 3proxy.cfg /etc/3proxy/3proxy.cfg

# 6) Копируем и делаем исполняемым скрипт запуска
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 7) Открываем порты
EXPOSE 3128 1080 8080

# 8) Определяем entrypoint
ENTRYPOINT ["/entrypoint.sh"]
