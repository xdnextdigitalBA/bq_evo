WITH _raw AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`facebook_ads`.`fb_basic_performance_per_day`
),

_renamed_columns AS (
    SELECT
        _fivetran_id,
        ad_id,
        date as Date,
        _fivetran_synced,
        account_id,
        adset_name,
        campaign_name as Campaign,
        clicks as Clicks,
        cpc,
        cpm,
        ctr,
        impressions as Impressions,
        reach,
        spend as Cost
    FROM _raw
),

_final AS (
    SELECT *    
    FROM _renamed_columns
)

SELECT * FROM _final