#!/bin/bash
echo "Iniciando app na porta 5000..."
./venv/bin/gunicorn --bind 0.0.0.0:5000 --timeout 240 app:app &

echo "Aguardando processos em segundo plano..."
wait