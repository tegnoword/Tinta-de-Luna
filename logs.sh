#!/bin/bash

docker compose down 

docker compose up --build -d > logs.txt 2>&1