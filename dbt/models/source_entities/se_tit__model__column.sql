{{ config(materialized='table') }}

with team_model as (
    select *
    from {{ ref('tit_team_model') }}
),

unpivoted as (
  select model_id, column_id
  from (
      unpivot team_model
      on
          "hatch_year",
          "hatch_nest_breed_ID",
          "hatch_Area",
          "hatch_Box",
          "hatch_mom_Ring",
          "hatch_nest_dad_Ring",
          "Extra-pair_paternity",
          "Extra-pair_dad_ring",
          "genetic_dad_ring_(WP_or_EP)",
          "hatch_nest_LD",
          "hatch_nest_CS",
          "hatch_nest_OH",
          "d0_hatch_nest_brood_size",
          "d14_hatch_nest_brood_size",
          "rear_nest_breed_ID",
          "rear_area",
          "rear_Box",
          "rear_mom_Ring",
          "rear_dad_Ring",
          "rear_nest_trt",
          "home_or_away",
          "rear_nest_LD",
          "rear_nest_CS",
          "rear_nest_OH",
          "rear_d0_rear_nest_brood_size",
          "rear_Cs_out",
          "rear_Cs_in",
          "net_rearing_manipulation",
          "rear_Cs_at_start_of_rearing",
          "d14_rear_nest_brood_size",
          "number_chicks_fledged_from_rear_nest",
          "Date_of_day14",
          "day_14_tarsus_length",
          "day_14_weight",
          "day14_measurer",
          "chick_sex_molec",
          "chick_survival_to_first_breed_season",
          "within-area_movement",
          "brood_reduction",
          "blood_sib",
          "hatch_incub_length",
          "rear_incub_length",
          "relatedness",
          "competition_weight",
          "relative_CS",
          "envir_rear",
          "percent_change",
          "parentage",
          "manipulation_non",
          "seasonal_timing",
          "brood_mortality",
          "brood_sex_ratio"
      into name column_header value column_id
  )
  where column_id != 'NA'
)
select
  'tit' as source_id,
  model_id,
  column_id
from unpivoted