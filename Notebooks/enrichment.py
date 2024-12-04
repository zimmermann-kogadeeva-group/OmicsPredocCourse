import pandas as pd
import requests
from diskcache import Cache
from time import sleep


def correct_term_col(value):
    if type(value) is dict:
        if "id" in value:
            return f"{value['label']} ({value['id']})"
        else:
            return value["label"]
    else:
        return value


def get_ora(
    genes,
    organism=208964,
    annotDataSet="GO:0008150",
    enrichmentTestType="FISHER",
    correction="FDR",
    cache_path=".go_terms_cache_py",
):
    if not isinstance(genes, str):
        genes = ",".join(genes)

    cache = Cache(cache_path)
    key = genes + str(organism) + annotDataSet + enrichmentTestType + correction
    if cache.get(key) is not None:
        return cache.get(key)

    # The default value for annotDataSet parameter means biological process GO terms
    query_params = {
        "geneInputList": genes,
        "organism": organism,
        "annotDataSet": annotDataSet,
        "enrichmentTestType": enrichmentTestType,
        "correction": correction,
    }

    # Send a GET request to GO API
    response = requests.post(
        "https://pantherdb.org/services/oai/pantherdb/enrich/overrep",
        headers={"accept": "application/json"},
        data=query_params,
    )

    df_res = pd.DataFrame()
    if response and "results" in response.json():
        # Convert to a dataframe, then correct term column and append
        # additional columns
        df_res = pd.DataFrame(response.json()["results"]["result"]).assign(
            term=lambda x: x.term.apply(correct_term_col)
        )

        cache.set(key, df_res)

        sleep(2)

    return df_res
