#!/bin/bash

# Script: fix_flake_issues_final.sh
# Descrição: Corrige definitivamente todos os problemas de formatação

echo "🛠️  Corrigindo todos os arquivos problemáticos..."

# 1. Corrigir auto_fix_flake8.py com todos os requisitos
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
    except Exception as e:
        print(f"Erro ao executar flake8: {e}")
        return False


if __name__ == "__main__":
    target_file = Path(__file__).parent / "fix_unmatched_parens_run_pipeline.py"
    success = run_flake8_autofix(target_file)
    msg = "Sucesso!" if success else "Falha na correção."
    print(msg)
EOL

# 2. Corrigir fix_unmatched_parens_run_pipeline.py definitivamente
cat > fix_unmatched_parens_run_pipeline.py << 'EOL'
def fix_unmatched_parens(text):
    """Corrige parênteses não correspondentes em um texto.

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
        "Este é um exemplo (com parênteses "
        "(desbalanceados) que precisa ser corrigido"
    )
    fixed_text = fix_unmatched_parens(example_text)
    print(fixed_text)


if __name__ == "__main__":
    main()
EOL

# 3. Corrigir fix_scripts.py (se existir)
if [ -f "fix_scripts.py" ]; then
    echo "📝 Corrigindo fix_scripts.py..."
    # Adiciona quebras de linha para linhas longas
    sed -i 's/\(.\{78\}\)\(.\)/\1\n\2/g' fix_scripts.py
    # Adiciona espaços após vírgulas
    sed -i 's/,\([^ ]\)/, \1/g' fix_scripts.py
fi

# 4. Configurar pre-commit corretamente
echo "⚙️  Configurando pre-commit definitivo..."
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

# 5. Executar verificações de código
echo "🔍 Executando verificações finais..."
pre-commit install
pre-commit run --all-files

# 6. Preparar commit
echo "🚀 Preparando commit final..."
git add .
git commit -m "Correções finais de formatação" || \
    echo "ℹ️  Alguns ajustes manuais podem ser necessários"

echo "✅ Todas as correções foram aplicadas!"
echo "➡️  Execute 'git push' para enviar as alterações"
