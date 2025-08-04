import logging
from pathlib import Path
import pandas as pd
from config.settings import DATA_CONFIG


class MunicipalDataPipeline:
    def __init__(self):
        self.raw_path = Path("data/raw/tn/municipios.csv")
        self.processed_path = Path("data/processed/dados_tratados.parquet")
        self.setup_dirs()

    def setup_dirs(self):
        Path("data/processed").mkdir(exist_ok=True)
        Path("logs").mkdir(exist_ok=True)

    def run(self):
        try:
            logging.info("Iniciando pipeline de gastos municipais")
            df = self.extract_data()
            df = self.transform_data(df)
            self.load_data(df)
            logging.info("Pipeline concluído com sucesso")
            return True

        except Exception as e:
            logging.error(f"Erro no pipeline: {str(e)}")
            return False

    def extract_data(self):
        if not self.raw_path.exists():
            raise FileNotFoundError(
                f"Arquivo não encontrado: {self.raw_path}",
            )

        return pd.read_csv(
            self.raw_path,
            encoding=DATA_CONFIG["encoding"],
            sep=DATA_CONFIG["separator"],
            decimal=DATA_CONFIG["decimal"],
        )

    def transform_data(self, df):
        for col in DATA_CONFIG["money_columns"]:
            if col in df.columns:
                df[col] = (
                    df[col]
                    .astype(str)
                    .str.replace(r"[^\d,]", "", regex=True)
                    .str.replace(",", ".")
                    .astype(float)
                )

        if "ano_exercicio" in df.columns:
            df = df[df["ano_exercicio"].between(*DATA_CONFIG["valid_years"])]

        return df

    def load_data(self, df):
        df.to_parquet(
            self.processed_path,
            engine="pyarrow",
            compression="snappy",
        )
