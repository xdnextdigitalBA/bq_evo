{{ config(
    tags=["historic"]
) }}

WITH _raw AS(
    SELECT *
    FROM {{ source('manual_data_upload', 'universal_analytics_historic_campaigns')}}
),

_final AS(
    SELECT *
    FROM _raw
)

SELECT * FROM _final