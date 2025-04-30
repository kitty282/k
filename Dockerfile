FROM alpine:latest

# Установка зависимостей для сборки
RUN apk add --no-cache build-base curl

# Скачивание и сборка 3proxy из исходников
RUN curl -L https://github.com/3proxy/3proxy/archive/refs/tags/0.9.5.tar.gz -o 3proxy.tar.gz \
    && tar -xzf 3proxy.tar.gz \
    && cd 3proxy-0.9.5 \
    && make -f Makefile.Linux \
    && cp bin/3proxy /usr/local/bin/3proxy \
    && chmod +x /usr/local/bin/3proxy \
    && cd .. \
    && rm -rf 3proxy-0.9.5 3proxy.tar.gz

# Копирование конфигурации
COPY 3proxy.cfg /etc/3proxy/3proxy.cfg

# Открытие портов
EXPOSE 3128 1080

# Запуск 3proxy
CMD ["/usr/local/bin/3proxy", "/etc/3proxy/3proxy.cfg"]
