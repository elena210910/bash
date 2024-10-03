#!/bin/bash

# Генерация файла с логами
cat <<EOL > access.log
192.168.1.1 - - [28/Jul/2024:12:34:56 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.2 - - [28/Jul/2024:12:35:56 +0000] "POST /login HTTP/1.1" 200 567
192.168.1.3 - - [28/Jul/2024:12:36:56 +0000] "GET /home HTTP/1.1" 404 890
192.168.1.1 - - [28/Jul/2024:12:37:56 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.4 - - [28/Jul/2024:12:38:56 +0000] "GET /about HTTP/1.1" 200 432
192.168.1.2 - - [28/Jul/2024:12:39:56 +0000] "GET /index.html HTTP/1.1" 200 1234
EOL

# Подсчёт общего количества запросов (количество строк в файле)
total_requests=$(wc -l < access.log)

# Подсчёт уникальных IP-адресов с использованием awk
unique_ips=$(awk '{print $1}' access.log | sort | uniq | wc -l)

# Подсчёт количества запросов по методам (GET, POST и т.д.)
get_requests=$(awk '$6 ~ /GET/ {count++} END {print count}' access.log)
post_requests=$(awk '$6 ~ /POST/ {count++} END {print count}' access.log)

# Нахождение самого популярного URL с использованием awk
most_popular_url=$(awk '{print $7}' access.log | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')

# Создание отчета в виде текстового файла
{
  echo "Отчет по логам:"
  echo "Общее количество запросов: $total_requests"
  echo "Количество уникальных IP-адресов: $unique_ips"
  echo "Количество GET-запросов: ${get_requests:-0}"
  echo "Количество POST-запросов: ${post_requests:-0}"
  echo "Самый популярный URL: $most_popular_url"
} > report.txt

# Вывод результатов на экран
cat report.txt


