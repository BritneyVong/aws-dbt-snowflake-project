{{
  config(
    materialized='ephemeral'
  )
}}

WITH hosts AS
(
    SELECT
      HOST_ID,
      HOST_NAME,
      HOST_SINCE,
      IS_SUPERHOST,
      RESPONSE_RATE_QUALITY,
      CREATED_AT AS HOST_CREATED_AT,
      ROW_NUMBER() OVER (PARTITION BY HOST_ID ORDER BY CREATED_AT DESC) AS rn
    FROM
      {{ ref('silver_hosts') }}
)
SELECT
    HOST_ID,
    HOST_NAME,
    HOST_SINCE,
    IS_SUPERHOST,
    RESPONSE_RATE_QUALITY,
    HOST_CREATED_AT
FROM hosts
WHERE rn = 1