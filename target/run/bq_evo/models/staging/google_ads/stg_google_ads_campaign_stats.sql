

  create or replace view `oss-big-query-dashboard-prod`.`staging`.`stg_google_ads_campaign_stats`
  OPTIONS(
      description="""Enth\u00e4lt alle Performancestatistiken der Google Ads Kampagnen"""
    )
  as WITH _raw AS(
    SELECT * 
    FROM `oss-big-query-dashboard-prod`.`google_ads`.`campaign_stats`

),

_transformed_cost AS(
    SELECT
        _fivetran_id,
        customer_id,
        date,
        _fivetran_synced,
        active_view_impressions,
        active_view_measurability,
        active_view_measurable_cost_micros,
        active_view_measurable_impressions,
        active_view_viewability,
        ad_network_type,
        base_campaign,
        clicks,
        conversions,
        conversions_value,
        cost_micros/1000000 as cost,
        device,
        id,
        impressions,
        interaction_event_types,
        interactions,
        view_through_conversions,
    FROM _raw
),

_final AS(
    SELECT * FROM _transformed_cost
)

SELECT * FROM _final;

