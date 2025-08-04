import pandas as pd
import os

DATA_RAW_DIR = "../data/raw/"
DATA_CLEANED_DIR = "cleaned/"


def carregar_dados():
    arquivos = [f for f in os.listdir(DATA_RAW_DIR) if f.endswith(".csv")]
    if not arquivos:
        raise FileNotFoundError(
            f"Nenhum arquivo CSV encontrado em {DATA_RAW_DIR}",
        )
    caminho_arquivo = os.path.join(DATA_RAW_DIR, arquivos[0])
    print(f"Carregando arquivo: {caminho_arquivo}")
    df = pd.read_csv(caminho_arquivo)
    return df


def limpar_dados(df):
    df_limpo = df.dropna()
    return df_limpo


def salvar_dados(df):
    os.makedirs(DATA_CLEANED_DIR, exist_ok=True)
    caminho_salvar = os.path.join(DATA_CLEANED_DIR, "dados_limpos.csv")
    df.to_csv(caminho_salvar, index=False)
    print(f"Dados limpos salvos em {caminho_salvar}")


if __name__ == "__main__":
    df = carregar_dados()
    df_limpo = limpar_dados(df)
    salvar_dados(df_limpo)
