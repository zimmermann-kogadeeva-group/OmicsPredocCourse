
get_ora <- function(
    genes, 
    organism=208964, 
    annotDataSet="GO:0008150",  # Biological process
    enrichmentTestType="FISHER", 
    correction="FDR"
) {
    # Define query parameters
    url <- "https://pantherdb.org/services/oai/pantherdb/enrich/overrep"
    headers <- httr::add_headers(accept = "application/json")
    query_params <- list(
        "geneInputList" = genes,
        "organism" = organism,
        "annotDataSet" = annotDataSet,
        "enrichmentTestType" = enrichmentTestType,
        "correction" = correction
    )
    
    # Send a POST request to GO API
    response <- httr::POST(url, query = query_params, headers = headers)
    
    # Check the response status code and content
    df_res <- data.frame()
    if (httr::status_code(response) == 200 && "results" %in% names(httr::content(response))) {
        data <- jsonlite::fromJSON(rawToChar(response$content))
        df_res <- dplyr::bind_cols(data$results$result[, -7], data$results$result[, 7])
        
    } else {
        cat("Error:", status_code(response), "\n")
        cat(content(response, as = "text"))
    }
    
    if (length(colnames(df_res)) == 0) {
        df_res <- data.frame(
            number_in_list=integer(),
            fold_enrichment=double(),
            fdr=double(),
            expected=integer(),
            number_in_reference=integer(),
            pValue=double(),
            plus_minus=character(),
            id=character(),
            label=character()
        )
    }
    Sys.sleep(2)
    return(df_res)
}

cache_dir <- cachem::cache_disk(".go_terms_cache_r")

get_ora <- memoise::memoise(get_ora, cache=cache_dir)

