WITH _source AS(
  SELECT
    PARSE_DATE('%Y%m%d', event_date) as event_date,
    TIMESTAMP_MICROS(event_timestamp) as event_ts,
    
    MAX(CASE WHEN params.key = 'ga_session_id' THEN value.int_value ELSE NULL END) OVER (PARTITION BY event_timestamp, user_pseudo_id) as session_id,
    user_pseudo_id,
    TIMESTAMP_MICROS(user_first_touch_timestamp) as user_first_touch_ts,

    event_name,

    params.key as params_key,
    params.value.string_value as params_string_value,
    params.value.int_value as params_int_value,
    params.value.float_value as params_float_value,
    params.value.double_value as params_double_value,

    (CASE WHEN traffic_source.name IS NULL THEN '(not set)' ELSE traffic_source.name END) as utm_campaign,
    (CASE WHEN traffic_source.medium IS NULL THEN '(not set)' ELSE traffic_source.medium END) as utm_medium,
    (CASE WHEN traffic_source.source IS NULL THEN '(not set)' ELSE traffic_source.source END) as utm_source,
    'EVO' as Partner,

    MAX(CASE WHEN params.key = 'page_title' THEN value.string_value ELSE NULL END) OVER (PARTITION BY event_timestamp, user_pseudo_id) as page_title,
    MAX(CASE WHEN params.key = 'page_location' THEN value.string_value ELSE NULL END) OVER (PARTITION BY event_timestamp, user_pseudo_id) as page_location,
    MAX(CASE WHEN params.key = 'page_referrer' THEN value.string_value ELSE NULL END) OVER (PARTITION BY event_timestamp, user_pseudo_id) as page_referrer,
    MAX(CASE WHEN params.key = 'page_path' THEN value.string_value ELSE NULL END) OVER (PARTITION BY event_timestamp, user_pseudo_id) as page_path,
    MAX(CASE WHEN params.key = 'percent_scrolled' THEN value.int_value ELSE NULL END) OVER (PARTITION BY event_timestamp, user_pseudo_id) as percent_scrolled,
    MAX(CASE WHEN params.key = 'session_engaged' THEN value.string_value ELSE NULL END) OVER (PARTITION BY event_timestamp, user_pseudo_id) as session_engaged,

    privacy_info.analytics_storage as analytics_storage,
    privacy_info.ads_storage as ads_storage,
    privacy_info.uses_transient_token as uses_transient_token,

    user_ltv.revenue as ltv_revenue,
    user_ltv.currency as ltv_currency,

    device.category as device_category,
    device.mobile_brand_name as device_brand,
    device.mobile_model_name as device_model_name,
    device.mobile_marketing_name as device_marketing_name,
    device.mobile_os_hardware_model as device_mobile_os_hardware_model,
    device.operating_system as device_os,
    device.operating_system_version as device_os_version,
    device.vendor_id as device_vendor_id,
    device.advertising_id as device_advertising_id,
    device.language as device_language,
    device.is_limited_ad_tracking as device_is_limited_ad_tracking,
    device.time_zone_offset_seconds as device_time_zone_offset_seconds,
    device.browser as device_browser,
    device.browser_version as device_browser_version,
    device.web_info.browser as device_web_info_browser,
    device.web_info.browser_version as device_web_info_browser_version,
    device.web_info.hostname as browser_web_info_hostname,

    geo.continent as continent,
    geo.country as country,
    geo.region as region,
    geo.city as city,
    geo.sub_continent as sub_continent,
    geo.metro as metropolitan_area,

    app_info.id as app_id,
    app_info.version as app_version,
    app_info.install_store as app_install_store,
    app_info.firebase_app_id as app_firebase_app_id,
    app_info.install_source as app_install_source,

    event_dimensions.hostname as event_hostname,

    ecommerce.total_item_quantity as total_item_quantity,
    ecommerce.purchase_revenue_in_usd as purchase_revenue_in_usd,
    ecommerce.purchase_revenue as purchase_revenue,
    ecommerce.refund_value_in_usd as refund_value_in_usd,
    ecommerce.refund_value as refund_value,
    ecommerce.shipping_value_in_usd as shipping_value_in_usd,
    ecommerce.shipping_value as shipping_value,
    ecommerce.tax_value_in_usd as tax_value_in_usd,
    ecommerce.tax_value as tax_value,
    ecommerce.unique_items as unique_items,
    ecommerce.transaction_id as transaction_id,
    
    items.item_id as item_id,
    items.item_name as item_name,
    items.item_brand as item_brand,
    items.item_variant as item_variant,
    items.item_category as item_category,
    items.item_category2 as item_category2,
    items.item_category3 as item_category3,
    items.item_category4 as item_category4,
    items.item_category5 as item_category5,
    items.price_in_usd as price_in_usd,
    items.price as price,
    items.quantity as quantity,
    items.item_revenue_in_usd as item_revenue_in_usd,
    items.item_revenue as item_revenue,
    items.item_refund_in_usd as item_refund_in_usd,
    items.item_refund as item_refund,
    items.coupon as coupon,
    items.affiliation as affiliation,
    items.location_id as location_id,
    items.item_list_id as item_list_id,
    items.item_list_name as item_list_name,
    items.item_list_index as item_list_index,
    items.promotion_id as promotion_id,
    items.promotion_name as promotion_name,
    items.creative_name as creative_name,
    items.creative_slot as creative_slot,

    collected_traffic_source.manual_campaign_id as manual_campaign_id,
    collected_traffic_source.manual_campaign_name as manual_campaign_name,
    collected_traffic_source.manual_source as manual_source,
    collected_traffic_source.manual_medium as manual_medium,
    collected_traffic_source.manual_term as manual_term,
    collected_traffic_source.manual_content as manual_content,
    collected_traffic_source.gclid as gclid,
    collected_traffic_source.dclid as dclid,
    collected_traffic_source.srsltid as srsltid

  FROM {{ source('analytics_352128287', 'events')}} as events
  LEFT JOIN UNNEST (event_params) as params
  /*LEFT JOIN UNNEST (privacy_info) as privacy_info
  LEFT JOIN UNNEST (user_ltv) as user_ltv*/
  LEFT JOIN UNNEST(items) as items 
),

