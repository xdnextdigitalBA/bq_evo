WITH _raw AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`staging`.`stg_google_analytics_352128287`
),

_added_partner AS(
    SELECT 
        *,
        'EVO' as Partner
    FROM _raw
),

_rename_columns AS(
    SELECT
        * EXCEPT(utm_campaign, utm_source, utm_medium),
        utm_campaign as Campaign,
        utm_source as Source,
        utm_medium as Medium,
        LOWER (CONCAT(utm_campaign, utm_source, utm_medium, Partner)) as CampaignID
    FROM _added_partner
),

_add_default_channel_groupings AS(
    SELECT *,
        case
            when (Source = 'direct' or Source is null or Source = '(direct)') 
                and (regexp_contains(Medium, r'^(\(not set\)|\(none\))$') or Medium is null) 
                then 'direct'
            when regexp_contains(Campaign, r'^(.*pmax.*|.*cross-network.*)$') 
                then 'cross-network'
            when regexp_contains(Campaign, r'^(.*shop.*)$') 
                and regexp_contains(Medium, r'^(.*cp.*|ppc|paid.*)$') 
                then 'shopping_paid'
            when regexp_contains(Source, r'^(google|bing)$') 
                and regexp_contains(Medium, r'^(.*cp.*|ppc|paid.*)$') 
                then 'search_paid'
            when regexp_contains(Source, r'^(twitter|facebook|fb|instagram|ig|linkedin|pinterest)$')
                and regexp_contains(Medium, r'^(.*cp.*|ppc|paid.*|social_paid)$') 
                then 'social_paid'
            when regexp_contains(Source, r'^(youtube)$')
                and regexp_contains(Medium, r'^(.*cp.*|ppc|paid.*)$') 
                then 'video_paid'
            when regexp_contains(Medium, r'^(display|banner|expandable|interstitial|cpm)$') 
                then 'display'
            when regexp_contains(Medium, r'^(.*cp.*|ppc|paid.*)$') 
                then 'other_paid'
            when regexp_contains(Medium, r'^(.*shop.*)$') 
                then 'shopping_organic'
            when regexp_contains(Source, r'^.*(twitter|t\.co|facebook|instagram|linkedin|lnkd\.in|pinterest).*') 
                and regexp_contains(Medium, r'^(.*cp.*|ppc|paid.*)$') 
                then 'social_paid'
            when regexp_contains(Source, r'^.*(twitter|t\.co|facebook|instagram|linkedin|lnkd\.in|pinterest).*') 
                or regexp_contains(Medium, r'^(social|social_advertising|social-advertising|social_network|social-network|social_media|social-media|sm|social-unpaid|social_unpaid)$') 
                then 'social_organic'
            when regexp_contains(Medium, r'^(.*video.*)$') 
                then 'video_organic'
            when regexp_contains(Source, r'^(google|bing|yahoo|baidu|duckduckgo|yandex|ask)$') 
                or Medium = 'organic'
                then 'search_organic'
            when regexp_contains(Source, r'^(email|mail|e-mail|e_mail|e mail|mail\.google\.com)$') 
                or regexp_contains(Medium, r'^(email|mail|e-mail|e_mail|e mail)$') 
                then 'email'
            when regexp_contains(Medium, r'^(affiliate|affiliates)$') 
                then 'affiliate'
            when Medium = 'referral'
                then 'referral'
            when Medium = 'audio' 
                then 'audio'
            when Medium = 'sms'
                then 'sms'
            when ends_with(Medium, 'push')
                or regexp_contains(Medium, r'.*(mobile|notification).*') 
                then 'mobile_push'
            else '(other)'
        end AS default_channel_grouping
    FROM _rename_columns
),

_final AS(
    SELECT *
    FROM _add_default_channel_groupings
)

SELECT * FROM _final