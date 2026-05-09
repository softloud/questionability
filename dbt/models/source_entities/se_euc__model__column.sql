{{ config(materialized='table') }}

with team_model as (
    select *
    from {{ ref('euc_team_model') }}
),
unpivoted as (
  select model_id, column_id
  from (
      unpivot team_model
      on
          "SurveyID",
          "Date",
          "Season",
          "Property",
          "Quadrat no",
          "Easting",
          "Northing",
          "Aspect",
          "Landscape position",
          "ExoticAnnualGrass_cover",
          "ExoticAnnualHerb_cover",
          "ExoticPerennialHerb_cover",
          "ExoticPerennialGrass_cover",
          "ExoticShrub_cover",
          "NativePerennialFern_cover",
          "NativePerennialGrass_cover",
          "NativePerennialHerb_cover",
          "NativePerennialGraminoid_cover",
          "NativeShrub_cover",
          "BareGround_cover",
          "Litter_cover",
          "MossLichen_cover",
          "Rock_cover",
          "Euc_canopy_cover",
          "Distance_to_Eucalypt_canopy(m)",
          "euc_sdlgs0_50cm",
          "euc_sdlgs50cm-2m",
          "euc_sdlgs>2m",
          "annual_precipitation",
          "precipitation_warmest_quarter",
          "precipitation_coldest_quarter",
          "PET",
          "MrVBF",
          "K_perc",
          "Th_ppm",
          "U_ppm",
          "SRad_Jan",
          "SRad_Jul",
          "all_grass",
          "all_exotic_grass",
          "all_native_grass_graminoid",
          "all_non-grass_veg",
          "shrub_cover",
          "herb_cover",
          "other_veg",
          "bare",
          "month",
          "all_exotic_herb",
          "native_herb_fern_gram",
          "growing_space",
          "soilPC1",
          "coverPC1",
          "coverPC2",
          "coverPC3",
          "precip_max_range",
          "year",
          "size_class",
          "all_perennial_grass",
          "sample"
      into name column_header value column_id
  )
  where column_id != 'NA'
)
select 
  'euc' as source_id,
  model_id,
  column_id
from unpivoted