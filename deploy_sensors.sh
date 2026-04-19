#!/bin/bash

# Скрипт быстрой развертки мониторинга для диагностики GPU/System Freeze
# Автор: [Твое Имя/Ник]

echo "--- Start Monitoring Deployment ---"

# 1. Запуск Node Exporter (Системные метрики)
echo "[1/2] Starting Node Exporter..."
docker run -d \
  --name=node-exporter \
  --net="host" \
  --pid="host" \
  -v "/:/host:ro,rslave" \
  --restart unless-stopped \
  quay.io/prometheus/node-exporter:latest \
  --path.rootfs=/host

# 2. Запуск NVIDIA DCGM Exporter (Метрики видеокарты)
echo "[2/2] Starting NVIDIA Exporter..."
docker run -d \
  --name=nvidia-exporter \
  -p 9400:9400 \
  --gpus all \
  --restart unless-stopped \
  nvcr.io/nvidia/k8s/dcgm-exporter:3.3.5-3.4.0-ubuntu22.04

echo "--- Deployment Complete ---"
echo "Check System Metrics: http://$(hostname -I | awk '{print $1}'):9100/metrics"
echo "Check GPU Metrics:    http://$(hostname -I | awk '{print $1}'):9400/metrics"
