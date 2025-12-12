import pandas as pd
from datetime import datetime

def ingest_erp_export(file_path: str) -> pd.DataFrame:
    df = pd.read_csv(file_path)
    df['ingestion_date'] = datetime.now()
    df['source_system'] = 'ERP_LEGACY'
    print (f'Ingested {len(df)} from ERP')
    return df

def ingest_manual_adjustments (file_path: str) ->pd.DataFrame:
    df = pd.read_excel(file_path)
    df['ingestion_date'] = datetime.now()
    df['source_system'] = 'MANUAL'
    return df

if __name__ == '__main__':
    erp_df = ingest_erp_export("data/sample_erp_export.csv")
    adj_df = ingest_manual_adjustments("data/sample_adjustments.xlsx")
    print("Ingestion layer ready for Azure Data factory mapping")


