#!/bin/bash

echo "🛑 Deteniendo y limpiando contenedores y volúmenes anteriores..."
docker compose down --volumes

echo "🚀 Construyendo y levantando los contenedores..."
docker compose up --build -d

docker compose logs -f backend > logs.txt 2>&1 &