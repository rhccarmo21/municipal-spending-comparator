#!/usr/bin/env python3
"""
Script para criar notebook de análise de gastos municipais
"""

import nbformat as nbf
from pathlib import Path


def setup_project_structure():
    """Cria toda a estrutura de diretórios necessária"""
    dirs = [
        "notebooks/exploratory",
        "data/raw/tn",
        "data/processed",
        "outputs/plots",
        "src/utils",
        "preprocessing",
    ]

    for dir_path in dirs:
        Path(dir_path).mkdir(parents=True, exist_ok=True)
        print(f"Diretório criado: {dir_path}")


def create_analysis_notebook():
    """Cria o notebook de análise inicial"""
    nb = nbf.v4.new_notebook()

    # Célula 1 - Cabeçalho Markdown
    header = """# Análise Inicial de Gastos Municipais
## Comparador de Gastos Públicos Municipais

**Autor**: Roberto Cunha
**Data**: 2024-06-20"""

    # Célula 2 - Configuração Inicial
    setup_code = """# Configuração inicial
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import plotly.express as px
from pathlib import Path

%matplotlib inline
plt.style.use('ggplot')
pd.set_option('display.max_columns', 100)
pd.set_option('display.float_format', '{:,.2f}'.format)

# Constantes
DATA_DIR = Path('../data/raw/tn')
OUTPUT_DIR = Path('../outputs/plots')
os.makedirs(OUTPUT_DIR, exist_ok=True)"""

    # Célula 3 - Carregamento de Dados
    load_code = """# Carrega o arquivo baixado do Tesouro Nacional
file_path = DATA_DIR / 'municipios.csv'
try:
    df = pd.read_csv(file_path, encoding='ISO-8859-1', sep=';', decimal=',')
    print(f"Dados carregados com sucesso! Shape: {df.shape}")
    display(df.head())
except Exception as e:
    print(f"Erro ao carregar dados: {e}")
    df = pd.DataFrame()  # DataFrame vazio para evitar erros"""

    # Célula 4 - Pré-processamento
    preprocess_code = """# Pré-processamento básico
if not df.empty:
    # Limpeza de nomes de colunas
    df.columns = df.columns.str.strip().str.lower().str.replace(' ', '_')

    # Identifica e converte colunas numéricas
    numeric_cols = []
    for col in df.select_dtypes(include=['object']).columns:
        try:
            pd.to_numeric(df[col].str.replace(',', '.'), errors='raise')
            numeric_cols.append(col)
        except:
            pass

    if numeric_cols:
        df[numeric_cols] = df[numeric_cols].apply(
            lambda x: x.str.replace(',
            ',
            '.').astype(float,
        )

    print("Pré-processamento concluído!")
    display(df.head())"""

    # Adiciona todas as células
    nb["cells"] = [
        nbf.v4.new_markdown_cell(header),
        nbf.v4.new_code_cell(setup_code),
        nbf.v4.new_code_cell(load_code),
        nbf.v4.new_code_cell(preprocess_code),
    ]

    # Salva o notebook
    notebook_path = "notebooks/exploratory/01-analise-inicial.ipynb"
    with open(notebook_path, "w", encoding="utf-8") as f:
        nbf.write(nb, f, version=4)

    print(f"\nNotebook criado com sucesso em: {notebook_path}")


if __name__ == "__main__":
    print("=== Configurando estrutura do projeto ===")
    setup_project_structure()

    print("\n=== Criando notebook de análise ===")
    create_analysis_notebook()

    print("\n=== Instruções para execução ===")
    print("1. Ative o ambiente virtual:")
    print("   source venv/bin/activate")
    print("2. Execute o Jupyter Notebook:")
    print(
        "   jupyter notebook notebooks/exploratory/01-analise-inicial.ipynb",
    )
    print("3. Siga as análises no notebook interativo")
