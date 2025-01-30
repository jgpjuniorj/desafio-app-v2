#!/bin/bash
echo "Iniciando redirect na porta 5001..."
./venv/bin/gunicorn --bind 0.0.0.0:5001 --timeout 240 redirect:app &

echo "Aguardando processos em segundo plano..."
wait