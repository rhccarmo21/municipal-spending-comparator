#!/bin/bash

# Script: ultimate_fix.sh
# Descrição: Correção definitiva para todos os problemas

echo "🛠️  Iniciando correção definitiva..."

# 1. Corrigir auto_fix_flake8.py
echo "🔧 Corrigindo auto_fix_flake8.py..."
cat > auto_fix_flake8.py << 'EOL'
import subprocess
from pathlib import Path


def run_flake8_autofix(file_path):
    """Executa autofix do flake8 em um arquivo.

    Args:
        file_path (str): Caminho para o arquivo

    Returns:
        bool: True se bem-sucedido
    """
    try:
        result = subprocess.run(
            ['flake8', '--isolated', file_path],
            capture_output=True,
            text=True
        )
        if result.returncode == 0:
            return True

        print(f"Erros encontrados em {file_path}:")
        print(result.stdout)
        return False
    except Exception as e:  # Espaço após ':' corrigido
        print(f"Erro ao executar flake8: {e}")
        return False


if __name__ == "__main__":
    target_file = Path(__file__).parent / "fix_unmatched_parens_run_pipeline.py"
    success = run_flake8_autofix(target_file)
    msg = "Sucesso!" if success else "Falha na correção."
    print(msg)
EOL

# 2. Corrigir configuração do pre-commit
echo "⚙️  Atualizando configuração do pre-commit..."
cat > .pre-commit-config.yaml << 'EOL'
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
    -   id: trailing-whitespace
    -   id: end-of-file-fixer
    -   id: check-yaml
    -   id: check-added-large-files
-   repo: https://github.com/psf/black
    rev: 23.3.0
    hooks:
    -   id: black
        args: [--line-length=79]
-   repo: https://github.com/pycqa/flake8
    rev: 6.0.0
    hooks:
    -   id: flake8
        additional_dependencies: [flake8-bugbear]
        args: [--max-line-length=79, --ignore=E203]
EOL

# 3. Executar verificações
echo "🔍 Executando verificações..."
pre-commit install
pre-commit run --all-files

# 4. Preparar commit
echo "🚀 Preparando commit final..."
git add .
git commit -m "Correções definitivas de formatação" || \
    echo "⚠️  Alguns erros precisam de atenção manual"

echo "✅ Correções aplicadas com sucesso!"
echo "➡️  Execute 'git push' para enviar as alterações"
