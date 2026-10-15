#!/bin/bash

docker compose down 

docker compose down --volumes

docker compose up --build -d > logs.txt 2>&1