

  create or replace view `oss-big-query-dashboard-prod`.`staging`.`stg_bing_ads_campaign_performance_daily_report`
  OPTIONS(
      description=""""""
    )
  as WITH _raw AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`bingads`.`campaign_performance_daily_report`
),

_renamed_columns AS(
    SELECT 
        _fivetran_id,
        _fivetran_synced,
        account_id,
        ad_distribution,
        ad_relevance,
        all_conversions,
        all_conversions_qualified,
        all_return_on_ad_spend,
        all_revenue,
        assists,
        average_cpc,
        average_position,
        bid_match_type,
        budget_association_status,
        campaign_id,
        campaign_name,
        campaign_status,
        clicks as Clicks,
        conversions,
        conversions_qualified,
        ctr,
        currency_code,
        date as Date,
        delivered_match_type,
        device_os,
        device_type,
        expected_ctr,
        historical_ad_relevance,
        historical_expected_ctr,
        historical_landing_page_experience,
        historical_quality_score,
        impressions as Impressions,
        landing_page_experience,
        low_quality_clicks,
        low_quality_clicks_percent,
        low_quality_conversion_rate,
        low_quality_conversions,
        low_quality_conversions_qualified,
        low_quality_general_clicks,
        low_quality_impressions,
        low_quality_impressions_percent,
        low_quality_sophisticated_clicks,
        network,
        phone_calls,
        phone_impressions,
        quality_score,
        return_on_ad_spend,
        revenue,
        spend as Cost,
        top_vs_other,
        view_through_conversions
    FROM _raw
),

_final AS(
    SELECT *
    FROM _renamed_columns
)

SELECT * FROM _final;

