#!/bin/bash

# ==============================================
# CONFIGURAÇÃO COMPLETA DO PROJETO - ATUALIZADA
# ==============================================

echo -e "\033[1;34m=== Configurando ambiente do projeto ===\033[0m"

# -------------------------------------------------------------------
# 1. Verificar pré-requisitos e estrutura existente
# -------------------------------------------------------------------
echo -e "\033[1;33m[1/6] Verificando ambiente...\033[0m"

[ ! -d "venv" ] && python3 -m venv venv
source venv/bin/activate

# -------------------------------------------------------------------
# 2. Criar diretórios faltantes
# -------------------------------------------------------------------
echo -e "\033[1;33m[2/6] Organizando estrutura...\033[0m"

# Diretórios essenciais faltantes
mkdir -p \
    data/external \
    src/utils \
    tests/integration

# -------------------------------------------------------------------
# 3. Instalar/atualizar dependências
# -------------------------------------------------------------------
echo -e "\033[1;33m[3/6] Gerenciando dependências...\033[0m"

cat > requirements.txt << 'EOL'
# Análise de Dados
pandas>=1.3.0
numpy>=1.21.0
pyarrow>=6.0.0
openpyxl>=3.0.0

# Visualização
matplotlib>=3.4.0
seaborn>=0.11.0
plotly>=5.0.0

# Pipeline e Automação
python-dotenv>=0.19.0
tenacity>=8.0.1

# Desenvolvimento
jupyter>=1.0.0
jupyterlab>=3.0.0
pytest>=6.2.0
EOL

pip install --upgrade pip
pip install -r requirements.txt

# -------------------------------------------------------------------
# 4. Configurar arquivos do pipeline
# -------------------------------------------------------------------
echo -e "\033[1;33m[4/6] Configurando pipeline...\033[0m"

# Arquivo de configuração se não existir
[ ! -f "config/settings.py" ] && cat > config/settings.py << 'EOL'
DATA_CONFIG = {
    'encoding': 'ISO-8859-1',
    'separator': ';',
    'decimal': ',',
    'money_columns': ['valor_atualizado', 'valor_orcado'],
    'valid_years': (2010, 2023),
    'required_columns': ['codigo_ibge', 'municipio', 'uf']
}
EOL

# -------------------------------------------------------------------
# 5. Configurar Git (opcional)
# -------------------------------------------------------------------
echo -e "\033[1;33m[5/6] Configurando versionamento...\033[0m"

if [ ! -d ".git" ]; then
    git init
    [ ! -f ".gitignore" ] && cat > .gitignore << 'EOL'
# Dados
data/raw/
data/processed/
data/external/

# Ambiente
venv/
__pycache__/

# Logs
logs/*.log

# IDE
.idea/
.vscode/
*.ipynb_checkpoints/
EOL
fi

# -------------------------------------------------------------------
# 6. Finalização
# -------------------------------------------------------------------
echo -e "\033[1;32m\n=== Configuração concluída! ===\033[0m"
echo -e "\033[1;33mEstrutura do projeto:\033[0m"
tree -L 2 -I 'venv|__pycache__'

echo -e "\n\033[1;33mPróximos passos:\033[0m"
echo "1. Ativar ambiente: source venv/bin/activate"
echo "2. Executar pipeline: python run_pipeline.py"
echo "3. Explorar notebooks: jupyter lab"