events_aggregated as (
  SELECT
    event_date,
    event_ts,
    session_id,
    user_pseudo_id,
    user_first_touch_ts,
    event_name,

--Kampagneninformationen
    MAX(utm_campaign) as utm_campaign,
    MAX(utm_medium) as utm_medium,
    (CASE WHEN MAX(utm_source) = 'ig' THEN 'instagram' ELSE MAX(utm_source) END) as utm_source,
  --  (CASE WHEN MAX(utm_campaign) IS NULL THEN '(not set)' ELSE MAX(utm_campaign) END) as utm_campaign,
  --  (CASE WHEN MAX(utm_medium) IS NULL THEN '(not set)' ELSE MAX(utm_medium) END) as utm_medium,
  --  (CASE WHEN MAX(utm_source) IS NULL THEN '(not set)' ELSE MAX(utm_source) END) as utm_source,

--Seiteninformationen
    MAX(page_title) as page_title,
    MAX(page_location) as page_location,
    MAX(page_referrer) as page_referrer,
    MAX(page_path) as page_path,
    MAX(percent_scrolled) as percent_scrolled,
    MAX(session_engaged) as session_engaged,

--Privacy-Infos
    MAX(analytics_storage) as analytics_storage,
    MAX(ads_storage) as ads_storage,
    MAX(uses_transient_token) as uses_transient_token,

--Kundenwertinformationen
    MAX(ltv_revenue) as ltv_revenue,
    MAX(ltv_currency) as ltv_currency,

--Geräteinformationen
    MAX(device_category) as device_category,
    MAX(device_brand) as device_brand,
    MAX(device_model_name) as device_model_name,
    MAX(device_marketing_name) as device_marketing_name,
    MAX(device_mobile_os_hardware_model) as device_mobile_os_hardware_model,
    MAX(device_os) as device_os,
    MAX(device_os_version) as device_os_version,
    MAX(device_vendor_id) as device_vendor_id,
    MAX(device_advertising_id) as device_advertising_id,
    MAX(device_language) as device_language,
    MAX(device_is_limited_ad_tracking) as device_is_limited_ad_tracking,
    MAX(device_time_zone_offset_seconds) as device_time_zone_offset_seconds,
    MAX(device_browser) as device_browser,
    MAX(device_browser_version) as device_browser_version,
    MAX(device_web_info_browser) as device_web_info_browser,
    MAX(device_web_info_browser_version) as device_web_info_browser_version,
    MAX(browser_web_info_hostname) as browser_web_info_hostname,

--Gebietsinformationen
    MAX(continent) as continent,
    MAX(country) as country,
    MAX(region) as region,
    MAX(city) as city,
    MAX(sub_continent) as sub_continent,
    MAX(metropolitan_area) as metropolitan_area,

--App-Informationen
    MAX(app_id) as app_id,
    MAX(app_version) as app_version,
    MAX(app_install_store) as app_install_store,
    MAX(app_firebase_app_id) as app_firebase_app_id,
    MAX(app_install_source) as app_install_source,

    MAX(event_hostname) as event_hostname,

--E-Commerceinformationen
    MAX(total_item_quantity) as total_item_quantity,
    MAX(purchase_revenue_in_usd) as purchase_revenue_in_usd,
    MAX(purchase_revenue) as purchase_revenue,
    MAX(refund_value_in_usd) as refund_value_in_usd,
    MAX(refund_value) as refund_value,
    MAX(shipping_value_in_usd) as shipping_value_in_usd,
    MAX(shipping_value) as shipping_value,
    MAX(tax_value_in_usd) as tax_value_in_usd,
    MAX(tax_value) as tax_value,
    MAX(unique_items) as unique_items,
    MAX(transaction_id) as transaction_id,

--Warenkorbinformationen
    MAX(item_id) as item_id,
    MAX(item_name) as item_name,
    MAX(item_brand) as item_brand,
    MAX(item_variant) as item_variant,
    MAX(item_category) as item_category,
    MAX(item_category2) as item_category2,
    MAX(item_category3) as item_category3,
    MAX(item_category4) as item_category4,
    MAX(item_category5) as item_category5,
    MAX(price_in_usd) as price_in_usd,
    MAX(price) as price,
    MAX(quantity) as quantity,
    MAX(item_revenue_in_usd) as item_revenue_in_usd,
    MAX(item_revenue) as item_revenue,
    MAX(item_refund_in_usd) as item_refund_in_usd,
    MAX(item_refund) as item_refund,
    MAX(coupon) as coupon,
    MAX(affiliation) as affiliation,
    MAX(location_id) as location_id,
    MAX(item_list_id) as item_list_id,
    MAX(item_list_name) as item_list_name,
    MAX(item_list_index) as item_list_index,
    MAX(promotion_id) as promotion_id,
    MAX(promotion_name) as promotion_name,
    MAX(creative_name) as creative_name,
    MAX(creative_slot) as creative_slot,

--Manuelle Trackingparameter
    MAX(manual_campaign_id) as manual_campaign_id,
    MAX(manual_campaign_name) as manual_campaign_name,
    MAX(manual_source) as manual_source,
    MAX(manual_medium) as manual_medium,
    MAX(manual_term) as manual_term,
    MAX(manual_content) as manual_content,
    MAX(gclid) as gclid,
    MAX(dclid) as dclid,
    MAX(srsltid) as srsltid

  FROM _source
  WHERE session_id <> 0
  GROUP BY 1,2,3,4,5,6
)

SELECT *
  --DISTINCT event_date
FROM events_aggregated