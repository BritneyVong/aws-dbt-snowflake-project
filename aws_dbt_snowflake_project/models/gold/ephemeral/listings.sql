{{
  config(
    materialized='ephemeral'
  )
}}

WITH listings AS
(
    SELECT
      LISTING_ID,
      PROPERTY_TYPE,
      ROOM_TYPE,
      CITY,
      COUNTRY,
      PRICE_PER_NIGHT_TAG,
      CREATED_AT AS LISTING_CREATED_AT,
      ROW_NUMBER() OVER (PARTITION BY LISTING_ID ORDER BY CREATED_AT DESC) AS rn
    FROM
      {{ ref('silver_listings') }}
)
SELECT
    LISTING_ID,
    PROPERTY_TYPE,
    ROOM_TYPE,
    CITY,
    COUNTRY,
    PRICE_PER_NIGHT_TAG,
    LISTING_CREATED_AT
FROM listings
WHERE rn = 1