WITH _raw_performance AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`staging`.`stg_bing_ads_campaign_performance_daily_report`
),

_raw_unique_campaigns AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_bing_ads_unique_campaigns`
),

_joined AS(
    SELECT * FROM _raw_unique_campaigns
    INNER JOIN _raw_performance
    ON _raw_unique_campaigns.id = _raw_performance.campaign_id
),

_final AS(
    SELECT *
    FROM _joined
)

SELECT * FROM _final