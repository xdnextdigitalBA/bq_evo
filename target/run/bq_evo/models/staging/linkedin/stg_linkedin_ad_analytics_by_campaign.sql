

  create or replace view `oss-big-query-dashboard-prod`.`staging`.`stg_linkedin_ad_analytics_by_campaign`
  OPTIONS(
      description="""Enth\u00e4lt alle Performancestatistiken der Linkedin-Kampagnen. Enth\u00e4lt keine Conversioninformationen."""
    )
  as WITH _raw AS (
    SELECT *    
    FROM `oss-big-query-dashboard-prod`.`linkedin_ads`.`ad_analytics_by_campaign`
),

_renamed_columns AS (
    SELECT
        campaign_id,
        day as Date,
        _fivetran_synced,
        action_clicks,
        ad_unit_clicks,
        approximate_unique_impressions,
        card_clicks,
        card_impressions,
        clicks as Clicks,
        comment_likes,
        comments,
        company_page_clicks,
        conversion_value_in_local_currency,
        cost_in_local_currency as Cost,
        cost_in_usd,
        external_website_conversions,
        external_website_post_click_conversions,
        external_website_post_view_conversions,
        follows,
        full_screen_plays,
        impressions as Impressions,
        landing_page_clicks,
        lead_generation_mail_contact_info_shares,
        lead_generation_mail_interested_clicks,
        likes,
        one_click_lead_form_opens,
        one_click_leads,
        opens,
        other_engagements,
        sends,
        shares,
        text_url_clicks,
        total_engagements,
        video_completions,
        video_first_quartile_completions,
        video_midpoint_completions,
        video_starts,
        video_third_quartile_completions,
        video_views,
        viral_card_clicks,
        viral_card_impressions,
        viral_clicks,
        viral_comment_likes,
        viral_comments,
        viral_company_page_clicks,
        viral_external_website_conversions,
        viral_external_website_post_click_conversions,
        viral_external_website_post_view_conversions,
        viral_follows,
        viral_full_screen_plays,
        viral_impressions,
        viral_landing_page_clicks,
        viral_likes,
        viral_one_click_lead_form_opens,
        viral_one_click_leads,
        viral_other_engagements,
        viral_shares,
        viral_total_engagements,
        viral_video_completions,
        viral_video_first_quartile_completions,
        viral_video_midpoint_completions,
        viral_video_starts,
        viral_video_third_quartile_completions,
        viral_video_views
    FROM _raw
),

_final AS(
    SELECT *
    FROM _renamed_columns
)

SELECT * FROM _final;

