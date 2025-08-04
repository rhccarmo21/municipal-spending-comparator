import logging
from pipelines.data_pipeline import MunicipalDataPipeline

logging.basicConfig(
    level=logging.INFO,
    format=("%(asctime)s - %(levelname)s - " "%(message)s"),
    handlers=[
        logging.FileHandler("logs/pipeline.log"),
        logging.StreamHandler(),
    ],
)

if __name__ == "__main__":
    pipeline = MunicipalDataPipeline()
    if pipeline.run():
        print("✅ Pipeline executado com sucesso!")
    else:
        print("❌ Ocorreu um erro - verifique logs/pipeline.log")
        exit(1)
