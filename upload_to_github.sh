#!/bin/bash

# Configuração inicial (execute apenas uma vez)
# git config --global user.name "Seu Nome"
# git config --global user.email "seu@email.com"

# Navegue até o diretório do projeto
cd ~/mpc/municipal-spending-comparator

# Verifique o status
git status

# Adicione todos os arquivos modificados
git add .

# Faça o commit com uma mensagem
git commit -m "Corrige erros flake8 e atualiza scripts"

# Faça o push para o repositório remoto
git push origin main

echo "Arquivos enviados para o GitHub com sucesso!"
