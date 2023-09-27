WITH _raw AS(
  SELECT *
  FROM {{ ref('int_google_analytics_all_events')}}
),

_select_purchase_events AS(
  SELECT * FROM _raw
  WHERE event_name = "purchase"
),

_final AS(
    SELECT *
    FROM _select_purchase_events
)

SELECT * FROM _final