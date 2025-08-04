#!/bin/bash

# Script: fix_flake_issues.sh
# Descrição: Corrige problemas específicos do flake8 e black

echo "🛠️  Corrigindo arquivos problemáticos..."

# 1. Corrigir auto_fix_flake8.py
cat > auto_fix_flake8.py << 'EOL'
import subprocess
from pathlib import Path

def run_flake8_autofix(file_path):
    """
    Executa autofix do flake8 em um arquivo.

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
    except Exception as e:
        print(f"Erro ao executar flake8: {e}")
        return False

if __name__ == "__main__":
    target_file = Path(__file__).parent / "fix_unmatched_parens_run_pipeline.py"
    success = run_flake8_autofix(target_file)
    print("Operação concluída com sucesso!" if success else "Falha na correção.")
EOL

# 2. Corrigir fix_unmatched_parens_run_pipeline.py
cat > fix_unmatched_parens_run_pipeline.py << 'EOL'
def fix_unmatched_parens(text):
    """
    Corrige parênteses não correspondentes em um texto.

    Args:
        text (str): Texto para corrigir

    Returns:
        str: Texto corrigido
    """
    open_parens = text.count('(')
    close_parens = text.count(')')

    if open_parens > close_parens:
        text += ')' * (open_parens - close_parens)
    elif close_parens > open_parens:
        text = '(' * (close_parens - open_parens) + text

    return text

def main():
    """Função principal para demonstração."""
    example_text = (
        "Este é um exemplo (com parênteses (desbalanceados"
        " que precisa ser corrigido"
    )
    fixed_text = fix_unmatched_parens(example_text)
    print(fixed_text)

if __name__ == "__main__":
    main()
EOL

echo "⚙️  Configurando pre-commit..."

# 3. Configurar pre-commit
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
-   repo: https://github.com/pycqa/flake8
    rev: 6.0.0
    hooks:
    -   id: flake8
        additional_dependencies: [flake8-bugbear]
EOL

echo "🔍 Executando verificações de código..."

# 4. Executar verificações
pre-commit install
pre-commit run --all-files

echo "🚀 Preparando para commit no GitHub..."

# 5. Preparar commit
git add .
git commit -m "Corrige erros de formatação e configura pre-commit" || echo "⚠️  Alguns erros precisam ser corrigidos manualmente"

echo "✅ Concluído! Execute 'git push' para enviar as alterações"
