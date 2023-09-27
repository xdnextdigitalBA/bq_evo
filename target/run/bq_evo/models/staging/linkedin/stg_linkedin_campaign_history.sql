

  create or replace view `oss-big-query-dashboard-prod`.`staging`.`stg_linkedin_campaign_history`
  OPTIONS(
      description="""Enth\u00e4lt alle Kampagneninformationen der Metakampagnen."""
    )
  as WITH _raw AS(
    SELECT *
    FROM `oss-big-query-dashboard-prod`.`linkedin_ads`.`campaign_history`
),

_renamed_columns AS(
    SELECT
        id,
        last_modified_time,
        _fivetran_synced,
        account_id,
        associated_entity,
        audience_expansion_enabled,
        campaign_group_id,
        cost_type,
        created_time,
        creative_selection,
        daily_budget_amount,
        daily_budget_currency_code,
        format,
        locale_country,
        locale_language,
        name as Campaign,
        objective_type,
        offsite_delivery_enabled,
        optimization_target_type,
        run_schedule_end,
        run_schedule_start,
        status,
        type,
        unit_cost_amount,
        unit_cost_currency_code,
        version_tag
    FROM _raw
),

_final AS(
    SELECT *
    FROM _renamed_columns
)

SELECT * FROM _final;

