WITH _raw_performance AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`staging`.`stg_meta_campaign_stats`
),

_raw_unique_campaigns AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`intermediate`.`int_meta_unique_campaigns`
),

_rename_join_column AS(
    SELECT 
        * EXCEPT (Campaign),
        Campaign as CampaignJoin
    FROM _raw_unique_campaigns
),

_joined AS(
    SELECT * FROM _rename_join_column
    INNER JOIN _raw_performance
    ON _rename_join_column.CampaignJoin = _raw_performance.Campaign
),

_final AS(
    SELECT * EXCEPT (CampaignJoin)
    FROM _joined
)

SELECT * FROM _final