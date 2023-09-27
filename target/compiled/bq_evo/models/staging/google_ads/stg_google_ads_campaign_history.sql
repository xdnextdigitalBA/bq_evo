WITH _raw AS(
  SELECT *
  FROM `oss-big-query-dashboard-prod`.`google_ads`.`campaign_history`
),

_renamed_columns AS(
  SELECT
    _fivetran_start,
    id,
    _fivetran_active,
    _fivetran_end,
    _fivetran_synced,
    ad_serving_optimization_status,
    advertising_channel_subtype,
    advertising_channel_type,
    base_campaign_id,
    customer_id,
    end_date,
    experiment_type,
    final_url_suffix,
    frequency_caps,
    name as campaign,
    optimization_score,
    payment_mode,
    serving_status,
    start_date,
    status,
    tracking_url_template,
    updated_at,
    vanity_pharma_display_url_mode,
    vanity_pharma_text,
    video_brand_safety_suitability
  FROM _raw
),

_add_new_columns AS(
  SELECT 
    *,
    'google' as Source,
    'cpc' as Medium,
    (CASE
      WHEN customer_id = 6607387807 THEN 'EVO'  
      ELSE '(null)'
    END) as Partner
  FROM _renamed_columns
),

_final AS(
  SELECT
    *,
    LOWER(CONCAT(campaign, Source, Medium, Partner)) as CampaignID
  FROM _add_new_columns
)

SELECT * FROM _final