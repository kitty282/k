FROM alpine:latest

# Установка зависимостей и скачивание 3proxy
RUN apk add --no-cache curl \
    && curl -L https://github.com/3proxy/3proxy/releases/download/0.9.4/3proxy-0.9.4.x86_64.tar.gz -o 3proxy.tar.gz \
    && tar -xzf 3proxy.tar.gz \
    && mv 3proxy /usr/local/bin/3proxy \
    && chmod +x /usr/local/bin/3proxy \
    && rm 3proxy.tar.gz

# Копирование конфигурации
COPY 3proxy.cfg /etc/3proxy/3proxy.cfg

# Открытие портов
EXPOSE 3128 1080

# Запуск 3proxy
CMD ["/usr/local/bin/3proxy", "/etc/3proxy/3proxy.cfg"]
