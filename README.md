# Airbnb Data Pipeline (dbt + Snowflake)

A hands-on data engineering project that takes raw Airbnb data (bookings, listings, and hosts) and turns it into clean, query-ready tables in Snowflake, using dbt to manage every transformation step.

## What it does

Raw CSV files are stored in AWS S3, loaded into Snowflake, then progressively cleaned and reshaped across three stages:

- **Bronze**: the data as it arrives, barely touched
- **Silver**: cleaned up, standardized, deduplicated
- **Gold**: the finished product: a wide combined table (`obt`) and a proper `fact` table ready for reporting, plus snapshot tables that track how listings and hosts change over time

## Built with

- AWS S3 (storage for the source CSV files, loaded into Snowflake)
- Snowflake (data warehouse)
- dbt (SQL transformations, models, snapshots)
- Python + uv (project and dependency management)
- Git/GitHub

## Notable problems I ran into and fixed

- Troubleshot a 403 Access Denied error when connecting Snowflake to an S3 bucket, which came down to how the AWS credentials and bucket permissions were set up
- A snapshot table that quietly ballooned to over 500,000 rows because it kept treating every re-run as a "new change". I traced it back to a wrong source table and a mismatched column name, then rebuilt it properly with deduplication logic
- A join that technically ran without errors but silently multiplied into billions of rows, which took some real digging through Snowflake's query profiler to catch
- Several small but stubborn syntax issues in dbt's Jinja templating (wrong brackets, missing parentheses, a stray semicolon) that don't show up until you actually try to compile the model
- Getting dbt to authenticate against Snowflake at all: I first tried SSO, hit a wall, and ended up setting a dedicated password via SQL instead
- Untangling a Python project structure (via uv) after some early setup mistakes, including workspace and package naming collisions
